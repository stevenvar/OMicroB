//************************************************************************
//*	HardwareSerial.h
//*
//*	Arduino Library for PIC32
//*		Copyright (c) 2010, 2011 by Mark Sproul
//************************************************************************
//*	this code is best viewed with tabs set to 4 spaces
//************************************************************************
//*	Edit History
//************************************************************************
//*	Oct 12,	2010	Got MPLAB X working on MacOSX 1.6 for the first time
//*	May 25, 2011	<MLS> Added support for Uart2 on UNO32
//*	Jun 24,	2011	<MLS> Adding USB support fore Serial.xxx
//*	Jun 29,	2011	<MLS> USB support only compiles if enabled
//*	Aug 26,	2011	<MLS> Microchip starter kits w/USB now default to USB serial
//*	Sep  1,	2011	<MLS> Issue #111, #ifdefs around <plib.h>, it was being included twice
//*	Sep  2,	2011	<MLS> Issue #111, changed include <plib.h> to include <p32xxxx.h>
//*	Nov  1,	2011	<MLS> Issue #140, HardwareSerial not derived from Stream 
//*	Nov  1,	2011	<MLS> Also fixed some other compatibilty issues
//* Nov 12, 2001	<GeneApperson> Rewrite for board variant support
//*	Jul 26, 2012	<GeneApperson> Added PPS support for PIC32MX1xx/MX2xx devices
//* 
//* Jan 27, 2014    <Skyler Brandt> Added support for RS485 addressing
//************************************************************************
/*
  HardwareSerial.h - Hardware serial library for Wiring
  Copyright (c) 2006 Nicholas Zambetti.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#ifndef HardwareSerial_h
#define HardwareSerial_h
#ifndef __LANGUAGE_C__
#define __LANGUAGE_C__
#endif

#include "wiring.h"

#ifdef __cplusplus
	#include "Print.h"
	#include "Stream.h"
#endif

#if defined (__SERIAL_IS_USB__)
    #include "USB.h"
#endif


//* ------------------------------------------------------------
//* 		General Declarations
//* ------------------------------------------------------------

// Define constants and variables for buffering incoming serial data.  We're
// using a ring buffer, in which rx_buffer_head is the index of the
// location to which to write the next incoming character and rx_buffer_tail
// is the index of the location from which to read.
// The algorithms used to operate on the head and tail assume that the
// size is a power of 2. (e.g. 32, 64, 128, etc)
#define RX_BUFFER_SIZE 512

typedef struct {
	unsigned char buffer[RX_BUFFER_SIZE];
	int head;
	int tail;
} ring_buffer;

#ifdef __cplusplus

//* ------------------------------------------------------------
//* 		Object Class Declarations
//* ------------------------------------------------------------

class HardwareSerial : public Stream
{
	private:
		p32_uart *		uart;		//uart register map
		isrFunc         isr;        // the ISR routine to use
		uint8_t			irq;		//base IRQ number for the UART
		uint8_t			vec;		//interrupt vector for the UART
		uint8_t			ipl;		//interrupt priority level
		uint8_t			spl;		//interrupt sub-priority level
#if defined(__PIC32_PPS__)
		uint8_t			pinTx;		//digital pin number of TX
		uint8_t			pinRx;		//digital pin number for RX
		ppsFunctionType	ppsTx;		//PPS select for UART TX
		ppsFunctionType	ppsRx;		//PPS select for UART RX
#endif
		p32_regset *	ifs;		//interrupt flag register set
		p32_regset *	iec;		//interrupt enable control register set
		uint32_t		bit_err;	//err interrupt flag bit
		uint32_t		bit_rx;		//rx interrupt flag bit
		uint32_t		bit_tx;		//tx interrupt flag bit
		ring_buffer		rx_buffer;	//queue used for UART rx data

        void            (*rxIntr)(int); // Interrupt callback routine

	public:
#if defined(__PIC32_PPS__)
		HardwareSerial(p32_uart * uartP, int irq, int vec, int ipl, int spl, isrFunc isrHandler, int pinT, int pinR, ppsFunctionType ppsT, ppsFunctionType ppsR);
#else
		HardwareSerial(p32_uart * uartP, int irq, int vec, int ipl, int spl, isrFunc isrHandler);
#endif

		void			doSerialInt(void);

        void            attachInterrupt(void (*callback)(int));
        void            detachInterrupt();
        
        void            enableAddressDetection (void);
        void            disableAddressDetection(void);

		void			begin(unsigned long baudRate);
        void            begin(unsigned long baudRate, uint8_t address);
		void			end();
		virtual int		available(void);
        virtual int     availableForWrite();
		virtual int		peek();
		virtual int		read(void);
		virtual void	flush(void);
		virtual void	purge(void);
		virtual	size_t	write(uint8_t);
		using	Print::write; // pull in write(str) and write(buf, size) from Print
        operator        int();

};


//* ------------------------------------------------------------
//* 		Declare Serial Port Objects
//* ------------------------------------------------------------

//
// These serial port names are intended to allow libraries and 
// architecture-neutral sketches to automatically default to the correct port 
// name for a particular type of use.  For example, a GPS module would normally
// connect to SERIAL_PORT_HARDWARE_OPEN, the first hardware serial port whose 
// RX/TX pins are not dedicated to another use.
//
// SERIAL_PORT_MONITOR        Port which normally prints to the 
//                            Arduino Serial Monitor
//
// SERIAL_PORT_USBVIRTUAL     Port which is USB virtual serial
//
// SERIAL_PORT_LINUXBRIDGE    Port which connects to a Linux system 
//                            via Bridge library
//
// SERIAL_PORT_HARDWARE       Hardware serial port, physical RX & TX pins.
//
// SERIAL_PORT_HARDWARE_OPEN  Hardware serial ports which are open for use.
//                            The RX & TX pins are NOT connected to anything 
//                            by default.
//
// In addition to this, a number may be postfixed to the macro names above
// when there are multiple ports of the same type.
//
// E.g. SERIAL_PORT_HARDWARE, SERIAL_PORT_HARDWARE1, SERIAL_PORT_HARDWARE2 ...
//
// Note that no number is postfixed for the first instance.
//

//* NOTE: NUM_SERIAL_PORTS is defined in Board_Defs.h per-board type.

#if defined (__SERIAL_IS_USB__) 
        /* 
        ** If we're using USB for serial, the USB serial port gets
        ** instantiated as Serial and hardware serial port 0 gets
        ** instantiated as Serial0.
        */
        extern CDCACM Serial;
        void serialEvent() __attribute__((weak));
        bool Serial_available() __attribute__((weak));
        #define SERIAL_PORT_USBVIRTUAL Serial
        #define SERIAL_PORT_MONITOR    Serial
        #if (NUM_SERIAL_PORTS > 0)
                extern HardwareSerial Serial0;
                void serialEvent0() __attribute__((weak));
                bool Serial0_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE       Serial0
                #define SERIAL_PORT_HARDWARE_OPEN  Serial0
        #endif

        #if (NUM_SERIAL_PORTS > 1)
                extern HardwareSerial Serial1;
                void serialEvent1() __attribute__((weak));
                bool Serial1_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE1       Serial1
                #define SERIAL_PORT_HARDWARE_OPEN1  Serial1
                #endif

        #if (NUM_SERIAL_PORTS > 2)
                extern HardwareSerial Serial2;
                void serialEvent2() __attribute__((weak));
                bool Serial2_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE2       Serial2
                #define SERIAL_PORT_HARDWARE_OPEN2  Serial2
        #endif

        #if (NUM_SERIAL_PORTS > 3)
                extern HardwareSerial Serial3;
                void serialEvent3() __attribute__((weak));
                bool Serial3_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE3       Serial3
                #define SERIAL_PORT_HARDWARE_OPEN3  Serial3
        #endif

        #if (NUM_SERIAL_PORTS > 4)
                extern HardwareSerial Serial4;
                void serialEvent4() __attribute__((weak));
                bool Serial4_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE4       Serial4
                #define SERIAL_PORT_HARDWARE_OPEN4  Serial4
        #endif

        #if (NUM_SERIAL_PORTS > 5)
                extern HardwareSerial Serial5;
                void serialEvent5() __attribute__((weak));
                bool Serial5_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE5       Serial5
                #define SERIAL_PORT_HARDWARE_OPEN5  Serial5
        #endif

        #if (NUM_SERIAL_PORTS > 6)
                extern HardwareSerial Serial6;
                void serialEvent6() __attribute__((weak));
                bool Serial6_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE6       Serial6
                #define SERIAL_PORT_HARDWARE_OPEN6  Serial6
        #endif

        #if (NUM_SERIAL_PORTS > 7)
                extern HardwareSerial Serial7;
                void serialEvent7() __attribute__((weak));
                bool Serial7_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE7       Serial7
                #define SERIAL_PORT_HARDWARE_OPEN7  Serial7
        #endif
