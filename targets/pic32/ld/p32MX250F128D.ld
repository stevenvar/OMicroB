/* Default linker script, for normal executables */
OUTPUT_FORMAT("elf32-tradlittlemips")
OUTPUT_ARCH(pic32mx)
ENTRY(_reset)
/*
 * Provide for a minimum stack and heap size
 * - _min_stack_size - represents the minimum space that must be made
 *                     available for the stack.  Can be overridden from
 *                     the command line using the linker's --defsym option.
 * - _min_heap_size  - represents the minimum space that must be made
 *                     available for the heap.  Can be overridden from
 *                     the command line using the linker's --defsym option.
 */
EXTERN (_min_stack_size _min_heap_size)
PROVIDE(_min_stack_size = 0x800) ;
PROVIDE(_min_heap_size = 0x800) ;

/*************************************************************************
 * Processor-specific object file.  Contains SFR definitions.
 *************************************************************************/
INPUT("processor.o")
OPTIONAL("libmchp_peripheral_32MX250F128D.a") 

/*************************************************************************
 * Memory Regions
 *
 * Memory regions without attributes cannot be used for orphaned sections.
 * Only sections specifically assigned to these regions can be allocated
 * into these regions.
 *************************************************************************/
MEMORY
{
  exception_mem              : ORIGIN = 0x9D000000, LENGTH = 0x1000
  kseg0_program_mem    (rx)  : ORIGIN = 0x9D001000, LENGTH = 0x1D000
  kseg0_eeprom_mem           : ORIGIN = 0x9D01E000, LENGTH = 0x1000
  kseg0_splitflash_mem       : ORIGIN = 0x9D01F000, LENGTH = 0x1000
  kseg0_boot_mem             : ORIGIN = 0x9FC00200, LENGTH = 0
  kseg1_boot_mem             : ORIGIN = 0xBFC00000, LENGTH = 0 
  debug_exec_mem             : ORIGIN = 0xBFC00490, LENGTH = 0
  config3                    : ORIGIN = 0xBFC00BF0, LENGTH = 0x4
  config2                    : ORIGIN = 0xBFC00BF4, LENGTH = 0x4
  config1                    : ORIGIN = 0xBFC00BF8, LENGTH = 0x4
  config0                    : ORIGIN = 0xBFC00BFC, LENGTH = 0x4
  kseg1_data_mem       (w!x) : ORIGIN = 0xA0000000, LENGTH = 0x8000
  sfrs                       : ORIGIN = 0xBF800000, LENGTH = 0x100000
  configsfrs                 : ORIGIN = 0xBFC00BF0, LENGTH = 0x10
}

/*************************************************************************
 * Memory Address Equates
 *************************************************************************/
_ebase_address  	    = ORIGIN(exception_mem);
_IMAGE_PTR_TABLE       	= _ebase_address + 0x0F8;
_IMAGE_HEADER_ADDR      = _ebase_address + 0x0FC;
_GEN_EXCPT_ADDR         = _ebase_address + 0x180;
_RESET_ADDR             = ORIGIN(kseg0_program_mem);
_EEPROM_ADDR            = ORIGIN(kseg0_eeprom_mem);
_BEV_EXCPT_ADDR         = 0xBFC00380;
_DBG_EXCPT_ADDR         = 0xBFC00480;
_DBG_CODE_ADDR          = ORIGIN(debug_exec_mem);

/*************************************************************************
 *  Bootloader program directives.
 *  
 * _IMAGE_TYPE
 *
 *  image type:
 */
     
_imageReserved                      = 0x00000000 ;
_imageMPIDE                         = 0x00000001 ;  /* This is a normal MPIDE sketch                                                                                                    */
_imageBootFlashBootloader           = 0x00000002 ;  /* This is a boot flash bootloader                                                                                                  */
_imageProgramFlashBootloader        = 0x00000004 ;  /* This is a program flash bootloader                                                                                               */
_imageSplitFlashBootloader          = 0x00000008 ;  /* This has bootloader code in both boot and program flash                                                                          */

 /*
 *  Instructions for the bootloader
 */
                                                                       
_imageFullFlashEraseLess4KEEProm    = 0x00010000 ;  /* The original bootloader method of erasing all of program flash except the last 4K reserved for eeprom                            */
_imageJustInTimeFlashErase          = 0x00020000 ;  /* Only flash pages written too needed by the sketch is erased                                                                      */
_imageLinkerSpecifiedFlashErase     = 0x00040000 ;  /* The linker defines the flash range to erase                                                                                      */
_imageFullFlashErase                = 0x00080000 ;  /* All of flash is erased                                                                                                           */
_imageExecutionJumpAddress          = 0x01000000 ;  /* the bootloader will jump to the execution jump address immediately after programming                                             */
_imageExecutionJumpToFirstInFlash   = 0x02000000 ;  /* the bootloader will jump to the first sketch loaded in flash ignoring the execution jump address immediately after programming   */
 
