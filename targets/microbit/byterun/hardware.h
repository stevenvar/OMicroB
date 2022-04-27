/* ubit-v2/hardware.h */
/* Copyright (c) 2018-20 J. M. Spivey */

#define UBIT 1

/* Hardware register definitions for nRF52833 */

#define BIT(i) (1 << (i))
#define SET_BIT(reg, n) reg |= BIT(n)
#define GET_BIT(reg, n) (((reg) >> (n)) & 0x1)
#define CLR_BIT(reg, n) reg &= ~BIT(n)
#define GET_BYTE(reg, n) (((reg) >> (8*(n))) & 0xff)
#define SET_BYTE(reg, n, v) \
    reg = (reg & ~(0xff << 8*n)) | ((v & 0xff) << 8*n)

/* The macros SET_FIELD, etc., are defined in an indirect way that
permits (because of the timing of CPP macro expansion) the 'field'
argument to be a macro that expands the a 'position, width' pair. */

#define SET_FIELD(reg, field, val) __SET_FIELD(reg, field, val)
#define __SET_FIELD(reg, pos, wid, val) \
    reg = (reg & ~__MASK(pos, wid)) | __FIELD(pos, wid, val)

#define GET_FIELD(reg, field) __GET_FIELD(reg, field)
#define __GET_FIELD(reg, pos, wid)  ((reg >> pos) & __MASK0(wid))

#define FIELD(field, val) __FIELD(field, val)
#define __FIELD(pos, wid, val)  (((val) & __MASK0(wid)) << pos)

#define MASK(field) __MASK(field)
#define __MASK(pos, wid)  (__MASK0(wid) << pos)

#define __MASK0(wid)  (~((-2) << (wid-1)))

#ifdef UBIT_V1

/* Device pins */
#define PAD19 0
#define  I2C_SCL PAD19
#define PAD2 1
#define PAD1 2
#define PAD0 3
/* LED columns are GPIO 4-12 */
#define PAD3 4
#define PAD4 5
#define PAD10 6
#define PAD9 10
#define PAD7 11
#define PAD6 12
#define ROW1 13
#define ROW2 14
#define ROW3 15
#define PAD16 16
#define PAD5 17
#define  BUTTON_A PAD5
#define PAD8 18
#define PAD12 20
#define PAD15 21
#define   SPI_MOSI PAD15
#define PAD14 22
#define  SPI_MISO PAD14
#define PAD13 23
#define  SPI_SCK PAD13
#define USB_TX 24
#define USB_RX 25
#define PAD11 26
#define  BUTTON_B PAD11
#define PAD20 30
#define  I2C_SDA PAD20

/* Only one I2C interface */
#define I2C_INTERNAL 0
#define I2C_EXTERNAL 0
#define N_I2C 1


/* Interrupts */
#define SVC_IRQ    -5
#define PENDSV_IRQ -2
#define RADIO_IRQ   1
#define UART_IRQ    2
#define I2C_IRQ     3
#define SPI_IRQ     4
#define GPIOTE_IRQ  6
#define ADC_IRQ     7
#define TIMER0_IRQ  8
#define TIMER1_IRQ  9
#define TIMER2_IRQ 10
#define RTC0_IRQ   11
#define TEMP_IRQ   12
#define RNG_IRQ    13
#define RTC1_IRQ   17

#define N_INTERRUPTS 32

#endif

#ifdef UBIT_V2

/* Device pins */
#define DEVPIN(p, i) ((p<<5) + i)
#define PORT(x) ((x)>>5)
#define PIN(x) ((x)&0x1f)

#define PAD14 DEVPIN(0, 1)
#define PAD0  DEVPIN(0, 2)
#define PAD1  DEVPIN(0, 3)
#define PAD2  DEVPIN(0, 4)
#define USB_TX DEVPIN(0, 6)
#define I2C0_SCL DEVPIN(0, 8)
#define PAD9  DEVPIN(0, 9)
#define PAD8  DEVPIN(0, 10)
#define PAD7  DEVPIN(0, 11)
#define   COL2 PAD7
#define PAD12 DEVPIN(0, 12)
#define PAD15 DEVPIN(0, 13)
#define PAD5  DEVPIN(0, 14)
#define   BUTTON_A PAD5
#define ROW3 DEVPIN(0, 15)
#define I2C0_SDA DEVPIN(0, 16)
#define PAD13 DEVPIN(0, 17)
#define ROW5 DEVPIN(0, 19)
#define ROW1 DEVPIN(0, 21)
#define ROW2 DEVPIN(0, 22)
#define PAD11 DEVPIN(0, 23)
#define   BUTTON_B PAD11
#define ROW4 DEVPIN(0, 24)
#define PAD19 DEVPIN(0, 26)
#define   I2C1_SCL PAD19
#define PAD4  DEVPIN(0, 28)
#define   COL1 PAD4
#define PAD10 DEVPIN(0, 30)
#define   COL5 PAD10
#define PAD3  DEVPIN(0, 31)
#define   COL3 PAD3

#define PAD20 DEVPIN(1, 0)
#define   I2C1_SDA PAD20
#define PAD16 DEVPIN(1, 2)
#define PAD6  DEVPIN(1, 5)
#define   COL4 PAD6
#define USB_RX DEVPIN(1, 8)

#define I2C_INTERNAL 0
#define I2C_EXTERNAL 1
#define N_I2C 2

/* TODO: Logo touch, mic power, mic input, speaker */

/* Interrupts */
#define SVC_IRQ    -5
#define PENDSV_IRQ -2
#define SYSTICK_IRQ -1
#define RADIO_IRQ   1
#define UART0_IRQ   2
#define I2C0_IRQ    3
#define I2C1_IRQ    4
#define GPIOTE_IRQ  6
#define ADC_IRQ     7
#define TIMER0_IRQ  8
#define TIMER1_IRQ  9
#define TIMER2_IRQ 10
#define RTC0_IRQ   11
#define TEMP_IRQ   12
#define RNG_IRQ    13
#define RTC1_IRQ   17
#define TIMER3_IRQ 26
#define TIMER4_IRQ 27
#define PWM0_IRQ   28
#define PWM1_IRQ   33
#define PWM2_IRQ   34
#define SPI0_IRQ   35
#define UART1_IRQ  40
#define PWM3_IRQ   45
#define SPI1_IRQ   47

