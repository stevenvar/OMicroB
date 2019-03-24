//************************************************************************
//* p32_defs.h
//*
//* chipKIT core files for PIC32
//*     Copyright (c) 2011 by Digilent Inc.
//* 
//************************************************************************
//*     Author: Gene Apperson
//*     Copyright (c) 2011, Digilent Inc, All rights reserved
//************************************************************************
//*
//* This file contains hardware dependent symbol and data type declarations
//* for the PIC32 microcontroller.
//*
//************************************************************************
//* This file is part of the core system for the chipKIT version
//* of the Arduino code base. It defines various generic symbols
//* describing the Microchip PIC32 devices.
//* 
//* This library is free software; you can redistribute it and/or
//* modify it under the terms of the GNU Lesser General Public
//* License as published by the Free Software Foundation; either
//* version 2.1 of the License, or (at your option) any later version.
//* 
//* This library is distributed in the hope that it will be useful,
//* but WITHOUT ANY WARRANTY; without even the implied warranty of
//* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//* Lesser General Public License for more details.
//* 
//* You should have received a copy of the GNU Lesser General
//* Public License along with this library; if not, write to the
//* Free Software Foundation, Inc., 59 Temple Place, Suite 330,
//* Boston, MA  02111-1307  USA
//************************************************************************
//* Edit History
//************************************************************************
//* Oct 2, 2011 <Gene Apperson> created
//* Jul 26, 2012 <GeneApperson> Added PPS support for PIC32MX1xx/MX2xx devices
//* Feb  6, 2013 <GeneApperson> Added bit definitions for several peripherals
//* Feb 17, 2012    <KeithV> Added PPS support for MZ devices
//************************************************************************


#if !defined(_P32_DEFS_H)
#define _P32_DEFS_H

#include <p32xxxx.h>
#include "cpudefs.h"
#include <inttypes.h>

/* ------------------------------------------------------------ */
/*              Misc. Declarations                              */
/* ------------------------------------------------------------ */

#define FLASH_SPEED_HZ          30000000

/* Some 3rd party chipKIT/Arduino libraries and sketches need a 
 * definition for BYTE. This is thrown in here in case they
 * need it. */
#ifndef BYTE
typedef uint8_t BYTE;
#endif

/* This next section is a minimial implementation of things that
 * would normally be in plib.h, which was removed when we went
 * from MPIDE to chipKIT-core. Some user sketches and 3d party
 * libraries need these functions to compile properly. */
#define BIT_0       0x0001
#define BIT_1       0x0002
#define BIT_2       0x0004
#define BIT_3       0x0008
#define BIT_4       0x0010
#define BIT_5       0x0020
#define BIT_6       0x0040
#define BIT_7       0x0080
#define BIT_8       0x0100
#define BIT_9       0x0200
#define BIT_10      0x0400
#define BIT_11      0x0800
#define BIT_12      0x1000
#define BIT_13      0x2000
#define BIT_14      0x4000
#define BIT_15      0x8000

#define IOPORT_A    A
#define IOPORT_B    B
#define IOPORT_C    C
#define IOPORT_D    D
#define IOPORT_E    E
#define IOPORT_F    F
#define IOPORT_G    G
#define IOPORT_H    H
#define IOPORT_J    J
#define IOPORT_K    K

#define PORTSetBitsX(PORTx, BITS) LAT##PORTx##SET = BITS
#define PORTSetBits(PORTx, BITS) PORTSetBitsX(PORTx, BITS)

#define PORTClearBitsX(PORTx, BITS) LAT##PORTx##CLR = BITS
#define PORTClearBits(PORTx, BITS) PORTClearBitsX(PORTx, BITS)

#define PORTReadBitsX(PORTx, BITS) (PORT##PORTx & BITS)
#define PORTReadBits(PORTx, BITS) PORTReadBitsX(PORTx, BITS)

#define PORTSetPinsDigitalOutX(PORTx, BITS) TRIS##PORTx##CLR = BITS
#define PORTSetPinsDigitalOut(PORTx, BITS) PORTSetPinsDigitalOutX(PORTx, BITS)

