/* common/startup.c */
/* Copyright (c) 2018 J. M. Spivey */

#include "hardware.h"
#include "microbian.h"

extern int main(int, char**);

void omicrob_task(int n) {
  timer_delay(10);
  main(0, NULL);
}

/* init -- main program, creates application processes */
void init(void) {
  serial_init();
  timer_init();
  display_init();
  radio_init();
  i2c_init(I2C_INTERNAL);
  adc_init();

  // Init some gpio
  gpio_connect(BUTTON_A);
  gpio_connect(BUTTON_B);

  // Start the VM
  start("OMicroB", omicrob_task, 0, STACK);
}

void default_start(void)
{
    init();                    /* Call the main program. */
    while (1) pause();         /* Halt if init() returns */
}

void __start(void) __attribute((weak, alias("default_start")));

/* The next four routines can be used in C compiler output, even
if not mentioned in the source. */

/* memcpy -- copy n bytes from src to dest (non-overlapping) */
void *memcpy(void *dest, const void *src, unsigned n)
{
    unsigned char *p = dest;
    const unsigned char *q = src;
    while (n-- > 0) *p++ = *q++;
    return dest;
}

/* memmove -- copy n bytes from src to dest, allowing overlaps */
void *memmove(void *dest, const void *src, unsigned n)
{
    unsigned char *p = dest;
    const unsigned char *q = src;
    if (dest <= src)
        while (n-- > 0) *p++ = *q++;
    else {
        p += n; q += n;
        while (n-- > 0) *--p = *--q;
    }
    return dest;
}
    
/* memset -- set n bytes of dest to byte x */
void *memset(void *dest, unsigned x, unsigned n)
{
    unsigned char *p = dest;
    while (n-- > 0) *p++ = x;
    return dest;
}

/* memcmp -- compare n bytes */
int memcmp(const void *pp, const void *qq, int n)
{
    const unsigned char *p = pp, *q = qq;
    while (n-- > 0) {
        if (*p++ != *q++)
            return (p[-1] < q[-1] ? -1 : 1);
    }
    return 0;
}

/* Addresses set by the linker */
#ifdef UBIT_V1
extern unsigned char __data_start[], __data_end[],
    __bss_start[], __bss_end[], __etext[], __stack[];
#endif
#ifdef UBIT_V2
extern unsigned char __xram_start[], __xram_end[],
    __data_start[], __data_end[], __bss_start[], __bss_end[],
    __etext[], __stack[];
#endif

/* __reset -- the system starts here */
void __reset(void)
{
    /* Activate the crystal clock */
    CLOCK.HFCLKSTARTED = 0;
    CLOCK.HFCLKSTART = 1;
    while (! CLOCK.HFCLKSTARTED) { }

    /* Enable the instruction cache */
    SET_BIT(NVMC.ICACHECONF, NVMC_ICACHECONF_CACHEEN);

    /* Copy xram and data segments and zero out bss. */
    #ifdef UBIT_V1
    int data_size = __data_end - __data_start;
    int bss_size = __bss_end - __bss_start;
    memcpy(__data_start, __etext, data_size);
    memset(__bss_start, 0, bss_size);
    #endif
    #ifdef UBIT_V2
    int xram_size = __xram_end - __xram_start;
    int data_size = __data_end - __data_start;
    int bss_size = __bss_end - __bss_start;
    memcpy(__xram_start, __etext, xram_size);
    memcpy(__data_start, __etext+xram_size, data_size);
    memset(__bss_start, 0, bss_size);
    #endif

    __start();
}


/* NVIC SETUP FUNCTIONS */

/* On Cortex-M4, only the top three bits of each interrupt priority
are implemented, but for portability priorities should be specified
with integers in the range [0..255]. */

/* irq_priority -- set priority for an IRQ to a value [0..255] */
void irq_priority(int irq, unsigned prio)
{
    if (irq < 0)
        SET_BYTE(SCB.SHPR[(irq+8) >> 2], irq & 0x3, prio);
    else
        SET_BYTE(NVIC.IPR[irq >> 2], irq & 0x3, prio);
}
     
/* See hardware.h for macros enable_irq, disable_irq, clear_pending, 
reschedule */

/* Device register arrays */