/*  
 * _IMAGE_FLASH_SIZE 
 *
 *      Typically _imageJustInTimeFlashErase is selected to just erase the pages
 *      of flash that code is written too; thus leaving all other flash pages untouched.
 *  
 *      If _imageLinkerSpecifiedFlashErase set, then the range
 *      starting from _ebase_address for _IMAGE_FLASH_SIZE bytes are erased.
 *
 *      If _imageFullFlashErase is specified, than the whole flash
 *      as known by the bootloader will be erased. This will erase eeprom as well
 *
 *      if _imageFullFlashEraseLess4KEEProm is set, all of flash less the last 4K is
 *      erased, this is the old default. This bit could be set to make a program flash bootloader
 *      erasing everything but the old flash. If NOTHING is set, this will be the default as this is the old behavior.
 *  
 *  _JUMP_ADDR
 *  
 *      This is the address that the bootloader will jump to start execution
 *      of the sketch. This is almost always _RESET_ADDR.
 *
 *      However, you can specify an alternate entry execution point for example
 *      if you have alternate starup code that, say, shared
 *      the runtime with other sketches or needed some kind of specific handling
 *
 *      Immediately after programming (avrdude upload) the bootloader will typically
 *      jump to the just loaded sketch, no matter where it was loaded in flash.
 *      _imageExecutionJumpToFirstInFlash will tell the bootloader to jump to the first
 *      sketch in flash even if the just loaded one is not at the beginning of flash.
 *      This is useful when programming sketches in slots of flash and then always
 *      jumping to the program-flash loader (vector sketch) as if the board was just reset.
 *      This bit does not effect jumping to a sketch already in flash after reset.
 *      As of today, after reset, the first program in flash will always be jumped to.
 *
 *************************************************************************/
 _IMAGE_TYPE            = _imageMPIDE | _imageJustInTimeFlashErase | _imageExecutionJumpAddress;
 _IMAGE_FLASH_SIZE      = LENGTH(exception_mem) + LENGTH(kseg0_program_mem);
_JUMP_ADDR              = _RESET_ADDR;

SECTIONS
{
  /* Boot Sections */
  .reset _RESET_ADDR :
  {
    KEEP(*(.reset))
  } > kseg0_program_mem
}

/* From here out every linker script is the same, so just include it */
/*INCLUDE "chipKIT-application-COMMON.ld"*/



/************************************************************************
 *	chipKIT-applicaiton-COMMON.ld
 *
 *	This is the common part of the linker script shared
 *	across all chipKIT PIC32 processors / boards.
 *
 ************************************************************************
 *	this code is based on code Copyright (c) 2005-2006 David A. Mellis
 * 	This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *	License as published by the Free Software Foundation; either
 *	version 2.1 of the License, or (at your option) any later version.
 *
 *	This library is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.//*	See the GNU
 *	Lesser General Public License for more details.
 *
 *	You should have received a copy of the GNU Lesser General
 *	Public License along with this library; if not, write to the
 *	Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 *	Boston, MA	02111-1307	USA
 *
 *
 ************************************************************************
 *	Edit History
 ************************************************************************
 *	Jun 30 2012 <Keith Vogel, Digilent> Extracted the common section of the linker script
 *	Jun 30 2012 <Keith Vogel, Digilent> Created a flash header section
 *	Jun 30 2012 <Keith Vogel, Digilent> Created a RAM header section
 ************************************************************************
 */

/*************************************************************************
 * For interrupt vector handling
 *************************************************************************/
PROVIDE(_vector_spacing = 0x00000001);
/*INPUT("crtbegin.o") */ 
INPUT("crtend.o") 
INPUT("crtn.o")
OPTIONAL("libmchp_peripheral.a")

/*************************************************************************
 * Start the layout of memory, the sections...
 *************************************************************************/

SECTIONS
{
  /* Don't allow config-fuse sections in an application sketch */
  /DISCARD/ : { *(.config_*) }
}