#define PORTSetPinsDigitalInX(PORTx, BITS) TRIS##PORTx##SET = BITS
#define PORTSetPinsDigitalIn(PORTx, BITS) PORTSetPinsDigitalInX(PORTx, BITS)

#if defined(__PIC32_PPS__)
    #define PORTSetAsDigitalPinX(PORTx, BITS) ANSEL##PORTx##CLR = BITS
    #define PORTSetAsDigitalPin(PORTx, BITS) PORTSetAsDigitalPinX(PORTx, BITS)
#endif


/* ------------------------------------------------------------ */
/*              Register Declarations                           */
/* ------------------------------------------------------------ */

typedef union {
  struct {
    unsigned r0:1;
    unsigned r1:1;
    unsigned r2:1;
    unsigned r3:1;
    unsigned r4:1;
    unsigned r5:1;
    unsigned r6:1;
    unsigned r7:1;
    unsigned r8:1;
    unsigned r9:1;
    unsigned r10:1;
    unsigned r11:1;
    unsigned r12:1;
    unsigned r13:1;
    unsigned r14:1;
    unsigned r15:1;
  };
  struct {
    unsigned w:32;
  };
} __REGbits_t;

/* This structure describes the register layout of the primary
** register, set, clear, and invert registers associated with
** most special function registers.
*/
typedef struct {
    volatile uint32_t   reg;
    volatile uint32_t   clr;
    volatile uint32_t   set;
    volatile uint32_t   inv;
} p32_regset;

/* This structure describes the register layout for a buffer
** register that does't have the associated set, clear, and invert
** registers.
*/
typedef struct {
    volatile uint32_t   reg;
    volatile uint32_t   rsv1;
    volatile uint32_t   rsv2;
    volatile uint32_t   rsv3;
} p32_regbuf;

/* This structure describes the register layout of an I/O port.
*/
#if defined(__PIC32_PPS__)
typedef struct {
    union
    {
        volatile p32_regset ansel;
        struct
        {
            volatile __REGbits_t ANSELxbits;
            volatile __REGbits_t ANSELxCLR;
            volatile __REGbits_t ANSELxSET;
            volatile __REGbits_t ANSELxINV;
        };
    };
    union
    {
        volatile p32_regset tris;
        struct
        {
            volatile __REGbits_t TRISxbits;
            volatile __REGbits_t TRISxCLR;
            volatile __REGbits_t TRISxSET;
            volatile __REGbits_t TRISxINV;
        };
    };
    union
    {
        volatile p32_regset port;
        struct
        {
            volatile __REGbits_t PORTxbits;
            volatile __REGbits_t PORTxCLR;
            volatile __REGbits_t PORTxSET;
            volatile __REGbits_t PORTxINV;
        };
    };
    union
    {
        volatile p32_regset lat;
        struct
        {
            volatile __REGbits_t LATxbits;
            volatile __REGbits_t LATxCLR;
            volatile __REGbits_t LATxSET;
            volatile __REGbits_t LATxINV;
        };
    };
    union
    {
        volatile p32_regset odc;
        struct
        {
            volatile __REGbits_t ODCxbits;
            volatile __REGbits_t ODCxCLR;
            volatile __REGbits_t ODCxSET;
            volatile __REGbits_t ODCxINV;
        };
    };
    union
    {
        volatile p32_regset cnpu;
        struct
        {
            volatile __REGbits_t CNPUxbits;
            volatile __REGbits_t CNPUxCLR;
            volatile __REGbits_t CNPUxSET;
            volatile __REGbits_t CNPUxINV;
       };
    };

    union
    {
        volatile p32_regset cnpd;
        struct
        {
            volatile __REGbits_t CNPDxbits;
            volatile __REGbits_t CNPDxCLR;
            volatile __REGbits_t CNPDxSET;
            volatile __REGbits_t CNPDxINV;
        };
    };
    union
    {
        volatile p32_regset cncon;
        struct
        {
            volatile __REGbits_t CNCONxbits;
            volatile __REGbits_t CNCONxCLR;
            volatile __REGbits_t CNCONxSET;
            volatile __REGbits_t CNCONxINV;
        };
    };
    union 
    {
        volatile p32_regset cnen;
        struct
        {
            volatile __REGbits_t CNENxbits;
            volatile __REGbits_t CNENxCLR;
            volatile __REGbits_t CNENxSET;
            volatile __REGbits_t CNENxINV;
        };
    };
    union
    {
        volatile p32_regset cnstat;
        struct
        {
            volatile __REGbits_t CNSTATxbits;
            volatile __REGbits_t CNSTATxCLR;
            volatile __REGbits_t CNSTATxSET;
            volatile __REGbits_t CNSTATxINV;
        };
    };
} p32_ioport;
#else       // Non-PPS PIC32s have much simpler I/O register structures
typedef struct {
    union
    {
        volatile p32_regset tris;
        struct
        {
            volatile __REGbits_t TRISxbits;
            volatile __REGbits_t TRISxCLR;
            volatile __REGbits_t TRISxSET;
            volatile __REGbits_t TRISxINV;
        };
    };
    union
    {
        volatile p32_regset port;
        struct
        {
            volatile __REGbits_t PORTxbits;
            volatile __REGbits_t PORTxCLR;
            volatile __REGbits_t PORTxSET;
            volatile __REGbits_t PORTxINV;
        };
    };
    union
    {
        volatile p32_regset lat;
        struct
        {
            volatile __REGbits_t LATxbits;
            volatile __REGbits_t LATxCLR;
            volatile __REGbits_t LATxSET;
            volatile __REGbits_t LATxINV;
        };
    };
    union
    {
        volatile p32_regset odc;
        struct
        {
            volatile __REGbits_t ODCxbits;
            volatile __REGbits_t ODCxCLR;
            volatile __REGbits_t ODCxSET;
            volatile __REGbits_t ODCxINV;
        };
    };
} p32_ioport;
#endif

