/*********************************************************************
 *
 *                  C Runtime Startup
 *
 *********************************************************************
 * Software License Agreement
 *
 * This software is developed by Microchip Technology Inc. and its
 * subsidiaries ("Microchip").
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1.      Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 *
 * 2.      Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 *
 * 3.      Microchip's name may not be used to endorse or promote products
 * derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY MICROCHIP "AS IS" AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL
 * MICROCHIP BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWSOEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 ********************************************************************/
 
#include <xc.h>
#include <cp0defs.h>

#if !defined(__XC32_VERSION)
#define USE_OLD_INIT
#define USE_OLD_DOTSECTION
#endif

#if (__XC32_VERSION > 1000) && !defined(CPP_INIT)
#define CPP_INIT
#endif

#if defined (PIC32MZ)
# ifndef PIC32_SRS_SET_COUNT
#  define PIC32_SRS_SET_COUNT 8
# endif
# ifndef INIT_SSX
#  define INIT_SSX 1
# endif
#else
# define PIC32_SRS_SET_COUNT 2
#endif


        ##################################################################
        # Entry point of the entire application
        ##################################################################
#if defined(USE_OLD_DOTSECTION)
        .section .reset,"ax",@progbits
#else
        .section .reset,code,keep
#endif
        .align 2
        .set noreorder
        .ent _reset
############################
# Begin ISA switching code #
############################

#if defined (__mips_micromips)
        .set micromips
#endif

#if (defined(__PIC32_HAS_MICROMIPS)) && (defined(__PIC32_HAS_MIPS32R2))
_reset:
        .word 0x10000003     /* MIPS32:    branch forward 0x10 bytes from here  */
                             /* MicroMIPS: ADDI32 $0, $0, 0x0007 (nop)          */
                             /* DO NOT change the relative branch               */

        .word 0x00000000     /* NOP */
__reset_micromips_isa:
        .set    micromips
        jal     _startup
        nop

        .align 2
        /* Device not in proper ISA mode */
        .set nomicromips
__reset_switch_isa:
        jal _startup
        nop

#else

_reset:
        jal _startup
        nop

#endif  /* __PIC32_HAS_MICROMIPS */

        .align 2
        .end _reset
        .globl _reset
        .size _reset, .-_reset

        .section .reset.startup,code,keep
        .align 2
        .set noreorder

#if defined (__mips_micromips)
        .set micromips
#else
        .set nomicromips
#endif

############################
# End ISA switching code   #
############################


        ##################################################################
        # Startup code
        ##################################################################
#if defined(USE_OLD_DOTSECTION)
        .section .startup,"ax",@progbits
#else
        .section .startup,code
#endif
        .align 2
        .set noreorder
        .ent _startup
_startup:
        ##################################################################
        # If entered because of an NMI, jump to the NMI handler.
        ##################################################################
        mfc0    k0,_CP0_STATUS
        ext     k0,k0,19,1              # Extract NMI bit
        beqz    k0,_no_nmi
        nop
        la      k0,_nmi_handler
        jr      k0
        nop
_no_nmi:

        ##################################################################
        # Initialize Stack Pointer
        #   _stack is initialized by the linker script to point to the
        #    starting location of the stack in DRM
        ##################################################################
        la      sp,_stack

        ##################################################################
        # Initialize Global Pointer
        #   _gp is initialized by the linker script to point to "middle"
        #   of the small variables region
        ##################################################################
        la      gp,_gp

#if (PIC32_SRS_SET_COUNT == 2)
        ##################################################################
        # Initialize Global Pointer in Shadow Set
        #   The SRSCtl's PSS field must be set to the shadow set in which
        #   to initialize the global pointer.  Since we have only a
        #   single shadow set (besides the normal), we will initialize
        #   SRSCtl<PSS> to SRSCtl<HSS>.  We then write the global pointer
        #   to the previous shadow set to ensure that on interrupt, the
        #   global pointer has been initialized.
        ##################################################################
        mfc0    t1,_CP0_SRSCTL          # Read SRSCtl register
        add     t3,t1,zero              # Save off current SRSCtl
        ext     t2,t1,26,4              # to obtain HSS field
        ins     t1,t2,6,4               # Put HSS field
        mtc0    t1,_CP0_SRSCTL          # into SRSCtl<PSS>
        ehb                             # Clear hazard before using new SRSCTL
        wrpgpr  gp,gp                   # Set global pointer in PSS
        mtc0    t3,_CP0_SRSCTL          # Restore SRSCtl
        ehb

