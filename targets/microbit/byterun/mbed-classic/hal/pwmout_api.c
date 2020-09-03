/* mbed Microcontroller Library
 * Copyright (c) 2013 Nordic Semiconductor
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include "mbed_assert.h"
#include "pwmout_api.h"
#include "cmsis.h"
#include "pinmap.h"
#include "mbed_error.h"

#define PWM_CHANNELS            3
#define PWM_VALUE_INVALID       0xFFFF

#define PWM_PERIOD_DEFAULT      20000

// use the last timer Capture/Compare channel to define the period.
#define TIMER_PERIOD_CC         3

// 1uS precision, which with a 16bit timer gives us a maximum period of around 65ms.
#define TIMER_PRESCALER_MIN     4
#define TIMER_PRESCALER_MAX     9

static NRF_TIMER_Type* const timer = NRF_TIMER2;

// PWM levels, both in absolute microseconds, and TIMER ticks (we cache both for simplicity and performance).
static uint32_t pwm_us[PWM_CHANNELS] = {0};
static uint16_t pwm_ticks[PWM_CHANNELS] = {PWM_VALUE_INVALID};

// PWM period, both in absolute microseconds, and TIMER ticks (we cache both for simplicity and performance).
static uint32_t pwm_period_us = PWM_PERIOD_DEFAULT;
static uint16_t pwm_period_ticks = PWM_PERIOD_DEFAULT;

// List of which pins the GPIOTE channels are allocated to.
static PinName pwm_pins[PWM_CHANNELS] = {NC};
static uint8_t pwm_last_allocated = 0;

// TIMER prescaler currently in use.
static uint8_t pwm_prescaler = TIMER_PRESCALER_MIN;

static uint8_t timer_enabled = 0;

/** @brief Function for handling timer 2 peripheral interrupts.
 */
#ifdef __cplusplus
extern "C" {
#endif

void TIMER2_IRQHandler(void)
{
    timer->TASKS_STOP = 1;

    // update the CC values of all channels.
    for (int i=0; i<PWM_CHANNELS; i++)
        timer->CC[i] = pwm_ticks[i];

    // Disable this interrupt - it is needed only when PWM values change.
    timer->SHORTS = TIMER_SHORTS_COMPARE3_CLEAR_Msk;
    timer->INTENCLR = TIMER_INTENCLR_COMPARE3_Msk;
    timer->PRESCALER = pwm_prescaler;
    timer->CC[TIMER_PERIOD_CC] = pwm_period_ticks;
    timer->TASKS_START = 1;
    timer->EVENTS_COMPARE[TIMER_PERIOD_CC] = 0;
}
#ifdef __cplusplus
}
#endif

/** @brief Function for initializing the Timer peripherals.
 */
static void timer_init()
{
    if(timer_enabled)
        return;

    timer->TASKS_STOP = 1;
    timer->POWER     = 0;
    timer->POWER     = 1;
    timer->MODE      = TIMER_MODE_MODE_Timer;
    timer->BITMODE   = TIMER_BITMODE_BITMODE_16Bit << TIMER_BITMODE_BITMODE_Pos;
    timer->PRESCALER = pwm_prescaler;
    timer->SHORTS = TIMER_SHORTS_COMPARE3_CLEAR_Msk;
    timer->CC[TIMER_PERIOD_CC] = pwm_period_ticks;

    NVIC_SetPriority(TIMER2_IRQn, 1);
    NVIC_EnableIRQ(TIMER2_IRQn);

    timer->TASKS_START = 1;

    timer_enabled = 1;
}

static uint16_t PWM_US_TO_TICKS(uint32_t value)
{
    return ((uint16_t) (value / ((uint32_t)(1 << (pwm_prescaler - TIMER_PRESCALER_MIN)))));
}

static int8_t pwm_get_channel(PinName pin)
{
    // If a channel is already assigned to this pin, return that.
    for (int i=0; i<PWM_CHANNELS; i++)
    {
        if (pwm_pins[i] == pin)
        {
            pwm_last_allocated = i;
            return i;
        }
    }

    return NC;
}