/* This structure defines the registers for a PIC32 UART.
*/
typedef struct {
    union
    {
        volatile __U1MODEbits_t uartMode;
        volatile p32_regset     uxMode;
    };
    union
    {
        volatile __U1STAbits_t  uartSta;
        volatile p32_regset     uxSta;
    };
    volatile p32_regbuf uxTx;
    volatile p32_regbuf uxRx;
    volatile p32_regset uxBrg;
} p32_uart;

/* UxMODE - Define bits in UART mode port
*/
#define _UARTMODE_ON    15
#define _UARTMODE_BRGH  3
#define _UARTMODE_PDSEL 1

/* UxSTA - Define bits in UART status/control register
*/
#define _UARTSTA_ADM_EN 24
#define _UARTSTA_ADDR   16
#define _UARTSTA_URXEN  12
#define _UARTSTA_UTXEN  10
#define _UARTSTA_UTXBF  9
#define _UARTSTA_TMRT   8
#define _UARTSTA_ADDEN  5

/* Structure for the registers of a PIC32 SPI controller
*/
typedef struct {
    union
    {
        volatile __SPI2CONbits_t    spiCon;
        volatile p32_regset         sxCon;
    };
    union
    {
        volatile __SPI2STATbits_t   spiStat;
        volatile p32_regset         sxStat;
    };
    volatile p32_regbuf sxBuf;
    volatile p32_regset sxBrg;
} p32_spi;

/*  SPIxCON - Define bits in the SPI control port
*/
#define _SPICON_ON      15
#define _SPICON_MODE32      11
#define _SPICON_MODE16      10
#define _SPICON_SMP     9
#define _SPICON_CKE     8
#define _SPICON_CKP     6
#define _SPICON_MSTEN   5

/*  SPIxSTAT - Define symbols in the SPI status port
*/
#define _SPISTAT_SPIROV 6
#define _SPISTAT_SPIRBE 5
#define _SPISTAT_SPITBE 3
#define _SPISTAT_SPITBF 1
#define _SPISTAT_SPIRBF 0