#elif (PIC32_SRS_SET_COUNT > 2)
        ##################################################################
        # Initialize Global Pointer in Shadow Set(s)
        #   The SRSCtl PSS field must be set to the shadow set in which
        #   to initialize the global pointer.  We will initialize
        #   SRSCtl<PSS> to the number of reg sets and work down to set zero.
        #   We write the global pointer to the previous shadow set to
        #   ensure that on interrupt, the global pointer has been
        #   initialized.
        ##################################################################
        mfc0    t1,_CP0_SRSCTL          # Read SRSCtl register
        add     t3,t1,zero              # Save off current SRSCtl

        li      t2,(PIC32_SRS_SET_COUNT-1)

1:      ins     t1,t2,6,4               # Put next shadow set field
        mtc0    t1,_CP0_SRSCTL          # into SRSCtl<PSS>
        ehb                             # Clear hazard before using new SRSCTL
        wrpgpr  gp,gp                   # Set global pointer in PSS

        addiu   t2,t2,-1                # Next lower shadow set
                                        # Loop for all sets
        bne     t2,$0,1b                # Down to zero (normal GPR set)
        nop

        mtc0    t3,_CP0_SRSCTL          # Restore SRSCtl
        ehb

#endif /* (PIC32_SRS_SET_COUNT > 2) */

        ##################################################################
        # Call the "on reset" procedure
        ##################################################################
        la      t0,_on_reset
        jalr    t0
        nop


#if defined(INIT_MMU_MZ_FIXED) || defined(__PIC32_HAS_MMU_MZ_FIXED)
        ##################################################################
        # Initialize TLB for fixed mapping to EBI and SQI
        ##################################################################
        .extern __pic32_tlb_init_ebi_sqi
        la      t0,__pic32_tlb_init_ebi_sqi
        jalr    t0
        nop
#endif

#if defined(__PIC32_HAS_L1_CACHE)
        ##################################################################
        # Initialize L1 cache register
        ##################################################################
        .extern __pic32_init_cache
        la      t0,__pic32_init_cache
        jalr    t0
        nop
#endif

        ##################################################################
        # Clear uninitialized data sections
        ##################################################################
        la      t0,_bss_begin
        la      t1,_bss_end
        b       _bss_check
        nop

_bss_init:      
        sw      zero,0x0(t0)
        sw      zero,0x4(t0)
        sw      zero,0x8(t0)
        sw      zero,0xc(t0)
        addu    t0,16
_bss_check:
        bltu    t0,t1,_bss_init
        nop
                
#if defined(USE_OLD_INIT)
        ##################################################################
        # Copy initialized data from program flash to data memory
        #   src=_data_image_begin dst=_data_begin stop=_data_end
        ##################################################################
        la      t0,_data_image_begin
        la      t1,_data_begin
        la      t2,_data_end
        b       _init_check
        nop

_init_data:     
        lw      t3,(t0)
        sw      t3,(t1)
        addu    t0,4
        addu    t1,4
_init_check:
        bltu    t1,t2,_init_data
        nop

        ##################################################################
        # If there are no RAM functions, skip the next two sections --
        # copying RAM functions from program flash to data memory and
        # initializing bus matrix registers.
        ##################################################################
        la      t1,_ramfunc_length
        beqz    t1,_ramfunc_done
        nop

        ##################################################################
        # Copy RAM functions from program flash to data memory
        #   src=_ramfunc_image_begin dst=_ramfunc_begin stop=_ramfunc_end
        ##################################################################
        la      t0,_ramfunc_image_begin
        la      t1,_ramfunc_begin
        la      t2,_ramfunc_end

_init_ramfunc:  
        lw      t3,(t0)
        sw      t3,(t1)
        addu    t0,4
        addu    t1,4
_ramfunc_check:
        bltu    t1,t2,_init_ramfunc
        nop

        ##################################################################
        # Initialize bus matrix registers if RAM functions exist in the
        # application
        ##################################################################
        la      t1,_bmxdkpba_address
        la      t2,BMXDKPBA
        sw      t1,0(t2)
        la      t1,_bmxdudba_address
        la      t2,BMXDUDBA
        sw      t1,0(t2)
        la      t1,_bmxdupba_address
        la      t2,BMXDUPBA
        sw      t1,0(t2)
_ramfunc_done:

#else
        ##################################################################
        # Initialize data using the linker-generated .dinit table
        ##################################################################
        .equiv FMT_CLEAR,0
        .equiv FMT_COPY,1
_dinit_init:
        la      t0,_dinit_addr

#define SRC t0
#define DST t1
#define LEN t2
#define FMT t3

0:      lw      DST,0(SRC)
        beqz    DST,9f
        addu    SRC,4
        lw      LEN,0(SRC)
        addu    SRC,4
        lw      FMT,0(SRC)
        beq     FMT,$0,_dinit_clear
        addu    SRC,4

