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
#include <stddef.h>
#include <stdbool.h>
#include "us_ticker_api.h"
#include "cmsis.h"
#include "PeripheralNames.h"
#include "nrf_delay.h"

/*
 * A higher precision implementation of the Ticker API using Timer 1 and a 1MHz clock.
 * This implementation should be used when higher precision than can be provided by the
 * LF clock source is required. i.e. precision of less than 30uS.
 */

#define MAX_TMR1_COUNTER_VAL     0x0000FFFF               // Run the timer in 16 bit mode, for consistency with RTC algorithm above.
#define TMR1_CLOCK_FREQ          (uint32_t)(1000000)	  // Run at 1MHz so the lower power 1MHz clock source can be used.
#define TMR1_IRQ_PRI            3                        /**< Priority of the TMR1 interrupt (used
                                                          *  for checking for timeouts and executing
                                                          *  timeout handlers). This must be the same
                                                          *  as APP_IRQ_PRIORITY_LOW; taken from the
                                                          *  Nordic SDK. */
#define MAX_TMR1_TASKS_DELAY     47                       /**< Maximum delay until an RTC task is executed. */

#define FUZZY_TMR1_TICKS          10  /* TMR COMPARE occurs when a CC register is N and the TMR
                                     * COUNTER value transitions from N-1 to N. If we're trying to
                                     * setup a callback for a time which will arrive very shortly,
                                     * there are limits to how short the callback interval may be for us
                                     * to rely upon the TMR Compare trigger. If the COUNTER is N,
                                     * writing N+2 to a CC register is guaranteed to trigger a COMPARE
                                     * event at N+2. */

#define TMR1_UNITS_TO_MICROSECONDS(TMR1_UNITS) TMR1_UNITS
#define MICROSECONDS_TO_TMR1_UNITS(MICROS)    MICROS

static bool              us_ticker_inited = false;
static volatile uint32_t overflowCount = 0;                   /**< The number of times the 24-bit TMR1 counter has overflowed. */
static volatile bool     us_ticker_callbackPending = false;
static uint32_t          us_ticker_callbackTimestamp;

static inline void tmr1_enableCompareInterrupt(void)
{
    NRF_TIMER1->INTENSET    = TIMER_INTENSET_COMPARE0_Msk;

    //NRF_RTC1->EVTENCLR = RTC_EVTEN_COMPARE0_Msk;
    //NRF_RTC1->INTENSET = RTC_INTENSET_COMPARE0_Msk;
}

static inline void tmr1_disableCompareInterrupt(void)
{
    NRF_TIMER1->INTENCLR    = TIMER_INTENSET_COMPARE0_Msk;

    //NRF_RTC1->INTENCLR = RTC_INTENSET_COMPARE0_Msk;
    //NRF_RTC1->EVTENCLR = RTC_EVTEN_COMPARE0_Msk;
}

static inline void tmr1_enableOverflowInterrupt(void)
{
	NRF_TIMER1->CC[3] = 0;
	NRF_TIMER1->INTENSET = (TIMER_INTENSET_COMPARE3_Enabled << TIMER_INTENSET_COMPARE3_Pos);

    //NRF_RTC1->EVTENCLR = RTC_EVTEN_OVRFLW_Msk;
    //NRF_RTC1->INTENSET = RTC_INTENSET_OVRFLW_Msk;
}

static inline void tmr1_disableOverflowInterrupt(void)
{
	NRF_TIMER1->INTENCLR = (TIMER_INTENSET_COMPARE3_Enabled << TIMER_INTENSET_COMPARE3_Pos);

    //NRF_RTC1->INTENCLR = RTC_INTENSET_OVRFLW_Msk;
    //NRF_RTC1->EVTENCLR = RTC_EVTEN_OVRFLW_Msk;
}

static inline void invokeCallback(void)
{
    us_ticker_callbackPending = false;
    //tmr1_disableCompareInterrupt();
    us_ticker_irq_handler();
}

