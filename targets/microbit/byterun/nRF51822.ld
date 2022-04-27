/* common/nRF51822.ld */
/* Copyright (c) 2018-20 J. M. Spivey */

MEMORY {
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 256K
    RAM (rwx) :  ORIGIN = 0x20000000, LENGTH = 16K
}

OUTPUT_FORMAT ("elf32-littlearm")

/* Setting the entry address helps GDB to find the stack bottom */
ENTRY(__reset)

SECTIONS {
    .text : {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
        __etext = .;

        PROVIDE(nmi_handler = default_handler);
        PROVIDE(hardfault_handler = default_handler);
        PROVIDE(svc_handler = default_handler);
        PROVIDE(pendsv_handler = default_handler);
        PROVIDE(systick_handler = default_handler);
        PROVIDE(uart_handler = default_handler);
        PROVIDE(timer0_handler = default_handler);
        PROVIDE(timer1_handler = default_handler);
        PROVIDE(timer2_handler = default_handler);
        PROVIDE(power_clock_handler = default_handler);
        PROVIDE(radio_handler = default_handler);
        PROVIDE(i2c_handler = default_handler);
        PROVIDE(spi_handler = default_handler);
        PROVIDE(gpiote_handler = default_handler);
        PROVIDE(adc_handler = default_handler);
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
    } > FLASH

    /DISCARD/ :
    {
        *(.ARM.exidx*)
        *(.gnu.linkonce.armexidx.*)
    }

    .data : AT (__etext) {
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
        end = __end;
    } > RAM

    /* Set stack top to end of RAM, and move stack limit down by
       size of stack */
    __stack = ORIGIN(RAM) + LENGTH(RAM);
    __stack_limit = __stack - 2048;

    /* Check if data + stack exceeds RAM limit */
    ASSERT(__stack_limit >= __end, "region RAM overlaps with stack")
}
