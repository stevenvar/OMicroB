/*
 * startup.c
 *
 * This file is part of the Phos operating system for microcontrollers
 * Copyright (c) 2018 J. M. Spivey
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#include "hardware.h"

/* init -- main program, creates application processes */
int main(int argc, const char **argv);

/* Addresses set by the linker */
extern unsigned __data_start[], __data_end[],
     __bss_start[], __bss_end[], __etext[], __stack[];

/* __reset -- the system starts here */
void __reset(void) {
     unsigned *p, *q;

     /* Make sure all RAM banks are powered on */
     POWER_RAMON |= BIT(0) | BIT(1);

     /* Copy data segment and zero out bss */
     p = __data_start; q = __etext;
     while (p < __data_end) *p++ = *q++;
     p = __bss_start;
     while (p < __bss_end) *p++ = 0;

     /* Let the program initialise itself */
     main(0, nullptr);

     /* If there is no scheduler, spin */
     while (1) pause();
}


/* NVIC SETUP FUNCTIONS */

/* On Cortex-M0, only the top two bits of each interrupt priority are
   implemented, so setting the priority to 0xff has the same effect as
   setting it to 0xc0.  Smaller numbers correspond to more urgency. */

/* irq_priority -- set priority for an IRQ to a value [0..0xff] */
void irq_priority(int irq, unsigned prio) {
     if (irq < 0)
          SET_BYTE(SCB_SHPR[(irq+8) >> 2], irq & 0x3, prio);
     else
          SET_BYTE(NVIC_IPR[irq >> 2], irq & 0x3, prio);
}

void enable_irq(int irq) {
     NVIC_ISER[0] = BIT(irq);
}

void disable_irq(int irq) {
     NVIC_ICER[0] = BIT(irq);
}

void clear_pending(int irq) {
     NVIC_ICPR[0] = BIT(irq);
}


/*  INTERRUPT VECTORS */

/* We use GCC features to define each handler name as an alias for the
   wrap_default() function if it is not defined elsewhere.
   Applications can subsitute their own definitions for default_handler()
   or for individual handler names like uart_handler(). */

void spin(void) {
     int n;

     intr_disable();

     /* Flash the seven stars of death */
     GPIO_DIR = 0xfff0;
     while (1) {
          GPIO_OUT = 0x4000;
          for (n = 1000000; n > 0; n--) {
               nop(); nop(); nop();
          }
          GPIO_OUT = 0;
          for (n = 200000; n > 0; n--) {
               nop(); nop(); nop();
          }
     }
}

void default_handler(void);
#pragma weak default_handler = _Z4spinv

static void wrap_default(void) {
     default_handler();
}

void nmi_handler(void);
#pragma weak nmi_handler = _ZL12wrap_defaultv

void hardfault_handler(void);
#pragma weak hardfault_handler = _ZL12wrap_defaultv

void svc_handler(void);
#pragma weak svc_handler = _ZL12wrap_defaultv

void pendsv_handler(void);
#pragma weak pendsv_handler = _ZL12wrap_defaultv

void systick_handler(void);
#pragma weak systick_handler = _ZL12wrap_defaultv

void uart_handler(void);
#pragma weak uart_handler = _ZL12wrap_defaultv

void timer0_handler(void);
#pragma weak timer0_handler = _ZL12wrap_defaultv

void timer1_handler(void);
#pragma weak timer1_handler = _ZL12wrap_defaultv

void timer2_handler(void);
#pragma weak timer2_handler = _ZL12wrap_defaultv

void power_clock_handler(void);
#pragma weak power_clock_handler = _ZL12wrap_defaultv

void radio_handler(void);
#pragma weak radio_handler = _ZL12wrap_defaultv

void spi0_twi0_handler(void);
#pragma weak spi0_twi0_handler = _ZL12wrap_defaultv

void spi1_twi1_handler(void);
#pragma weak spi1_twi1_handler = _ZL12wrap_defaultv

void gpiote_handler(void);
#pragma weak gpiote_handler = _ZL12wrap_defaultv

void adc_handler(void);
#pragma weak adc_handler = _ZL12wrap_defaultv

void rtc0_handler(void);
#pragma weak rtc0_handler = _ZL12wrap_defaultv

void temp_handler(void);
#pragma weak temp_handler = _ZL12wrap_defaultv

void rng_handler(void);
#pragma weak rng_handler = _ZL12wrap_defaultv

void ecb_handler(void);
#pragma weak ecb_handler = _ZL12wrap_defaultv

void ccm_aar_handler(void);
#pragma weak ccm_aar_handler = _ZL12wrap_defaultv

void wdt_handler(void);
#pragma weak wdt_handler = _ZL12wrap_defaultv

void rtc1_handler(void);
#pragma weak rtc1_handler = _ZL12wrap_defaultv

void qdec_handler(void);
#pragma weak qdec_handler = _ZL12wrap_defaultv

void lpcomp_handler(void);
#pragma weak lpcomp_handler = _ZL12wrap_defaultv

void swi0_handler(void);
#pragma weak swi0_handler = _ZL12wrap_defaultv

void swi1_handler(void);
#pragma weak swi1_handler = _ZL12wrap_defaultv

void swi2_handler(void);
#pragma weak swi2_handler = _ZL12wrap_defaultv

void swi3_handler(void);
#pragma weak swi3_handler = _ZL12wrap_defaultv

void swi4_handler(void);
#pragma weak swi4_handler = _ZL12wrap_defaultv

void swi5_handler(void);
#pragma weak swi5_handler = _ZL12wrap_defaultv

typedef void (*handler)(void);

// Entries filled with default_handler are unused by the hardware.  Getting
// such an interrupt would be a real surprise!

handler __vectors[] __attribute((section(".vectors"))) = {
    (handler) __stack,          // -16
    __reset,
    nmi_handler,
    hardfault_handler,
    default_handler,            // -12
    default_handler,
    default_handler,
    default_handler,
    default_handler,           // -8
    default_handler,
    default_handler,
    svc_handler,
    default_handler,           // -4
    default_handler,
    pendsv_handler,
    systick_handler,

    /* external interrupts */
    power_clock_handler,        //  0
    radio_handler,
    uart_handler,
    spi0_twi0_handler,
    spi1_twi1_handler,          //  4
    default_handler,
    gpiote_handler,
    adc_handler,
    timer0_handler,             //  8
    timer1_handler,
    timer2_handler,
    rtc0_handler,
    temp_handler,               // 12
    rng_handler,
    ecb_handler,
    ccm_aar_handler,
    wdt_handler,                // 16
    rtc1_handler,
    qdec_handler,
    lpcomp_handler,
    swi0_handler,               // 20
    swi1_handler,
    swi2_handler,
    swi3_handler,
    swi4_handler,               // 24
    swi5_handler,
    default_handler,
    default_handler,
    default_handler,            // 28
    default_handler,
    default_handler,
    default_handler
};
