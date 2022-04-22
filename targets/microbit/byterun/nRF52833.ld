/* common/nRF52833.ld */
/* Copyright (c) 2018-20 J. M. Spivey */

MEMORY {
    FLASH   (rx)  : ORIGIN = 0x00000000,      LENGTH = 512K
    RAM     (rwx) : ORIGIN = 0x20000000,      LENGTH = 124K
    CODERAM (rwx) : ORIGIN = 0x00800000+124K, LENGTH = 4K
}

OUTPUT_FORMAT ("elf32-littlearm")

/* Setting the entry address helps GDB to find the stack bottom */
ENTRY(__reset)

SECTIONS {
    .text ALIGN(16) : SUBALIGN(16) {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        __etext = .;

        PROVIDE(nmi_handler = default_handler);
        PROVIDE(hardfault_handler = default_handler);
        PROVIDE(svc_handler = default_handler);
        PROVIDE(debugmon_handler = default_handler);
        PROVIDE(pendsv_handler = default_handler);
        PROVIDE(systick_handler = default_handler);
        PROVIDE(power_clock_handler = default_handler);
        PROVIDE(radio_handler = default_handler);
        PROVIDE(uart0_handler = default_handler);
        PROVIDE(i2c0_handler = default_handler);
        PROVIDE(i2c1_handler = default_handler);
        PROVIDE(nfc_handler = default_handler);
        PROVIDE(gpiote_handler = default_handler);
        PROVIDE(adc_handler = default_handler);
        PROVIDE(timer0_handler = default_handler);
        PROVIDE(timer1_handler = default_handler);
        PROVIDE(timer2_handler = default_handler);
        PROVIDE(rtc0_handler = default_handler);
        PROVIDE(temp_handler = default_handler);
        PROVIDE(rng_handler = default_handler);
        PROVIDE(ecb_handler = default_handler);
        PROVIDE(ccm_aar_handler = default_handler);
        PROVIDE(wdt_handler = default_handler);
        PROVIDE(rtc1_handler = default_handler);
        PROVIDE(qdec_handler = default_handler);
        PROVIDE(lpcomp_handler = default_handler);
        PROVIDE(swi0_handler = default_handler);
        PROVIDE(swi1_handler = default_handler);
        PROVIDE(swi2_handler = default_handler);
        PROVIDE(swi3_handler = default_handler);
        PROVIDE(swi4_handler = default_handler);
        PROVIDE(swi5_handler = default_handler);
        PROVIDE(timer3_handler = default_handler);
        PROVIDE(timer4_handler = default_handler);
        PROVIDE(pwm0_handler = default_handler);
        PROVIDE(pdm_handler = default_handler);
        PROVIDE(mwu_handler = default_handler);
        PROVIDE(pwm1_handler = default_handler);
        PROVIDE(pwm2_handler = default_handler);
        PROVIDE(spi0_handler = default_handler);
        PROVIDE(rtc2_handler = default_handler);
        PROVIDE(i2s_handler = default_handler);
        PROVIDE(fpu_handler = default_handler);
        PROVIDE(usbd_handler = default_handler);
        PROVIDE(uart1_handler = default_handler);
        PROVIDE(pwm3_handler = default_handler);
        PROVIDE(spi1_handler = default_handler);
    } > FLASH

    .xram : AT (LOADADDR(.text) + SIZEOF(.text)) {
        __xram_start = .;
        *(.xram*)
        . = ALIGN(4);
        __xram_end = .;
    } > CODERAM

    .data : AT (LOADADDR(.xram) + SIZEOF(.xram)) {
        __data_start = .;
        *(.data*)
        . = ALIGN(4);
        __data_end = .;
    } > RAM

    .bss : {
        __bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
        __end = .;
    } > RAM

    /* Set stack top to end of RAM, and move stack limit down by
       size of stack */
    __stack = ORIGIN(RAM) + LENGTH(RAM);
    __stack_limit = __stack - 2048;

    /* Check if data + stack exceeds RAM limit */
    ASSERT(__stack_limit >= __end, "region RAM overlaps with stack")
}