#ifdef UBIT_V1
volatile _DEVICE _i2c * const I2C[1] = {
    &I2C0
};

volatile _DEVICE _timer * const TIMER[3] = {
    &TIMER0, &TIMER1, &TIMER2
};
#endif

#ifdef UBIT_V2
volatile _DEVICE _gpio * const GPIO[2] = {
    &GPIO0, &GPIO1
};

volatile _DEVICE _i2c * const I2C[2] = {
    &I2C0, &I2C1
};

volatile _DEVICE _timer * const TIMER[5] = {
    &TIMER0, &TIMER1, &TIMER2, &TIMER3, &TIMER4
};

volatile _DEVICE _pwm * const PWM[4] = {
    &PWM0, &PWM1, &PWM2, &PWM3
};
#endif


/*  INTERRUPT VECTORS */

/* We use the linker script to define each handler name as an alias
for default_handler if it is not defined elsewhere.  Applications can
subsitute their own definitions for individual handler names like
uart_handler(). */

/* delay_loop -- timed delay */
void delay_loop(unsigned usecs)
{
    /* Without executing from RAM, this delay loop may go slowly, but
       it isn't used anywhere it matters. */
    unsigned t = usecs << 4;
    while (t > 0) {
        /* 62.5nsec per iteration */
        nop();
        t--;
    }
}

/* spin -- show Seven Stars of Death */
void spin(void)
{
  /* The SSOD was easy on micro:bit-v1 and is harder on v2, but it
     has proven so popular that it is worth the effort to keep it.
     We assume the icache is enabled -- if not, the flashing will
     just go at about half speed. */

#ifdef UBIT_V1
  intr_disable();

  GPIO.DIR = 0xfff0;
  while (1) {
    GPIO.OUT = 0x4000;
    delay_loop(500000);
    GPIO.OUT = 0;
    delay_loop(100000);
  }
#endif

#ifdef UBIT_V2
  int i, k;

  static const unsigned ssod[] = {
    __ROW(ROW1, 0,1,0,1,0),
    __ROW(ROW3, 1,0,1,0,1),
    __ROW(ROW5, 0,1,0,1,0)
  };

  intr_disable();

  GPIO0.DIR = LED_MASK0;
  GPIO1.DIR = LED_MASK1;
    
  while (1) {
    for (k = 33; k > 0; k--) { /* 0.5s on */
      for (i = 0; i < 6; i += 2) { /* 15ms per loop */
        GPIO0.OUT = ssod[i];
        GPIO1.OUT = ssod[i+1];
        delay_loop(5000);
      }
    }
    GPIO0.OUT = 0;
    GPIO0.OUT = 0;
    delay_loop(100000); /* 0.1s off */
  }
  #endif
}

void default_handler(void) __attribute((weak, alias("spin")));

/* This vector table is placed at address 0 in the flash by directives
in the linker script. */

#ifdef UBIT_V1

/* The linker script makes all these handlers into weak aliases for */
/* default_handler. */

void nmi_handler(void);
void hardfault_handler(void);
void svc_handler(void);
void pendsv_handler(void);
void systick_handler(void);
void uart_handler(void);
void timer0_handler(void);
void timer1_handler(void);
void timer2_handler(void);
void power_clock_handler(void);
void radio_handler(void);
void i2c_handler(void);
void spi_handler(void);
void gpiote_handler(void);
void adc_handler(void);
void rtc0_handler(void);
void temp_handler(void);
void rng_handler(void);
void ecb_handler(void);
void ccm_aar_handler(void);
void wdt_handler(void);
void rtc1_handler(void);
void qdec_handler(void);
void lpcomp_handler(void);
void swi0_handler(void);
void swi1_handler(void);
void swi2_handler(void);
void swi3_handler(void);
void swi4_handler(void);
void swi5_handler(void);

