/*********************************************************************
 *
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
 
	.section	.text.pic32softwarereset,code
	# .align	2
	.globl	__pic32_software_reset
	.globl	SoftReset
	.set	nomips16
	.set	nomicromips
	.ent	__pic32_software_reset
	.type	__pic32_software_reset, @function
	
SoftReset:
__pic32_software_reset:

	.frame	$sp,24,$31
	.mask	0x80000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro

	di
	ehb

0:
	li	$3,0xaa990000
	lui	$2,%hi(SYSKEY)
	addiu	$3,$3,26197
	sw	$0,%lo(SYSKEY)($2)
	sw	$3,%lo(SYSKEY)($2)
	li	$3,0x55660000
	ori	$3,$3,0x99aa
	sw	$3,%lo(SYSKEY)($2)
	lui	$2,%hi(RSWRSTSET)
	li	$3,0x1
	sw	$3,%lo(RSWRSTSET)($2)
	lui	$2,%hi(RSWRST)
	lw	$2,%lo(RSWRST)($2)

	j	0b
	nop

	.set	macro
	.set	reorder

	.end	__pic32_software_reset
	.size	__pic32_software_reset, .-__pic32_software_reset
