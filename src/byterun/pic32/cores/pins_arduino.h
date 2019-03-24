//************************************************************************
//* pins_arduino.h
//*
//* Arduino core files for PIC32
//* Copyright (c) 2010, 2011 by Mark Sproul
//*
//*
//************************************************************************
//* this code is based on code Copyright (c) 2005-2006 David A. Mellis
//*
//* pins_arduino.h - Pin definition functions for Arduino
//* Part of Arduino - http://www.arduino.cc/
//*
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
//* May  5,    2011    <MLS> added analog_pin_to_channel_PGM
//* Nov 12, 2011    <GeneApperson> Rewrite for board variant support
//* Jul 26, 2012    <GeneApperson> Added PPS support for PIC32MX1xx/MX2xx devices
//* Feb 17, 2012    <KeithV> Added PPS support for MZ devices
//* May 19, 2018    <MattJ> Added digitalPinToInterrup macro
//************************************************************************

#if !defined(PINS_ARDUINO_H)
#define PINS_ARDUINO_H

#include "System_Config.h"
#include "System_Defs.h"
/* ------------------------------------------------------------ */
/*                    General Declarations                        */
/* ------------------------------------------------------------ */
/* The following declarations are invariant between boards and
** define symbols used by the board definition files.
*/

#define _BV(bit) (1ul << (bit))

/* Symbols used in pin mapping.
*/
#define NOT_A_PIN       0
#define NOT_A_PORT      0
#define NOT_ON_TIMER    0
#define NOT_ANALOG_PIN  0xFF
#define NOT_PPS_PIN     0xFF
#define NOT_CN_PIN      0xFF
#define NOT_INT_PIN     0xFF
#define NOT_AN_INTERRUPT 0xFF

/* Symbols to define the bit position of the timer fields within the
** timer mapping table.
*/
#define _BN_TIMER_OC    0
#define _BN_TIMER_IC    4
#define _BN_TIMER_TCK   8

#define _MSK_TIMER_OC   0x000F
#define _MSK_TIMER_IC   0x00F0
#define _MSK_TIMER_TCK  0x0F00

#if defined(OPT_BOARD_INTERNAL)

/* Define the port symbols used to index into the port address and
** bit tables.
*/
#define _IOPORT_PA    1
#define _IOPORT_PB    2
#define _IOPORT_PC    3
#define _IOPORT_PD    4
#define _IOPORT_PE    5
#define _IOPORT_PF    6
#define _IOPORT_PG    7
#define _IOPORT_PH    8
#define _IOPORT_PJ    9
#define _IOPORT_PK    10


/* Symbols used for timer related peripherals. These are used in
** the table that maps digital pin to timer related pin.
*/
#define _TIMER_OC1        (1 << _BN_TIMER_OC)
#define _TIMER_OC2        (2 << _BN_TIMER_OC)
#define _TIMER_OC3        (3 << _BN_TIMER_OC)
#define _TIMER_OC4        (4 << _BN_TIMER_OC)
#define _TIMER_OC5        (5 << _BN_TIMER_OC)
#define _TIMER_OC6        (6 << _BN_TIMER_OC)
#define _TIMER_OC7        (7 << _BN_TIMER_OC)
#define _TIMER_OC8        (8 << _BN_TIMER_OC)
#define _TIMER_OC9        (9 << _BN_TIMER_OC)

#define _TIMER_IC1        (1 << _BN_TIMER_IC)
#define _TIMER_IC2        (2 << _BN_TIMER_IC)
#define _TIMER_IC3        (3 << _BN_TIMER_IC)
#define _TIMER_IC4        (4 << _BN_TIMER_IC)
#define _TIMER_IC5        (5 << _BN_TIMER_IC)
#define _TIMER_IC6        (6 << _BN_TIMER_IC)
#define _TIMER_IC7        (7 << _BN_TIMER_IC)
#define _TIMER_IC8        (8 << _BN_TIMER_IC)
#define _TIMER_IC9        (9 << _BN_TIMER_IC)

#define _TIMER_TCK1       (1 << _BN_TIMER_TCK)
#define _TIMER_TCK2       (2 << _BN_TIMER_TCK)
#define _TIMER_TCK3       (3 << _BN_TIMER_TCK)
#define _TIMER_TCK4       (4 << _BN_TIMER_TCK)
#define _TIMER_TCK5       (5 << _BN_TIMER_TCK)
#define _TIMER_TCK6       (6 << _BN_TIMER_TCK)
#define _TIMER_TCK7       (7 << _BN_TIMER_TCK)
#define _TIMER_TCK8       (8 << _BN_TIMER_TCK)
#define _TIMER_TCK9       (9 << _BN_TIMER_TCK)