void *__vectors[] __attribute((section(".vectors"))) = {
    __stack,                    /* -16 */
    __reset,
    nmi_handler,
    hardfault_handler,
    0,                          /* -12 */
    0,
    0,
    0,
    0,                          /*  -8 */
    0,
    0,
    svc_handler,
    0,                          /* -4 */
    0,
    pendsv_handler,
    systick_handler,

    /* external interrupts */
    power_clock_handler,        /*  0 */
    radio_handler,
    uart_handler,
    i2c_handler,
    spi_handler,                /*  4 */
    0,
    gpiote_handler,
    adc_handler,
    timer0_handler,             /*  8 */
    timer1_handler,
    timer2_handler,
    rtc0_handler,
    temp_handler,               /* 12 */
    rng_handler,
    ecb_handler,
    ccm_aar_handler,
    wdt_handler,                /* 16 */
    rtc1_handler,
    qdec_handler,
    lpcomp_handler,
    swi0_handler,               /* 20 */
    swi1_handler,
    swi2_handler,
    swi3_handler,
    swi4_handler,               /* 24 */
    swi5_handler,
    0,
    0,
    0,                          /* 28 */
    0,
    0,
    0
};
#endif

#ifdef UBIT_V2

/* The linker script makes all these handlers into weak aliases
for default_handler. */

void nmi_handler(void);
void hardfault_handler(void);
void memmgt_handler(void);
void busfault_handler(void);
void usagefault_handler(void);
void svc_handler(void);
void debugmon_handler(void);
void pendsv_handler(void);
void systick_handler(void);
void power_clock_handler(void);
void radio_handler(void);
void uart0_handler(void);
void i2c0_handler(void);
void i2c1_handler(void);
void nfc_handler(void);
void gpiote_handler(void);
void adc_handler(void);
void timer0_handler(void);
void timer1_handler(void);
void timer2_handler(void);
void rtc0_handler(void);
void temp_handler(void);
void rng_handler(void);
void ecb_handler(void);
void ccm_aar_handler(void);
void wdt_handler(void);
void rtc1_handler(void);
void qdec_handler(void);
void lpcomp_handler(void);
void swi0_handler(void);
void swi1_handler(void);
void swi2_handler(void);
void swi3_handler(void);
void swi4_handler(void);
void swi5_handler(void);
void timer3_handler(void);
void timer4_handler(void);
void pwm0_handler(void);
void pdm_handler(void);
void mwu_handler(void);
void pwm1_handler(void);
void pwm2_handler(void);
void spi0_handler(void);
void rtc2_handler(void);
void i2s_handler(void);
void fpu_handler(void);
void usbd_handler(void);
void uart1_handler(void);
void pwm3_handler(void);
void spi1_handler(void);

void *__vectors[] __attribute((section(".vectors"))) = {
    __stack,                    /* -16 */
    __reset,
    nmi_handler,
    hardfault_handler,
    hardfault_handler,          /* -12 */
    hardfault_handler,
    hardfault_handler,
    0,
    0,                          /*  -8 */
    0,
    0,
    svc_handler,
    debugmon_handler,           /* -4 */
    0,
    pendsv_handler,
    systick_handler,
    
    /* external interrupts */
    power_clock_handler,        /*  0 */
    radio_handler,
    uart0_handler,
    i2c0_handler,
    i2c1_handler,               /*  4 */
    nfc_handler,
    gpiote_handler,
    adc_handler,
    timer0_handler,             /*  8 */
    timer1_handler,
    timer2_handler,
    rtc0_handler,
    temp_handler,               /* 12 */
    rng_handler,
    ecb_handler,
    ccm_aar_handler,
    wdt_handler,                /* 16 */
    rtc1_handler,
    qdec_handler,
    lpcomp_handler,
    swi0_handler,               /* 20 */
    swi1_handler,
    swi2_handler,
    swi3_handler,
    swi4_handler,               /* 24 */
    swi5_handler,
    timer3_handler,
    timer4_handler,
    pwm0_handler,               /* 28 */
    pdm_handler,
    0,
    0,
    mwu_handler,                /* 32 */
    pwm1_handler,
    pwm2_handler,
    spi0_handler,
    rtc2_handler,               /* 36 */
    i2s_handler,
    fpu_handler,
    usbd_handler,
    uart1_handler,              /* 40 */
    0,
    0,
    0,
    0,                          /* 44 */
    pwm3_handler,
    0,
    spi1_handler,
    0,                          /* 48 */
    0,
    0,
    0,
    0,                          /* 52 */
    0,
    0,
    0,
    0,                          /* 56 */
    0,
    0,
    0,
    0,                          /* 60 */
    0,
    0,
    0
};
#endif
