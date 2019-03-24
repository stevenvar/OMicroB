/************************************************************************/
/*																		*/
/*	Board_Defs.h --	Default Board Customization Declarations			*/
/*																		*/
/************************************************************************/
/*	Author: Gene Apperson												*/
/*	Copyright 2011, Digilent. All rights reserved						*/
/************************************************************************/
/*  File Description:													*/
/*																		*/
/* This file contains the board specific declarations and data structure*/
/* to customize the chipKIT MPIDE for use with a generic board using a	*/
/* PIC32 part in a 64-pin package.										*/
/*																		*/
/* This code is based on earlier work:									*/
/*		Copyright (c) 2010, 2011 by Mark Sproul							*/
/*		Copyright (c) 2005, 2006 by David A. Mellis						*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/*																		*/
/*	10/07/2011(GeneA): Created											*/
/*	11/28/2011(GeneA): Moved data definitions and configuration			*/
/*		functions to Board_Data.c										*/
/*	11/29/2011(GeneA): Moved int priority definitions to System_Defs.h	*/
/*  03/11/2012(BrianS): Modified for Fubarino board                     */
/*																		*/
/************************************************************************/
//*	This library is free software; you can redistribute it and/or
//*	modify it under the terms of the GNU Lesser General Public
//*	License as published by the Free Software Foundation; either
//*	version 2.1 of the License, or (at your option) any later version.
//*	
//*	This library is distributed in the hope that it will be useful,
//*	but WITHOUT ANY WARRANTY; without even the implied warranty of
//*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//*	Lesser General Public License for more details.
//*	
//*	You should have received a copy of the GNU Lesser General
//*	Public License along with this library; if not, write to the
//*	Free Software Foundation, Inc., 59 Temple Place, Suite 330,
//*	Boston, MA  02111-1307  USA
/************************************************************************/

#if !defined(BOARD_DEFS_H)
#define BOARD_DEFS_H

#include <inttypes.h>

/* ------------------------------------------------------------ */
/*				Public Board Declarations						*/
/* ------------------------------------------------------------ */
/* The following define symbols that can be used in a sketch to
** refer to peripherals on the board generically.
*/

#define _USB
#define	_BOARD_NAME_	"Fubarino Mini"

/* Define the peripherals available on the board.
*/
#define	NUM_DIGITAL_PINS	33
#define	NUM_ANALOG_PINS		13
#define NUM_OC_PINS			5
#define	NUM_IC_PINS			5
#define	NUM_TCK_PINS		5
#define	NUM_INT_PINS		5

#define	NUM_SERIAL_PORTS	2
#define	NUM_SPI_PORTS		1
#define	NUM_I2C_PORTS		1

#define NUM_DSPI_PORTS		2
#define NUM_DTWI_PORTS		2

/* Define I/O devices on the board.
*/
#define	NUM_LED				1
#define NUM_BTN				1
#define	NUM_SWT				0
#define NUM_SERVO			0

/* ------------------------------------------------------------ */
/*						LED Declarations						*/
/* ------------------------------------------------------------ */

/* Define the pin numbers for the LEDs
*/
#define	PIN_LED1	1

/* ------------------------------------------------------------ */
/*					Button Declarations							*/
/* ------------------------------------------------------------ */

/* One button (PRG) for this board
*/
#define	PIN_BTN1	16
/* Also define the virutal program button for soft reset */
#define USE_VIRTUAL_PROGRAM_BUTTON      1
#define VIRTUAL_PROGRAM_BUTTON_TRIS     TRISAbits.TRISA8
#define VIRTUAL_PROGRAM_BUTTON          LATAbits.LATA8

/* ------------------------------------------------------------ */
/*					Switch Declarations							*/
/* ------------------------------------------------------------ */

/* No switches on this board.
*/

/* ------------------------------------------------------------ */
/*					Servo Pin Declarations						*/
/* ------------------------------------------------------------ */

/* No servo connectors on this board.
*/

/* ------------------------------------------------------------ */
/*					Timer Pin Declarations						*/
/* ------------------------------------------------------------ */

#define PIN_OC1		4
#define	PIN_OC3		7
#define	PIN_OC2		8
#define	PIN_OC4		9
#define	PIN_OC5		0

