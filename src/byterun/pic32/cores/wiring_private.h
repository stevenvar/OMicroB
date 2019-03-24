//************************************************************************
//*	WInterrupts.h
//*	
//*	Arduino core files for PIC32
//*		Copyright (c) 2010, 2011 by Mark Sproul
//*	
//*	
//************************************************************************
//*	this code is based on code Copyright (c) 2005-2006 David A. Mellis
//*	
//*	This library is free software; you can redistribute it and/or
//*	modify it under the terms of the GNU Lesser General Public
//*	License as published by the Free Software Foundation; either
//*	version 2.1 of the License, or (at your option) any later version.
//*	
//*	This library is distributed in the hope that it will be useful,
//*	but WITHOUT ANY WARRANTY; without even the implied warranty of
//*	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.//*	See the GNU
//*	Lesser General Public License for more details.
//*	
//*	You should have received a copy of the GNU Lesser General
//*	Public License along with this library; if not, write to the
//*	Free Software Foundation, Inc., 59 Temple Place, Suite 330,
//*	Boston, MA  02111-1307  USA
//*	
//*	
//************************************************************************
//*	Edit History
//************************************************************************

#ifndef WiringPrivate_h
#define WiringPrivate_h
	#if 0
		#include <avr/io.h>
		#include <avr/interrupt.h>
		#include <avr/delay.h>
	#endif
	
	#include <stdio.h>
	#include <stdarg.h>

	#define	_ENABLE_PIC_RTC_

	#ifndef Wiring_h
		#include "wiring.h"
	#endif
	
	#ifdef __cplusplus
		extern "C"{
	#endif

	#if 0
		#ifndef cbi
			#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
		#endif
		#ifndef sbi
			#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
		#endif
	#endif

		#define EXTERNAL_INT_0 0
		#define EXTERNAL_INT_1 1
		#define EXTERNAL_INT_2 2
		#define EXTERNAL_INT_3 3
		#define EXTERNAL_INT_4 4
		#define EXTERNAL_INT_5 5
		#define EXTERNAL_INT_6 6
		#define EXTERNAL_INT_7 7

		#if defined(__AVR_ATmega1280__) || defined(__AVR_ATmega2560__)
			#define EXTERNAL_NUM_INTERRUPTS 8
		#elif defined(__PIC32MX__) || defined(__PIC32MZXX__)
			#define EXTERNAL_NUM_INTERRUPTS 5
		#else
			#define EXTERNAL_NUM_INTERRUPTS 2
		#endif


	void turnOffPWM(uint8_t timer);
	
	void _configSystem(uint32_t clk);
	void _enableMultiVectorInterrupts();
	void _initCoreTimer(uint32_t prd);
	void __attribute__((noreturn)) _softwareReset(void);

#if defined(__PIC32MZXX__)
    #define initIntVector()
#else
        void initIntVector(void);
#endif
	
	typedef void (*voidFuncPtr)(void);

	#ifdef __cplusplus
	} // extern "C"
	#endif

#endif
