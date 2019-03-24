/************************************************************************/
/*																		*/
/*	System_Config.h -- System Build Configuration Declarations			*/
/*																		*/
/************************************************************************/
/*	Author: Gene Apperson												*/
/*	Copyright 2011, Digilent. All rights reserved						*/
/************************************************************************/
/*  File Description:													*/
/*																		*/
/* This file contains the definition of symbols used for general build	*/
/* configuration of the system.											*/
/*																		*/
/************************************************************************/
/*  Revision History:													*/
/*																		*/
/*	11/29/2011(GeneApperson): Created									*/
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

#if !defined(SYSTEM_CONFIG_H)
#define SYSTEM_CONFIG_H

/* ------------------------------------------------------------ */
/*				Core Function Build Configuration				*/
/* ------------------------------------------------------------ */

/* Build management for HardwareSerial objects
*/
#if	!defined(OPT_SYSTEM_SERIAL0)
#define	OPT_SYSTEM_SERIAL0	1
#endif

#if	!defined(OPT_SYSTEM_SERIAL1)
#define	OPT_SYSTEM_SERIAL1	1
#endif

#if	!defined(OPT_SYSTEM_SERIAL2)
#define	OPT_SYSTEM_SERIAL2	1
#endif

#if	!defined(OPT_SYSTEM_SERIAL3)
#define	OPT_SYSTEM_SERIAL3	1
#endif

#if	!defined(OPT_SYSTEM_SERIAL4)
#define	OPT_SYSTEM_SERIAL4	1
#endif

#if	!defined(OPT_SYSTEM_SERIAL5)
#define	OPT_SYSTEM_SERIAL5	1
#endif

#if	!defined(OPT_SYSTEM_SERIAL6)
#define	OPT_SYSTEM_SERIAL6	1
#endif

#if	!defined(OPT_SYSTEM_SERIAL7)
#define	OPT_SYSTEM_SERIAL7	1
#endif

/* Build management for attachInterrupt, detachInterrupt
*/
#if !defined(OPT_SYSTEM_EXT_INT0)
#define	OPT_SYSTEM_EXT_INT0	1
#endif

#if !defined(OPT_SYSTEM_EXT_INT1)
#define	OPT_SYSTEM_EXT_INT1	1
#endif

#if !defined(OPT_SYSTEM_EXT_INT2)
#define	OPT_SYSTEM_EXT_INT2	1
#endif

#if !defined(OPT_SYSTEM_EXT_INT3)
#define	OPT_SYSTEM_EXT_INT3	1
#endif

#if !defined(OPT_SYSTEM_EXT_INT4)
#define	OPT_SYSTEM_EXT_INT4	1
#endif

/* ------------------------------------------------------------ */

#endif	// SYSTEM_CONFIG_H

/************************************************************************/
