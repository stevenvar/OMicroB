/* NRF51822.ld -- Copyright (c) 2018 J. M. Spivey */

MEMORY {
    FLASH (rx) : ORIGIN = 0x00000000, LENGTH = 0x40000
    RAM (rwx) :  ORIGIN = 0x20000000, LENGTH = 0x4000
}

OUTPUT_FORMAT ("elf32-littlearm")

SECTIONS {
    .text : {
        KEEP(*(.vectors))
        *(.text*)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    /* Should probably be discarded ? We don't use exceptions */
    .ARM.exidx : {
        __exidx_start = .;
        *(.ARM.exidx*)
        __exidx_end = .;
        *(.gnu.linkonce.armexidx.*)
    } > FLASH

    __etext = .;

    .data : AT (__etext) {
        __data_start = .;
        *(.data*)
        . = ALIGN(4);
        __data_end = .;
    } > RAM

    .bss : {
        __bss_start = .;
        __bss_start__ = __bss_start;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        __bss_end = .;
        __bss_end__ = __bss_end;
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