SECTIONS
{
  .eeprom_pic32 _EEPROM_ADDR (NOLOAD):
  {
    KEEP(*(.eeprom_pic32 .eeprom_pic32.*))
  } > kseg0_eeprom_mem

  /DISCARD/ : { *(.bev_handler) }

 .image_ptr_table _IMAGE_PTR_TABLE :
  {
    LONG(_ebase_address)
    LONG(_image_header_info)
  } > exception_mem

  .app_excpt _GEN_EXCPT_ADDR :
  {
    KEEP(*(.gen_handler))
  } > exception_mem

  .vector_0 _ebase_address + 0x200 :
  {
    _new_vector_0 = . ;
	KEEP(*(.vector_new_0))
    _original_vector_0 = . ;
	KEEP(*(.vector_0))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_0) <= (_vector_spacing << 5), "function at exception vector 0 too large")
  .vector_1 _ebase_address + 0x200 + (_vector_spacing << 5) * 1 :
  {
    KEEP(*(.vector_new_1))
    KEEP(*(.vector_1))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_1) <= (_vector_spacing << 5), "function at exception vector 1 too large")
  .vector_2 _ebase_address + 0x200 + (_vector_spacing << 5) * 2 :
  {
    KEEP(*(.vector_new_2))
    KEEP(*(.vector_2))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_2) <= (_vector_spacing << 5), "function at exception vector 2 too large")
  .vector_3 _ebase_address + 0x200 + (_vector_spacing << 5) * 3 :
  {
    KEEP(*(.vector_new_3))
    KEEP(*(.vector_3))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_3) <= (_vector_spacing << 5), "function at exception vector 3 too large")
  .vector_4 _ebase_address + 0x200 + (_vector_spacing << 5) * 4 :
  {
    KEEP(*(.vector_new_4))
    KEEP(*(.vector_4))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_4) <= (_vector_spacing << 5), "function at exception vector 4 too large")
  .vector_5 _ebase_address + 0x200 + (_vector_spacing << 5) * 5 :
  {
    KEEP(*(.vector_new_5))
    KEEP(*(.vector_5))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_5) <= (_vector_spacing << 5), "function at exception vector 5 too large")
  .vector_6 _ebase_address + 0x200 + (_vector_spacing << 5) * 6 :
  {
    KEEP(*(.vector_new_6))
    KEEP(*(.vector_6))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_6) <= (_vector_spacing << 5), "function at exception vector 6 too large")
  .vector_7 _ebase_address + 0x200 + (_vector_spacing << 5) * 7 :
  {
    KEEP(*(.vector_new_7))
    KEEP(*(.vector_7))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_7) <= (_vector_spacing << 5), "function at exception vector 7 too large")
  .vector_8 _ebase_address + 0x200 + (_vector_spacing << 5) * 8 :
  {
    KEEP(*(.vector_new_8))
    KEEP(*(.vector_8))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_8) <= (_vector_spacing << 5), "function at exception vector 8 too large")
  .vector_9 _ebase_address + 0x200 + (_vector_spacing << 5) * 9 :
  {
    KEEP(*(.vector_new_9))
    KEEP(*(.vector_9))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_9) <= (_vector_spacing << 5), "function at exception vector 9 too large")
  .vector_10 _ebase_address + 0x200 + (_vector_spacing << 5) * 10 :
  {
    KEEP(*(.vector_new_10))
    KEEP(*(.vector_10))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_10) <= (_vector_spacing << 5), "function at exception vector 10 too large")
  .vector_11 _ebase_address + 0x200 + (_vector_spacing << 5) * 11 :
  {
    KEEP(*(.vector_new_11))
    KEEP(*(.vector_11))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_11) <= (_vector_spacing << 5), "function at exception vector 11 too large")
  .vector_12 _ebase_address + 0x200 + (_vector_spacing << 5) * 12 :
  {
    KEEP(*(.vector_new_12))
    KEEP(*(.vector_12))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_12) <= (_vector_spacing << 5), "function at exception vector 12 too large")
  .vector_13 _ebase_address + 0x200 + (_vector_spacing << 5) * 13 :
  {
    KEEP(*(.vector_new_13))
    KEEP(*(.vector_13))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_13) <= (_vector_spacing << 5), "function at exception vector 13 too large")
  .vector_14 _ebase_address + 0x200 + (_vector_spacing << 5) * 14 :
  {
    KEEP(*(.vector_new_14))
    KEEP(*(.vector_14))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_14) <= (_vector_spacing << 5), "function at exception vector 14 too large")
  .vector_15 _ebase_address + 0x200 + (_vector_spacing << 5) * 15 :
  {
    KEEP(*(.vector_new_15))
    KEEP(*(.vector_15))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_15) <= (_vector_spacing << 5), "function at exception vector 15 too large")
  .vector_16 _ebase_address + 0x200 + (_vector_spacing << 5) * 16 :
  {
    KEEP(*(.vector_new_16))
    KEEP(*(.vector_16))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_16) <= (_vector_spacing << 5), "function at exception vector 16 too large")
  .vector_17 _ebase_address + 0x200 + (_vector_spacing << 5) * 17 :
  {
    KEEP(*(.vector_new_17))
    KEEP(*(.vector_17))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_17) <= (_vector_spacing << 5), "function at exception vector 17 too large")
  .vector_18 _ebase_address + 0x200 + (_vector_spacing << 5) * 18 :
  {
    KEEP(*(.vector_new_18))
    KEEP(*(.vector_18))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_18) <= (_vector_spacing << 5), "function at exception vector 18 too large")
  .vector_19 _ebase_address + 0x200 + (_vector_spacing << 5) * 19 :
  {
    KEEP(*(.vector_new_19))
    KEEP(*(.vector_19))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_19) <= (_vector_spacing << 5), "function at exception vector 19 too large")
  .vector_20 _ebase_address + 0x200 + (_vector_spacing << 5) * 20 :
  {
    KEEP(*(.vector_new_20))
    KEEP(*(.vector_20))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_20) <= (_vector_spacing << 5), "function at exception vector 20 too large")
  .vector_21 _ebase_address + 0x200 + (_vector_spacing << 5) * 21 :
  {
    KEEP(*(.vector_new_21))
    KEEP(*(.vector_21))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_21) <= (_vector_spacing << 5), "function at exception vector 21 too large")
  .vector_22 _ebase_address + 0x200 + (_vector_spacing << 5) * 22 :
  {
    KEEP(*(.vector_new_22))
    KEEP(*(.vector_22))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_22) <= (_vector_spacing << 5), "function at exception vector 22 too large")
  .vector_23 _ebase_address + 0x200 + (_vector_spacing << 5) * 23 :
  {
    KEEP(*(.vector_new_23))
    KEEP(*(.vector_23))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_23) <= (_vector_spacing << 5), "function at exception vector 23 too large")
  .vector_24 _ebase_address + 0x200 + (_vector_spacing << 5) * 24 :
  {
    KEEP(*(.vector_new_24))
    KEEP(*(.vector_24))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_24) <= (_vector_spacing << 5), "function at exception vector 24 too large")
  .vector_25 _ebase_address + 0x200 + (_vector_spacing << 5) * 25 :
  {
    KEEP(*(.vector_new_25))
    KEEP(*(.vector_25))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_25) <= (_vector_spacing << 5), "function at exception vector 25 too large")
  .vector_26 _ebase_address + 0x200 + (_vector_spacing << 5) * 26 :
  {
    KEEP(*(.vector_new_26))
    KEEP(*(.vector_26))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_26) <= (_vector_spacing << 5), "function at exception vector 26 too large")
  .vector_27 _ebase_address + 0x200 + (_vector_spacing << 5) * 27 :
  {
    KEEP(*(.vector_new_27))
    KEEP(*(.vector_27))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_27) <= (_vector_spacing << 5), "function at exception vector 27 too large")
  .vector_28 _ebase_address + 0x200 + (_vector_spacing << 5) * 28 :
  {
    KEEP(*(.vector_new_28))
    KEEP(*(.vector_28))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_28) <= (_vector_spacing << 5), "function at exception vector 28 too large")
  .vector_29 _ebase_address + 0x200 + (_vector_spacing << 5) * 29 :
  {
    KEEP(*(.vector_new_29))
    KEEP(*(.vector_29))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_29) <= (_vector_spacing << 5), "function at exception vector 29 too large")
  .vector_30 _ebase_address + 0x200 + (_vector_spacing << 5) * 30 :
  {
    KEEP(*(.vector_new_30))
    KEEP(*(.vector_30))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_30) <= (_vector_spacing << 5), "function at exception vector 30 too large")
  .vector_31 _ebase_address + 0x200 + (_vector_spacing << 5) * 31 :
  {
    KEEP(*(.vector_new_31))
    KEEP(*(.vector_31))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_31) <= (_vector_spacing << 5), "function at exception vector 31 too large")
  .vector_32 _ebase_address + 0x200 + (_vector_spacing << 5) * 32 :
  {
    KEEP(*(.vector_new_32))
    KEEP(*(.vector_32))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_32) <= (_vector_spacing << 5), "function at exception vector 32 too large")
  .vector_33 _ebase_address + 0x200 + (_vector_spacing << 5) * 33 :
  {
    KEEP(*(.vector_new_33))
    KEEP(*(.vector_33))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_33) <= (_vector_spacing << 5), "function at exception vector 33 too large")
  .vector_34 _ebase_address + 0x200 + (_vector_spacing << 5) * 34 :
  {
    KEEP(*(.vector_new_34))
    KEEP(*(.vector_34))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_34) <= (_vector_spacing << 5), "function at exception vector 34 too large")
  .vector_35 _ebase_address + 0x200 + (_vector_spacing << 5) * 35 :
  {
    KEEP(*(.vector_new_35))
    KEEP(*(.vector_35))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_35) <= (_vector_spacing << 5), "function at exception vector 35 too large")
  .vector_36 _ebase_address + 0x200 + (_vector_spacing << 5) * 36 :
  {
    KEEP(*(.vector_new_36))
    KEEP(*(.vector_36))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_36) <= (_vector_spacing << 5), "function at exception vector 36 too large")
  .vector_37 _ebase_address + 0x200 + (_vector_spacing << 5) * 37 :
  {
    KEEP(*(.vector_new_37))
    KEEP(*(.vector_37))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_37) <= (_vector_spacing << 5), "function at exception vector 37 too large")
  .vector_38 _ebase_address + 0x200 + (_vector_spacing << 5) * 38 :
  {
    KEEP(*(.vector_new_38))
    KEEP(*(.vector_38))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_38) <= (_vector_spacing << 5), "function at exception vector 38 too large")
  .vector_39 _ebase_address + 0x200 + (_vector_spacing << 5) * 39 :
  {
    KEEP(*(.vector_new_39))
    KEEP(*(.vector_39))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_39) <= (_vector_spacing << 5), "function at exception vector 39 too large")
  .vector_40 _ebase_address + 0x200 + (_vector_spacing << 5) * 40 :
  {
    KEEP(*(.vector_new_40))
    KEEP(*(.vector_40))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_40) <= (_vector_spacing << 5), "function at exception vector 40 too large")
  .vector_41 _ebase_address + 0x200 + (_vector_spacing << 5) * 41 :
  {
    KEEP(*(.vector_new_41))
    KEEP(*(.vector_41))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_41) <= (_vector_spacing << 5), "function at exception vector 41 too large")
  .vector_42 _ebase_address + 0x200 + (_vector_spacing << 5) * 42 :
  {
    KEEP(*(.vector_new_42))
    KEEP(*(.vector_42))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_42) <= (_vector_spacing << 5), "function at exception vector 42 too large")
  .vector_43 _ebase_address + 0x200 + (_vector_spacing << 5) * 43 :
  {
    KEEP(*(.vector_new_43))
    KEEP(*(.vector_43))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_43) <= (_vector_spacing << 5), "function at exception vector 43 too large")
  .vector_44 _ebase_address + 0x200 + (_vector_spacing << 5) * 44 :
  {
    KEEP(*(.vector_new_44))
    KEEP(*(.vector_44))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_44) <= (_vector_spacing << 5), "function at exception vector 44 too large")
  .vector_45 _ebase_address + 0x200 + (_vector_spacing << 5) * 45 :
  {
    KEEP(*(.vector_new_45))
    KEEP(*(.vector_45))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_45) <= (_vector_spacing << 5), "function at exception vector 45 too large")
  .vector_46 _ebase_address + 0x200 + (_vector_spacing << 5) * 46 :
  {
    KEEP(*(.vector_new_46))
    KEEP(*(.vector_46))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_46) <= (_vector_spacing << 5), "function at exception vector 46 too large")
  .vector_47 _ebase_address + 0x200 + (_vector_spacing << 5) * 47 :
  {
    KEEP(*(.vector_new_47))
    KEEP(*(.vector_47))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_47) <= (_vector_spacing << 5), "function at exception vector 47 too large")
  .vector_48 _ebase_address + 0x200 + (_vector_spacing << 5) * 48 :
  {
    KEEP(*(.vector_new_48))
    KEEP(*(.vector_48))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_48) <= (_vector_spacing << 5), "function at exception vector 48 too large")
  .vector_49 _ebase_address + 0x200 + (_vector_spacing << 5) * 49 :
  {
    KEEP(*(.vector_new_49))
    KEEP(*(.vector_49))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_49) <= (_vector_spacing << 5), "function at exception vector 49 too large")
  .vector_50 _ebase_address + 0x200 + (_vector_spacing << 5) * 50 :
  {
    KEEP(*(.vector_new_50))
    KEEP(*(.vector_50))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_50) <= (_vector_spacing << 5), "function at exception vector 50 too large")
  .vector_51 _ebase_address + 0x200 + (_vector_spacing << 5) * 51 :
  {
    KEEP(*(.vector_new_51))
    KEEP(*(.vector_51))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_51) <= (_vector_spacing << 5), "function at exception vector 51 too large")
  .vector_52 _ebase_address + 0x200 + (_vector_spacing << 5) * 52 :
  {
    KEEP(*(.vector_new_52))
    KEEP(*(.vector_52))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_52) <= (_vector_spacing << 5), "function at exception vector 52 too large")
  .vector_53 _ebase_address + 0x200 + (_vector_spacing << 5) * 53 :
  {
    KEEP(*(.vector_new_53))
    KEEP(*(.vector_53))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_53) <= (_vector_spacing << 5), "function at exception vector 53 too large")
  .vector_54 _ebase_address + 0x200 + (_vector_spacing << 5) * 54 :
  {
    KEEP(*(.vector_new_54))
    KEEP(*(.vector_54))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_54) <= (_vector_spacing << 5), "function at exception vector 54 too large")
  .vector_55 _ebase_address + 0x200 + (_vector_spacing << 5) * 55 :
  {
    KEEP(*(.vector_new_55))
    KEEP(*(.vector_55))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_55) <= (_vector_spacing << 5), "function at exception vector 55 too large")
  .vector_56 _ebase_address + 0x200 + (_vector_spacing << 5) * 56 :
  {
    KEEP(*(.vector_new_56))
    KEEP(*(.vector_56))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_56) <= (_vector_spacing << 5), "function at exception vector 56 too large")
  .vector_57 _ebase_address + 0x200 + (_vector_spacing << 5) * 57 :
  {
    KEEP(*(.vector_new_57))
    KEEP(*(.vector_57))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_57) <= (_vector_spacing << 5), "function at exception vector 57 too large")
  .vector_58 _ebase_address + 0x200 + (_vector_spacing << 5) * 58 :
  {
    KEEP(*(.vector_new_58))
    KEEP(*(.vector_58))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_58) <= (_vector_spacing << 5), "function at exception vector 58 too large")
  .vector_59 _ebase_address + 0x200 + (_vector_spacing << 5) * 59 :
  {
    KEEP(*(.vector_new_59))
    KEEP(*(.vector_59))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_59) <= (_vector_spacing << 5), "function at exception vector 59 too large")
  .vector_60 _ebase_address + 0x200 + (_vector_spacing << 5) * 60 :
  {
    KEEP(*(.vector_new_60))
    KEEP(*(.vector_60))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_60) <= (_vector_spacing << 5), "function at exception vector 60 too large")
  .vector_61 _ebase_address + 0x200 + (_vector_spacing << 5) * 61 :
  {
    KEEP(*(.vector_new_61))
    KEEP(*(.vector_61))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_61) <= (_vector_spacing << 5), "function at exception vector 61 too large")
  .vector_62 _ebase_address + 0x200 + (_vector_spacing << 5) * 62 :
  {
    KEEP(*(.vector_new_62))
    KEEP(*(.vector_62))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_62) <= (_vector_spacing << 5), "function at exception vector 62 too large")
  .vector_63 _ebase_address + 0x200 + (_vector_spacing << 5) * 63 :
  {
    KEEP(*(.vector_new_63))
    KEEP(*(.vector_63))
  } > exception_mem
  ASSERT (_vector_spacing == 0 || SIZEOF(.vector_63) <= (_vector_spacing << 5), "function at exception vector 63 too large")
  .startup :
  {
    KEEP(*(.startup))
  } > kseg0_program_mem
  /* Code Sections */

  .text  :
  {
    _text_begin = . ;

    *(.stub .gnu.linkonce.t.*)
    KEEP (*(.text.*personality*))
    /* .gnu.warning sections are handled specially by elf32.em.  */
    *(.mips16.fn.*)
    *(.mips16.call.*)
    *(.gnu.warning)
    . = ALIGN(4) ;
  } >kseg0_program_mem =0

   .init      :
  {
	KEEP (*crti.o(.init))
	KEEP (*crtbegin.o(.init))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o *crtn.o ).init))
	KEEP (*crtend.o(.init))
    KEEP (*crtn.o(.init))
    . = ALIGN(4) ;
  }  >kseg0_program_mem 

  .fini       :
  {
    KEEP (*(.fini))
    . = ALIGN(4) ;
  } >kseg0_program_mem

  .preinit_array     :
  {
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    . = ALIGN(4) ;
    PROVIDE_HIDDEN (__preinit_array_end = .);
  }>kseg0_program_mem

  .init_array     :
  {
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array))
    . = ALIGN(4) ;
    PROVIDE_HIDDEN (__init_array_end = .);
  }>kseg0_program_mem

  .fini_array     :
  {
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array))
    . = ALIGN(4) ;
    PROVIDE_HIDDEN (__fini_array_end = .);
  }>kseg0_program_mem


  .ctors        :
  { 
    /* gcc uses crtbegin.o to find the start of
       the constructors, so we make sure it is
       first.  Because this is a wildcard, it
       doesn't matter if the user does not
       actually link against crtbegin.o; the
       linker won't look for a file to match a
       wildcard.  The wildcard also means that it
       doesn't matter which directory crtbegin.o
       is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
       the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
    . = ALIGN(4) ;
  }>kseg0_program_mem 
  

  .dtors          :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
    . = ALIGN(4) ;
  }>kseg0_program_mem

  .preinit_array    :
  {
    KEEP (*(.preinit_array))
    . = ALIGN(4) ;
  }>kseg0_program_mem

  /* Read-only sections */
  .header_info ALIGN(4) :
  {
    _image_header_info = . ;
    LONG(SIZEOF(.header_info))                 /* size of this structure       */
    LONG(0xFFFFFFFF)                           /* bootloader version           */
    KEEP(*(.mpide_version *.mpide_version.*))  /* MPIDE build version          */
    LONG(0xFFFFFFFF)                           /* booloader capabilities       */
    LONG(0xFFFFFFFF)                           /* VID and PID                  */
    LONG(_IMAGE_TYPE)                          /* image type and options       */
    LONG(_JUMP_ADDR)                           /* image execution address      */
    LONG(_ebase_address)                       /* image base address           */
    LONG(_IMAGE_FLASH_SIZE)                    /* size of image flash used     */
    LONG(ORIGIN(kseg0_eeprom_mem))             /* eeprom location              */
    LONG(LENGTH(kseg0_eeprom_mem))             /* eeprom size                  */
    LONG(ORIGIN(configsfrs))                   /* config bits location         */
    LONG(LENGTH(configsfrs))                   /* config bits size             */
    LONG(_ram_header_addr)                     /* ram header pointer           */
    LONG(SIZEOF(.ram_exchange_data))           /* ram Header size              */
    LONG(0xFFFFFFFF)                           /* what the bootloader skips    */
    LONG(_original_vector_0)                   /* the original vector 0        */
    LONG(_new_vector_0)                        /* new/indirect vector 0        */
    LONG(_vector_spacing << 5)                 /* spacing of both org/new vec  */
    _image_header_info_end = . ;
  } > kseg0_program_mem
/*  ASSERT (SIZEOF(.header_info) == 76, "MPIDE Version not specfied correctly")*/

  .rodata  ALIGN(4) :
  {
    *(.gnu.linkonce.r.*)
    *(.rodata1)
    . = ALIGN(4) ;
  } >kseg0_program_mem

  /*
   * Place constant variables in this area that you don't want included
   * in the output. Ideal for big arrays for storing a filesystem that
   * would take forever to program. Also has the effect that reprogramming
   * can make the data persistent as long as addresses don't change.
   */
  .romdata ALIGN(4) (NOLOAD) :
  {
    *(.romdata .romdata.*)
    . = ALIGN(4) ;
  } >kseg0_program_mem

  /*
   * Small initialized constant global and static data can be placed in the
   * .sdata2 section.  This is different from .sdata, which contains small
   * initialized non-constant global and static data.
   */
  .sdata2 ALIGN(4)   :
  {
    *(.sdata2 .sdata2.* .gnu.linkonce.s2.*)
    . = ALIGN(4) ;
  } >kseg0_program_mem

  /*
   * Uninitialized constant global and static data (i.e., variables which will
   * always be zero).  Again, this is different from .sbss, which contains
   * small non-initialized, non-constant global and static data.
   */
  .sbss2 ALIGN(4)   :
  {
    *(.sbss2 .sbss2.* .gnu.linkonce.sb2.*)
    . = ALIGN(4) ;
  } >kseg0_program_mem

  .dbg_data ORIGIN(kseg1_data_mem) (NOLOAD) :
  {
    . += (DEFINED (_DEBUGGER) ? 0x200 : 0x0);
  } >kseg1_data_mem

  .ram_exchange_data (NOLOAD) :
  {
    _ram_header_addr = . ;
    . += 8 ;
  } >kseg1_data_mem

  /* Persistent data - Use the new C 'persistent' attribute instead. */
  .persist ALIGN(4) (NOLOAD) :
  {
    _persist_begin = .;
    *(.persist .persist.*)
    . = ALIGN(4) ;
    _persist_end = .;
  } >kseg1_data_mem

  ASSERT( _persist_end <= ORIGIN(kseg1_data_mem) + 0x600, "Bootloader does not preserve debug, RAM Header, or persistent data beyond the first 1.5K")

  /* If this is a bootloader, than skip around the protected memory and don't place anything there */
  _protected_end = ((_IMAGE_TYPE & (_imageSplitFlashBootloader | _imageProgramFlashBootloader | _imageBootFlashBootloader)) != 0) ? (ORIGIN(kseg1_data_mem) + 0x600) : . ;

  .protected_bootloader ORIGIN(kseg1_data_mem) (NOLOAD) :
  {
    . += (((_IMAGE_TYPE & (_imageSplitFlashBootloader | _imageProgramFlashBootloader | _imageBootFlashBootloader)) != 0) ? (ORIGIN(kseg1_data_mem) + 0x600) : 0x0);
  }

  /*
   *  Note that input sections named .data* are not mapped here.
   *  The best-fit allocator locates them, so that they may flow
   *  around absolute sections as needed.
   */
  .data :
  {
    _data_begin = . ;
    *( .gnu.linkonce.d.*)
    KEEP (*(.gnu.linkonce.d.*personality*))

    *(.data1)
    . = ALIGN(4) ;
  } >kseg1_data_mem

  _data_image_begin = LOADADDR(.data) ;
  . = .;
  _gp = ALIGN(16) + 0x7ff0;

  .got ALIGN(4)   :
  {
     *(.got.plt) *(.got)
  } >kseg1_data_mem
  /*
   * We want the small data sections together, so single-instruction offsets
   * can access them all, and initialized data all before uninitialized, so
   * we can shorten the on-disk segment size.
   */
  .sdata ALIGN(4) :
  {
    _sdata_begin = . ;
    *(.sdata .sdata.* .gnu.linkonce.s.*)
    . = ALIGN(4) ;
    _sdata_end = . ;
  } >kseg1_data_mem
  .lit8           :
  {
    *(.lit8)
    . = ALIGN(4) ;
  } >kseg1_data_mem

  .lit4           :
  {
    *(.lit4)
  } >kseg1_data_mem

  . = ALIGN (4) ;
  _data_end = . ;
  _bss_begin = . ;

  .sbss ALIGN(4) :
  {
    _sbss_begin = . ;
    *(.dynsbss)
    *(.sbss .sbss.* .gnu.linkonce.sb.*)
    *(.scommon)
    . = ALIGN(4) ;
    _sbss_end = . ;
  } >kseg1_data_mem

  .bss   :
  {
    *(.dynbss)
    *(.gnu.linkonce.b.*)
    *(COMMON)
    /*
     * Align here to ensure that the .bss section occupies space up to
     * _end.  Align after .bss to ensure correct alignment even if the
     * .bss section disappears because there are no input sections.
     */
    . = ALIGN(4) ;
  } >kseg1_data_mem

  . = ALIGN(4) ;
  _end = . ;
  _bss_end = . ;

  /*
   *  The heap and stack are best-fit allocated by the linker after other
   *  data and bss sections have been allocated.
   */
  /*
   * RAM functions go at the end of our stack and heap allocation.
   * Alignment of 2K required by the boundary register (BMXDKPBA).
   *
   * RAM functions are now allocated by the linker. The linker generates
   * _ramfunc_begin and _bmxdkpba_address symbols depending on the
   * location of RAM functions.
   */
  _bmxdudba_address = LENGTH(kseg1_data_mem) ;
  _bmxdupba_address = LENGTH(kseg1_data_mem) ;

    /* The .pdr section belongs in the absolute section */

    /DISCARD/ : { *(.pdr) }
    /* We don't load .reginfo onto the target, so don't locate it
     * in real memory
     */
    /DISCARD/ : { *(.reginfo) }

  .gcc_compiled_long32 : { KEEP(*(.gcc_compiled_long32)) }
  .gcc_compiled_long64 : { KEEP(*(.gcc_compiled_long64)) }

  /* Stabs debugging sections.  */
  .stab          0 : { *(.stab) }
  .stabstr       0 : { *(.stabstr) }
  .stab.excl     0 : { *(.stab.excl) }
  .stab.exclstr  0 : { *(.stab.exclstr) }
  .stab.index    0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment       0 : { *(.comment) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1 */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2 */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2 */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0  : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /* DWARF 3 */
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  .debug_ranges   0 : { *(.debug_ranges) }
  .gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }
  .gptab.sdata : { *(.gptab.data) *(.gptab.sdata) }
  .gptab.sbss : { *(.gptab.bss) *(.gptab.sbss) }
  .mdebug.abi32 : { KEEP(*(.mdebug.abi32)) }
  .mdebug.abiN32 : { KEEP(*(.mdebug.abiN32)) }
  .mdebug.abi64 : { KEEP(*(.mdebug.abi64)) }
  .mdebug.abiO64 : { KEEP(*(.mdebug.abiO64)) }
  .mdebug.eabi32 : { KEEP(*(.mdebug.eabi32)) }
  .mdebug.eabi64 : { KEEP(*(.mdebug.eabi64)) }
  /DISCARD/ : { *(.rel.dyn) }
  .gnu.attributes 0 : { KEEP (*(.gnu.attributes)) }
  /DISCARD/ : { *(.note.GNU-stack) }
  /DISCARD/ : { *(.note.GNU-stack) *(.gnu_debuglink) *(.gnu.lto_*) *(.discard) }
}