/* This structure defines the registers for a PIC32 I2C port.
*/
typedef struct {
    union
    {
        volatile __I2C1CONbits_t    i2cCon;
        volatile p32_regset         ixCon;
    };
    union
    {
        volatile __I2C1STATbits_t   i2cStat;
        volatile p32_regset         ixStat;
    };
    volatile p32_regset ixAdd;
    volatile p32_regset ixMsk;
    volatile p32_regset ixBrg;
    volatile p32_regset ixTrn;
    volatile p32_regbuf ixRcv;
} p32_i2c;

/* I2CxCON - Define symbols for the I2C control port bits
*/
#define _I2CCON_ON      15
#define _I2CCON_SIDL    13
#define _I2CCON_SCLREL  12
#define _I2CCON_STRICT  11
#define _I2CCON_A10M    10
#define _I2CCON_DISSLW  9
#define _I2CCON_SMEN    8
#define _I2CCON_GCEN    7
#define _I2CCON_STREN   6
#define _I2CCON_ACKDT   5
#define _I2CCON_ACKEN   4
#define _I2CCON_RCEN    3
#define _I2CCON_PEN     2
#define _I2CCON_RSEN    1
#define _I2CCON_SEN     0

/* I2CSTAT - Define symbols for the I2C status port bits
*/
#define _I2CSTAT_ACKSTAT    15
#define _I2CSTAT_TRSTAT     14
#define _I2CSTAT_BCL        10
#define _I2CSTAT_GCSTAT     9
#define _I2CSTAT_ADD10      8
#define _I2CSTAT_IWCOL      7
#define _I2CSTAT_I2COV      6
#define _I2CSTAT_DA         5
#define _I2CSTAT_P          4
#define _I2CSTAT_S          3
#define _I2CSTAT_RW         2
#define _I2CSTAT_RBF        1
#define _I2CSTAT_TBF        0

/* This structure defines the registers for a PIC32 Timer.
*/
typedef struct {
    volatile p32_regset tmxCon;
    volatile p32_regset tmxTmr;
    volatile p32_regset tmxPr;
} p32_timer;

/* Define bits in the timer control register.
** Type A timers (timer1) have different control bits
** than Type B timers (timer2 - timer5)
*/
// Type A timer - Timer1
#define _BN_TACON_ON        15
#define _BN_TACON_FRZ       14
#define _BN_TACON_SIDL      13
#define _BN_TACON_TWDIS     12
#define _BN_TACON_TWIP      11
#define _BN_TACON_TGATE     7
#define _BN_TACON_TCKPS     4
#define _BN_TACON_TSYNC     2
#define _BN_TACON_TCS       1

#define TACON_ON            (1 << _BN_TACON_ON)
#define TACON_OFF           (0)
#define TACON_FRZ_ON        (1 << _BN_TACON_FRZ)
#define TACON_FRZ_OFF       (0)
#define TACON_IDLE_STOP     (1 << _BN_TACON_SIDL)
#define TACON_IDLE_RUN      (0)
#define TACON_TWDIS_ON      (1 << _BN_TACON_TWDIS)
#define TACON_TWDIS_OFF     (0)
#define TACON_TWIP          (1 << _BN_TACON_TWIP)
#define TACON_TGATE_ON      (1 << _BN_TACON_TGATE)
#define TACON_TGATE_OFF     (0)
#define TACON_TSYNC_ON      (1 << _BN_TACON_TSYNC)
#define TACON_TSYNC_OFF     (0)

#define TACON_SRC_INT       (0 << _BN_TACON_TCS)
#define TACON_SRC_EXT       (1 << _BN_TACON_TCS)

#define TACON_PS_MASK       (3 << _BN_TACON_TCKPS)
#define TACON_PS_1          (0 << _BN_TACON_TCKPS)
#define TACON_PS_8          (1 << _BN_TACON_TCKPS)
#define TACON_PS_64         (2 << _BN_TACON_TCKPS)
#define TACON_PS_256        (3 << _BN_TACON_TCKPS)