#define PIN_IC1		0
#define PIN_IC2		1
#define PIN_IC3		2
#define PIN_IC4		3
#define	PIN_IC5		10

#define	PIN_TCK1	46
//#define	PIN_TCK2	not available on the chip
//#define	PIN_TCK3	not available on the chip
//#define	PIN_TCK4	not available on the chip
//#define	PIN_TCK5	not available on the chip

/* ------------------------------------------------------------ */
/*					Interrupt Pin Declarations					*/
/* ------------------------------------------------------------ */

#define	PIN_INT0	24		// B7   non-PPS
#define	PIN_INT1	3		// B14  INT1R = RPB14 = 1
#define PIN_INT2	0		// B13  INT2R = RPB13 = 3
#define	PIN_INT3	6		// A1   INT3R = RPA1 = 0
#define	PIN_INT4	4		// B15  INT4R = RPB15 = 3

/* ------------------------------------------------------------ */
/*					SPI Pin Declarations						*/
/* ------------------------------------------------------------ */
/* These symbols are defined for compatibility with the original
** SPI library (<SPI.h>) and the original pins_arduino.h. SPI1 is 
** used as the default SPI port on Fubarino Mini for this library.
*/
static const uint8_t SS   = 5;		// PIC32 SS1
static const uint8_t MOSI = 18;		// PIC32 SDO1
static const uint8_t MISO = 19;		// PIC32 SDI1
static const uint8_t SCK  = 3;		// PIC32 SCK1

/* The Digilent DSPI library uses these ports.
*/
#define	PIN_DSPI0_SS	5   // These are kind of arbitrary as they're managed by the sketch as GPIO not by the library
#define	PIN_DSPI1_SS	30  // These are kind of arbitrary as they're managed by the sketch as GPIO not by the library

/* ------------------------------------------------------------ */
/*					Analog Pins									*/
/* ------------------------------------------------------------ */
/* Define symbols for accessing the analog pins. This table is
** used to map an analog pin number to the corresponding digital
** pin number.
*/
#define	A0		0
#define	A1		3
#define A2		4
#define A3		5
#define A4		6
#define A5		7
#define A6		8
#define A7		9
#define A8		10
#define A9		11
#define A10		12
#define A11		13
#define A12     20

/* ------------------------------------------------------------ */
/*					Change Notice Pins							*/
/* ------------------------------------------------------------ */
/* These define the pin numbers for the various change notice
** pins.
*** TODO: MX250 parts have Change Notification on EVERY I/O pin.
*** How should that get mapped? What calls actually use these values?
*/
#define	PIN_CN0		6
#define	PIN_CN1		5
#define	PIN_CN2		34
#define	PIN_CN3		33
#define	PIN_CN4		32
#define	PIN_CN5		31
#define	PIN_CN6		30
#define	PIN_CN7		29
#define	PIN_CN8		24
#define	PIN_CN9		25
#define	PIN_CN10	26
#define	PIN_CN11	27
#define	PIN_CN12	44
#define	PIN_CN13	10
#define	PIN_CN14	11
#define	PIN_CN15	12
#define	PIN_CN16	13
#define	PIN_CN17	28
#define	PIN_CN18	29

/* ------------------------------------------------------------ */
/*					Pin Mapping Macros							*/
/* ------------------------------------------------------------ */
/* Macros used to access the port and pin mapping tables.
** These are mostly generic, but some of them may be board specific.
** These perform slightly better as macros compared to inline functions
*/
#undef digitalPinToAnalog
#define	digitalPinToAnalog(P) ( digital_pin_to_analog_PGM[P] )

#undef analogInPinToChannel
#define analogInPinToChannel(P) ( analog_pin_to_channel_PGM[P]  )

/* ------------------------------------------------------------ */
/*					Data Definitions							*/
/* ------------------------------------------------------------ */

/* The following declare externals to access the pin mapping
** tables. These tables are defined in Board_Data.c.
*/

#if !defined(OPT_BOARD_DATA)

