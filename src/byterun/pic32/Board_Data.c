/************************************************************************/
/*																		*/
/*	Board_Data.c --	Default Board Customization Data Declarations		*/
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
/*	11/28/2011(GeneA): Created by splitting data out of Board_Defs.h	*/
/*  03/11/2012(BrianS): Modified for Fubarino board                     */
/*	02/12/2013(GeneA): removed dependency on Microchip plib library		*/
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

#if !defined(BOARD_DATA_C)
#define BOARD_DATA_C

#include <inttypes.h>

/* ------------------------------------------------------------ */
/*					Data Tables									*/
/* ------------------------------------------------------------ */
/* The following declarations define data used in pin mapping.	*/
/* ------------------------------------------------------------ */

#if defined(OPT_BOARD_DATA)

/* ------------------------------------------------------------ */
/* This table is used to map from port number to the address of
** the TRIS register for the port. This is used for setting the
** pin direction.
*/
const uint32_t	port_to_tris_PGM[] = {
	NOT_A_PORT,				//index value 0 is not used

#if defined(_PORTA)
	(uint32_t)&TRISA,
#else
	NOT_A_PORT,
#endif

#if defined(_PORTB)
	(uint32_t)&TRISB,
#else
	NOT_A_PORT,
#endif

#if defined(_PORTC)
	(uint32_t)&TRISC,
#else
	NOT_A_PORT,
#endif

#if defined(_PORTD)
	(uint32_t)&TRISD,
#else
	NOT_A_PORT,
#endif

#if defined(_PORTE)
	(uint32_t)&TRISE,
#else
	NOT_A_PORT,
#endif

#if defined(_PORTF)
	(uint32_t)&TRISF,
#else
	NOT_A_PORT,
#endif

#if defined(_PORTG)
	(uint32_t)&TRISG,
#else
	NOT_A_PORT,
#endif

	NOT_A_PORT,
};

/* ------------------------------------------------------------ */
/* This table is used to map the digital pin number to the port
** containing that pin. The default mapping is to assign pin numbers
** for every possible port bit in order from PORTA to PORTG.
*/
const uint8_t	digital_pin_to_port_PGM[] = {
    // Pins 0 through 32
    _IOPORT_PB, //  0  RB13
	_IOPORT_PA, //  1  RA10
	_IOPORT_PA, //  2  RA7
	_IOPORT_PB, //  3  RB14
	_IOPORT_PB, //  4  RB15
	_IOPORT_PA, //  5  RA0
	_IOPORT_PA, //  6  RA1
	_IOPORT_PB, //  7  RB0
	_IOPORT_PB, //  8  RB1
	_IOPORT_PB, //  9  RB2
	_IOPORT_PB, // 10  RB3
	_IOPORT_PC, // 11  RC0
	_IOPORT_PC, // 12  RC1
	_IOPORT_PC, // 13  RC2
	_IOPORT_PA, // 14  RA2
	_IOPORT_PA, // 15  RA3
	_IOPORT_PA, // 16  RA8
    _IOPORT_PB, // 17  RB4
	_IOPORT_PA, // 18  RA4
	_IOPORT_PA, // 19  RA9
	_IOPORT_PC, // 20  RC3
	_IOPORT_PC, // 21  RC4
	_IOPORT_PC, // 22  RC5
	_IOPORT_PB, // 23  RB5
	_IOPORT_PB, // 24  RB7
	_IOPORT_PB, // 25  RB8
	_IOPORT_PB, // 26  RB9
	_IOPORT_PC, // 27  RC6
	_IOPORT_PC, // 28  RC7
	_IOPORT_PC, // 29  RC8
	_IOPORT_PC, // 30  RC9
	_IOPORT_PB, // 31  RB10
	_IOPORT_PB, // 32  RB11
};