// Type B timer - Timer2-Timer5
#define _BN_TBCON_ON        15
#define _BN_TBCON_FRZ       14
#define _BN_TBCON_SIDL      13
#define _BN_TBCON_TGATE     7
#define _BN_TBCON_TCKPS     4
#define _BN_TBCON_T32       3
#define _BN_TBCON_TCS       1

#define TBCON_ON            (1 << _BN_TBCON_ON)
#define TBCON_OFF           (0)
#define TBCON_FRZ_ON        (1 << _BN_TBCON_FRZ)
#define TBCON_FRZ_OFF       (0)
#define TBCON_IDLE_STOP     (1 << _BN_TBCON_SIDL)
#define TBCON_IDLE_RUN      (0)
#define TBCON_TGATE_ON      (1 << _BN_TBCON_TGATE)
#define TBCON_TGATE_OFF     (0)

#define TBCON_PS_MASK       (7 << _BN_TBCON_TCKPS)
#define TBCON_PS_1          (0 << _BN_TBCON_TCKPS)
#define TBCON_PS_2          (1 << _BN_TBCON_TCKPS)
#define TBCON_PS_4          (2 << _BN_TBCON_TCKPS)
#define TBCON_PS_8          (3 << _BN_TBCON_TCKPS)
#define TBCON_PS_16         (4 << _BN_TBCON_TCKPS)
#define TBCON_PS_32         (5 << _BN_TBCON_TCKPS)
#define TBCON_PS_64         (6 << _BN_TBCON_TCKPS)
#define TBCON_PS_256        (7 << _BN_TBCON_TCKPS)

#define TBCON_MODE32        (1 << _BN_TBCON_T32)
#define TBCON_MODE16        (0)
#define TBCON_SRC_EXT       (1 << _BN_TBCON_TCS)
#define TBCON_SRC_INT       (0)

/* This structure defines the registers for a PIC32 Input Capture.
*/
typedef struct {
    volatile p32_regset icxCon;
    volatile p32_regbuf icxBuf;
} p32_ic;

/* Define bits in the input capture control register
*/
#define _BN_ICCON_ON        15
#define _BN_ICCON_FRZ       14
#define _BN_ICCON_SIDL      13
#define _BN_ICCON_FEDGE     9
#define _BN_ICCON_C32       8
#define _BN_ICCON_ICTMR     7
#define _BN_ICCON_ICI       5
#define _BN_ICCON_ICOV      4
#define _BN_ICCON_ICBNE     3
#define _BN_ICCON_ICM       0

#define ICCON_ON            (1 << _BN_ICCON_ON)
#define ICCON_OFF           (0)
#define ICCON_FRZ_ON        (1 << _BN_ICCON_FRZ)
#define ICCON_FRZ_OFF       (0)
#define ICCON_IDLE_STOP     (1 << _BN_ICCON_SIDL)
#define ICCON_IDLE_RUN      (0)
#define ICCON_FEDGE_RISING  (1 << _BN_ICCON_FEDGE)
#define ICCON_FEDGE_FALLING (0)
#define ICCON_WIDTH_32      (1 << _BN_ICCON_C32)
#define ICCON_WIDTH_16      (0)
#define ICCON_SOURCE_TIMER2 (1 << _BN_ICCON_ICTMR)
#define ICCON_SOURCE_TIMER3 (0)
#define ICCON_INT_FOURTH_EVENT  (3 << _BN_ICCON_ICI)
#define ICCON_INT_THIRD_EVENT   (2 << _BN_ICCON_ICI)
#define ICCON_INT_SECOND_EVENT  (1 << _BN_ICCON_ICI)
#define ICCON_INT_EVERY_EVENT   (0 << _BN_ICCON_ICI)
#define ICCON_OVERFLOW      (1 << _BN_ICCON_ICOV)
#define ICCON_ICBNE         (1 << _BN_ICCON_ICBNE)
#define ICCON_ICM_INTERRUPT     (7 << _BN_ICCON_ICM)
#define ICCON_ICM_EVERY_EDGE    (6 << _BN_ICCON_ICM)
#define ICCON_ICM_RISING_16     (5 << _BN_ICCON_ICM)
#define ICCON_ICM_RISING_4      (4 << _BN_ICCON_ICM)
#define ICCON_ICM_RISING_EDGE   (3 << _BN_ICCON_ICM)
#define ICCON_ICM_FALLING_EDGE  (2 << _BN_ICCON_ICM)
#define ICCON_ICM_EDGE_DETECT   (1 << _BN_ICCON_ICM)
#define ICCON_ICM_DISABLE       (0 << _BN_ICCON_ICM)