#define N_INTERRUPTS 64

/* For compatibility, allow UART as a synonym for UART0 */
#define UART_IRQ UART0_IRQ
#define uart_handler uart0_handler

#endif

/* Device register structures */

/* The structure-like entities that describe hardware devices are in
fact unions containing an anonymous internal struct for each register:
each struct begins with a padding field as big as the offset of the
register.  Some macro trickery is needed here to create the unique
name of the padding field from the offset, so that (e.g.)

    _REGISTER(unsigned MODE, 0x504)

expands into

    struct { unsigned char _pad_0x504[0x504]; unsigned MODE; }

When this is overlaid with other similar structs in a big union, each
device register is given the appropriate offset.

Each device has a macro: for example, TIMER1 expands into

    (* (volatile _DEVICE _timer *) 0x40008000)

so client programs can use names like TIMER1.MODE to refer to an
individual device register, in this case at address 0x40008504.  
The C compiler ought to be able to sort out the address arithmetic
efficiently.

Where multiple identical devices exist, we make a little array of
pointers to them (in file startup.c), so that the same register can be
named as TIMER[1]->MODE in code that treats all timers uniformly.  The
-> is unfortunate, but this scheme has the advantage of not assuming
that the devices form a regular array in the address space -- which
the five timers certainly don't. */

#define _DEVICE  union
#define _REGISTER(decl, offset) \
    struct { unsigned char __pad_##offset[offset]; decl; }

/* _dma -- standard layout for DMA parameters */
struct _dma {
    void *PTR;
    unsigned MAXCNT;
    unsigned AMOUNT;
};
    

/* System control block */
_DEVICE _scb {
    _REGISTER(unsigned CPUID, 0x00);
    _REGISTER(unsigned ICSR, 0x04);
#define   SCB_ICSR_PENDSVSET 28
#define   SCB_ICSR_VECTACTIVE 0, 8
    _REGISTER(unsigned SCR, 0x10);
#define   SCB_SCR_SLEEPONEXIT 1
#define   SCB_SCR_SLEEPDEEP 2
#define   SCB_SCR_SEVONPEND 4
    _REGISTER(unsigned SHPR[3], 0x18);
};

#define SCB (* (volatile _DEVICE _scb *) 0xe000ed00)


/* Debug */
_DEVICE _debug {
    _REGISTER(unsigned DEMCR, 0xfc);
#define   DEBUG_DEMCR_TRCENA 24
};

//#define DEBUG (* (volatile _DEVICE _debug *) 0xe000ed00)


/* Nested vectored interupt controller */
_DEVICE _nvic {
    _REGISTER(unsigned ISER[8], 0x100);
    _REGISTER(unsigned ICER[8], 0x180);
    _REGISTER(unsigned ISPR[8], 0x200);
    _REGISTER(unsigned ICPR[8], 0x280);
    _REGISTER(unsigned IPR[60], 0x400);
};

#define NVIC (* (volatile _DEVICE _nvic *) 0xe000e000)

#ifdef UBIT_V2

/* Systick timer */
_DEVICE _systick {
    _REGISTER(unsigned CSR, 0x10);
#define  SYSTICK_CSR_COUNTFLAG 16
#define  SYSTICK_CSR_CLKSOURCE 2, 1
#define    SYSTICK_CLKSOURCE_External 0
#define    SYSTICK_CLKSOURCE_Internal 1
#define  SYSTICK_CSR_TICKINT 1
#define  SYSTICK_CSR_ENABLE 0            
    _REGISTER(unsigned RVR, 0x14);
    _REGISTER(unsigned CVR, 0x18);
    _REGISTER(unsigned CALIB, 0x1c);
#define   SYSTICK_CALIB_NOREF 31
#define   SYSTICK_CALIB_SKEW 30
#define   SYSTICK_CALIB_TENMS 0, 24
};

#define SYSTICK_CLOCK 64000000

#define SYSTICK (* (volatile _DEVICE _systick *) 0xe000e000)


/* Data watchpoint and trace */
_DEVICE _dwt {
    _REGISTER(unsigned CTRL, 0x00);
#define   DWT_CTRL_CYCCNTENA 0
    _REGISTER(unsigned CYCCNT, 0x04);
};

#define DWT (* (volatile _DEVICE _dwt *) 0xe0001000)

#endif


/* Clock control */
_DEVICE _clock {
    _REGISTER(unsigned HFCLKSTART, 0x000);
    _REGISTER(unsigned LFCLKSTART, 0x008);
    _REGISTER(unsigned HFCLKSTARTED, 0x100);
    _REGISTER(unsigned LFCLKSTARTED, 0x104);
    _REGISTER(unsigned LFCLKSRC, 0x518);
#define   CLOCK_LFCLKSRC_RC 0
#ifdef UBIT_V1
    _REGISTER(unsigned XTALFREQ, 0x550);
#define   CLOCK_XTALFREQ_16MHz 0xFF
#endif
};

#define CLOCK (* (volatile _DEVICE _clock *) 0x40000000)


/* Memory protection unit */
_DEVICE _mpu {
    _REGISTER(unsigned DISABLEINDEBUG, 0x608);
};

#define MPU (* (volatile _DEVICE _mpu *) 0x40000000)


/* Factory information */
_DEVICE _ficr {
    _REGISTER(unsigned DEVICEID[2], 0x060);
    _REGISTER(unsigned DEVICEADDR[2], 0x0a4);
    _REGISTER(unsigned OVERRIDEEN, 0x0a0);
#define   FICR_OVERRIDEEN_NRF 0
    _REGISTER(unsigned NRF_1MBIT[5], 0x0b0);
};

#define FICR (* (volatile _DEVICE _ficr *) 0x10000000)


/* Non-Volatile Memory Controller */
_DEVICE _nvmc {
    _REGISTER(unsigned READY, 0x400);
    _REGISTER(unsigned CONFIG, 0x504);
#define   NVMC_CONFIG_WEN 0
#define   NVMC_CONFIG_EEN 1   
    _REGISTER(void *ERASEPAGE, 0x508);
    _REGISTER(unsigned ICACHECONF, 0x540);
#define   NVMC_ICACHECONF_CACHEEN 0
};

#define NVMC (* (volatile _DEVICE _nvmc *) 0x4001e000)


/* GPIO */
_DEVICE _gpio {
/* Registers */
    _REGISTER(unsigned OUT, 0x004);
    _REGISTER(unsigned OUTSET, 0x008);
    _REGISTER(unsigned OUTCLR, 0x00c);
    _REGISTER(unsigned IN, 0x010);
    _REGISTER(unsigned DIR, 0x014);
    _REGISTER(unsigned DIRSET, 0x018);
    _REGISTER(unsigned DIRCLR, 0x01c);
    _REGISTER(unsigned PINCNF[32], 0x200);
#define   GPIO_PINCNF_DIR 0, 1
#define     GPIO_DIR_Input 0
#define     GPIO_DIR_Output 1
#define   GPIO_PINCNF_INPUT 1, 1
#define     GPIO_INPUT_Connect 0
#define     GPIO_INPUT_Disconnect 1
#define   GPIO_PINCNF_PULL 2, 2
#define     GPIO_PULL_Disabled 0
#define     GPII_PULL_Pulldown 1    
#define     GPIO_PULL_Pullup 3
#define   GPIO_PINCNF_DRIVE 8, 3
#define     GPIO_DRIVE_S0S1 0
#define     GPIO_DRIVE_H0S1 1
#define     GPIO_DRIVE_S0H1 2
#define     GPIO_DRIVE_S0D1 6 /* Open drain */
#define   GPIO_PINCNF_SENSE 16, 2
#define     GPIO_SENSE_Disabled 0
#define     GPIO_SENSE_High 2
#define     GPIO_SENSE_Low 3
};

#ifdef UBIT_V1
#define GPIO (* (volatile _DEVICE _gpio *) 0x50000500)
#endif

#ifdef UBIT_V2
#define GPIO0 (* (volatile _DEVICE _gpio *) 0x50000500)
#define GPIO1 (* (volatile _DEVICE _gpio *) 0x50000800)

extern volatile _DEVICE _gpio * const GPIO[2]; /* defined in startup.c */
#endif

/* GPIOTE */

_DEVICE _gpiote {
/* Tasks */
    _REGISTER(unsigned OUT[8], 0x000);
    _REGISTER(unsigned SET[8], 0x030);
    _REGISTER(unsigned CLR[8], 0x060);
/* Events */
    _REGISTER(unsigned IN[8], 0x100);
    _REGISTER(unsigned PORT, 0x17c);
/* Registers */
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned CONFIG[8], 0x510);
#define   GPIOTE_CONFIG_MODE 0, 2
#define     GPIOTE_MODE_Event 1
#define     GPIOTE_MODE_Task 3
#define   GPIOTE_CONFIG_PSEL 8, 6 /* Note 6 bits including port number */
#define   GPIOTE_CONFIG_POLARITY 16, 2
#define     GPIOTE_POLARITY_LoToHi 1
#define     GPIOTE_POLARITY_HiToLo 2
#define     GPIOTE_POLARITY_Toggle 3
#define   GPIOTE_CONFIG_OUTINIT 20, 1
};