/* ------------------------------------------------------------ */
/* This table is used to map from digital pin number to a bit mask
** for the corresponding bit within the port.
*/
const uint16_t	digital_pin_to_bit_mask_PGM[] = {
	_BV( 13 ) ,	 //  0  RB13
	_BV( 10 ) ,	 //  1  RA10
	_BV( 7 ),	 //  2  RA7
	_BV( 14 ),	 //  3  RB14
	_BV( 15 ) ,	 //  4  RB15
	_BV( 0 ),	 //  5  RA0
	_BV( 1 ),	 //  6  RA1
	_BV( 0 ) ,	 //  7  RB0
	_BV( 1 ) ,	 //  8  RB1
	_BV( 2 ) ,	 //  9  RB2
	_BV( 3 ) ,	 // 10  RB3
	_BV( 0 ) ,	 // 11  RC0
	_BV( 1 ) ,	 // 12  RC1
	_BV( 2 ) ,	 // 13  RC2
	_BV( 2 ) ,	 // 14  RA2
	_BV( 3 ) ,	 // 15  RA3
	_BV( 8 ) ,	 // 16  RA8
	_BV( 4 ) ,	 // 17  RB4
	_BV( 4 ) ,	 // 18  RA4
	_BV( 9 ) ,	 // 19  RA9
	_BV( 3 ) ,	 // 20  RC3
	_BV( 4 ) ,	 // 21  RC4
	_BV( 5 ) ,	 // 22  RC5
	_BV( 5 ) ,	 // 23  RB5
	_BV( 7 ) ,	 // 24  RB7
	_BV( 8 ) ,	 // 25  RB8
	_BV( 9 ) ,	 // 26  RB9
	_BV( 6 ) ,	 // 27  RC6
	_BV( 7 ) ,	 // 28  RC7
	_BV( 8 ) ,	 // 29  RC8
	_BV( 9 ) ,	 // 30  RC9
	_BV( 10 ) ,	 // 31  RB10
	_BV( 11 ) ,	 // 32  RB11
};

/* ------------------------------------------------------------ */
/* This table is used to map from digital pin number to the output
** compare number, input capture number, and timer external clock
** input associated with that pin.
*/
const uint16_t	digital_pin_to_timer_PGM[] = {
	_TIMER_OC5 ,	//  0  RB13
	NOT_ON_TIMER ,	//  1  RA10
	NOT_ON_TIMER ,	//  2  RA7
	NOT_ON_TIMER ,	//  3  RB14
	_TIMER_OC1 ,	//  4  RB15
	NOT_ON_TIMER ,	//  5  RA0
	NOT_ON_TIMER ,	//  6  RA1
	_TIMER_OC3 ,	//  7  RB0
	_TIMER_OC2 ,	//  8  RB1
	_TIMER_OC4 ,	//  9  RB2
	NOT_ON_TIMER ,  // 10  RB3
	NOT_ON_TIMER ,	// 11  RC0
	NOT_ON_TIMER ,	// 12  RC1
	NOT_ON_TIMER ,	// 13  RC2
	NOT_ON_TIMER ,	// 14  RA2
	NOT_ON_TIMER ,	// 15  RA3
	NOT_ON_TIMER ,	// 16  RA8
	NOT_ON_TIMER ,	// 17  RB4
	NOT_ON_TIMER ,	// 18  RA4
	NOT_ON_TIMER ,	// 19  RA9
	NOT_ON_TIMER ,	// 20  RC3
	NOT_ON_TIMER ,	// 21  RC4
	NOT_ON_TIMER ,	// 22  RC5
	NOT_ON_TIMER ,	// 23  RB5
	NOT_ON_TIMER ,	// 24  RB7
	NOT_ON_TIMER ,	// 25  RB8
	NOT_ON_TIMER ,	// 26  RB9
	NOT_ON_TIMER ,	// 27  RC6
	NOT_ON_TIMER ,	// 28  RC7
	NOT_ON_TIMER ,	// 29  RC8
	NOT_ON_TIMER ,	// 30  RC9
	NOT_ON_TIMER ,	// 31  RB10
	NOT_ON_TIMER ,	// 32  RB11
};