/* Analog pin definition symbols. Used in the digital pin
** to analog pin mapping table.
*/
#define _BOARD_AN0        0
#define _BOARD_AN1        1
#define _BOARD_AN2        2
#define _BOARD_AN3        3
#define _BOARD_AN4        4
#define _BOARD_AN5        5
#define _BOARD_AN6        6
#define _BOARD_AN7        7
#define _BOARD_AN8        8
#define _BOARD_AN9        9
#define _BOARD_AN10        10
#define _BOARD_AN11        11
#define _BOARD_AN12        12
#define _BOARD_AN13        13
#define _BOARD_AN14        14
#define _BOARD_AN15        15

#endif        //OPT_BOARD_INTERNAL

/* ------------------------------------------------------------ */
/*                Data Definitions Support Macros                    */
/* ------------------------------------------------------------ */
/* The following macros are used in building the data tables
** used by the hardware abstraction layer.
*/
#if defined(__PIC32MX47XH__) || defined(__PIC32MX37XH__)

#define _RPOBASE    RPB0R       //base address of PPS output select registers
#define _RPIBASE    INT1R       //base address of PPS input select registers
#define _PPS_OUT(P) (uint8_t)(P)
#define _PPS_IN(P)  (uint8_t)(((P) & 0x0F) | ((P) >> 4))

#elif defined(__PIC32MX47XL__) || defined(__PIC32MX37XL__)

#define _RPOBASE    RPA14R      //base address of PPS output select registers
#define _RPIBASE    INT1R       //base address of PPS input select registers
#define _PPS_OUT(P) (uint8_t)(P)
#define _PPS_IN(P)  (uint8_t)(((P) & 0x0F) | ((P) >> 4))

#elif defined(__PIC32MX1XX__) || defined(__PIC32MX2XX__)
/* The following are used to build tables used to map pin numbers for
** PPS input and output selection.
*/
#define _RPOBASE    RPA0R        //base address of PPS output select registers
#define _RPIBASE    INT1R        //base address of PPS input select registers
#define _PPS_OUT(P) (uint8_t)(P)
#define _PPS_IN(P)  (uint8_t)(((P) & 0x0F) | ((P) >> 4))

#elif defined(__PIC32MZXX__)

/* The following are used to build tables used to map pin numbers for
** PPS input and output selection.
*/
#if (__PIC32_PINS__ == 64)
    #define _RPOBASE RPB0R        //base address of PPS output select registers
#else
    #define _RPOBASE RPA14R        //base address of PPS output select registers
#endif
#define _RPIBASE    INT1R        //base address of PPS input select registers
#define _PPS_OUT(P) (uint8_t)(P)
#define _PPS_IN(P)  (uint8_t)(((P) & 0x0F) | ((P) >> 4))

#endif    // defined(__PIC32_PPS__)

/* ------------------------------------------------------------ */
/*                    Pin Mapping Macros                            */
/* ------------------------------------------------------------ */
/* Macros used to access the port and pin mapping tables.
** These are mostly generic, but some of them may be board specific.
** These perform slightly better as macros compared to inline functions.
** Any of these macros may be redefined as part of the board variant
** mechanism to customize operation of the system for a specific board.
** The new definition will be in the Board_Defs.h file for the variant.
*/
#define digitalPinToPort(P)     ( digital_pin_to_port_PGM[P]  )
#define digitalPinToBitMask(P)  ( digital_pin_to_bit_mask_PGM[P]  )
#define digitalPinToTimerOC(P)  ( (digital_pin_to_timer_PGM[P] & _MSK_TIMER_OC)  )
#define digitalPinToTimerIC(P)  ( (digital_pin_to_timer_PGM[P] & _MSK_TIMER_IC)  )
#define digitalPinToTimerTCK(P) ( (digital_pin_to_timer_PGM[P] & _MSK_TIMER_TCK) )
#define digitalPinToTimer(P)    ( digitalPinToTimerOC(P) )
#define digitalPinToCN(P)       (NOT_CN_PIN)

/* Override this in Board_Defs.h if you don't have all 5 interrupt pins defined.
 * Or, define a PIN_INTx macro as being NOT_INT_PIN to disable it.
 */
#define digitalPinToInterrupt(P) \
    ((P) == PIN_INT0 ? 0 : \
    ((P) == PIN_INT1 ? 1 : \
    ((P) == PIN_INT2 ? 2 : \
    ((P) == PIN_INT3 ? 3 : \
    ((P) == PIN_INT4 ? 4 : NOT_INT_PIN)))))

#if defined(__PIC32_PPS__)
// This macro returns a pointer to a p32_ioport structure as defined in p32_defs.h
// For MX1xx and MX2xx devices, the port register map starts with the ANSELx register.
#define portRegisters(P) ((p32_ioport *)(port_to_tris_PGM[P] - 0x0010))