#else
        /* 
        ** If we're not using USB for serial, then hardware serial port 0
        ** gets instantiated as Serial.
        */
        #if (NUM_SERIAL_PORTS > 0)
                extern HardwareSerial Serial;
                void serialEvent() __attribute__((weak));
                bool Serial_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE Serial
                #define SERIAL_PORT_MONITOR  Serial
        #endif
        #if (NUM_SERIAL_PORTS > 1)
                extern HardwareSerial Serial1;
                void serialEvent1() __attribute__((weak));
                bool Serial1_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE1       Serial1
                #define SERIAL_PORT_HARDWARE_OPEN   Serial1
        #endif

        #if (NUM_SERIAL_PORTS > 2)
                extern HardwareSerial Serial2;
                void serialEvent2() __attribute__((weak));
                bool Serial2_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE2       Serial2
                #define SERIAL_PORT_HARDWARE_OPEN1  Serial2
        #endif

        #if (NUM_SERIAL_PORTS > 3)
                extern HardwareSerial Serial3;
                void serialEvent3() __attribute__((weak));
                bool Serial3_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE3       Serial3
                #define SERIAL_PORT_HARDWARE_OPEN2  Serial3
        #endif

        #if (NUM_SERIAL_PORTS > 4)
                extern HardwareSerial Serial4;
                void serialEvent4() __attribute__((weak));
                bool Serial4_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE4       Serial4
                #define SERIAL_PORT_HARDWARE_OPEN3  Serial4
        #endif

        #if (NUM_SERIAL_PORTS > 5)
                extern HardwareSerial Serial5;
                void serialEvent5() __attribute__((weak));
                bool Serial5_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE5       Serial5
                #define SERIAL_PORT_HARDWARE_OPEN4  Serial5
        #endif

        #if (NUM_SERIAL_PORTS > 6)
                extern HardwareSerial Serial6;
                void serialEvent6() __attribute__((weak));
                bool Serial6_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE6       Serial6
                #define SERIAL_PORT_HARDWARE_OPEN5  Serial6
        #endif

        #if (NUM_SERIAL_PORTS > 7)
                extern HardwareSerial Serial7;
                void serialEvent7() __attribute__((weak));
                bool Serial7_available() __attribute__((weak));
                #define SERIAL_PORT_HARDWARE7       Serial7
                #define SERIAL_PORT_HARDWARE_OPEN6  Serial7
        #endif
#endif

extern void serialEventRun(void) __attribute__((weak));

//* ------------------------------------------------------------

#endif  //      __cplusplus

#endif  //      HardwareSerial_h

/************************************************************************/