/* ------------------------------------------------------------ */
/* This table maps from a digital pin number to the corresponding
** PPS register. This register is used to select the peripheral output
** connected to the pin. The register is set to 0 to disconnect the
** pin from any peripheral so it can be used as GPIO.
** For PIC32MX1xx/2xx series devices, the PPS output select registers
** are arranged as a contiguous series of 32 bit registers. This table
** treats these registers as an array of DWORDs an stores the index
** to the register.
*/
const uint8_t digital_pin_to_pps_out_PGM[] = {
	_PPS_OUT(_PPS_RPB13R),	//	0	RB13
	NOT_PPS_PIN,	        //	1	RA10
	NOT_PPS_PIN,	        //	2	RA7
	_PPS_OUT(_PPS_RPB14R),	//	3	RB14
	_PPS_OUT(_PPS_RPB15R),	//	4	RB15
	_PPS_OUT(_PPS_RPA0R),	//	5	RA0
	_PPS_OUT(_PPS_RPA1R),	//	6	RA1
	_PPS_OUT(_PPS_RPB0R),	//	7	RB0
	_PPS_OUT(_PPS_RPB1R),	//	8	RB1
	_PPS_OUT(_PPS_RPB2R),	//	9	RB2
	_PPS_OUT(_PPS_RPB3R),	//	10	RB3
	_PPS_OUT(_PPS_RPC0R),	//	11	RC0
	_PPS_OUT(_PPS_RPC1R),	//	12	RC1
	_PPS_OUT(_PPS_RPC2R),	//	13	RC2
	_PPS_OUT(_PPS_RPA2R),	//	14	RA2
	_PPS_OUT(_PPS_RPA3R),	//	15	RA3
	_PPS_OUT(_PPS_RPA8R),	//	16	RA8
	_PPS_OUT(_PPS_RPB4R),	//	17	RB4
	_PPS_OUT(_PPS_RPA4R), 	//	18	RA4
	_PPS_OUT(_PPS_RPA9R),	//	19	RA9
	_PPS_OUT(_PPS_RPC3R),	//	20	RC3
	_PPS_OUT(_PPS_RPC4R),	//	21	RC4
	_PPS_OUT(_PPS_RPC5R),	//	22	RC5
	_PPS_OUT(_PPS_RPB5R),	//	23  RB5
	_PPS_OUT(_PPS_RPB7R),	//	24	RB7
	_PPS_OUT(_PPS_RPB8R),	//	25	RB8
	_PPS_OUT(_PPS_RPB9R),	//	26	RB9
	_PPS_OUT(_PPS_RPC6R),	//	27	RC6
	_PPS_OUT(_PPS_RPC7R),	//	28	RC7
	_PPS_OUT(_PPS_RPC8R),	//	29	RC8
	_PPS_OUT(_PPS_RPC9R),	//	30  RC9
    _PPS_OUT(_PPS_RPB10),   //  31  RB10
    _PPS_OUT(_PPS_RPB11),   //  32  RB11
};