static void pwm_disconnect(PinName pin)
{
    // We need two PPI channels for each PWM. We precompute this here for simplicity.
    uint8_t channel = 0xFF;

    for (int i=0; i < PWM_CHANNELS; i++)
    {
        if (pwm_pins[i] == pin)
        {
            channel = i;
            break;
        }
    }

    // if PWM is not connected, nothing to do.
    if (channel == 0xFF)
        return;

    NRF_GPIOTE->CONFIG[channel] = (GPIOTE_CONFIG_MODE_Task << GPIOTE_CONFIG_MODE_Pos) |
                                      (31UL << GPIOTE_CONFIG_PSEL_Pos) |
                                      (GPIOTE_CONFIG_POLARITY_HiToLo << GPIOTE_CONFIG_POLARITY_Pos);

    NRF_PPI->CHENCLR = (1 << channel*2) | (1 << (channel*2 + 1));
    pwm_pins[channel] = NC;
}

static int8_t pwm_allocate_channel(PinName pin)
{
    // Allocate the first unused one.
    for (int i=0; i<PWM_CHANNELS; i++)
        if (pwm_pins[i] == NC)
        {
            pwm_pins[i] = pin;
            pwm_last_allocated = i;
            return i;
        }

    // We're out of available channels. Perform a round robin to recycle
    // the least recently used one.
    pwm_last_allocated = (pwm_last_allocated + 1) % PWM_CHANNELS;
    pwm_disconnect(pwm_pins[pwm_last_allocated]);
    pwm_pins[pwm_last_allocated] = pin;

    return pwm_last_allocated;
}

/** @brief Function for initializing the GPIO Tasks/Events peripheral.
 */
static void pwm_connect(PinName pin, uint8_t gpiote_channel)
 {
     // We need two PPI channels for each PWM. We precompute this here for simplicity.
     uint8_t ppi_channel = gpiote_channel*2;

     // Connect GPIO input buffers and configure PWM_OUTPUT_PIN_NUMBER as an output.
     NRF_GPIO->PIN_CNF[pin] = (GPIO_PIN_CNF_SENSE_Disabled << GPIO_PIN_CNF_SENSE_Pos)
                             | (GPIO_PIN_CNF_DRIVE_S0S1 << GPIO_PIN_CNF_DRIVE_Pos)
                             | (GPIO_PIN_CNF_PULL_Disabled << GPIO_PIN_CNF_PULL_Pos)
                             | (GPIO_PIN_CNF_INPUT_Connect << GPIO_PIN_CNF_INPUT_Pos)
                             | (GPIO_PIN_CNF_DIR_Output << GPIO_PIN_CNF_DIR_Pos);

     NRF_GPIO->OUTCLR = (1UL << pin);

     /* Finally configure the channel as the caller expects. If OUTINIT works, the channel is configured properly.
        If it does not, the channel output inheritance sets the proper level. */
     NRF_GPIOTE->CONFIG[gpiote_channel] = (GPIOTE_CONFIG_MODE_Task << GPIOTE_CONFIG_MODE_Pos) |
                                          ((uint32_t)pin << GPIOTE_CONFIG_PSEL_Pos) |
                                          ((uint32_t)GPIOTE_CONFIG_POLARITY_Toggle << GPIOTE_CONFIG_POLARITY_Pos) |
                                          ((uint32_t)GPIOTE_CONFIG_OUTINIT_High << GPIOTE_CONFIG_OUTINIT_Pos); // ((uint32_t)GPIOTE_CONFIG_OUTINIT_High <<
                                                                                                              // GPIOTE_CONFIG_OUTINIT_Pos);//

     /* Three NOPs are required to make sure configuration is written before setting tasks or getting events */
     __NOP();
     __NOP();
     __NOP();

     /* Launch the task to take the GPIOTE channel output to the desired level */
     NRF_GPIOTE->TASKS_OUT[gpiote_channel] = 1;

     // Bring up a PWM
     NRF_PPI->CH[ppi_channel].TEP = (uint32_t)&NRF_GPIOTE->TASKS_OUT[gpiote_channel];
     NRF_PPI->CH[ppi_channel].EEP = (uint32_t)&timer->EVENTS_COMPARE[gpiote_channel];

     //on a compare event on RTC 1, flip the pin again, i.e. pwm down
     NRF_PPI->CH[ppi_channel+1].TEP = (uint32_t)&NRF_GPIOTE->TASKS_OUT[gpiote_channel];
     NRF_PPI->CH[ppi_channel+1].EEP = (uint32_t)&timer->EVENTS_COMPARE[TIMER_PERIOD_CC];

     NRF_PPI->CHENSET = (1 << ppi_channel) | (1 << (ppi_channel + 1));
 }