_dinit_copy:
        lbu     t4,0(SRC)
        subu    LEN,1
        addu    SRC,1
        sb      t4,0(DST)
        bne     LEN,$0,_dinit_copy
        addu    DST,1

        b       _dinit_end
        nop

_dinit_clear:
        sb      $0,(DST)
        subu    LEN,1
        bne     LEN,$0,_dinit_clear
        addu    DST,1

_dinit_end:
        addu    SRC,3
        addiu   LEN,$0,0xFFFFFFFC
        and     SRC,LEN,SRC
        lw      DST,0(SRC)
        bne     DST,$0,0b
        nop
9:

        ##################################################################
        # If there are no RAM functions, skip the next section --
        # initializing bus matrix registers.
        ##################################################################
        la      t1,_ramfunc_begin
        beqz    t1,_ramfunc_done
        nop

#if defined(INIT_SSX)
  /* TODO */
#else /* Use BMX */
        ##################################################################
        # Initialize bus matrix registers if RAM functions exist in the
        # application
        ##################################################################
        la      t1,_bmxdkpba_address
        la      t2,BMXDKPBA
        sw      t1,0(t2)
        la      t1,_bmxdudba_address
        la      t2,BMXDUDBA
        sw      t1,0(t2)
        la      t1,_bmxdupba_address
        la      t2,BMXDUPBA
        sw      t1,0(t2)
#endif /* INIT_SSX */

_ramfunc_done:

#endif  /* OLD_INIT */

        ##################################################################
        # Initialize CP0 registers
        ##################################################################
        # Initialize Count register
        ##################################################################
        mtc0    zero,_CP0_COUNT

        ##################################################################
        # Initialize Compare register
        ##################################################################
        li      t2,-1
        mtc0    t2,_CP0_COMPARE

        ##################################################################
        # Ensure BEV set and Initialize EBase register
        ##################################################################
        li      t0, (1<<22)
        mfc0    t2,_CP0_STATUS
        or      t2,t0,t2               # Set BEV bit 22
        mtc0    t2,_CP0_STATUS
        la      t1,_ebase_address
        ehb
        mtc0    t1,_CP0_EBASE

        ##################################################################
        # Initialize IntCtl/INTCON.VS register with _vector_spacing
        ##################################################################
        la      t1,_vector_spacing
#if defined(INIT_INTCONVS)
        la      t0, INTCON
        lw      t2, 0(t0)
        li      t2, 0
        ins     t2, t1, 16,7
#if defined(__PIC32MM) && defined(_INTCON_MVEC_MASK)
        ori     t2, t2, _INTCON_MVEC_MASK
#endif
        sw      t2, 0(t0)
#endif
        li      t2,0                    # Clear t2 and
        ins     t2,t1,5,5               # shift value to VS field
        mtc0    t2,_CP0_INTCTL

        ##################################################################
        # Initialize CAUSE registers
        # - Enable counting of Count register <DC = 0>
        # - Use special exception vector <IV = 1>
        # - Clear pending software interrupts <IP1:IP0 = 0>
        ##################################################################
        li      t1,0x00800000
        mtc0    t1,_CP0_CAUSE

        ##################################################################
        # Initialize STATUS register
        # - Access to Coprocessor 0 not allowed in user mode <CU0 = 0>
        # - User mode uses configured endianness <RE = 0>
        # - Preserve Bootstrap Exception vectors <BEV>
        # - Preserve soft reset <SR> and non-maskable interrupt <NMI>
        # - CorExtend enabled based on whether CorExtend User Defined
        #   Instructions have been implemented <CEE = Config<UDI>>
        # - Disable any pending interrupts <IM7..IM2 = 0, IM1..IM0 = 0>
        # - Disable hardware interrupts <IPL7:IPL2 = 0>
        # - Base mode is Kernel mode <UM = 0>
        # - Error level is normal <ERL = 0>
        # - Exception level is normal <EXL = 0>
        # - Interrupts are disabled <IE = 0>
        # - DSPr2 ASE is enabled for devices that support it <MX = 1>
        # - FPU64 is enabled for devices that support it <CU1=1> & <FR=1>
        ##################################################################
        mfc0    t0,_CP0_CONFIG
        ext     t1,t0,22,1              # Extract UDI from Config register
        sll     t1,t1,17                # Move UDI to Status.CEE location
        mfc0    t0,_CP0_STATUS
        and     t0,t0,0x00580000        # Preserve SR, NMI, and BEV
#if defined(__PIC32_HAS_DSPR2)
        li      t2, 0x01000000          # Set the Status.MX bit to enable DSP
        or      t0,t2,t0