#define isPpsPin(P) ((digital_pin_to_pps_out_PGM[P] == NOT_PPS_PIN) ? 0 : 1)

#define ppsInputSelect(P) (digital_pin_to_pps_in_PGM[P] & 0x000F)
#define ppsOutputSelect(F) ((F) & PPS_OUT_MASK)
#define ppsSetFromPin(P) ((digital_pin_to_pps_in_PGM[P] >> 4) & 0x000F)
#define ppsSetFromFunc(F) (((F) >> 8) & 0x000F)
#define ppsInputFromFunc(F) ((F) & PPS_IN_MASK)
#define ppsOutputFromFunc(F) ((F) & PPS_OUT_MASK)
#define ppsFuncIsInput(F)   ((F) & _PPS_INPUT_BIT)
#define ppsFuncIsOutput(F)  (!ppsFuncIsInput(F))
#define ppsOutputRegister(P) (volatile uint32_t *)((uint32_t)(&_RPOBASE) + 4*digital_pin_to_pps_out_PGM[P])
#define ppsInputRegister(F) ((uint32_t *)(4*(ppsInputFromFunc(F)) + (uint32_t)&_RPIBASE))


// #define    timerOCtoDigitalPin(P) (uint8_t)(output_compare_to_digital_pin_PGM[P])
#define timerOCtoOutputSelect(P) (uint8_t)(output_compare_to_pps_sel_PGM[P])
#define externalIntToDigitalPin(P) (uint8_t)(external_int_to_digital_pin_PGM[P])
#define externalIntToInputSelect(P) (uint8_t)(ext_int_to_pps_sel_PGM[P])
#else
// This macro returns a pointer to a p32_ioport structure as defined in p32_defs.h
// For MX3xx-MX7xx devices, the port register map starts with the TRISx register
#define portRegisters(P) ((p32_ioport *)(port_to_tris_PGM[P]))
#endif

#define portModeRegister(P) ( (volatile uint32_t *)port_to_tris_PGM[P] )
#define portInputRegister(P) ( (volatile uint32_t *)(port_to_tris_PGM[P] + 0x0010) )
#define portOutputRegister(P) ( (volatile uint32_t *)(port_to_tris_PGM[P] + 0x0020) )

// This macro converts digital pin number to logical analog pin number.
// This definition is the default mapping. It assumes that the analog pins
// are contiguous starting at digital pin 16.
// This macro will usually be redefined in the board variant.
#define digitalPinToAnalog(P) ( (((P) > 15) && ((P) < 32)) ? (P)-16 : NOT_ANALOG_PIN )
// This definition can usually be used for the non-default case where there
// is a mapping table to go from digital pin to analog pin.
// This definition would go in the Board_Defs.h file for the board variant.
//#define    digitalPinToAnalog(P) ( digital_pin_to_analog_PGM[P] )

// This macro converts from logical analog pin/channel number to the physical
// A/D converter channel.
// This definition is the default one-to-one mapping. This macro will
// usually be redefined in the board variant.
#define analogInPinToChannel(P) ( P )
// This definition is used when there isn't a one-to-one mapping
// and a table is used to map from logical analog channel number to
// physical analog channel number.
//#define analogInPinToChannel(P) ( analog_pin_to_channel_PGM[P]  )

/* ------------------------------------------------------------ */
/* Include the board definition file for the specified variant.
*/
#include "Board_Defs.h"

/* ------------------------------------------------------------ */
/* Data tables for PPS pin mapping support defined in pins_arduino.h
*/

#if defined(__PIC32_PPS__)
#if !defined(OPT_BOARD_DATA)

extern const uint8_t output_compare_to_pps_sel_PGM[];
extern const uint8_t ext_int_to_pps_sel_PGM[];

#endif
#endif

/* ------------------------------------------------------------ */
/*                Define Symbol Defaults                            */
/* ------------------------------------------------------------ */
/* Establish some defaults for symbols that may not have been
** defined by the board variant, but that the system requires
** to be defined
*/

/* Define the number of extended i/o pins. These are pins
** that are not native to the microcontroller, but implemented
** using an i/o expander or external A/D or D/A converters.
*/
#if !defined(NUM_DIGITAL_PINS_EXTENDED)
#define NUM_DIGITAL_PINS_EXTENDED    NUM_DIGITAL_PINS
#endif

#if !defined(NUM_ANALOG_PINS_EXTENDED)
#define NUM_ANALOG_PINS_EXTENDED    NUM_ANALOG_PINS
#endif

#if !defined(LED_BUILTIN)
#define LED_BUILTIN PIN_LED1
#endif

/* ------------------------------------------------------------ */

#endif        // PINS_ARDUINO_H

//************************************************************************