/* ------------------------------------------------------------ */
/* This table maps from the digital pin number to the value to be
** loaded into a PPS input select register to select that pin.
** It also maps from digital pin number to input/output pin set to 
** which the pin belongs. The set mask is in the high four bits,
** the select value is in the low four bits.
** Note: if the PIC32 device has more than four pin sets, or more than
** 16 pin mapping choices per input function, then this table will have
** to be redefined as a table of uint16_t values and the macros used to
** access the table redefined as well.
*/
const uint8_t digital_pin_to_pps_in_PGM[] = {
	_PPS_IN(_PPS_RPB13),		//	0	RB13
	NOT_PPS_PIN,	        	//	1	RA10
	NOT_PPS_PIN,	        	//	2	RA7
	_PPS_IN(_PPS_RPB14),		//	3	RB14
	_PPS_IN(_PPS_RPB15),		//	4	RB15
	_PPS_IN(_PPS_RPA0),		    //	5	RA0
	_PPS_IN(_PPS_RPA1),		    //	6	RA1
	_PPS_IN(_PPS_RPB0),		    //	7	RB0
	_PPS_IN(_PPS_RPB1),		    //	8	RB1
	_PPS_IN(_PPS_RPB2),		    //	9	RB2
	_PPS_IN(_PPS_RPB3),		    //	10	RB3
	_PPS_IN(_PPS_RPC0),		    //	11	RC0
	_PPS_IN(_PPS_RPC1),		    //	12	RC1
	_PPS_IN(_PPS_RPC2),		    //	13	RC2
	_PPS_IN(_PPS_RPA2),		    //	14	RA2
	_PPS_IN(_PPS_RPA3),		    //	15	RA3
	_PPS_IN(_PPS_RPA8),		    //	16	RA8
	_PPS_IN(_PPS_RPB4),		    //	17	RB4
	_PPS_IN(_PPS_RPA4), 		//	18	RA4
	_PPS_IN(_PPS_RPA9),		    //	19	RA9
	_PPS_IN(_PPS_RPC3),		    //	20	RC3
	_PPS_IN(_PPS_RPC4),		    //	21	RC4
	_PPS_IN(_PPS_RPC5),		    //	22	RC5
	_PPS_IN(_PPS_RPB5),		    //	23  RB5
	_PPS_IN(_PPS_RPB7),		    //	24	RB7
	_PPS_IN(_PPS_RPB8),		    //	25	RB8
	_PPS_IN(_PPS_RPB9),		    //	26	RB9
	_PPS_IN(_PPS_RPC6),		    //	27	RC6
	_PPS_IN(_PPS_RPC7),		    //	28	RC7
	_PPS_IN(_PPS_RPC8),		    //	29	RC8
	_PPS_IN(_PPS_RPC9),	        //	30  RC9
	_PPS_IN(_PPS_RPB10),        //  31  RB10
	_PPS_IN(_PPS_RPB11),        //  32  RB11
};

/* ------------------------------------------------------------ */
/* This table maps from a digital pin number to the corresponding
** analog pin number.
*/
//#if defined(_NOT_USED_)
const uint8_t digital_pin_to_analog_PGM[] = {
	_BOARD_AN11,    //	0	RB13
	NOT_ANALOG_PIN,	//	1	RA10
	NOT_ANALOG_PIN,	//	2	RA7
	_BOARD_AN10, 	//	3	RB14
	_BOARD_AN9,	    //	4	RB15
	_BOARD_AN0,	    //	5	RA0
	_BOARD_AN1,	    //	6	RA1
	_BOARD_AN2,	    //	7	RB0
	_BOARD_AN3,	    //	8	RB1
	_BOARD_AN4,	    //	9	RB2
	_BOARD_AN5,	    //	10	RB3
	_BOARD_AN6,	    //	11	RC0
	_BOARD_AN7,	    //	12	RC1
	_BOARD_AN8,	    //	13	RC2
	NOT_ANALOG_PIN,	//	14	RA2
	NOT_ANALOG_PIN,	//	15	RA3
	NOT_ANALOG_PIN,	//	16	RA8
	NOT_ANALOG_PIN,	//	17	RB4
	NOT_ANALOG_PIN,	//	18	RA4
	NOT_ANALOG_PIN,	//	19	RA9
	_BOARD_AN12,	//	20	RC3
	NOT_ANALOG_PIN,	//	21	RC4
	NOT_ANALOG_PIN,	//	22	RC5
	NOT_ANALOG_PIN,	//	23  RB5
	NOT_ANALOG_PIN,	//	24	RB7
	NOT_ANALOG_PIN,	//	25	RB8
	NOT_ANALOG_PIN,	//	26	RB9
	NOT_ANALOG_PIN,	//	27	RC6
	NOT_ANALOG_PIN,	//	28	RC7
	NOT_ANALOG_PIN, //	29	RC8
	NOT_ANALOG_PIN, //	30  RC9
	NOT_ANALOG_PIN, //  31  RB10
	NOT_ANALOG_PIN,	//  32  RB11
};
//#endif

/* ------------------------------------------------------------ */
/* This table is used to map from the analog pin number to the
** actual A/D converter channel used for that pin.
** In the default case, where there is a one-to-one mapping, this
** table isn't needed as the analogInPinToChannel() macro is defined
** to provide the mapping.
*/
//#if defined(_NOT_USED_)
const uint8_t analog_pin_to_channel_PGM[] = {
			//*	Arduino Pin		PIC32 Analog channel
	0,		//*	A0				1 to 1 mapping
	1,		//*	A1
	2,		//*	A2
	3,		//*	A3
	4,		//*	A4
	5,		//*	A5
	6,		//*	A6
	7,		//*	A7
	8,		//*	A8
	9,		//*	A9
	10,		//*	A10
	11,		//*	A11
	12,		//*	A12
	13,		//*	A13
	14,		//*	A14
	15,		//*	A15
};
//#endif