/**
 * @brief Function for starting the TIMER1 timer. The timer is expected to
 * keep running--some interrupts may be disabled temporarily.
 */
static void tmr1_start()
{
	NRF_TIMER1->TASKS_STOP = 1;

	NRF_CLOCK->EVENTS_HFCLKSTARTED  = 0;
	NRF_CLOCK->TASKS_HFCLKSTART     = 1;
	while (NRF_CLOCK->EVENTS_HFCLKSTARTED == 0) ;

	NRF_TIMER1->MODE      = TIMER_MODE_MODE_Timer;
	NRF_TIMER1->TASKS_CLEAR = 1;
	NRF_TIMER1->PRESCALER = 4; 		// Configure for 1MHz operation
	NRF_TIMER1->BITMODE   = TIMER_BITMODE_BITMODE_16Bit;
	tmr1_enableOverflowInterrupt();
    tmr1_enableCompareInterrupt();

    NVIC_SetPriority(TIMER1_IRQn, TMR1_IRQ_PRI);
    NVIC_ClearPendingIRQ(TIMER1_IRQn);
    NVIC_EnableIRQ(TIMER1_IRQn);

    NRF_TIMER1->TASKS_START = 1;
}

/**
 * @brief Function for stopping the RTC1 timer. We don't expect to call this.
 */
void tmr1_stop(void)
{
    NVIC_DisableIRQ(TIMER1_IRQn);
    tmr1_disableCompareInterrupt();
    tmr1_disableOverflowInterrupt();

    NRF_TIMER1->TASKS_STOP = 1;
    nrf_delay_us(MAX_TMR1_TASKS_DELAY);

    NRF_TIMER1->TASKS_CLEAR = 1;
    nrf_delay_us(MAX_TMR1_TASKS_DELAY);
}

/**
 * @brief Function for returning the current value of the RTC1 counter.
 *
 * @return Current RTC1 counter as a 64-bit value with 48-bit precision (even
 *         though the underlying counter is 16-bit)
 */
static inline uint64_t tmr1_getCounter64(void)
{
    NRF_TIMER1->TASKS_CAPTURE[2] = 1;

    NVIC_DisableIRQ(TIMER1_IRQn);

    if (NRF_TIMER1->EVENTS_COMPARE[3])
    {
        NRF_TIMER1->EVENTS_COMPARE[3] = 0;
        overflowCount++;
    }

    NVIC_EnableIRQ(TIMER1_IRQn);

    return (((uint64_t)(overflowCount)) << 16) | (NRF_TIMER1->CC[2] & MAX_TMR1_COUNTER_VAL);
}

/**
 * @brief Function for returning the current value of the RTC1 counter.
 *
 * @return Current RTC1 counter as a 32-bit value (even though the underlying counter is 24-bit)
 */
static inline uint32_t tmr1_getCounter(void)
{
    return tmr1_getCounter64();
}

/**
 * @brief Function for handling the RTC1 interrupt.
 *
 * @details Checks for timeouts, and executes timeout handlers for expired timers.
 */
void TIMER1_IRQHandler(void)
{
    if (NRF_TIMER1->EVENTS_COMPARE[0])
	{
		NRF_TIMER1->EVENTS_COMPARE[0] = 0;
		if (us_ticker_callbackPending && ((int)(us_ticker_callbackTimestamp - tmr1_getCounter()) <= 0)) {
			invokeCallback();
		}
	}

    if (NRF_TIMER1->EVENTS_COMPARE[3]) {
        overflowCount++;
        NRF_TIMER1->EVENTS_COMPARE[3] = 0;
    }
}

void us_ticker_init(void)
{
    if (us_ticker_inited) {
        return;
    }

    tmr1_start();
    us_ticker_inited = true;
}

uint32_t us_ticker_read()
{
    if (!us_ticker_inited) {
        us_ticker_init();
    }

    return TMR1_UNITS_TO_MICROSECONDS(tmr1_getCounter64());
}