extern const uint32_t	port_to_tris_PGM[];
extern const uint8_t	digital_pin_to_port_PGM[];
extern const uint16_t	digital_pin_to_bit_mask_PGM[];
extern const uint16_t	digital_pin_to_timer_PGM[];
extern const uint8_t	digital_pin_to_pps_out_PGM[];
extern const uint8_t	digital_pin_to_pps_in_PGM[];
extern const uint8_t 	digital_pin_to_analog_PGM[];
extern const uint8_t	analog_pin_to_channel_PGM[];

extern const uint8_t	output_compare_to_digital_pin_PGM[];
extern const uint8_t	external_int_to_digital_pin_PGM[];

#endif

/* ------------------------------------------------------------ */
/*				Internal Declarations							*/
/* ------------------------------------------------------------ */
/* The following declarations are used to map peripherals for	*/
/* the core and libraries and to provide configuration options	*/
/* for the core. They are not normally needed by a user sketch.	*/
/* ------------------------------------------------------------ */

#if defined(OPT_BOARD_INTERNAL)

/* ------------------------------------------------------------ */
/*				Core Configuration Declarations					*/
/* ------------------------------------------------------------ */
/*																*/
/* These are conditional compilation switches that control the	*/
/* board core configuration functions. These functions provide	*/
/* hooks that can call from some of the core functions into		*/
/* functions defined below that can be used to extend or		*/
/* replace the default behavior of the core function. To use	*/
/* this, enter the appropriate code into the appropriate		*/
/* function skeleton below and then set the appropriate switch	*/
/* value to 1. This will cause the configuration function to be	*/
/* compiled into the build and will cause the code to call the	*/
/* hook function to be compiled into the core function.			*/
/*																*/
/* ------------------------------------------------------------ */

#define	OPT_BOARD_INIT			1	//board needs special init code
#define	OPT_BOARD_DIGITAL_IO	0	//board does not extend digital i/o functions
#define	OPT_BOARD_ANALOG_READ	0	//board does not extend analogRead
#define	OPT_BOARD_ANALOG_WRITE	0	//board does not extend analogWrite

#endif	// OPT_BOARD_INTERNAL

/* ------------------------------------------------------------ */
/*					Serial Port Declarations					*/
/* ------------------------------------------------------------ */

/* Serial port 0 uses UART1
*/
#define	_SER0_BASE		_UART1_BASE_ADDRESS
#define	_SER0_IRQ		_UART1_ERR_IRQ
#define	_SER0_VECTOR	_UART_1_VECTOR
#define	_SER0_IPL_ISR	IPL2SOFT
#define	_SER0_IPL		2
#define	_SER0_SPL		0
#define	_SER0_TX_OUT	PPS_OUT_U1TX		// RPB4R = U1TX = 1
#define	_SER0_TX_PIN	17					// RB4
#define	_SER0_RX_IN		PPS_IN_U1RX			// U1RXR = RPA4 = 2
#define	_SER0_RX_PIN	18					// RA4

/* Serial port 1 uses UART2
*/
#define	_SER1_BASE		_UART2_BASE_ADDRESS
#define	_SER1_IRQ		_UART2_ERR_IRQ
#define	_SER1_VECTOR	_UART_2_VECTOR
#define	_SER1_IPL_ISR	IPL2SOFT
#define	_SER1_IPL		2
#define	_SER1_SPL		0
#define	_SER1_TX_OUT	PPS_OUT_U2TX		// RPB9R = U2TX = 2
#define	_SER1_TX_PIN	26					// RB9
#define	_SER1_RX_IN		PPS_IN_U2RX			// U2RXR = RPB8 = 4
#define	_SER1_RX_PIN	25					// RB8

/* ------------------------------------------------------------ */
/*					SPI Port Declarations						*/
/* ------------------------------------------------------------ */

/* SPI1 (also known as DSPI0)
 * The Digilent DSPI and standard SPI libraries uses these ports.
 * This port (SPI1) is the port used by the default SPI library
 * <SPI.h>. Both port's MOSI/MISO pins can be changed using PPS
 * from within a sketch.
 * Note SCK1 only comes out B14, which is Arduino/Fubarino Mini
 * pin 3
 */