/* Interrupts */
#define GPIOTE_INT_IN0 0
#define GPIOTE_INT_IN1 1
#define GPIOTE_INT_IN2 2
#define GPIOTE_INT_IN3 3
#ifdef UBIT_V2
#define GPIOTE_INT_IN4 4
#define GPIOTE_INT_IN5 5
#define GPIOTE_INT_IN6 6
#define GPIOTE_INT_IN7 7
#endif
#define GPIOTE_INT_PORT 31

#define GPIOTE (* (volatile _DEVICE _gpiote *) 0x40006000)


/* PPI */
_DEVICE _ppi {
/* Tasks */
    _REGISTER(struct {
        unsigned EN;
        unsigned DIS;
    } CHG[6], 0x000);
/* Registers */
    _REGISTER(unsigned CHEN, 0x500);
    _REGISTER(unsigned CHENSET, 0x504);
    _REGISTER(unsigned CHENCLR, 0x508);
    _REGISTER(struct {
        unsigned volatile *EEP;
        unsigned volatile *TEP;       
    } CH[20], 0x510);
    _REGISTER(unsigned CHGRP[6], 0x800);
    #ifdef UBIT_V2
    _REGISTER(struct {
        unsigned volatile *FORK;
    }, 0x910);
    #endif
};

#define PPI (* (volatile _DEVICE _ppi *) 0x4001f000)


/* Radio */
_DEVICE _radio {
/* Tasks */
    _REGISTER(unsigned TXEN, 0x000);
    _REGISTER(unsigned RXEN, 0x004);
    _REGISTER(unsigned START, 0x008);
    _REGISTER(unsigned STOP, 0x00c);
    _REGISTER(unsigned DISABLE, 0x010);
    _REGISTER(unsigned RSSISTART, 0x014);
    _REGISTER(unsigned RSSISTOP, 0x018);
    _REGISTER(unsigned BCSTART, 0x01c);
    _REGISTER(unsigned BCSTOP, 0x020);
/* Events */
    _REGISTER(unsigned READY, 0x100);
    _REGISTER(unsigned ADDRESS, 0x104);
    _REGISTER(unsigned PAYLOAD, 0x108);
    _REGISTER(unsigned END, 0x10c);
    _REGISTER(unsigned DISABLED, 0x110);
    _REGISTER(unsigned DEVMATCH, 0x114);
    _REGISTER(unsigned DEVMISS, 0x118);
    _REGISTER(unsigned RSSIEND, 0x11c);
    _REGISTER(unsigned BCMATCH, 0x128);
/* Registers */
    _REGISTER(unsigned SHORTS, 0x200);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned CRCSTATUS, 0x400);
    _REGISTER(unsigned RXMATCH, 0x408);
    _REGISTER(unsigned RXCRC, 0x40c);
    _REGISTER(unsigned DAI, 0x410);
    _REGISTER(void *PACKETPTR, 0x504);
    _REGISTER(unsigned FREQUENCY, 0x508);
    _REGISTER(unsigned TXPOWER, 0x50c);
    _REGISTER(unsigned MODE, 0x510);
#define   RADIO_MODE_NRF_1Mbit 0
    _REGISTER(unsigned PCNF0, 0x514);