#endif
#if defined(__PIC32_HAS_FPU64)
        li      t2, 0x24000000          # Set the Status.CU1 and Status.FR bits to
        or      t0,t2,t0                # enable the FPU in FR64 mode
#endif

        or      t0,t1,t0                # Include Status.CEE (from UDI)
        mtc0    t0,_CP0_STATUS

#if defined(__PIC32_HAS_FPU64)
                                        # FPU Control and Status
        li      t2,0x1000000            # FCSR: RM=0, FS=1, FO=0, FN=0
                                        # Enables: 0b00000 E=1, V=0, Z=0, O=0, U=0, I=0
        ctc1    t2, $31                 # High perf on denormal operands & tiny results
#endif
        ehb
	
        ##################################################################
        # Initialize CONFIG register
        ##################################################################
#if defined(__PIC32_HAS_L1_CACHE)
	mfc0    t0,_CP0_CONFIG
	li      t1,0x00000003
	or      t0,t1,t0
	mtc0    t0,_CP0_CONFIG
#endif

        ##################################################################
        # Call the "on bootstrap" procedure
        ##################################################################
        la      t0,_on_bootstrap
        jalr    t0
        nop

        ##################################################################
        # Initialize Status<BEV> for normal exception vectors
        ##################################################################
        mfc0    t0,_CP0_STATUS
        and     t0,t0,0xffbfffff        # Clear BEV
        mtc0    t0,_CP0_STATUS

        ##################################################################
        # Call main. We do this via a thunk in the text section so that
        # a normal jump and link can be used, enabling the startup code
        # to work properly whether main is written in MIPS16 or MIPS32
        # code. I.e., the linker will correctly adjust the JAL to JALX if
        # necessary
        ##################################################################
        and     a0,a0,0
        and     a1,a1,0
        la      t0,_main_entry
        jr      t0
        nop

        .end _startup

        ##################################################################
        # Boot Exception Vector Handler
        # Jumps to _bootstrap_exception_handler
        ##################################################################
        
#if defined(USE_OLD_DOTSECTION)
        .section .bev_handler,"ax",@progbits
#else
        .section .bev_handler,code,keep
#endif
        .align 2
        .set noreorder
        .ent _bev_exception
_bev_exception:
        la      k0,_bootstrap_exception_handler
        jr      k0
        nop

        .end _bev_exception
                        
        ##################################################################
        # General Exception Vector Handler
        # Jumps to _general_exception_handler
        ##################################################################
        
#if defined(USE_OLD_DOTSECTION)
        .section .gen_handler,"ax",@progbits
#else
        .section .gen_handler,code
#endif

        .set noreorder
        .ent _gen_exception
_gen_exception:
        la      k0,_general_exception_handler_entry
        jr      k0
        nop

        .end _gen_exception

#if defined(INIT_MMU_MZ_FIXED) || defined(__PIC32_HAS_MMU_MZ_FIXED)
        ##################################################################
        # Simple TLB-Refill Exception Vector
        # Jumps to _simple_tlb_refill_exception_context
        ##################################################################
        .section .simple_tlb_refill_vector,code,keep
        .align 2
        .set noreorder
        .ent simple_tlb_refill_vector
simple_tlb_refill_vector:
        la      k0,_simple_tlb_refill_exception_context
        jr      k0
        nop

        .end simple_tlb_refill_vector
#endif


#if defined(__PIC32_HAS_L1_CACHE)
        ##################################################################
        # Cache-Error Exception Vector Handler
        # Jumps to _cache_err_exception_context
        ##################################################################
        .section .cache_err_vector,code,keep
        .align 2
        .set noreorder
        .ent _cache_err_vector
_cache_err_vector:
        la      k0,_cache_err_exception_context
        jr      k0
        nop

        .end _cache_err_vector
#endif

        .section .text.main_entry,code,keep
        .align 2
        .ent _main_entry
_main_entry:

#if defined(CPP_INIT)
#        .weak _init
        # call .init section to run constructors etc
        lui	a0,%hi(_init)
        addiu	sp,sp,-24
        addiu	a0,a0,%lo(_init)
        beq	a0,$0,2f
        sw	$31,20(sp)	 #,
        jalr	a0
        nop
2:
#endif
        and     a0,a0,0
        and     a1,a1,0
        
        ##################################################################
        # Call main
        ##################################################################
        jal main
        nop

        ##################################################################
        # Call exit
        ##################################################################
        #jal    exit
        #nop

        ##################################################################
        # Just in case, go into infinite loop
        ##################################################################
1:
        b       1b
        nop
        .end _main_entry