#define	_DSPI0_BASE			_SPI1_BASE_ADDRESS
#define	_DSPI0_ERR_IRQ		_SPI1_ERR_IRQ
#define	_DSPI0_RX_IRQ		_SPI1_RX_IRQ
#define	_DSPI0_TX_IRQ		_SPI1_TX_IRQ
#define	_DSPI0_VECTOR		_SPI_1_VECTOR
#define	_DSPI0_IPL_ISR		IPL3SOFT
#define	_DSPI0_IPL			3
#define	_DSPI0_SPL			0

#define _DSPI0_MISO_IN		PPS_IN_SDI1
#define _DSPI0_MISO_PIN		19
#define _DSPI0_MOSI_OUT		PPS_OUT_SDO1
#define _DSPI0_MOSI_PIN		18

/* SPI2 (also known as DSPI1)
 * Note SCK2 only comes out B15, which is Arduino/Fubarino Mini 
 * pin 4
 */
#define	_DSPI1_BASE			_SPI2_BASE_ADDRESS
#define	_DSPI1_ERR_IRQ		_SPI2_ERR_IRQ
#define	_DSPI1_RX_IRQ		_SPI2_RX_IRQ
#define	_DSPI1_TX_IRQ		_SPI2_TX_IRQ
#define	_DSPI1_VECTOR		_SPI_2_VECTOR
#define	_DSPI1_IPL_ISR		IPL3SOFT
#define	_DSPI1_IPL			3
#define	_DSPI1_SPL			0

#define _DSPI1_MISO_IN      PPS_IN_SDI2
#define _DSPI1_MISO_PIN     27
#define _DSPI1_MOSI_OUT     PPS_OUT_SDO2
#define _DSPI1_MOSI_PIN     29

/* ------------------------------------------------------------ */
/*					I2C Port Declarations						*/
/* ------------------------------------------------------------ */

/* The standard I2C port uses I2C1 (SCL1/SDA1). On the Fubarino 
** Mini, these come out to pins RB8 (SCL1) and RB9 (SDA1) 
** (Arduino pins 25 and 26 respectively).
*/
#define	_TWI_BASE		_I2C1_BASE_ADDRESS
#define	_TWI_BUS_IRQ	_I2C1_BUS_IRQ
#define	_TWI_SLV_IRQ	_I2C1_SLAVE_IRQ
#define	_TWI_MST_IRQ	_I2C1_MASTER_IRQ
#define	_TWI_VECTOR		_I2C_1_VECTOR
#define	_TWI_IPL_ISR	IPL3SOFT
#define _TWI_IPL		3
#define	_TWI_SPL		0

/* Declarations for Digilent DTWI library.
**		DTWI0 is on Arduino pins 25 (SCL1) and 26 (SDA1).
**		DTWI1 is on Arduino pins 10 (SCL2) and  9 (SDA2).
*/
#define	_DTWI0_BASE		_I2C1_BASE_ADDRESS
#define	_DTWI0_BUS_IRQ	_I2C1_BUS_IRQ
#define	_DTWI0_VECTOR	_I2C_1_VECTOR
#define	_DTWI0_IPL_ISR	IPL3SOFT
#define	_DTWI0_IPL		3
#define	_DTWI0_SPL		0
#define _DTWI0_SCL_PIN  25 
#define _DTWI0_SDA_PIN  26

#define	_DTWI1_BASE		_I2C2_BASE_ADDRESS
#define	_DTWI1_BUS_IRQ	_I2C2_BUS_IRQ
#define	_DTWI1_VECTOR	_I2C_2_VECTOR
#define	_DTWI1_IPL_ISR	IPL3SOFT
#define	_DTWI1_IPL		3
#define	_DTWI1_SPL		0
#define _DTWI1_SCL_PIN  10 
#define _DTWI1_SDA_PIN  9

/* ------------------------------------------------------------ */
/*					A/D Converter Declarations					*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */

#define DefineSDSPI(var) DSPI0 var
#define DefineDSDVOL(vol, spi) DSDVOL vol(spi, 19)     // Create an DSDVOL object


/* ------------------------------------------------------------ */

#endif	// BOARD_DEFS_H

/************************************************************************/