#define   RADIO_PCNF0_LFLEN 0, 4
#define   RADIO_PCNF0_S0LEN 8, 1
#define   RADIO_PCNF0_S1LEN 16, 4
    _REGISTER(unsigned PCNF1, 0x518);
#define   RADIO_PCNF1_MAXLEN 0, 8
#define   RADIO_PCNF1_STATLEN 8, 8
#define   RADIO_PCNF1_BALEN 16, 3
#define   RADIO_PCNF1_ENDIAN 24, 1
#define     RADIO_ENDIAN_Little 0
#define     RADIO_ENDIAN_Big 1
#define   RADIO_PCNF1_WHITEEN 25
    _REGISTER(unsigned BASE0, 0x51c);
    _REGISTER(unsigned BASE1, 0x520);
    _REGISTER(unsigned PREFIX0, 0x524);
    _REGISTER(unsigned PREFIX1, 0x528);
    _REGISTER(unsigned TXADDRESS, 0x52c);
    _REGISTER(unsigned RXADDRESSES, 0x530);
    _REGISTER(unsigned CRCCNF, 0x534);
    _REGISTER(unsigned CRCPOLY, 0x538);
    _REGISTER(unsigned CRCINIT, 0x53c);
    _REGISTER(unsigned TEST, 0x540);
    _REGISTER(unsigned TIFS, 0x544);
    _REGISTER(unsigned RSSISAMPLE, 0x548);
    _REGISTER(unsigned STATE, 0x550);
    _REGISTER(unsigned DATAWHITEIV, 0x554);
    _REGISTER(unsigned BCC, 0x560);
    _REGISTER(unsigned DAB[8], 0x600);
    _REGISTER(unsigned DAP[8], 0x620);
    _REGISTER(unsigned DACNF, 0x640);
    _REGISTER(unsigned OVERRIDE[5], 0x724);
    _REGISTER(unsigned POWER, 0xffc);
};

/* Interrupts */
#define RADIO_INT_READY 0
#define RADIO_INT_END 3
#define RADIO_INT_DISABLED 4

#define RADIO (* (volatile _DEVICE _radio *) 0x40001000)


/* TIMERS: Timers 0, 1, 2 are all 8/16/24/32 bit.  
   There are two more timers at different addresses, plus a SysTick timer. */

_DEVICE _timer {
/* Tasks */
    _REGISTER(unsigned START, 0x000);
    _REGISTER(unsigned STOP, 0x004);
    _REGISTER(unsigned COUNT, 0x008);
    _REGISTER(unsigned CLEAR, 0x00c);
    _REGISTER(unsigned SHUTDOWN, 0x010);
    _REGISTER(unsigned CAPTURE[4], 0x040);
/* Events */
    _REGISTER(unsigned COMPARE[4], 0x140);
/* Registers */
    _REGISTER(unsigned SHORTS, 0x200);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned MODE, 0x504);
#define   TIMER_MODE_Timer 0
#define   TIMER_MODE_Counter 1
    _REGISTER(unsigned BITMODE, 0x508);
#define   TIMER_BITMODE_16Bit 0
#define   TIMER_BITMODE_8Bit 1
#define   TIMER_BITMODE_24Bit 2
#define   TIMER_BITMODE_32Bit 3
    _REGISTER(unsigned PRESCALER, 0x510);
    _REGISTER(unsigned CC[4], 0x540);
};

/* Interrupts */
#define TIMER_INT_COMPARE0 16
#define TIMER_INT_COMPARE1 17
#define TIMER_INT_COMPARE2 18
#define TIMER_INT_COMPARE3 19
/* Shortcuts */
#define TIMER_COMPARE0_CLEAR 0
#define TIMER_COMPARE1_CLEAR 1
#define TIMER_COMPARE2_CLEAR 2
#define TIMER_COMPARE3_CLEAR 3
#define TIMER_COMPARE0_STOP 8
#define TIMER_COMPARE1_STOP 9
#define TIMER_COMPARE2_STOP 10
#define TIMER_COMPARE3_STOP 11

#define TIMER0 (* (volatile _DEVICE _timer *) 0x40008000)
#define TIMER1 (* (volatile _DEVICE _timer *) 0x40009000)
#define TIMER2 (* (volatile _DEVICE _timer *) 0x4000a000)
#ifdef UBIT_V2
#define TIMER3 (* (volatile _DEVICE _timer *) 0x4001a000)
#define TIMER4 (* (volatile _DEVICE _timer *) 0x4001b000)
#endif

#ifdef UBIT_V1
extern volatile _DEVICE _timer * const TIMER[3];
#endif

#ifdef UBIT_V2
extern volatile _DEVICE _timer * const TIMER[5];
#endif


/* Random Number Generator */
_DEVICE _rng {
/* Tasks */
    _REGISTER(unsigned START, 0x000);
    _REGISTER(unsigned STOP, 0x004);
/* Events */
    _REGISTER(unsigned VALRDY, 0x100);
/* Registers */
    _REGISTER(unsigned SHORTS, 0x200);
    _REGISTER(unsigned INTEN, 0x300);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned CONFIG, 0x504);
#define   RNG_CONFIG_DERCEN 0
    _REGISTER(unsigned VALUE, 0x508);
};

/* Interrupts */
#define RNG_INT_VALRDY 0

#define RNG (* (volatile _DEVICE _rng *) 0x4000d000)


/* Temperature sensor */
_DEVICE _temp {
/* Tasks */
    _REGISTER(unsigned START, 0x000);
    _REGISTER(unsigned STOP, 0x004);
/* Events */
    _REGISTER(unsigned DATARDY, 0x100);
/* Registers */
    _REGISTER(unsigned INTEN, 0x300);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned VALUE, 0x508);
};

/* Interrupts */
#define TEMP_INT_DATARDY 0

#define TEMP (* (volatile _DEVICE _temp *) 0x4000c000)


