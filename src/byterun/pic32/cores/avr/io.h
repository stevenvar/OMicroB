#ifndef __IO_H_
#define __IO_H_ 1

/* For AVR */
#if defined(__AVR__)
    #include <avr/io.h>
#endif

/* For PIC32 */
#if defined(__PIC32MX__)
    #include <p32xxxx.h>    /* this gives all the CPU/hardware definitions */
#endif

#endif /* __IOE_H_ */