/* ------------------------------------------------------------ */
/* This table maps from an output compare number as stored in the
** digital_pin_to_timer_PGM table to the digital pin number of the
** pin that OC is connected to. This table is only required for
** devices that support peripheral pin select (PPS), i.e. PIC32MX1xx/2xx
** devices.
*/

const uint8_t output_compare_to_digital_pin_PGM[] = {
	NOT_PPS_PIN,				// There is no OC0, so this one needs to be blank
	PIN_OC1,					// A0, B3, B4, B15, B7  ; B15   RPB15R  = 5
	PIN_OC2,					// A1, B5, B1, B11, B8  ; B1    RPB1R   = 5
	PIN_OC3,					// A3, B14, B0, B10, B9 ; B0    RPB0R   = 5
	PIN_OC4,					// A2, B6, A4, B13, B2  ; B2    RPB2R   = 5
	PIN_OC5						// A2, B6, A4, B13, B2	; B13   RPB13R  = 6
};

/* ------------------------------------------------------------ */
/* This table maps from an external interrupt number to the digital
** pin for that interrupt.
*/

const uint8_t external_int_to_digital_pin_PGM[] = {
	NOT_PPS_PIN,			// INT0 is not mappable
	PIN_INT1,				// INT1
	PIN_INT2,				// INT2
	PIN_INT3,				// INT3
	PIN_INT4				// INT4
};

/* ------------------------------------------------------------ */
/*		Include Files for Board Customization Functions			*/
/* ------------------------------------------------------------ */


/* ------------------------------------------------------------ */
/*				Board Customization Functions					*/
/* ------------------------------------------------------------ */
/*																*/
/* The following can be used to customize the behavior of some	*/
/* of the core API functions. These provide hooks that can be	*/
/* used to extend or replace the default behavior of the core	*/
/* functions. To use one of these functions, add the desired	*/
/* code to the function skeleton below and then set the value	*/
/* of the appropriate compile switch above to 1. This will		*/
/* cause the hook function to be compiled into the build and	*/
/* to cause the code to call the hook function to be compiled	*/
/* into the appropriate core function.							*/
/*																*/
/* ------------------------------------------------------------ */
/***	_board_init
**
**	Parameters:
**		none
**
**	Return Value:
**		none
**
**	Errors:
**		none
**
**	Description:
**		This function is called from the core init() function.
**		This can be used to perform any board specific init
**		that needs to be done when the processor comes out of
**		reset and before the user sketch is run.
*/
#if	(OPT_BOARD_INIT != 0)

void _board_init(void) {

	/*	Turn off Secondary oscillator so pins can be used as GPIO
	*/
	OSCCONCLR	=	_OSCCON_SOSCEN_MASK;

}

#endif

/* ------------------------------------------------------------ */
/***	_board_pinMode
**
**	Parameters:
**		pin		- digital pin number to configure
**		mode	- mode to which the pin should be configured
**
**	Return Value:
**		Returns 0 if not handled, !0 if handled.
**
**	Errors:
**		none
**
**	Description:
**		This function is called at the beginning of the pinMode
**		function. It can perform any special processing needed
**		when setting the pin mode. If this function returns zero,
**		control will pass through the normal pinMode code. If
**		it returns a non-zero value the normal pinMode code isn't
**		executed.
*/
#if	(OPT_BOARD_DIGITAL_IO != 0)

int	_board_pinMode(uint8_t pin, uint8_t mode) {
	
	return 0;

}

#endif