/* I2C */
_DEVICE _i2c {
/* Tasks */
    _REGISTER(unsigned STARTRX, 0x000);
    _REGISTER(unsigned STARTTX, 0x008);
    _REGISTER(unsigned STOP, 0x014);
    _REGISTER(unsigned SUSPEND, 0x01c);
    _REGISTER(unsigned RESUME, 0x020);
/* Events */
    _REGISTER(unsigned STOPPED, 0x104);
    _REGISTER(unsigned RXDREADY, 0x108);
    _REGISTER(unsigned TXDSENT, 0x11c);
    _REGISTER(unsigned ERROR, 0x124);
    _REGISTER(unsigned BB, 0x138);
    _REGISTER(unsigned SUSPENDED, 0x148);
/* Registers */
    _REGISTER(unsigned SHORTS, 0x200);
    _REGISTER(unsigned INTEN, 0x300);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned ERRORSRC, 0x4c4);
#define   I2C_ERRORSRC_OVERRUN 0
#define   I2C_ERRORSRC_ANACK 1
#define   I2C_ERRORSRC_DNACK 2
#define   I2C_ERRORSRC_All 0x7
    _REGISTER(unsigned ENABLE, 0x500) ;
#define   I2C_ENABLE_Disabled 0
#define   I2C_ENABLE_Enabled 5
    _REGISTER(unsigned PSELSCL, 0x508);
    _REGISTER(unsigned PSELSDA, 0x50c);
    _REGISTER(unsigned RXD, 0x518);
    _REGISTER(unsigned TXD, 0x51c) ;
    _REGISTER(unsigned FREQUENCY, 0x524);
#define   I2C_FREQUENCY_100kHz 0x01980000
    _REGISTER(unsigned ADDRESS, 0x588);
    _REGISTER(unsigned POWER, 0xffc);
};
    
/* Interrupts */
#define I2C_INT_STOPPED 1
#define I2C_INT_RXDREADY 2
#define I2C_INT_TXDSENT 7
#define I2C_INT_ERROR 9
#define I2C_INT_BB 14
/* Shortcuts */
#define I2C_BB_SUSPEND 0
#define I2C_BB_STOP 1

#ifdef UBIT_V1
#define I2C0 (* (volatile _DEVICE _i2c *) 0x40003000)

extern volatile _DEVICE _i2c * const I2C[1];
#endif

#ifdef UBIT_V2
#define I2C0 (* (volatile _DEVICE _i2c *) 0x40003000)
#define I2C1 (* (volatile _DEVICE _i2c *) 0x40004000)

extern volatile _DEVICE _i2c * const I2C[2];
#endif


/* UART */
_DEVICE _uart {
/* Tasks */
    _REGISTER(unsigned STARTRX, 0x000);
    _REGISTER(unsigned STARTTX, 0x008);
/* Events */
    _REGISTER(unsigned RXDRDY, 0x108);
    _REGISTER(unsigned TXDRDY, 0x11c);
/* Registers */
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned ENABLE, 0x500);
#define   UART_ENABLE_Disabled 0
#define   UART_ENABLE_Enabled 4
    _REGISTER(unsigned PSELTXD, 0x50c);
    _REGISTER(unsigned PSELRXD, 0x514);
    _REGISTER(unsigned RXD, 0x518);
    _REGISTER(unsigned TXD, 0x51c);
    _REGISTER(unsigned BAUDRATE, 0x524);
#define   UART_BAUDRATE_1200   0x0004f000
#define   UART_BAUDRATE_2400   0x0009d000
#define   UART_BAUDRATE_4800   0x0013b000
#define   UART_BAUDRATE_9600   0x00275000
#define   UART_BAUDRATE_14400  0x003af000
#define   UART_BAUDRATE_19200  0x004ea000
#define   UART_BAUDRATE_28800  0x0075c000
#define   UART_BAUDRATE_31250  0x00800000
#define   UART_BAUDRATE_38400  0x009d0000
#define   UART_BAUDRATE_56000  0x00e50000
#define   UART_BAUDRATE_57600  0x00eb0000
#define   UART_BAUDRATE_76800  0x013a9000
#define   UART_BAUDRATE_115200 0x01d60000
#define   UART_BAUDRATE_230400 0x03b00000
#define   UART_BAUDRATE_250000 0x04000000
#define   UART_BAUDRATE_460800 0x07400000
#define   UART_BAUDRATE_921600 0x0f000000
#define   UART_BAUDRATE_1M     0x10000000
    _REGISTER(unsigned CONFIG, 0x56c);
#define   UART_CONFIG_HWFC 0
#define   UART_CONFIG_PARITY 1, 3
#define     UART_PARITY_None 0
#define     UART_PARITY_Even 7
};

/* Interrupts */
#define   UART_INT_RXDRDY 2
#define   UART_INT_TXDRDY 7

#define UART (* (volatile _DEVICE _uart *) 0x40002000)

#ifdef UBIT_V2