/**
 * Setup the us_ticker callback interrupt to go at the given timestamp.
 *
 * @Note: Only one callback is pending at any time.
 *
 * @Note: If a callback is pending, and this function is called again, the new
 * callback-time overrides the existing callback setting. It is the caller's
 * responsibility to ensure that this function is called to setup a callback for
 * the earliest timeout.
 *
 * @Note: If this function is used to setup an interrupt which is immediately
 * pending--such as for 'now' or a time in the past,--then the callback is
 * invoked a few ticks later.
 */
void us_ticker_set_interrupt(timestamp_t timestamp)
{
    if (!us_ticker_inited) {
        us_ticker_init();
    }

    /*
     * The argument to this function is a 32-bit microsecond timestamp for when
     * a callback should be invoked. On the nRF51, we use an RTC timer running
     * at 32kHz to implement a low-power us-ticker. This results in a problem
     * based on the fact that 1000000 is not a multiple of 32768.
     *
     * Going from a micro-second based timestamp to a 32kHz based RTC-time is a
     * linear mapping; but this mapping doesn't preserve wraparounds--i.e. when
     * the 32-bit micro-second timestamp wraps around unfortunately the
     * underlying RTC counter doesn't. The result is that timestamp expiry
     * checks on micro-second timestamps don't yield the same result when
     * applied on the corresponding RTC timestamp values.
     *
     * One solution is to translate the incoming 32-bit timestamp into a virtual
     * 64-bit timestamp based on the knowledge of system-uptime, and then use
     * this wraparound-free 64-bit value to do a linear mapping to RTC time.
     * System uptime on an nRF is maintained using the 24-bit RTC counter. We
     * track the overflow count to extend the 24-bit hardware counter by an
     * additional 32 bits. RTC_UNITS_TO_MICROSECONDS() converts this into
     * microsecond units (in 64-bits).
     */

	/*
    const uint64_t currentTime64 = TMR1_UNITS_TO_MICROSECONDS(tmr1_getCounter64());
    uint64_t timestamp64 = (currentTime64 & ~(uint64_t)0xFFFFFFFFULL) + timestamp;
    if (((uint32_t)currentTime64 > 0x80000000) && (timestamp < 0x80000000)) {
        timestamp64 += (uint64_t)0x100000000ULL;
    }
    uint32_t newCallbackTime = MICROSECONDS_TO_TMR1_UNITS(timestamp64);
	*/

    uint32_t newCallbackTime = timestamp;

    /* Check for repeat setup of an existing callback. This is actually not
     * important; the following code should work even without this check. */
    if (us_ticker_callbackPending && (newCallbackTime == us_ticker_callbackTimestamp)) {
        return;
    }

    /* Check for callbacks which are immediately (or will *very* shortly become) pending.
     * Even if they are immediately pending, they are scheduled to trigger a few
     * ticks later. This keeps things simple by invoking the callback from an
     * independent interrupt context. */
    if ((int)(newCallbackTime - tmr1_getCounter()) <= (int)FUZZY_TMR1_TICKS) {
        newCallbackTime = tmr1_getCounter() + FUZZY_TMR1_TICKS;
    }

    us_ticker_callbackTimestamp = newCallbackTime;
    us_ticker_callbackPending = true;
    NRF_TIMER1->CC[0]             = newCallbackTime & MAX_TMR1_COUNTER_VAL;
    //tmr1_enableCompareInterrupt();
}

void us_ticker_disable_interrupt(void)
{
    //if (us_ticker_callbackPending) {
    //    //tmr1_disableCompareInterrupt();
    //    us_ticker_callbackPending = false;
    //}
}

void us_ticker_clear_interrupt(void)
{
    //NRF_TIMER1->EVENTS_COMPARE[3] = 0;
    //NRF_TIMER1->EVENTS_COMPARE[0] = 0;
}