/* This structure defines the registers for a PIC32 Output Compare.
*/
typedef struct {
    volatile p32_regset ocxCon;
    volatile p32_regset ocxR;
    volatile p32_regset ocxRs;
} p32_oc;

/* Define bits in the output compare control register
*/
#define _BN_OCCON_ON        15
#define _BN_OCCON_SIDL      13
#define _BN_OCCON_OC32      5
#define _BN_OCCON_OCFLT     4
#define _BN_OCCON_OCTSEL    3
#define _BN_OCCON_OCM       0

#ifndef OCCON_ON
#define OCCON_ON            (1 << _BN_OCCON_ON)
#endif
#define OCCON_OFF           (0)
#define OCCON_IDLE_STOP     (1 << _BN_OCCON_SIDL)
#define OCCON_IDLE_RUN      (0)
#define OCCON_MODE32        (1 << _BN_OCCON_OC32)
#define OCCON_MODE16        (0)
#ifndef OCCON_OCFLT
#define OCCON_OCFLT         (1 << _BN_OCCON_OCFLT)
#endif
#define OCCON_SRC_TIMER3    (1 << _BN_OCCON_OCTSEL)
#define OCCON_SRC_TIMER2    (0)

#define OCCON_PWM_FAULT_ENABLE      (7 << _BN_OCCON_OCM)
#define OCCON_PWM_FAULT_DISABLE     (6 << _BN_OCCON_OCM)
#define OCCON_PULSE_CONTINUOUS      (5 << _BN_OCCON_OCM)
#define OCCON_PULSE_SINGLE          (4 << _BN_OCCON_OCM)
#define OCCON_PULSE_TOGGLE          (3 << _BN_OCCON_OCM)
#define OCCON_FALLING_EDGE          (2 << _BN_OCCON_OCM)
#define OCCON_RISING_EDGE           (1 << _BN_OCCON_OCM)
#define OCCON_MODE_OFF              (0 << _BN_OCCON_OCM)

/* This structure defines the registers for a PIC32 A/D converter
*/
typedef struct {
    volatile p32_regset adxCon1;
    volatile p32_regset adxCon2;
    volatile p32_regset adxCon3;
    volatile p32_regset unused;
    volatile p32_regset adxChs;
    volatile p32_regset adxCssl;
    volatile p32_regset adxPcfg;
    volatile p32_regbuf adxBuf0;
    volatile p32_regbuf adxBuf1;
    volatile p32_regbuf adxBuf2;
    volatile p32_regbuf adxBuf3;
    volatile p32_regbuf adxBuf4;
    volatile p32_regbuf adxBuf5;
    volatile p32_regbuf adxBuf6;
    volatile p32_regbuf adxBuf7;
    volatile p32_regbuf adxBuf8;
    volatile p32_regbuf adxBuf9;
    volatile p32_regbuf adxBufA;
    volatile p32_regbuf adxBufB;
    volatile p32_regbuf adxBufC;
    volatile p32_regbuf adxBufD;
    volatile p32_regbuf adxBufE;
    volatile p32_regbuf adxBufF;
} p32_adc;

/* This structure defines the change notice/pull-up enable registers.
*/
typedef struct {
    volatile p32_regset cnCon;
    volatile p32_regset cnEn;
    volatile p32_regset cnPue;
} p32_cn;
/* Define bits in the change notice control register
*/
#define _BN_CNCON_ON        15
#define _BN_CNCON_SIDL      13