/* UARTE -- UART with EasyDMA */
_DEVICE _uarte {
/* Tasks */
    _REGISTER(unsigned STARTRX, 0x000);
    _REGISTER(unsigned STOPRX, 0x004);
    _REGISTER(unsigned STARTTX, 0x008);
    _REGISTER(unsigned STOPTX, 0x00c);
    _REGISTER(unsigned FLUSHRX, 0x02c);
/* Events */
    _REGISTER(unsigned CTS, 0x100);
    _REGISTER(unsigned NTCS, 0x104);
    _REGISTER(unsigned RXDRDY, 0x108);
    _REGISTER(unsigned ENDRX, 0x110);
    _REGISTER(unsigned TXDRDY, 0x11c);
    _REGISTER(unsigned ENDTX, 0x120);
    _REGISTER(unsigned ERROR, 0x124);
    _REGISTER(unsigned RXTO, 0x144);
    _REGISTER(unsigned RXSTARTED, 0x14c);
    _REGISTER(unsigned TXSTARTED, 0x150);
    _REGISTER(unsigned TXSTOPPED, 0x158);
/* Shorts */
    _REGISTER(unsigned SHORTS, 0x200);
#define   UARTE_ENDRX_STARTRX 5
#define   UARTE_ENDRX_STOPRX 6
/* Registers */
    _REGISTER(unsigned INTEN, 0x300);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
#define   UARTE_INT_CTS 0
#define   UARTE_INT_NCTS 1
#define   UARTE_INT_RXDRDY 2
#define   UARTE_INT_ENDRX 4
#define   UARTE_INT_TXDRDY 7
#define   UARTE_INT_ENDTX 8
#define   UARTE_INT_ERROR 9
#define   UARTE_INT_RXTO 17
#define   UARTE_INT_RXSTARTED 19
#define   UARTE_INT_TXSTARTED 20
#define   UARTE_INT_TXSTOPPED 22
    _REGISTER(unsigned ERRORSRC, 0x480);
#define   UARTE_ERROR_OVERRUN 0
#define   UARTE_ERROR_PARITY 1
#define   UARTE_ERROR_FRAMING 2
#define   UARTE_ERROR_BREAK 3
    _REGISTER(unsigned ENABLE, 0x500);
#define   UARTE_ENABLE_Disabled 0
#define   UARTE_ENABLE_Enabled 8
    _REGISTER(unsigned PSELRTS, 0x508);
    _REGISTER(unsigned PSELTXD, 0x50c);
    _REGISTER(unsigned PSELCTS, 0x510);
    _REGISTER(unsigned PSELRXD, 0x514);
    _REGISTER(unsigned BAUDRATE, 0x524);
#define   UARTE_BAUDRATE_1200   0x0004f000
#define   UARTE_BAUDRATE_2400   0x0009d000
#define   UARTE_BAUDRATE_4800   0x0013b000
#define   UARTE_BAUDRATE_9600   0x00275000
#define   UARTE_BAUDRATE_14400  0x003af000
#define   UARTE_BAUDRATE_19200  0x004ea000
#define   UARTE_BAUDRATE_28800  0x0075c000
#define   UARTE_BAUDRATE_31250  0x00800000
#define   UARTE_BAUDRATE_38400  0x009d0000
#define   UARTE_BAUDRATE_56000  0x00e50000
#define   UARTE_BAUDRATE_57600  0x00eb0000
#define   UARTE_BAUDRATE_76800  0x013a9000
#define   UARTE_BAUDRATE_115200 0x01d60000
#define   UARTE_BAUDRATE_230400 0x03b00000
#define   UARTE_BAUDRATE_250000 0x04000000
#define   UARTE_BAUDRATE_460800 0x07400000
#define   UARTE_BAUDRATE_921600 0x0f000000
#define   UARTE_BAUDRATE_1M     0x10000000
    _REGISTER(struct _dma RXD, 0x534);
    _REGISTER(struct _dma TXD, 0x544);
    _REGISTER(unsigned CONFIG, 0x56c);
#define   UARTE_CONFIG_HWFC 0
#define   UARTE_CONFIG_PARITY 1, 3
#define     UARTE_PARITY_Disabled 0
#define     UARTE_PARITY_Enabled 7
#define   UARTE_CONFIG_STOP 4, 1
#define     UARTE_STOP_1 0
#define     UARTE_STOP_2 1
#define   UARTE_CONFIG_PARITYTYPE 8
#define     UARTE_PARITYTYPE_Even 0
#define     UARTE_PARITYTYPE_Odd 1
};

#define UARTE0 (* (volatile _DEVICE _uarte *) 0x40002000)
#define UARTE1 (* (volatile _DEVICE _uarte *) 0x40028000)

extern volatile _DEVICE _uarte * const UARTE[2];

#endif

#ifdef UBIT_V1

/* ADC */
_DEVICE _adc {
/* Tasks */
    _REGISTER(unsigned START, 0x000);
    _REGISTER(unsigned STOP, 0x004);
/* Events */
    _REGISTER(unsigned END, 0x100);
/* Registers */
    _REGISTER(unsigned INTEN, 0x300);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned BUSY, 0x400);
    _REGISTER(unsigned ENABLE, 0x500);
    _REGISTER(unsigned CONFIG, 0x504);
#define   ADC_CONFIG_RES 0, 2
#define     ADC_RES_8Bit 0
#define     ADC_RES_9bit 1
#define     ADC_RES_10bit 2
#define   ADC_CONFIG_INPSEL 2, 3
#define     ADC_INPSEL_AIn_1_1 0
#define     ADC_INPSEL_AIn_2_3 1
#define     ADC_INPSEL_AIn_1_3 2
#define     ADC_INPSEL_Vdd_2_3 5
#define     ADC_INPSEL_Vdd_1_3 6
#define   ADC_CONFIG_REFSEL 5, 2
#define     ADC_REFSEL_BGap 0
#define     ADC_REFSEL_Ext 1
#define     ADC_REFSEL_Vdd_1_2 2
#define     ADC_REFSEL_Vdd_1_3 3
#define   ADC_CONFIG_PSEL 8, 8
#define   ADC_CONFIG_EXTREFSEL 16, 2
#define     ADC_EXTREFSEL_Ref0 1
#define     ADC_EXTREFSEL_Ref1 2
    _REGISTER(unsigned RESULT, 0x508);
};

/* Interrupts */
#define ADC_INT_END 0

#define ADC (* (volatile _DEVICE _adc *) 0x40007000)

#endif

#ifdef UBIT_V2

/* SAADC */
_DEVICE _adc {
/* Tasks */
    _REGISTER(unsigned START, 0x000);
    _REGISTER(unsigned SAMPLE, 0x004);
    _REGISTER(unsigned STOP, 0x008);
    _REGISTER(unsigned CALIBRATE, 0x00c);
/* Events */
    _REGISTER(unsigned STARTED, 0x100);
    _REGISTER(unsigned END, 0x104);
    _REGISTER(unsigned DONE, 0x108);
    _REGISTER(unsigned RESULTDONE, 0x10c);
    _REGISTER(unsigned CALDONE, 0x110);
    _REGISTER(unsigned STOPPED, 0x114);
/* Registers */
    _REGISTER(unsigned INTEN, 0x300);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned BUSY, 0x400);
    _REGISTER(unsigned ENABLE, 0x500);
    _REGISTER(struct {
        unsigned PSELP;
        unsigned PSELN;
        unsigned CONFIG;
        unsigned LIMIT;
    } CHAN[8], 0x510);
