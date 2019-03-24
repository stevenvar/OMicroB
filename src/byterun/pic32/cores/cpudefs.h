//************************************************************************
//*    cpudefs.h
//*    
//*    Arduino core files for PIC32
//*        Copyright (c) 2011 by Mark Sproul
//*    
//*        This file is designed to provide some of the cpu specific definitions
//*        that are available for avr chips and not for pic32 chips
//************************************************************************
//*    
//*    This library is free software; you can redistribute it and/or
//*    modify it under the terms of the GNU Lesser General Public
//*    License as published by the Free Software Foundation; either
//*    version 2.1 of the License, or (at your option) any later version.
//*    
//*    This library is distributed in the hope that it will be useful,
//*    but WITHOUT ANY WARRANTY; without even the implied warranty of
//*    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.//*    See the GNU
//*    Lesser General Public License for more details.
//*    
//*    You should have received a copy of the GNU Lesser General
//*    Public License along with this library; if not, write to the
//*    Free Software Foundation, Inc., 59 Temple Place, Suite 330,
//*    Boston, MA    02111-1307    USA
//*    
//*    
//************************************************************************
//*    Edit History
//************************************************************************
//*    Apr 16, 2011    <MLS> started on cpudefs.h
//*    Apr 24,    2011    <MLS> copied to bootloader, important to keep them in sync
//*    Jun 16,    2011    <MLS> Added 32MX360F256L
//*    Jun 21,    2011    <MLS> Added 32MX440F512H
//* Nov 19, 2011    <GeneApperson> corrected errors in some parts, added
//*                        definitions for all 1XX/2XX/3XX/4XX/5XX/6XX/7XX devices
//************************************************************************

//************************************************************************
//*    Microchip pic32 chip names

#define    E2END        0x0fff    //*    4 k of simulated EEPROM

#include "cpudefs_table.h"
#include "cpudefs_retired.h"

#ifndef _CPU_NAME_
    #error CPU type is unknown, cpudefs.h needs to have additions
#endif

//Fix issue 213
#ifndef __PIC32_PPS__
  #define OPT_BOARD_INTERNAL
#endif

//************************************************************************
#ifndef _CPU_NAME_
    #define _CPU_NAME_    "Unknown"
#endif