#define CNCON_ON            (1 << _BN_CNCON_ON)
#define CNCON_OFF           (0)
#define CNCON_IDLE_STOP     (1 << _BN_CNCON_SIDL)
#define CNCON_IDLE_RUN      (0)

/* This structure defines the registers for the PIC32 parallel master port.
*/
typedef struct {
    volatile p32_regset pmpCon;
    volatile p32_regset pmpMode;
    volatile p32_regset pmpAddr;
    volatile p32_regset pmpDout;
    volatile p32_regset pmpDin;
    volatile p32_regset pmpAen;
    volatile p32_regset pmpStat;
} p32_pmp;


/* ------------------------------------------------------------ */
/*          Peripheral Pin Select Output Declarations           */
/* ------------------------------------------------------------ */

/* Currently, PPS is only supported in PIC32MX1xx/PIC32MX2xx/PIC32MX47X devices.
*/

#if defined (__PIC32_PPS__)

    // Definitions common to all chips
    #define _PPS_SET_A  0x0100
    #define _PPS_SET_B  0x0200
    #define _PPS_SET_C  0x0400
    #define _PPS_SET_D  0x0800

    typedef uint32_t p32_ppsout;
    typedef uint32_t p32_ppsin;

    #define _PPS_INPUT_BIT  (1 << 15)
    #define PPS_OUT_MASK    0x000F
    #define PPS_IN_MASK     0x00FF

    // Per chip group include combinations

    #if defined(__PIC32MX47X__) || defined(__PIC32MX37X__)
        #include "pps/peripherals_37x47x.h"
        #include "pps/pingroups_37x47x.h"

        #if (__PIC32_PINS__ == 64)
            #if defined(__PIC32MX37X__)
                #include "pps/pins_37x_64.h"
            #elif defined(__PIC32MX47X__)
                #include "pps/pins_47x_64.h"
            #else 
                #error Pin definitions have not been configured for your CPU
            #endif 
        #elif (__PIC32_PINS__ == 100)
            #if defined(__PIC32MX37X__)
                #include "pps/pins_37x_100.h"
            #elif defined(__PIC32MX47X__)
                #include "pps/pins_47x_100.h"
            #else 
                #error Pin definitions have not been configured for your CPU
            #endif 
        #else 
            #error Pin definitions have not been configured for your CPU
        #endif // __PIC32_PINS__

    #elif defined(__PIC32MX1XX__) || defined(__PIC32MX2XX__)

        #include "pps/peripherals_1xx2xx.h"
        #include "pps/pingroups_1xx2xx.h"

        #if defined(__PIC32MX1XX__)
            #include "pps/pins_1xx.h"
        #elif defined(__PIC32MX2XX__)
            #include "pps/pins_2xx.h"
        #else
            #error Pin definitions have not been configured for your CPU
        #endif

    #elif defined(__PIC32MZXX__)
        #include "pps/peripherals_mz.h"

        #if (__PIC32_PINS__ == 64)
            #include "pps/pingroups_mz.h"
            #include "pps/pins_mz_64.h"
        #elif (__PIC32_PINS__ == 100)
            #include "pps/pingroups_mz.h"
            #include "pps/pins_mz_100.h"
        #elif (__PIC32_PINS__ == 124)
            #include "pps/pingroups_mz.h"
            #include "pps/pins_mz_124.h"
        #elif (__PIC32_PINS__ == 144)
            #include "pps/pingroups_mz.h"
            #include "pps/pins_mz_144.h"
        #elif (__PIC32_PINS__ == 169)
            #include "pps/pingroups_mzda.h"
            #include "pps/pins_mz_169.h"
        #elif (__PIC32_PINS__ == 176)
            #include "pps/pingroups_mzda.h"
            #include "pps/pins_mz_176.h"
        #elif (__PIC32_PINS__ == 288)
            #include "pps/pingroups_mzda.h"
            #include "pps/pins_mz_288.h"
        #else
            #error Pin definitions have not been configured for your CPU
        #endif

    #endif

#endif

/* ------------------------------------------------------------ */

#endif      // P32_DEFS_H

//************************************************************************