void pwmout_init(pwmout_t *obj, PinName pin)
{
    MBED_ASSERT(pin != (PinName)NC);

    timer_init();

    int8_t channel = pwm_get_channel(pin);

    if (channel == NC)
    {
        // Bring up a new channel (this can't fail).
        channel = pwm_allocate_channel(pin);
        timer->CC[channel] = PWM_VALUE_INVALID;
        pwm_connect(pin, channel);
    }

    obj->pwm = channel;
    obj->pin = pin;

    pwmout_pulsewidth_us(obj, 0);
}

void pwmout_free(pwmout_t *obj)
{
    pwm_disconnect(obj->pin);
}

void pwmout_write(pwmout_t *obj, float value)
{
    pwmout_pulsewidth_us(obj, (int)((float)pwm_period_us * value));
}

float pwmout_read(pwmout_t *obj)
{
    int8_t channel = pwm_get_channel(obj->pin);

    if(channel == NC)
        return 0;

    return (float)pwm_us[channel] / (float)pwm_period_us;
}

void pwmout_period(pwmout_t *obj, float seconds)
{
    pwmout_period_us(obj,(int)(seconds * (float)1000000));
}

void pwmout_period_ms(pwmout_t *obj, int ms)
{
    pwmout_period_us(obj, ms * 1000);
}

// Set the PWM period, keeping the duty cycle the same.
void pwmout_period_us(pwmout_t *obj, int us)
{
    uint32_t p = 0x10000;
    int prescaler = TIMER_PRESCALER_MIN;
    uint32_t old_period_us = pwm_period_us;

    // Quick validation - do nothing if the frequency is identical to it's current value.
    if (us == pwm_period_us)
        return;

    // Calculate the ideal prescaler for this value. If it's higher than our current prescaler.
    while (p < us && p != (uint32_t) (1 << 31))
    {
        p = p << 1;
        prescaler++;
    }

    // Silently ignore requests to go out of scope (all we can do with the mbed API at present).
    if (prescaler > TIMER_PRESCALER_MAX)
        return;

    // Update global frequency timestamps.
    pwm_prescaler = prescaler;
    pwm_period_us = us;
    pwm_period_ticks = PWM_US_TO_TICKS(us);

    pwmout_t pwm;
    pwm.pin = NC;
    pwm.pwm = NC;

    // Update all PWM channel values to maintin the same duty cycle (mbed standard behaviour).
    for (int i=0; i<PWM_CHANNELS; i++)
    {
        if (pwm_ticks[i] != PWM_VALUE_INVALID)
        {
            pwm.pin = pwm_pins[i];
            pwmout_pulsewidth_us(&pwm, (uint32_t) ((float)pwm_us[i] * ((float)us / (float)old_period_us)));
            pwm.pin = NC;
        }
    }
}

void pwmout_pulsewidth(pwmout_t *obj, float seconds)
{
    pwmout_pulsewidth_us(obj,(int)(seconds * (float)1000000));
}

void pwmout_pulsewidth_ms(pwmout_t *obj, int ms)
{
    pwmout_pulsewidth_us(obj, ms * 1000);
}

void pwmout_pulsewidth_us(pwmout_t *obj, int us)
{
    PinName pin = (PinName)obj->pin;

    int8_t channel = pwm_get_channel(pin);

    if (channel == NC)
    {
        // Bring up a new channel (this can't fail).
        channel = pwm_allocate_channel(pin);
        timer->CC[channel] = PWM_VALUE_INVALID;
        pwm_connect(pin, channel);
    }

    // Record (internally for now) the new pulse width of this channel.
    pwm_us[channel] = us;
    pwm_ticks[channel] = PWM_US_TO_TICKS(us);

    // If
    if (us == 0 || us >= pwm_period_us)
    {
        pwm_disconnect(pin);
        if (us)
            NRF_GPIO->OUTSET = (1UL << pin);
        else
            NRF_GPIO->OUTCLR = (1UL << pin);

        return;
    }

    // Configure to receive a one-shot interrupt when the next PWM period completes (also stop the timer at this point to avoid potential race conditions)
    __disable_irq();

    timer->EVENTS_COMPARE[TIMER_PERIOD_CC] = 0;
    timer->INTENSET = TIMER_INTENSET_COMPARE3_Msk;
    timer->SHORTS = TIMER_SHORTS_COMPARE3_CLEAR_Msk | TIMER_SHORTS_COMPARE3_STOP_Msk;

    __enable_irq();
}
