/*************************************************************************
 * Legacy processor-specific object file.  Contains SFR definitions.
 * The SFR definitions are now provided in a processor-specific *.S
 * assembly source file rather than the processor.o file. Use the new
 * .S file rather than this processor.o file for new projects. MPLAB XC32
 * v2.10 and later will automatically link the new .S file. When using * this linker script with an older MPLAB XC32 version, remove the
 * OPTIONAL() line below and add the pic32mx/lib/proc/<device>.S file
 * to your project.
 *************************************************************************/
OPTIONAL("processor.o")

/*************************************************************************
 * Processor-specific legacy peripheral libraries are optional.
 * These legacy plibs are available as a separate download from
 *   http://www.microchip.com/mplabxc
 * Use MPLAB Harmony for new projects.
 *   http://www.microchip.com/mplabharmony
 *************************************************************************/
OPTIONAL("libmchp_peripheral.a")
OPTIONAL("libmchp_peripheral_32MX795F512L.a")

/*************************************************************************
 * Symbols used for interrupt-vector table generation
 * To override the defaults, define the _vector_spacing & _ebase_address
 * symbols using the --defsym linker opt as shown in these examples:
 *   xc32-gcc src.c -Wl,--defsym=_vector_spacing=2
 *   xc32-gcc src.c -Wl,--defsym=_ebase_address=0x9D001000
 *************************************************************************/
PROVIDE(_vector_spacing = 0x0001);
PROVIDE(_ebase_address = 0x9FC01000);

/*************************************************************************
 * Memory Address Equates
 * _RESET_ADDR                    -- Reset Vector or entry point
 * _BEV_EXCPT_ADDR                -- Boot exception Vector
 * _DBG_EXCPT_ADDR                -- In-circuit Debugging Exception Vector
 * _DBG_CODE_ADDR                 -- In-circuit Debug Executive address
 * _DBG_CODE_SIZE                 -- In-circuit Debug Executive size
 * _GEN_EXCPT_ADDR                -- General Exception Vector
 *************************************************************************/
_RESET_ADDR                    = 0xBFC00000;
_BEV_EXCPT_ADDR                = 0xBFC00380;
_DBG_EXCPT_ADDR                = 0xBFC00480;
_DBG_CODE_ADDR                 = 0xBFC02000;
_DBG_CODE_SIZE                 = 0xFF0;
_GEN_EXCPT_ADDR                = _ebase_address + 0x180;

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
  kseg0_program_mem     (rx)  : ORIGIN = 0x9D000000, LENGTH = 0x80000
  kseg0_boot_mem              : ORIGIN = 0x9FC00490, LENGTH = 0x970
  exception_mem               : ORIGIN = 0x9FC01000, LENGTH = 0x1000
  kseg1_boot_mem              : ORIGIN = 0xBFC00000, LENGTH = 0x490
  debug_exec_mem              : ORIGIN = 0xBFC02000, LENGTH = 0xFF0
  config3                     : ORIGIN = 0xBFC02FF0, LENGTH = 0x4
  config2                     : ORIGIN = 0xBFC02FF4, LENGTH = 0x4
  config1                     : ORIGIN = 0xBFC02FF8, LENGTH = 0x4
  config0                     : ORIGIN = 0xBFC02FFC, LENGTH = 0x4
  kseg1_data_mem       (w!x)  : ORIGIN = 0xA0000000, LENGTH = 0x20000
  sfrs                        : ORIGIN = 0xBF800000, LENGTH = 0x100000
  configsfrs                  : ORIGIN = 0xBFC02FF0, LENGTH = 0x10
}

/*************************************************************************
 * Configuration-word sections. Map the config-pragma input sections to
 * absolute-address output sections.
 *************************************************************************/
SECTIONS
{
  .config_BFC02FF0 : {
    KEEP(*(.config_BFC02FF0))
  } > config3
  .config_BFC02FF4 : {
    KEEP(*(.config_BFC02FF4))
  } > config2
  .config_BFC02FF8 : {
    KEEP(*(.config_BFC02FF8))
  } > config1
  .config_BFC02FFC : {
    KEEP(*(.config_BFC02FFC))
  } > config0
}