#define   ADC_CONFIG_RESP 0, 2
#define   ADC_CONFIG_RESN 4, 2
#define     ADC_RES_Bypass 0
#define     ADC_RES_Pulldown 1
#define     ADC_RES_Pullup 2
#define     ADC_RES_VDD_1_2 3
#define   ADC_CONFIG_GAIN 8, 3
#define     ADC_GAIN_1_6 0
#define     ADC_GAIN_1_5 1
#define     ADC_GAIN_1_4 2
#define     ADC_GAIN_1_3 3
#define     ADC_GAIN_1_2 4
#define     ADC_GAIN_1 5
#define     ADC_GAIN_2 6
#define     ADC_GAIN_3 7
#define   ADC_CONFIG_REFSEL 12, 1
#define     ADC_REFSEL_Internal 0
#define     ADC_REFSEL_VDD_1_4 1
#define   ADC_CONFIG_TACQ 16, 3
#define     ADC_TACQ_3us 0
#define     ADC_TACQ_5us 1
#define     ADC_TACQ_10us 2
#define     ADC_TACQ_15us 3
#define     ADC_TACQ_20us 4
#define     ADC_TACQ_40us 5
#define  ADC_CONFIG_MODE 20, 1
#define     ADC_MODE_SE 0
#define     ADC_MODE_Diff 1
#define  ADC_CONFIG_BURST 24, 1
#define     ADC_BURST_Disabled 0
#define     ADC_BURST_Enabled 1
    _REGISTER(unsigned RESOLUTION, 0x5f0);
#define   ADC_RESOLUTION_8bit 0
#define   ADC_RESOLUTION_10bit 1
#define   ADC_RESOLUTION_12bit 2
#define   ADC_RESOLUTION_14bit 3
    _REGISTER(unsigned OVERSAMPLE, 0x5f4);
    _REGISTER(unsigned SAMPLERATE, 0x5f8);
    _REGISTER(struct _dma RESULT, 0x62c);
};

/* Interrupts */
#define ADC_INT_STARTED 0
#define ADC_INT_END 1
#define ADC_INT_DONE 2
#define ADC_INT_RESULTDONE 3
#define ADC_INT_CALDONE 4
#define ADC_INT_STOPPED 5

#define ADC (* (volatile _DEVICE _adc *) 0x40007000)

/* PWM */
_DEVICE _pwm {                       
/* Tasks */
    _REGISTER(unsigned STOP, 0x004);
    _REGISTER(unsigned SEQSTART[2], 0x008);
    _REGISTER(unsigned NEXTSTEP, 0x010);
/* Events */
    _REGISTER(unsigned STOPPED, 0x104);
    _REGISTER(unsigned SEQSTARTED[2], 0x108);
    _REGISTER(unsigned SEQEND[2], 0x110);
    _REGISTER(unsigned PWMPERIODEND, 0x118);
    _REGISTER(unsigned LOOPSDONE, 0x11c);
/* Registers */
    _REGISTER(unsigned SHORTS, 0x200);
    _REGISTER(unsigned INTEN, 0x300);
    _REGISTER(unsigned INTENSET, 0x304);
    _REGISTER(unsigned INTENCLR, 0x308);
    _REGISTER(unsigned ENABLE, 0x500);
    _REGISTER(unsigned MODE, 0x504);
#define   PWM_MODE_Up 0
#define   PWM_MODE_UpAndDown 1
    _REGISTER(unsigned COUNTERTOP, 0x508);
    _REGISTER(unsigned PRESCALER, 0x50c);
    _REGISTER(unsigned DECODER, 0x510);
#define   PWM_DECODER_LOAD 0, 2
#define     PWM_LOAD_Common 0
#define     PWM_LOAD_Grouped 1
#define     PWM_LOAD_Individual 2
#define     PWM_LOAD_Waveform 3
#define   PWM_DECODER_MODE 8, 1
#define     PWM_MODE_RefreshCount 0
#define     PWM_MODE_NextStep 1
    _REGISTER(unsigned LOOP, 0x514);
    _REGISTER(struct {
        void *PTR;
        unsigned CNT;
        unsigned REFRESH;
        unsigned ENDDELAY;
        unsigned char filler[16];
    } SEQ[2], 0x520);
    _REGISTER(unsigned PSEL[4], 0x560);
};
    
/* Interrupts */
#define   PWM_INT_STOPPED 1
#define   PWM_INT_SEQSTARTED0 2
#define   PWM_INT_SEQSTARTED1 3
#define   PWM_INT_SEQEND0 4
#define   PWM_INT_SEQEND1 5
#define   PWM_INT_PWMPERIODEND 6
#define   PWM_INT_LOOPSDONE 7

/* Shortcuts */
#define   PWM_SEQEND0_STOP 0
#define   PWM_SEQEND1_STOP 1
#define   PWM_LOOPSDONE_SEQSTART0 2
#define   PWM_LOOPSDONE_SEQSTART1 3
#define   PWM_LOOPSDONE_STOP 4

#define PWM0 (* (volatile _DEVICE _pwm *) 0x4001c000)
#define PWM1 (* (volatile _DEVICE _pwm *) 0x40021000)
#define PWM2 (* (volatile _DEVICE _pwm *) 0x40022000)
#define PWM3 (* (volatile _DEVICE _pwm *) 0x4002d000)

extern volatile _DEVICE _pwm * const PWM[4];

/* PWM sequence parameters */
#define PWM_SEQ_COMPARE 0, 15
#define PWM_SEQ_POLARITY 15, 1
#define   PWM_POLARITY_RisingEdge 0
#define   PWM_POLARITY_FallingEdge 1

#define PWM_SAMPLE(c, p) \
    (FIELD(PWM_SEQ_COMPARE, c) | FIELD(PWM_SEQ_POLARITY, p))
#define RISING PWM_POLARITY_RisingEdge
#define FALLING PWM_POLARITY_FallingEdge

#endif

// TODO integrate ubit 1 here

/* NVIC stuff */

/* irq_priority -- set priority of an IRQ from 0 (highest) to 255 */
void irq_priority(int irq, unsigned priority);

/* enable_irq -- enable interrupts from an IRQ */
#define enable_irq(irq)  NVIC.ISER[(irq)>>5] = BIT((irq)&0x1f)

/* disable_irq -- disable interrupts from a specific IRQ */
#define disable_irq(irq)  NVIC.ICER[(irq)>>5] = BIT((irq)&0x1f)

/* clear_pending -- clear pending interrupt from an IRQ */
#define clear_pending(irq)  NVIC.ICPR[(irq)>>5] = BIT((irq)&0x1f)

/* reschedule -- request PendSC interrupt */
#define reschedule()  SCB.ICSR = BIT(SCB_ICSR_PENDSVSET)

