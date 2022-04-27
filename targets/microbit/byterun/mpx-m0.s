@@@ mpx-m0.s
@@@ Copyright (c) 2018 J. M. Spivey        

@@@ Hardware multiplexing for the ARM Cortex-M0

    .syntax unified
    .text

@@@ set_stack -- enter process mode
    .global set_stack
    .thumb_func
set_stack:
    msr psp, r0                 @ Set up the stack
    movs r0, #2                 @ Use psp for stack pointer
    msr control, r0
    isb                         @ Drain the pipeline
    bx lr
        
@@@ Stack layout for interrupt frames (17 words, 68 bytes)
@@@ --------------------------------------
@@@ 16  PSR  Status register
@@@ 15  PC   Program counter
@@@ 14  LR   Link register
@@@ 13  R12
@@@ 12  R3
@@@ 11  R2           (Saved by hardware)
@@@ 10  R1
@@@  9  R0
@@@ --------------------------------------
@@@  8  R11   
@@@  7  R10
@@@  6  R9
@@@  5  R8           (Saved manually)
@@@  4  R7
@@@  3  R6
@@@  2  R5
@@@  1  R4
@@@  0  LR'  Magic value <-- Stack pointer
@@@ --------------------------------------

@@@ The magic value for exception return is carefully preserved for each
@@@ process.  On Cortex-M0, it will always be 0xfffffffd, but on other
@@@ chips it encodes info about the hardware-saved frame layout.

@@@ isave -- save context for system call
    .macro isave
    mrs r0, psp                 @ Get thread stack pointer
    subs r0, #36
    movs r1, r0
    mov r3, lr                  @ Preserve magic value 0xfffffffd
    stm r1!, {r3-r7}            @ Save low regs on thread stack
    mov r4, r8                  @ Copy from high to low
    mov r5, r9
    mov r6, r10
    mov r7, r11
    stm r1!, {r4-r7}            @ Save high regs in thread stack
    .endm                       @ Return new thread sp

@@@ irestore -- restore context after system call
    .macro irestore             @ Expect process sp in r0
    movs r1, r0
    adds r0, #20
    ldm r0!, {r4-r7}            @ Restore high registers
    mov r8, r4                  @ Copy from low to high
    mov r9, r5
    mov r10, r6
    mov r11, r7
    ldm r1!, {r3-r7}            @ Restore low registers
    msr psp, r0                 @ Set stack pointer for thread
    bx r3
    .endm

@@@ svc_handler -- handler for SVC interrupt (system call)
    .global svc_handler
    .thumb_func
svc_handler:
    isave                       @ Complete saving of state
    @@ Argument in r0 is sp of old process
    bl system_call              @ Perform system call
    @@ Result in r0 is sp of new process
    irestore                    @ Restore manually saved state

@@@ pendsv_handler -- handler for PendSV interupt (context switch)
    .global pendsv_handler
    .thumb_func
pendsv_handler:
    isave                       @ Complete saving of process state
    bl cxt_switch               @ Choose a new process
    irestore                    @ Restore state for that process