/* ------------------------------------------------------------ */
/***	_board_getPinMode
**
**	Parameters:
**		pin		- digital pin number
**		mode	- pointer to variable to receive mode value
**
**	Return Value:
**		Returns 0 if not handled, !0 if handled.
**
**	Errors:
**		none
**
**	Description:
**		This function is called at the beginning of the getPinMode
**		function. It can perform any special processing needed
**		when getting the pin mode. If this function returns zero,
**		control will pass through the normal getPinMode code. If
**		it returns a non-zero value the normal getPinMode code isn't
**		executed.
*/
#if	(OPT_BOARD_DIGITAL_IO != 0)

int	_board_getPinMode(uint8_t pin, uint8_t * mode) {
	
	return 0;

}

#endif

/* ------------------------------------------------------------ */
/***	_board_digitalWrite
**
**	Parameters:
**		pin		- digital pin number
**		val		- value to write to the pin
**
**	Return Value:
**		Returns 0 if not handled, !0 if handled.
**
**	Errors:
**		none
**
**	Description:
**		This function is called at the beginning of the digitalWrite
**		function. It can perform any special processing needed
**		in writing to the pin. If this function returns zero,
**		control will pass through the normal digitalWrite code. If
**		it returns a non-zero value the normal digitalWrite code isn't
**		executed.
*/#if	(OPT_BOARD_DIGITAL_IO != 0)

int	_board_digitalWrite(uint8_t pin, uint8_t val) {
	
	return 0;

}

#endif

/* ------------------------------------------------------------ */
/***	_board_digitalRead
**
**	Parameters:
**		pin		- digital pin number
**		val		- pointer to variable to receive pin value
**
**	Return Value:
**		Returns 0 if not handled, !0 if handled.
**
**	Errors:
**		none
**
**	Description:
**		This function is called at the beginning of the digitalRead
**		function. It can perform any special processing needed
**		in reading from the pin. If this function returns zero,
**		control will pass through the normal digitalRead code. If
**		it returns a non-zero value the normal digitalRead code isn't
**		executed.
*/
#if	(OPT_BOARD_DIGITAL_IO != 0)

int	_board_digitalRead(uint8_t pin, uint8_t * val) {
	
	return 0;

}

#endif

/* ------------------------------------------------------------ */
/***	_board_analogRead
**
**	Parameters:
**		pin		- analog channel number
**		val		- pointer to variable to receive analog value
**
**	Return Value:
**		Returns 0 if not handled, !0 if handled.
**
**	Errors:
**		none
**
**	Description:
**		This function is called at the beginning of the analogRead
**		function. It can perform any special processing needed
**		in reading from the pin. If this function returns zero,
**		control will pass through the normal analogRead code. If
**		it returns a non-zero value the normal analogRead code isn't
**		executed.
*/
#if (OPT_BOARD_ANALOG_READ != 0)

int	_board_analogRead(uint8_t pin, int * val) {

	return 0;

}

#endif

/* ------------------------------------------------------------ */
/***	_board_analogReference
**
**	Parameters:
**
**	Return Value:
**		Returns 0 if not handled, !0 if handled.
**
**	Errors:
**		none
**
**	Description:
**		This function is called at the beginning of the analogReference
**		function. It can perform any special processing needed
**		to set the reference voltage. If this function returns zero,
**		control will pass through the normal analogReference code. If
**		it returns a non-zero value the normal analogReference code isn't
**		executed.
*/
#if (OPT_BOARD_ANALOG_READ != 0)

int	_board_analogReference(uint8_t mode) {

	return 0;

}

#endif

/* ------------------------------------------------------------ */
/***	_board_analogWrite
**
**	Parameters:
**		pin		- pin number
**		val		- analog value to write
**
**	Return Value:
**		Returns 0 if not handled, !0 if handled.
**
**	Errors:
**		none
**
**	Description:
**		This function is called at the beginning of the analogWrite
**		function. It can perform any special processing needed
**		in writing to the pin. If this function returns zero,
**		control will pass through the normal analogWrite code. If
**		it returns a non-zero value the normal analogWrite code isn't
**		executed.
*/
#if (OPT_BOARD_ANALOG_WRITE != 0)

int	_board_analogWrite(uint8_t pin, int val) {

	return 0;

}

#endif

#endif // OPT_BOARD_DATA

/* ------------------------------------------------------------ */

#endif	// BOARD_DATA_C

/************************************************************************/