/* active_irq -- find active interrupt: -16 to 63 */
#define active_irq()  (GET_FIELD(SCB.ICSR, SCB_ICSR_VECTACTIVE) - 16)

/* delay_loop -- timed delay */
void delay_loop(unsigned usec);


/* GPIO convenience */

/* gpio_dir -- set GPIO direction */
static inline void gpio_dir(unsigned pin, unsigned dir) {
#ifdef UBIT_V1
  if (dir) GPIO.DIRSET = BIT(pin);
  else GPIO.DIRCLR = BIT(pin);
#endif
#ifdef UBIT_V2
  if (dir) GPIO[PORT(pin)]->DIRSET = BIT(PIN(pin));
  else GPIO[PORT(pin)]->DIRCLR = BIT(PIN(pin));
#endif
}

/* gpio_connect -- connect pin for input */
static inline void gpio_connect(unsigned pin) {
#ifdef UBIT_V1
  SET_FIELD(GPIO.PINCNF[pin], GPIO_PINCNF_INPUT, GPIO_INPUT_Connect);
#endif
#ifdef UBIT_V2
  SET_FIELD(GPIO[PORT(pin)]->PINCNF[PIN(pin)],
            GPIO_PINCNF_INPUT, GPIO_INPUT_Connect);
#endif
}

/* gpio_drive -- set GPIO drive strength */
static inline void gpio_drive(unsigned pin, unsigned mode) {
#ifdef UBIT_V1
  SET_FIELD(GPIO.PINCNF[pin], GPIO_PINCNF_DRIVE, mode);
#endif
#ifdef UBIT_V2
  SET_FIELD(GPIO[PORT(pin)]->PINCNF[PIN(pin)],
            GPIO_PINCNF_DRIVE, mode);
#endif
}

/* gpio_out -- set GPIO output bit */
static inline void gpio_out(unsigned pin, unsigned value) {
#ifdef UBIT_V1
  if (value) GPIO.OUTSET = BIT(pin);
  else GPIO.OUTCLR = BIT(pin);
#endif
#ifdef UBIT_V2
  if (value) GPIO[PORT(pin)]->OUTSET = BIT(PIN(pin));
  else GPIO[PORT(pin)]->OUTCLR = BIT(PIN(pin));
#endif
}

/* gpio_in -- get GPIO input bit */
static inline unsigned gpio_in(unsigned pin) {
#ifdef UBIT_V1
  return GET_BIT(GPIO.IN, pin);
#endif
#ifdef UBIT_V2
  return GET_BIT(GPIO[PORT(pin)]->IN, PIN(pin));
#endif
}


/* Image constants */

#ifdef UBIT_V1

#define NIMG 3

typedef unsigned image[NIMG];

#define __ROW(r, c1, c2, c3, c4, c5, c6, c7, c8, c9)                 \
    (BIT(r) | !c1<<4 | !c2<<5 | !c3<<6 | !c4<<7 | !c5<<8             \
     | !c6<<9 | !c7<<10 | !c8<<11 | !c9<<12)

#define IMAGE(x11, x24, x12, x25, x13,                               \
              x34, x35, x36, x37, x38,                               \
              x22, x19, x23, x39, x21,                               \
              x18, x17, x16, x15, x14,                               \
              x33, x27, x31, x26, x32)                               \
    { __ROW(ROW1, x11, x12, x13, x14, x15, x16, x17, x18, x19),      \
      __ROW(ROW2, x21, x22, x23, x24, x25, x26, x27, 0, 0),          \
      __ROW(ROW3, x31, x32, x33, x34, x35, x36, x37, x38, x39) }

#define LED_MASK 0xfff0

#define led_init()  GPIO.DIRSET = LED_MASK
#define led_dot()   GPIO.OUTSET = 0x5fbf
#define led_off()   GPIO.OUTCLR = LED_MASK

#endif

#ifdef UBIT_V2

#define NIMG 10

typedef unsigned image[NIMG];

#define LED_MASK0 0xd1688800 /* 1101 0001 0110 1000 1000 1000 0000 0000 */
#define LED_MASK1 0x00000020
#define LED_DOT0  0x50008800 /* 0101 0000 0000 0000 1000 1000 0000 0000 */
#define LED_DOT1  0x00000020

#define __ROW(r, c1, c2, c3, c4, c5) \
    BIT(r) | (!c1<<28) | (!c2<<11) | (!c3<<31) | (!c5<<30), (!c4<<5)

#define IMAGE(x11, x12, x13, x14, x15, \
              x21, x22, x23, x24, x25, \
              x31, x32, x33, x34, x35, \
              x41, x42, x43, x44, x45, \
              x51, x52, x53, x54, x55) \
    { __ROW(ROW1, x11, x12, x13, x14, x15), \
      __ROW(ROW2, x21, x22, x23, x24, x25), \
      __ROW(ROW3, x31, x32, x33, x34, x35), \
      __ROW(ROW4, x41, x42, x43, x44, x45), \
      __ROW(ROW5, x51, x52, x53, x54, x55) }
    
#define led_init()  GPIO0.DIRSET = LED_MASK0, GPIO1.DIRSET = LED_MASK1
#define led_dot()   GPIO0.OUTSET = LED_DOT0, GPIO1.OUTSET = LED_DOT1
#define led_off()   GPIO0.OUTCLR = LED_MASK0, GPIO1.OUTCLR = LED_MASK1

#endif

/* CODERAM -- mark function for copying to RAM */
#define CODERAM  __attribute((noinline, section(".xram")))

/* A few assembler macros for single instructions. */
#define intr_disable()  asm volatile ("cpsid i")
#define intr_enable()   asm volatile ("cpsie i")
#define get_primask()   ({ unsigned x;                                   \
                           asm volatile ("mrs %0, primask" : "=r"(x)); x; })
#define set_primask(x)  asm volatile ("msr primask, %0" : : "r"(x))
#define nop()           asm volatile ("nop")
#define syscall(op)     asm volatile ("svc %0" : : "i"(op))

/* pause() -- disabled on V2 owing to long wakeup time */
#ifdef UBIT_V1
#define pause()         asm volatile ("wfe")
#endif
#ifdef UBIT_V2
#define pause()         /* asm volatile ("wfe") */
#endif
