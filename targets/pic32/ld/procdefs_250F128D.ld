/*************************************************************************
 * Legacy processor-specific object file.  Contains SFR definitions.
 * The SFR definitions are now provided in a processor-specific *.S
 * assembly source file rather than the processor.o file. Use the new
 * .S file rather than this processor.o file for new projects. MPLAB XC32
 * v2.10 and later will automatically link the new .S file. When using * this linker script with an older MPLAB XC32 version, remove the
 * OPTIONAL() line below and add the pic32mx/lib/proc/<device>.S file
 * to your project.
 *************************************************************************/
INPUT("processor.o")

/*************************************************************************
 * Processor-specific legacy peripheral libraries are optional.
 * These legacy plibs are available as a separate download from
 *   http://www.microchip.com/mplabxc
 * Use MPLAB Harmony for new projects.
 *   http://www.microchip.com/mplabharmony
 *************************************************************************/
OPTIONAL("libmchp_peripheral.a")
OPTIONAL("libmchp_peripheral_32MX250F128D.a")

/*************************************************************************
 * Symbols used for interrupt-vector table generation
 * To override the defaults, define the _vector_spacing & _ebase_address
 * symbols using the --defsym linker opt as shown in these examples:
 *   xc32-gcc src.c -Wl,--defsym=_vector_spacing=2
 *   xc32-gcc src.c -Wl,--defsym=_ebase_address=0x9D001000
 *************************************************************************/
PROVIDE(_vector_spacing = 0x0001);
_ebase_address = 0x9D000000;




/*************************************************************************
 * Memory Regions
 *
 * Memory regions without attributes cannot be used for orphaned sections.
 * Only sections specifically assigned to these regions can be allocated
 * into these regions.
 *
 * The Debug exception vector is located at 0x9FC00480.
 *
 * The config_<address> sections are used to locate the config words at
 * their absolute addresses.
 *************************************************************************/


MEMORY
{
  kseg0_program_mem     (rx)  : ORIGIN = 0x9D001000, LENGTH = 0x1D000
  exception_mem               : ORIGIN = 0x9D000000, LENGTH = 0x1000
  debug_exec_mem              : ORIGIN = 0x9FC00490, LENGTH = 0x760
  kseg0_eeprom_mem           : ORIGIN = 0x9D01E000, LENGTH = 0x1000
  kseg0_splitflash_mem       : ORIGIN = 0x9D01F000, LENGTH = 0x1000
  kseg0_boot_mem              : ORIGIN = 0x9FC00200, LENGTH = 0
  kseg1_boot_mem              : ORIGIN = 0xBFC00000, LENGTH = 0
  config3                     : ORIGIN = 0xBFC00BF0, LENGTH = 0x4
  config2                     : ORIGIN = 0xBFC00BF4, LENGTH = 0x4
  config1                     : ORIGIN = 0xBFC00BF8, LENGTH = 0x4
  config0                     : ORIGIN = 0xBFC00BFC, LENGTH = 0x4
  kseg1_data_mem       (w!x)  : ORIGIN = 0xA0000000, LENGTH = 0x8000
  sfrs                        : ORIGIN = 0xBF800000, LENGTH = 0x100000
  configsfrs                  : ORIGIN = 0xBFC00BF0, LENGTH = 0x10
}

/*************************************************************************
 * Memory Address Equates
 * _RESET_ADDR                    -- Reset Vector or entry point
 * _BEV_EXCPT_ADDR                -- Boot exception Vector
 * _DBG_EXCPT_ADDR                -- In-circuit Debugging Exception Vector
 * _DBG_CODE_ADDR                 -- In-circuit Debug Executive address
 * _DBG_CODE_SIZE                 -- In-circuit Debug Executive size
 * _GEN_EXCPT_ADDR                -- General Exception Vector
 *************************************************************************/
_RESET_ADDR                    = ORIGIN(kseg0_program_mem);
_BEV_EXCPT_ADDR                = 0xBFC00380;
_DBG_EXCPT_ADDR                = 0xBFC00480;
_DBG_CODE_ADDR                 = 0x9FC00490;
_DBG_CODE_SIZE                 = 0x760;
_GEN_EXCPT_ADDR                = _ebase_address + 0x180;

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


/*************************************************************************
 * Configuration-word sections. Map the config-pragma input sections to
 * absolute-address output sections.
 *************************************************************************/
SECTIONS
{
  .config_BFC00BF0 : {
    KEEP(*(.config_BFC00BF0))
  } > config3
  .config_BFC00BF4 : {
    KEEP(*(.config_BFC00BF4))
  } > config2
  .config_BFC00BF8 : {
    KEEP(*(.config_BFC00BF8))
  } > config1
  .config_BFC00BFC : {
    KEEP(*(.config_BFC00BFC))
  } > config0
}
