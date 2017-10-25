opt subtitle "Microchip Technology Omniscient Code Generator v1.44 (Free mode) build 201709140600"

opt pagewidth 120

	opt lm

	processor	18F4620
opt include "/Applications/microchip/xc8/v1.44/include/18f4620.cgen.inc"
clrc   macro
	bcf	status,0
endm
setc   macro
	bsf	status,0
endm
clrz   macro
	bcf	status,2
endm
setz   macro
	bsf	status,2
endm
skipnz macro
	btfsc	status,2
endm
skipz  macro
	btfss	status,2
endm
skipnc macro
	btfsc	status,0
endm
skipc  macro
	btfss	status,0
endm
pushw macro
	movwf postinc1
endm
pushf macro arg1
	movff arg1, postinc1
endm
popw macro
	movf postdec1,f
	movf indf1,w
endm
popf macro arg1
	movf postdec1,f
	movff indf1,arg1
endm
popfc macro arg1
	movff plusw1,arg1
	decfsz fsr1,f
endm
	global	__ramtop
	global	__accesstop
# 52 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PORTA equ 0F80h ;# 
# 189 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PORTB equ 0F81h ;# 
# 360 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PORTC equ 0F82h ;# 
# 535 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PORTD equ 0F83h ;# 
# 677 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PORTE equ 0F84h ;# 
# 880 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
LATA equ 0F89h ;# 
# 992 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
LATB equ 0F8Ah ;# 
# 1104 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
LATC equ 0F8Bh ;# 
# 1216 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
LATD equ 0F8Ch ;# 
# 1328 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
LATE equ 0F8Dh ;# 
# 1380 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TRISA equ 0F92h ;# 
# 1385 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
DDRA equ 0F92h ;# 
# 1602 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TRISB equ 0F93h ;# 
# 1607 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
DDRB equ 0F93h ;# 
# 1824 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TRISC equ 0F94h ;# 
# 1829 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
DDRC equ 0F94h ;# 
# 2046 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TRISD equ 0F95h ;# 
# 2051 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
DDRD equ 0F95h ;# 
# 2268 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TRISE equ 0F96h ;# 
# 2273 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
DDRE equ 0F96h ;# 
# 2432 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
OSCTUNE equ 0F9Bh ;# 
# 2497 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PIE1 equ 0F9Dh ;# 
# 2574 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PIR1 equ 0F9Eh ;# 
# 2651 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
IPR1 equ 0F9Fh ;# 
# 2728 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PIE2 equ 0FA0h ;# 
# 2794 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PIR2 equ 0FA1h ;# 
# 2860 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
IPR2 equ 0FA2h ;# 
# 2926 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
EECON1 equ 0FA6h ;# 
# 2992 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
EECON2 equ 0FA7h ;# 
# 2999 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
EEDATA equ 0FA8h ;# 
# 3006 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
EEADR equ 0FA9h ;# 
# 3013 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
EEADRH equ 0FAAh ;# 
# 3020 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
RCSTA equ 0FABh ;# 
# 3025 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
RCSTA1 equ 0FABh ;# 
# 3230 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TXSTA equ 0FACh ;# 
# 3235 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TXSTA1 equ 0FACh ;# 
# 3486 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TXREG equ 0FADh ;# 
# 3491 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TXREG1 equ 0FADh ;# 
# 3498 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
RCREG equ 0FAEh ;# 
# 3503 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
RCREG1 equ 0FAEh ;# 
# 3510 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SPBRG equ 0FAFh ;# 
# 3515 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SPBRG1 equ 0FAFh ;# 
# 3522 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SPBRGH equ 0FB0h ;# 
# 3529 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
T3CON equ 0FB1h ;# 
# 3641 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR3 equ 0FB2h ;# 
# 3648 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR3L equ 0FB2h ;# 
# 3655 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR3H equ 0FB3h ;# 
# 3662 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CMCON equ 0FB4h ;# 
# 3752 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CVRCON equ 0FB5h ;# 
# 3831 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
ECCP1AS equ 0FB6h ;# 
# 3913 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PWM1CON equ 0FB7h ;# 
# 3983 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
BAUDCON equ 0FB8h ;# 
# 3988 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
BAUDCTL equ 0FB8h ;# 
# 4155 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCP2CON equ 0FBAh ;# 
# 4234 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCPR2 equ 0FBBh ;# 
# 4241 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCPR2L equ 0FBBh ;# 
# 4248 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCPR2H equ 0FBCh ;# 
# 4255 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCP1CON equ 0FBDh ;# 
# 4352 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCPR1 equ 0FBEh ;# 
# 4359 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCPR1L equ 0FBEh ;# 
# 4366 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
CCPR1H equ 0FBFh ;# 
# 4373 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
ADCON2 equ 0FC0h ;# 
# 4444 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
ADCON1 equ 0FC1h ;# 
# 4529 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
ADCON0 equ 0FC2h ;# 
# 4648 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
ADRES equ 0FC3h ;# 
# 4655 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
ADRESL equ 0FC3h ;# 
# 4662 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
ADRESH equ 0FC4h ;# 
# 4669 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SSPCON2 equ 0FC5h ;# 
# 4731 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SSPCON1 equ 0FC6h ;# 
# 4801 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SSPSTAT equ 0FC7h ;# 
# 5022 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SSPADD equ 0FC8h ;# 
# 5029 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
SSPBUF equ 0FC9h ;# 
# 5036 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
T2CON equ 0FCAh ;# 
# 5107 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PR2 equ 0FCBh ;# 
# 5112 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
MEMCON equ 0FCBh ;# 
# 5217 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR2 equ 0FCCh ;# 
# 5224 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
T1CON equ 0FCDh ;# 
# 5327 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR1 equ 0FCEh ;# 
# 5334 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR1L equ 0FCEh ;# 
# 5341 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR1H equ 0FCFh ;# 
# 5348 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
RCON equ 0FD0h ;# 
# 5481 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
WDTCON equ 0FD1h ;# 
# 5509 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
HLVDCON equ 0FD2h ;# 
# 5514 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
LVDCON equ 0FD2h ;# 
# 5779 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
OSCCON equ 0FD3h ;# 
# 5856 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
T0CON equ 0FD5h ;# 
# 5933 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR0 equ 0FD6h ;# 
# 5940 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR0L equ 0FD6h ;# 
# 5947 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TMR0H equ 0FD7h ;# 
# 5954 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
STATUS equ 0FD8h ;# 
# 6025 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR2 equ 0FD9h ;# 
# 6032 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR2L equ 0FD9h ;# 
# 6039 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR2H equ 0FDAh ;# 
# 6046 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PLUSW2 equ 0FDBh ;# 
# 6053 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PREINC2 equ 0FDCh ;# 
# 6060 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
POSTDEC2 equ 0FDDh ;# 
# 6067 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
POSTINC2 equ 0FDEh ;# 
# 6074 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
INDF2 equ 0FDFh ;# 
# 6081 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
BSR equ 0FE0h ;# 
# 6088 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR1 equ 0FE1h ;# 
# 6095 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR1L equ 0FE1h ;# 
# 6102 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR1H equ 0FE2h ;# 
# 6109 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PLUSW1 equ 0FE3h ;# 
# 6116 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PREINC1 equ 0FE4h ;# 
# 6123 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
POSTDEC1 equ 0FE5h ;# 
# 6130 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
POSTINC1 equ 0FE6h ;# 
# 6137 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
INDF1 equ 0FE7h ;# 
# 6144 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
WREG equ 0FE8h ;# 
# 6156 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR0 equ 0FE9h ;# 
# 6163 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR0L equ 0FE9h ;# 
# 6170 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
FSR0H equ 0FEAh ;# 
# 6177 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PLUSW0 equ 0FEBh ;# 
# 6184 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PREINC0 equ 0FECh ;# 
# 6191 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
POSTDEC0 equ 0FEDh ;# 
# 6198 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
POSTINC0 equ 0FEEh ;# 
# 6205 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
INDF0 equ 0FEFh ;# 
# 6212 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
INTCON3 equ 0FF0h ;# 
# 6304 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
INTCON2 equ 0FF1h ;# 
# 6374 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
INTCON equ 0FF2h ;# 
# 6491 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PROD equ 0FF3h ;# 
# 6498 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PRODL equ 0FF3h ;# 
# 6505 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PRODH equ 0FF4h ;# 
# 6512 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TABLAT equ 0FF5h ;# 
# 6521 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TBLPTR equ 0FF6h ;# 
# 6528 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TBLPTRL equ 0FF6h ;# 
# 6535 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TBLPTRH equ 0FF7h ;# 
# 6542 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TBLPTRU equ 0FF8h ;# 
# 6551 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PCLAT equ 0FF9h ;# 
# 6558 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PC equ 0FF9h ;# 
# 6565 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PCL equ 0FF9h ;# 
# 6572 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PCLATH equ 0FFAh ;# 
# 6579 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
PCLATU equ 0FFBh ;# 
# 6586 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
STKPTR equ 0FFCh ;# 
# 6692 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TOS equ 0FFDh ;# 
# 6699 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TOSL equ 0FFDh ;# 
# 6706 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TOSH equ 0FFEh ;# 
# 6713 "/Applications/microchip/xc8/v1.44/include/pic18f4620.h"
TOSU equ 0FFFh ;# 
	FNCALL	_main,_setup
	FNCALL	_setup,_gc_init
	FNCALL	_setup,_interp
	FNCALL	_setup,_interp_init
	FNCALL	_interp,___lmul
	FNCALL	_interp,__fassert
	FNCALL	_interp,_caml_write_reg
	FNCALL	_interp,_get_primitive
	FNCALL	_interp,_peek
	FNCALL	_interp,_pop
	FNCALL	_interp,_pop_n
	FNCALL	_interp,_push
	FNCALL	_interp,_read_int8
	FNCALL	_interp,_read_opcode
	FNCALL	_interp,_read_ptr_1B
	FNCALL	_interp,_read_uint8
	FNCALL	_read_uint8,_read_byte
	FNCALL	_read_ptr_1B,_read_int8
	FNCALL	_read_int8,_read_byte
	FNCALL	_read_opcode,_read_byte
	FNCALL	_push,_caml_raise_stack_overflow
	FNCALL	_caml_raise_stack_overflow,__fassert
	FNCALL	__fassert,_printf
	FNCALL	_printf,___lwdiv
	FNCALL	_printf,___lwmod
	FNCALL	_printf,_putch
	FNROOT	_main
	global	_ocaml_heap2
	global	_ocaml_heap1
	global	_acc
	global	_ocaml_stack
	global	_ocaml_heap
psect	idataCOMRAM,class=CODE,space=0,delta=1,noexec
global __pidataCOMRAM
__pidataCOMRAM:
	file	"blink.c"
	line	33

;initializer for _ocaml_heap2
		db	low(_ocaml_heap+040h)
	db	high(_ocaml_heap+040h)

	line	32

;initializer for _ocaml_heap1
		db	low(_ocaml_heap)
	db	high(_ocaml_heap)

	line	35

;initializer for _acc
	dw	(03h) & 0xffff
	dw	highword(03h)
psect	idataBANK1,class=CODE,space=0,delta=1,noexec
global __pidataBANK1
__pidataBANK1:
	line	37

;initializer for _ocaml_stack
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(01h) & 0xffff
	dw	highword(01h)
	dw	(02761h) & 0xffff
	dw	highword(02761h)
	dw	(-4194288) & 0xffff
	dw	highword(-4194288)
	line	27

;initializer for _ocaml_heap
	dw	(04F7h) & 0xffff
	dw	highword(04F7h)
	dw	(05h) & 0xffff
	dw	highword(05h)
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	db   0
	global	_ocaml_bytecode
psect	smallconst,class=SMALLCONST,space=0,reloc=2,noexec
global __psmallconst
__psmallconst:
	db	0
	file	"blink.c"
	line	75
_ocaml_bytecode:
	db	low(06h)
	db	low(011h)
	db	low(0)
	db	low(07h)
	db	low(05h)
	db	low(09h)
	db	low(04h)
	db	low(01h)
	db	low(0)
	db	low(01h)
	db	low(0Ch)
	db	low(0FFh)
	db	low(05h)
	db	low(03h)
	db	low(0Bh)
	db	low(04h)
	db	low(01h)
	db	low(08h)
	db	low(0)
	db	low(0)
	db	low(0Ah)
	db	low(08h)
	db	low(0)
	db	low(02h)
	db	low(02h)
	db	low(0Dh)
	global __end_of_ocaml_bytecode
__end_of_ocaml_bytecode:
	global	_dpowers
psect	smallconst
	file	"/Applications/microchip/xc8/v1.44/sources/common/doprnt.c"
	line	354
_dpowers:
	dw	(01h)&0ffffh
	dw	(0Ah)&0ffffh
	dw	(064h)&0ffffh
	dw	(03E8h)&0ffffh
	dw	(02710h)&0ffffh
	global __end_of_dpowers
__end_of_dpowers:
	global	_ocaml_primitives
psect	smallconst
	file	"blink.c"
	line	106
_ocaml_primitives:
		db	low(_caml_write_reg)
	db	high(_caml_write_reg)

	global __end_of_ocaml_primitives
__end_of_ocaml_primitives:
	global	_ocaml_bytecode
	global	_dpowers
	global	_ocaml_primitives
	global	_tab_heap_start
	global	_new_heap
	global	_heap_todo
	global	_current_heap
	global	_extra_args
	global	_pc
	global	_ocaml_global_data
	global	_tab_heap_end
	global	_old_heap
	global	_heap_end
psect	nvCOMRAM,class=COMRAM,space=1,noexec
global __pnvCOMRAM
__pnvCOMRAM:
	global	_heap_end
_heap_end:
       ds      3
	global	_heap_ptr
	global	_heap_ptr
_heap_ptr:
       ds      3
	global	_heap2_start
	global	_heap2_start
_heap2_start:
       ds      3
	global	_heap1_start
	global	_heap1_start
_heap1_start:
       ds      3
	global	_sp
	global	_sp
_sp:
       ds      2
	global	_env
	global	_env
_env:
       ds      4
	global	_trapSp
psect	nvBANK0,class=BANK0,space=1,noexec,lowdata
global __pnvBANK0
__pnvBANK0:
_trapSp:
       ds      4
	global	_heap2_end
	global	_heap2_end
_heap2_end:
       ds      3
	global	_heap1_end
	global	_heap1_end
_heap1_end:
       ds      3
	global	_TRISD
_TRISD	set	0xF95
	global	_LATD2
_LATD2	set	0x7C62
psect	smallconst
	
STR_1:; BSR set to: 0

	db	47
	db	85	;'U'
	db	115	;'s'
	db	101	;'e'
	db	114	;'r'
	db	115	;'s'
	db	47
	db	115	;'s'
	db	116	;'t'
	db	101	;'e'
	db	118	;'v'
	db	101	;'e'
	db	110	;'n'
	db	47
	db	103	;'g'
	db	105	;'i'
	db	116	;'t'
	db	104	;'h'
	db	117	;'u'
	db	98	;'b'
	db	47
	db	79	;'O'
	db	77	;'M'
	db	105	;'i'
	db	99	;'c'
	db	114	;'r'
	db	111	;'o'
	db	66	;'B'
	db	47
	db	115	;'s'
	db	114	;'r'
	db	99	;'c'
	db	47
	db	98	;'b'
	db	121	;'y'
	db	116	;'t'
	db	101	;'e'
	db	114	;'r'
	db	117	;'u'
	db	110	;'n'
	db	47
	db	105	;'i'
	db	110	;'n'
	db	116	;'t'
	db	101	;'e'
	db	114	;'r'
	db	112	;'p'
	db	46
	db	99	;'c'
	db	0
	
STR_8:; BSR set to: 0

	db	65	;'A'
	db	115	;'s'
	db	115	;'s'
	db	101	;'e'
	db	114	;'r'
	db	116	;'t'
	db	105	;'i'
	db	111	;'o'
	db	110	;'n'
	db	32
	db	102	;'f'
	db	97	;'a'
	db	105	;'i'
	db	108	;'l'
	db	101	;'e'
	db	100	;'d'
	db	58	;':'
	db	32
	db	37
	db	115	;'s'
	db	32
	db	108	;'l'
	db	105	;'i'
	db	110	;'n'
	db	101	;'e'
	db	32
	db	37
	db	100	;'d'
	db	58	;':'
	db	32
	db	34
	db	37
	db	115	;'s'
	db	34
	db	10
	db	0
	
STR_7:; BSR set to: 0

	db	40
	db	110	;'n'
	db	117	;'u'
	db	108	;'l'
	db	108	;'l'
	db	41
	db	0
	
STR_2:; BSR set to: 0

	db	48	;'0'
	db	0
STR_3	equ	STR_1+0
STR_5	equ	STR_1+0
STR_4	equ	STR_2+0
STR_6	equ	STR_2+0
; #config settings
	file	"blink.as"
	line	#
psect	cinit,class=CODE,delta=1,reloc=2
global __pcinit
__pcinit:
global start_initialization
start_initialization:

global __initialization
__initialization:
psect	bssCOMRAM,class=COMRAM,space=1,noexec
global __pbssCOMRAM
__pbssCOMRAM:
	global	_tab_heap_start
_tab_heap_start:
       ds      6
	global	_new_heap
_new_heap:
       ds      3
	global	_heap_todo
_heap_todo:
       ds      3
	global	_cpt
	global	_cpt
_cpt:
       ds      2
	global	_current_heap
_current_heap:
       ds      2
	global	_caml_names_of_builtin_cprim
_caml_names_of_builtin_cprim:
       ds      2
	global	_caml_builtin_cprim
_caml_builtin_cprim:
       ds      2
	global	_nativeint_custom_operations
_nativeint_custom_operations:
       ds      2
	global	_int64_custom_operations
_int64_custom_operations:
       ds      2
	global	_int32_custom_operations
_int32_custom_operations:
       ds      2
_extra_args:
       ds      1
_pc:
       ds      1
	global	_ocaml_global_data
_ocaml_global_data:
       ds      4
psect	dataCOMRAM,class=COMRAM,space=1,noexec
global __pdataCOMRAM
__pdataCOMRAM:
	file	"blink.c"
	line	33
	global	_ocaml_heap2
_ocaml_heap2:
       ds      2
psect	dataCOMRAM
	file	"blink.c"
	line	32
	global	_ocaml_heap1
_ocaml_heap1:
       ds      2
psect	dataCOMRAM
	file	"blink.c"
	line	35
	global	_acc
_acc:
       ds      4
psect	bssBANK0,class=BANK0,space=1,noexec,lowdata
global __pbssBANK0
__pbssBANK0:
	global	_tab_heap_end
_tab_heap_end:
       ds      6
	global	_atom0_header
	global	_atom0_header
_atom0_header:
       ds      4
	global	_old_heap
_old_heap:
       ds      3
psect	dataBANK1,class=BANK1,space=1,noexec,lowdata
global __pdataBANK1
__pdataBANK1:
	file	"blink.c"
	line	37
	global	_ocaml_stack
_ocaml_stack:
       ds      128
psect	dataBANK1
	file	"blink.c"
	line	27
	global	_ocaml_heap
_ocaml_heap:
       ds      128
	file	"blink.as"
	line	#
psect	cinit
; Initialize objects allocated to BANK1 (256 bytes)
	global __pidataBANK1
	; load TBLPTR registers with __pidataBANK1
	movlw	low (__pidataBANK1)
	movwf	tblptrl
	movlw	high(__pidataBANK1)
	movwf	tblptrh
	movlw	low highword(__pidataBANK1)
	movwf	tblptru
	lfsr	0,__pdataBANK1
	lfsr	1,256
	copy_data0:
	tblrd	*+
	movff	tablat, postinc0
	movf	postdec1,w
	movf	fsr1l,w
	bnz	copy_data0
	movf	fsr1h,w
	bnz	copy_data0
; Initialize objects allocated to COMRAM (8 bytes)
	global __pidataCOMRAM
	; load TBLPTR registers with __pidataCOMRAM
	movlw	low (__pidataCOMRAM)
	movwf	tblptrl
	movlw	high(__pidataCOMRAM)
	movwf	tblptrh
	movlw	low highword(__pidataCOMRAM)
	movwf	tblptru
	lfsr	0,__pdataCOMRAM
	lfsr	1,8
	copy_data1:
	tblrd	*+
	movff	tablat, postinc0
	movf	postdec1,w
	movf	fsr1l,w
	bnz	copy_data1
	line	#
; Clear objects allocated to BANK0 (13 bytes)
	global __pbssBANK0
lfsr	0,__pbssBANK0
movlw	13
clear_0:
clrf	postinc0,c
decf	wreg
bnz	clear_0
; Clear objects allocated to COMRAM (32 bytes)
	global __pbssCOMRAM
lfsr	0,__pbssCOMRAM
movlw	32
clear_1:
clrf	postinc0,c
decf	wreg
bnz	clear_1
psect cinit,class=CODE,delta=1
global end_of_initialization,__end_of__initialization

;End of C runtime variable initialization code

end_of_initialization:
__end_of__initialization:
movlb 0
goto _main	;jump to C main() function
psect	cstackCOMRAM,class=COMRAM,space=1,noexec
global __pcstackCOMRAM
__pcstackCOMRAM:
?_gc_init:	; 1 bytes @ 0x0
?_putch:	; 1 bytes @ 0x0
??_putch:	; 1 bytes @ 0x0
?_caml_raise_stack_overflow:	; 1 bytes @ 0x0
?_read_byte:	; 1 bytes @ 0x0
??_read_byte:	; 1 bytes @ 0x0
?_read_opcode:	; 1 bytes @ 0x0
?_read_uint8:	; 1 bytes @ 0x0
?_read_int8:	; 1 bytes @ 0x0
?_read_ptr_1B:	; 1 bytes @ 0x0
?_interp_init:	; 1 bytes @ 0x0
??_interp_init:	; 1 bytes @ 0x0
?_setup:	; 1 bytes @ 0x0
	global	?_get_primitive
?_get_primitive:	; 2 bytes @ 0x0
	global	?___lwdiv
?___lwdiv:	; 2 bytes @ 0x0
	global	?_peek
?_peek:	; 4 bytes @ 0x0
	global	?_pop
?_pop:	; 4 bytes @ 0x0
?_interp:	; 4 bytes @ 0x0
	global	read_byte@c
read_byte@c:	; 1 bytes @ 0x0
putch@c:	; 1 bytes @ 0x0
	global	peek@n
peek@n:	; 2 bytes @ 0x0
	global	___lwdiv@dividend
___lwdiv@dividend:	; 2 bytes @ 0x0
	global	gc_init@heap_size
gc_init@heap_size:	; 4 bytes @ 0x0
	ds   1
??_read_opcode:	; 1 bytes @ 0x1
??_read_uint8:	; 1 bytes @ 0x1
??_read_int8:	; 1 bytes @ 0x1
??_read_ptr_1B:	; 1 bytes @ 0x1
?_pop_n:	; 1 bytes @ 0x1
	global	read_ptr_1B@ofs
read_ptr_1B@ofs:	; 1 bytes @ 0x1
	global	pop_n@n
pop_n@n:	; 2 bytes @ 0x1
	ds   1
??_get_primitive:	; 1 bytes @ 0x2
	global	get_primitive@prim_ind
get_primitive@prim_ind:	; 1 bytes @ 0x2
	global	___lwdiv@divisor
___lwdiv@divisor:	; 2 bytes @ 0x2
	ds   1
??_pop_n:	; 1 bytes @ 0x3
	global	?_caml_write_reg
?_caml_write_reg:	; 4 bytes @ 0x3
	global	caml_write_reg@pin
caml_write_reg@pin:	; 4 bytes @ 0x3
	ds   1
??_gc_init:	; 1 bytes @ 0x4
??_peek:	; 1 bytes @ 0x4
??_pop:	; 1 bytes @ 0x4
??___lwdiv:	; 1 bytes @ 0x4
	global	?___lmul
?___lmul:	; 4 bytes @ 0x4
	global	___lwdiv@quotient
___lwdiv@quotient:	; 2 bytes @ 0x4
	global	___lmul@multiplier
___lmul@multiplier:	; 4 bytes @ 0x4
	ds   2
	global	___lwdiv@counter
___lwdiv@counter:	; 1 bytes @ 0x6
	ds   1
	global	?___lwmod
?___lwmod:	; 2 bytes @ 0x7
	global	___lwmod@dividend
___lwmod@dividend:	; 2 bytes @ 0x7
	global	caml_write_reg@v
caml_write_reg@v:	; 4 bytes @ 0x7
	ds   1
	global	___lmul@multiplicand
___lmul@multiplicand:	; 4 bytes @ 0x8
	ds   1
	global	___lwmod@divisor
___lwmod@divisor:	; 2 bytes @ 0x9
	ds   2
??_caml_write_reg:	; 1 bytes @ 0xB
??___lwmod:	; 1 bytes @ 0xB
	global	___lwmod@counter
___lwmod@counter:	; 1 bytes @ 0xB
	ds   1
??___lmul:	; 1 bytes @ 0xC
	global	?_printf
?_printf:	; 2 bytes @ 0xC
	global	printf@f
printf@f:	; 2 bytes @ 0xC
	global	___lmul@product
___lmul@product:	; 4 bytes @ 0xC
	ds   8
??_printf:	; 1 bytes @ 0x14
	ds   1
	global	printf@flag
printf@flag:	; 1 bytes @ 0x15
	ds   1
	global	printf@prec
printf@prec:	; 1 bytes @ 0x16
	ds   1
	global	printf@ap
printf@ap:	; 2 bytes @ 0x17
	ds   2
	global	printf@cp
printf@cp:	; 2 bytes @ 0x19
	ds   2
	global	printf@val
printf@val:	; 2 bytes @ 0x1B
	ds   2
	global	printf@c
printf@c:	; 1 bytes @ 0x1D
	ds   1
?__fassert:	; 1 bytes @ 0x1E
	global	__fassert@line
__fassert@line:	; 2 bytes @ 0x1E
	ds   2
	global	__fassert@file
__fassert@file:	; 2 bytes @ 0x20
	ds   2
	global	__fassert@exp
__fassert@exp:	; 2 bytes @ 0x22
	ds   2
??__fassert:	; 1 bytes @ 0x24
??_caml_raise_stack_overflow:	; 1 bytes @ 0x24
?_push:	; 1 bytes @ 0x24
	global	push@x
push@x:	; 4 bytes @ 0x24
	ds   4
??_push:	; 1 bytes @ 0x28
	ds   2
??_interp:	; 1 bytes @ 0x2A
	ds   16
	global	interp@arg1
interp@arg1:	; 4 bytes @ 0x3A
	ds   4
	global	interp@opcode
interp@opcode:	; 1 bytes @ 0x3E
	ds   1
	global	interp@n
interp@n:	; 1 bytes @ 0x3F
	ds   1
??_setup:	; 1 bytes @ 0x40
?_main:	; 2 bytes @ 0x40
main@argc:	; 2 bytes @ 0x40
	ds   2
main@argv:	; 3 bytes @ 0x42
	ds   3
??_main:	; 1 bytes @ 0x45
;!
;!Data Sizes:
;!    Strings     95
;!    Constant    38
;!    Data        264
;!    BSS         45
;!    Persistent  28
;!    Stack       0
;!
;!Auto Spaces:
;!    Space          Size  Autos    Used
;!    COMRAM          127     69     127
;!    BANK0           128      0      23
;!    BANK1           256      0     256
;!    BANK2           256      0       0
;!    BANK3           256      0       0
;!    BANK4           256      0       0
;!    BANK5           256      0       0
;!    BANK6           256      0       0
;!    BANK7           256      0       0
;!    BANK8           256      0       0
;!    BANK9           256      0       0
;!    BANK10          256      0       0
;!    BANK11          256      0       0
;!    BANK12          256      0       0
;!    BANK13          256      0       0
;!    BANK14          256      0       0
;!    BANK15          128      0       0

;!
;!Pointer List with Targets:
;!
;!    caml_names_of_builtin_cprim	PTR void  size(2) Largest target is 0
;!		 -> NULL(NULL[0]), 
;!
;!    caml_builtin_cprim	PTR void  size(2) Largest target is 0
;!		 -> NULL(NULL[0]), 
;!
;!    nativeint_custom_operations	PTR void  size(2) Largest target is 0
;!		 -> NULL(NULL[0]), 
;!
;!    int64_custom_operations	PTR void  size(2) Largest target is 0
;!		 -> NULL(NULL[0]), 
;!
;!    int32_custom_operations	PTR void  size(2) Largest target is 0
;!		 -> NULL(NULL[0]), 
;!
;!    _fassert@exp	PTR const unsigned char  size(2) Largest target is 2
;!		 -> STR_6(CODE[2]), STR_4(CODE[2]), STR_2(CODE[2]), 
;!
;!    _fassert@file	PTR const unsigned char  size(2) Largest target is 50
;!		 -> STR_5(CODE[50]), STR_3(CODE[50]), STR_1(CODE[50]), 
;!
;!    printf@f	PTR const unsigned char  size(2) Largest target is 36
;!		 -> STR_8(CODE[36]), 
;!
;!    printf@cp	PTR const unsigned char  size(2) Largest target is 50
;!		 -> STR_7(CODE[7]), STR_6(CODE[2]), STR_5(CODE[50]), STR_4(CODE[2]), 
;!		 -> STR_3(CODE[50]), STR_2(CODE[2]), STR_1(CODE[50]), 
;!
;!    printf@ap	PTR void [1] size(2) Largest target is 2
;!		 -> ?_printf(COMRAM[2]), 
;!
;!    heap_todo	PTR long  size(3) Largest target is 65535
;!		 -> NULL(NULL[0]), ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    new_heap	PTR long  size(3) Largest target is 65535
;!		 -> NULL(NULL[0]), ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    old_heap	PTR long  size(3) Largest target is 65535
;!		 -> NULL(NULL[0]), ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    heap_end	PTR long  size(3) Largest target is 65535
;!		 -> NULL(NULL[0]), ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    heap_ptr	PTR long  size(3) Largest target is 65535
;!		 -> NULL(NULL[0]), ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    heap2_end	PTR const long  size(3) Largest target is 65535
;!		 -> ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    heap2_start	PTR const long  size(3) Largest target is 65535
;!		 -> ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    tab_heap_end	PTR long [2] size(3) Largest target is 65535
;!		 -> ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    tab_heap_start	PTR long [2] size(3) Largest target is 65535
;!		 -> ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    heap1_end	PTR const long  size(3) Largest target is 65535
;!		 -> ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    heap1_start	PTR const long  size(3) Largest target is 65535
;!		 -> ROM(CODE[65535]), ocaml_heap(BANK1[128]), 
;!
;!    sp	PTR long  size(2) Largest target is 128
;!		 -> NULL(NULL[0]), ocaml_stack(BANK1[128]), 
;!
;!    sp__get_primitive	PTR void  size(2) Largest target is 4
;!		 -> caml_write_reg(), 
;!
;!    ocaml_primitives	const PTR void [1] size(2) Largest target is 4
;!
;!    ocaml_heap2	PTR const long  size(2) Largest target is 128
;!		 -> ocaml_heap(BANK1[128]), 
;!
;!    ocaml_heap1	PTR const long  size(2) Largest target is 128
;!		 -> ocaml_heap(BANK1[128]), 
;!


;!
;!Critical Paths under _main in COMRAM
;!
;!    _setup->_interp
;!    _interp->_push
;!    _read_uint8->_read_byte
;!    _read_int8->_read_byte
;!    _read_opcode->_read_byte
;!    _caml_raise_stack_overflow->__fassert
;!    __fassert->_printf
;!    _printf->___lwmod
;!    ___lwmod->___lwdiv
;!    _caml_write_reg->_get_primitive
;!    ___lmul->_pop
;!
;!Critical Paths under _main in BANK0
;!
;!    None.
;!
;!Critical Paths under _main in BANK1
;!
;!    None.
;!
;!Critical Paths under _main in BANK2
;!
;!    None.
;!
;!Critical Paths under _main in BANK3
;!
;!    None.
;!
;!Critical Paths under _main in BANK4
;!
;!    None.
;!
;!Critical Paths under _main in BANK5
;!
;!    None.
;!
;!Critical Paths under _main in BANK6
;!
;!    None.
;!
;!Critical Paths under _main in BANK7
;!
;!    None.
;!
;!Critical Paths under _main in BANK8
;!
;!    None.
;!
;!Critical Paths under _main in BANK9
;!
;!    None.
;!
;!Critical Paths under _main in BANK10
;!
;!    None.
;!
;!Critical Paths under _main in BANK11
;!
;!    None.
;!
;!Critical Paths under _main in BANK12
;!
;!    None.
;!
;!Critical Paths under _main in BANK13
;!
;!    None.
;!
;!Critical Paths under _main in BANK14
;!
;!    None.
;!
;!Critical Paths under _main in BANK15
;!
;!    None.

;;
;;Main: autosize = 0, tempsize = 0, incstack = 0, save=0
;;

;!
;!Call Graph Tables:
;!
;! ---------------------------------------------------------------------------------
;! (Depth) Function   	        Calls       Base Space   Used Autos Params    Refs
;! ---------------------------------------------------------------------------------
;! (0) _main                                                 5     0      5    5584
;!                                             64 COMRAM     5     0      5
;!                              _setup
;! ---------------------------------------------------------------------------------
;! (1) _setup                                                0     0      0    5584
;!                            _gc_init
;!                             _interp
;!                        _interp_init
;! ---------------------------------------------------------------------------------
;! (2) _interp_init                                          0     0      0       0
;! ---------------------------------------------------------------------------------
;! (2) _interp                                              22    22      0    5442
;!                                             42 COMRAM    22    22      0
;!                             ___lmul
;!                           __fassert
;!                     _caml_write_reg *
;!                      _get_primitive
;!                               _peek
;!                                _pop
;!                              _pop_n
;!                               _push
;!                          _read_int8
;!                        _read_opcode
;!                        _read_ptr_1B
;!                         _read_uint8
;! ---------------------------------------------------------------------------------
;! (3) _read_uint8                                           0     0      0      23
;!                          _read_byte
;! ---------------------------------------------------------------------------------
;! (3) _read_ptr_1B                                          1     1      0      46
;!                                              1 COMRAM     1     1      0
;!                          _read_int8
;! ---------------------------------------------------------------------------------
;! (4) _read_int8                                            0     0      0      23
;!                          _read_byte
;! ---------------------------------------------------------------------------------
;! (3) _read_opcode                                          0     0      0      23
;!                          _read_byte
;! ---------------------------------------------------------------------------------
;! (4) _read_byte                                            1     1      0      23
;!                                              0 COMRAM     1     1      0
;! ---------------------------------------------------------------------------------
;! (3) _push                                                 6     2      4    2483
;!                                             36 COMRAM     6     2      4
;!          _caml_raise_stack_overflow
;! ---------------------------------------------------------------------------------
;! (4) _caml_raise_stack_overflow                            0     0      0    1929
;!                           __fassert
;! ---------------------------------------------------------------------------------
;! (5) __fassert                                             6     0      6    1929
;!                                             30 COMRAM     6     0      6
;!                             _printf
;! ---------------------------------------------------------------------------------
;! (6) _printf                                              24    16      8    1179
;!                                             12 COMRAM    18    10      8
;!                            ___lwdiv
;!                            ___lwmod
;!                              _putch
;! ---------------------------------------------------------------------------------
;! (7) _putch                                                1     1      0       0
;! ---------------------------------------------------------------------------------
;! (7) ___lwmod                                              5     1      4     311
;!                                              7 COMRAM     5     1      4
;!                            ___lwdiv (ARG)
;! ---------------------------------------------------------------------------------
;! (7) ___lwdiv                                              7     3      4     314
;!                                              0 COMRAM     7     3      4
;! ---------------------------------------------------------------------------------
;! (3) _pop_n                                                4     2      2     174
;!                                              1 COMRAM     4     2      2
;!                         _read_uint8 (ARG)
;! ---------------------------------------------------------------------------------
;! (3) _pop                                                  4     0      4       0
;!                                              0 COMRAM     4     0      4
;! ---------------------------------------------------------------------------------
;! (3) _peek                                                 4     0      4     174
;!                                              0 COMRAM     4     0      4
;! ---------------------------------------------------------------------------------
;! (3) _get_primitive                                        3     1      2      22
;!                                              0 COMRAM     3     1      2
;! ---------------------------------------------------------------------------------
;! (3) _caml_write_reg                                       8     0      8     106
;!                                              3 COMRAM     8     0      8
;!                      _get_primitive (ARG)
;!                         _read_uint8 (ARG)
;! ---------------------------------------------------------------------------------
;! (3) ___lmul                                              12     4      8     370
;!                                              4 COMRAM    12     4      8
;!                                _pop (ARG)
;! ---------------------------------------------------------------------------------
;! (2) _gc_init                                              6     2      4     142
;!                                              0 COMRAM     6     2      4
;! ---------------------------------------------------------------------------------
;! Estimated maximum stack depth 7
;! ---------------------------------------------------------------------------------
;!
;! Call Graph Graphs:
;!
;! _main (ROOT)
;!   _setup
;!     _gc_init
;!     _interp
;!       ___lmul
;!         _pop (ARG)
;!       __fassert
;!         _printf
;!           ___lwdiv
;!           ___lwmod
;!             ___lwdiv (ARG)
;!           _putch
;!       _caml_write_reg *
;!         _get_primitive (ARG)
;!         _read_uint8 (ARG)
;!           _read_byte
;!       _get_primitive *
;!       _peek *
;!       _pop *
;!       _pop_n *
;!         _read_uint8 (ARG)
;!           _read_byte
;!       _push *
;!         _caml_raise_stack_overflow
;!           __fassert
;!             _printf
;!               ___lwdiv
;!               ___lwmod
;!                 ___lwdiv (ARG)
;!               _putch
;!       _read_int8 *
;!         _read_byte
;!       _read_opcode *
;!         _read_byte
;!       _read_ptr_1B *
;!         _read_int8
;!           _read_byte
;!       _read_uint8 *
;!         _read_byte
;!     _interp_init
;!

;! Address spaces:

;!Name               Size   Autos  Total    Cost      Usage
;!BIGRAM             F7F      0       0      37        0.0%
;!EEDATA             400      0       0       0        0.0%
;!BITBANK14          100      0       0      32        0.0%
;!BANK14             100      0       0      33        0.0%
;!BITBANK13          100      0       0      30        0.0%
;!BANK13             100      0       0      31        0.0%
;!BITBANK12          100      0       0      28        0.0%
;!BANK12             100      0       0      29        0.0%
;!BITBANK11          100      0       0      26        0.0%
;!BANK11             100      0       0      27        0.0%
;!BITBANK10          100      0       0      24        0.0%
;!BANK10             100      0       0      25        0.0%
;!BITBANK9           100      0       0      22        0.0%
;!BANK9              100      0       0      23        0.0%
;!BITBANK8           100      0       0      20        0.0%
;!BANK8              100      0       0      21        0.0%
;!BITBANK7           100      0       0      18        0.0%
;!BANK7              100      0       0      19        0.0%
;!BITBANK6           100      0       0      16        0.0%
;!BANK6              100      0       0      17        0.0%
;!BITBANK5           100      0       0      14        0.0%
;!BANK5              100      0       0      15        0.0%
;!BITBANK4           100      0       0      12        0.0%
;!BANK4              100      0       0      13        0.0%
;!BITBANK3           100      0       0      10        0.0%
;!BANK3              100      0       0      11        0.0%
;!BITBANK2           100      0       0       8        0.0%
;!BANK2              100      0       0       9        0.0%
;!BITBANK1           100      0       0       6        0.0%
;!BANK1              100      0     100       7      100.0%
;!BITBANK15           80      0       0      35        0.0%
;!BANK15              80      0       0      36        0.0%
;!BITBANK0            80      0       0       4        0.0%
;!BANK0               80      0      17       5       18.0%
;!BITCOMRAM           7F      0       0       0        0.0%
;!COMRAM              7F     45      7F       1      100.0%
;!BITSFR               0      0       0     200        0.0%
;!SFR                  0      0       0     200        0.0%
;!STACK                0      0       0       2        0.0%
;!NULL                 0      0       0       0        0.0%
;!ABS                  0      0     196      34        0.0%
;!DATA                 0      0     196       3        0.0%
;!CODE                 0      0       0       0        0.0%

	global	_main

;; *************** function _main *****************
;; Defined at:
;;		line 2023 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;  argc            2   64[COMRAM] int 
;;  argv            3   66[COMRAM] PTR PTR unsigned char 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  2   64[COMRAM] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, pclath, tosl, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         5       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         5       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels required when called:    7
;; This function calls:
;;		_setup
;; This function is called by:
;;		Startup code after reset
;; This function uses a non-reentrant model
;;
psect	text0,class=CODE,space=0,reloc=2,group=0
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	2023
global __ptext0
__ptext0:
psect	text0
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	2023
	global	__size_of_main
	__size_of_main	equ	__end_of_main-_main
	
_main:
;incstack = 0
	opt	stack 24
	line	2024
	
l1523:
	call	_setup	;wreg free
	goto	l148
	line	2026
	
l1525:
	line	2027
;	Return value of _main is never used
	
l148:
	global	start
	goto	start
	opt stack 0
GLOBAL	__end_of_main
	__end_of_main:
	signat	_main,8314
	global	_setup

;; *************** function _setup *****************
;; Defined at:
;;		line 2001 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, pclath, tosl, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    6
;; This function calls:
;;		_gc_init
;;		_interp
;;		_interp_init
;; This function is called by:
;;		_main
;; This function uses a non-reentrant model
;;
psect	text1,class=CODE,space=0,reloc=2,group=0
	line	2001
global __ptext1
__ptext1:
psect	text1
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	2001
	global	__size_of_setup
	__size_of_setup	equ	__end_of_setup-_setup
	
_setup:
;incstack = 0
	opt	stack 24
	line	2010
	
l1509:
	call	_interp_init	;wreg free
	line	2011
	movlw	low(010h)
	movwf	((c:gc_init@heap_size)),c
	movlw	high(010h)
	movwf	((c:gc_init@heap_size+1)),c
	movlw	low highword(010h)
	movwf	((c:gc_init@heap_size+2)),c
	movlw	high highword(010h)
	movwf	((c:gc_init@heap_size+3)),c
	call	_gc_init	;wreg free
	line	2012
	
l1511:
	call	_interp	;wreg free
	line	2013
	
l140:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_setup
	__end_of_setup:
	signat	_setup,89
	global	_interp_init

;; *************** function _interp_init *****************
;; Defined at:
;;		line 164 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_setup
;; This function uses a non-reentrant model
;;
psect	text2,class=CODE,space=0,reloc=2,group=0
	line	164
global __ptext2
__ptext2:
psect	text2
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	164
	global	__size_of_interp_init
	__size_of_interp_init	equ	__end_of_interp_init-_interp_init
	
_interp_init:
;incstack = 0
	opt	stack 29
	line	165
	
l1417:
		movlw	low(_ocaml_stack+074h)
	movwf	((c:_sp)),c
	movlw	high(_ocaml_stack+074h)
	movwf	((c:_sp+1)),c

	line	166
	
l1419:
	movlw	low(01h)
	movlb	0	; () banked
	movwf	((_trapSp))&0ffh
	movlw	high(01h)
	movwf	((_trapSp+1))&0ffh
	movlw	low highword(01h)
	movwf	((_trapSp+2))&0ffh
	movlw	high highword(01h)
	movwf	((_trapSp+3))&0ffh
	line	167
	
l1421:; BSR set to: 0

	movlw	low(01h)
	movwf	((c:_env)),c
	movlw	high(01h)
	movwf	((c:_env+1)),c
	movlw	low highword(01h)
	movwf	((c:_env+2)),c
	movlw	high highword(01h)
	movwf	((c:_env+3)),c
	line	168
	
l1423:; BSR set to: 0

	movlw	low(0)
	movwf	((c:_extra_args)),c
	line	169
	
l1425:; BSR set to: 0

	movlw	low(0)
	movwf	((c:_pc)),c
	line	170
	
l109:; BSR set to: 0

	return	;funcret
	opt stack 0
GLOBAL	__end_of_interp_init
	__end_of_interp_init:
	signat	_interp_init,89
	global	_interp

;; *************** function _interp *****************
;; Defined at:
;;		line 174 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  n               1   63[COMRAM] unsigned char 
;;  arg1            4   58[COMRAM] long 
;;  opcode          1   62[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  4  111[None  ] long 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, pclath, tosl, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         6       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:         16       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:        22       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:       22 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    5
;; This function calls:
;;		___lmul
;;		__fassert
;;		_caml_write_reg
;;		_get_primitive
;;		_peek
;;		_pop
;;		_pop_n
;;		_push
;;		_read_int8
;;		_read_opcode
;;		_read_ptr_1B
;;		_read_uint8
;; This function is called by:
;;		_setup
;; This function uses a non-reentrant model
;;
psect	text3,class=CODE,space=0,reloc=2,group=0
	line	174
global __ptext3
__ptext3:
psect	text3
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	174
	global	__size_of_interp
	__size_of_interp	equ	__end_of_interp-_interp
	
_interp:; BSR set to: 0

;incstack = 0
	opt	stack 24
	line	176
	
l112:
	line	183
	
l1427:
	call	_read_opcode	;wreg free
	movwf	((c:interp@opcode)),c
	line	207
	goto	l1495
	line	210
	
l114:
	line	211
	
l1429:
	movlw	high(0)
	movwf	((c:peek@n+1)),c
	movlw	low(0)
	movwf	((c:peek@n)),c
	call	_peek	;wreg free
	movff	0+?_peek,(c:_acc)
	movff	1+?_peek,(c:_acc+1)
	movff	2+?_peek,(c:_acc+2)
	movff	3+?_peek,(c:_acc+3)
	
	line	212
	goto	l112
	line	280
	
l116:
	line	281
	
l1431:
	movff	(c:_acc),(c:push@x)
	movff	(c:_acc+1),(c:push@x+1)
	movff	(c:_acc+2),(c:push@x+2)
	movff	(c:_acc+3),(c:push@x+3)
	call	_push	;wreg free
	line	282
	
l1433:
	movlw	high(01h)
	movwf	((c:peek@n+1)),c
	movlw	low(01h)
	movwf	((c:peek@n)),c
	call	_peek	;wreg free
	movff	0+?_peek,(c:_acc)
	movff	1+?_peek,(c:_acc+1)
	movff	2+?_peek,(c:_acc+2)
	movff	3+?_peek,(c:_acc+3)
	
	line	283
	goto	l112
	line	344
	
l117:
	line	345
	
l1435:
	call	_read_uint8	;wreg free
	movwf	(??_interp+0+0)&0ffh,c
	movf	((??_interp+0+0)),c,w
	movwf	((c:pop_n@n)),c
	clrf	((c:pop_n@n+1)),c
	call	_pop_n	;wreg free
	line	346
	goto	l112
	line	471
	
l118:
	line	472
	
l1437:
	call	_pop	;wreg free
	movff	0+?_pop,(c:interp@arg1)
	movff	1+?_pop,(c:interp@arg1+1)
	movff	2+?_pop,(c:interp@arg1+2)
	movff	3+?_pop,(c:interp@arg1+3)
	
	line	473
	
l1439:
	movff	(c:_extra_args),??_interp+0+0
	clrf	(??_interp+0+0+1)&0ffh,c
	clrf	(??_interp+0+0+2)&0ffh,c
	clrf	(??_interp+0+0+3)&0ffh,c
	bcf	status,0
	rlcf	(??_interp+0+0),c,w
	movwf	(??_interp+4+0)&0ffh,c
	rlcf	(??_interp+0+1),c,w
	movwf	1+(??_interp+4+0)&0ffh,c
	
	rlcf	(??_interp+0+2),c,w
	movwf	2+(??_interp+4+0)&0ffh,c
	
	rlcf	(??_interp+0+3),c,w
	movwf	3+(??_interp+4+0)&0ffh,c
	movlw	01h
	addwf	(??_interp+4+0),c,w
	movwf	((c:push@x)),c
	movlw	0
	addwfc	(??_interp+4+1),c,w
	movwf	1+((c:push@x)),c
	
	movlw	0
	addwfc	(??_interp+4+2),c,w
	movwf	2+((c:push@x)),c
	
	movlw	0
	addwfc	(??_interp+4+3),c,w
	movwf	3+((c:push@x)),c
	call	_push	;wreg free
	line	474
	
l1441:
	movff	(c:_env),(c:push@x)
	movff	(c:_env+1),(c:push@x+1)
	movff	(c:_env+2),(c:push@x+2)
	movff	(c:_env+3),(c:push@x+3)
	call	_push	;wreg free
	line	475
	
l1443:
	movff	(c:_pc),??_interp+0+0
	clrf	(??_interp+0+0+1)&0ffh,c
	clrf	(??_interp+0+0+2)&0ffh,c
	clrf	(??_interp+0+0+3)&0ffh,c
	bcf	status,0
	rlcf	(??_interp+0+0),c,w
	movwf	(??_interp+4+0)&0ffh,c
	rlcf	(??_interp+0+1),c,w
	movwf	1+(??_interp+4+0)&0ffh,c
	
	rlcf	(??_interp+0+2),c,w
	movwf	2+(??_interp+4+0)&0ffh,c
	
	rlcf	(??_interp+0+3),c,w
	movwf	3+(??_interp+4+0)&0ffh,c
	movlw	01h
	addwf	(??_interp+4+0),c,w
	movwf	((c:push@x)),c
	movlw	0
	addwfc	(??_interp+4+1),c,w
	movwf	1+((c:push@x)),c
	
	movlw	0
	addwfc	(??_interp+4+2),c,w
	movwf	2+((c:push@x)),c
	
	movlw	0
	addwfc	(??_interp+4+3),c,w
	movwf	3+((c:push@x)),c
	call	_push	;wreg free
	line	476
	
l1445:
	movff	(c:interp@arg1),(c:push@x)
	movff	(c:interp@arg1+1),(c:push@x+1)
	movff	(c:interp@arg1+2),(c:push@x+2)
	movff	(c:interp@arg1+3),(c:push@x+3)
	call	_push	;wreg free
	line	480
	
l1447:
	movlw	low(03FFh)
	movwf	(??_interp+0+0)&0ffh,c
	movlw	high(03FFh)
	movwf	1+(??_interp+0+0)&0ffh,c
	movff	(c:_acc),??_interp+2+0
	movff	(c:_acc+1),??_interp+2+0+1
	movf	(??_interp+0+0),c,w
	xorwf	(??_interp+2+0),c
	movf	(??_interp+0+1),c,w
	xorwf	(??_interp+2+1),c
	rlcf	(??_interp+2+1),c,w
	rrcf	(??_interp+2+1),c
	rrcf	(??_interp+2+0),c
	rlcf	(??_interp+2+1),c,w
	rrcf	(??_interp+2+1),c
	rrcf	(??_interp+2+0),c
	movlw	low(_ocaml_heap)
	addwf	(??_interp+2+0),c,w
	movwf	c:fsr2l
	movlw	high(_ocaml_heap)
	addwfc	(??_interp+2+1),c,w
	movwf	1+c:fsr2l
	movff	postinc2,??_interp+4+0
	movff	postinc2,??_interp+4+0+1
	movff	postinc2,??_interp+4+0+2
	movff	postinc2,??_interp+4+0+3
	rlcf	(??_interp+4+3),c,w
	rrcf	(??_interp+4+3),c
	rrcf	(??_interp+4+2),c
	rrcf	(??_interp+4+1),c
	rrcf	(??_interp+4+0),c
	movf	(??_interp+4+0),c,w
	movwf	((c:_pc)),c
	line	481
	
l1449:
	movff	(c:_acc),(c:_env)
	movff	(c:_acc+1),(c:_env+1)
	movff	(c:_acc+2),(c:_env+2)
	movff	(c:_acc+3),(c:_env+3)
	line	482
	
l1451:
	movlw	low(0)
	movwf	((c:_extra_args)),c
	line	483
	goto	l112
	line	579
	
l119:
	line	580
	
l1453:
	call	_read_uint8	;wreg free
	movwf	((c:interp@n)),c
	line	581
	
l1455:
	movff	(c:interp@n),(c:pop_n@n)
	clrf	((c:pop_n@n+1)),c
	call	_pop_n	;wreg free
	line	582
	
l1457:
	movf	((c:_extra_args)),c,w
	btfsc	status,2
	goto	u491
	goto	u490
u491:
	goto	l1465
u490:
	line	583
	
l1459:
	decf	((c:_extra_args)),c
	line	584
	
l1461:
	movlw	low(03FFh)
	movwf	(??_interp+0+0)&0ffh,c
	movlw	high(03FFh)
	movwf	1+(??_interp+0+0)&0ffh,c
	movff	(c:_acc),??_interp+2+0
	movff	(c:_acc+1),??_interp+2+0+1
	movf	(??_interp+0+0),c,w
	xorwf	(??_interp+2+0),c
	movf	(??_interp+0+1),c,w
	xorwf	(??_interp+2+1),c
	rlcf	(??_interp+2+1),c,w
	rrcf	(??_interp+2+1),c
	rrcf	(??_interp+2+0),c
	rlcf	(??_interp+2+1),c,w
	rrcf	(??_interp+2+1),c
	rrcf	(??_interp+2+0),c
	movlw	low(_ocaml_heap)
	addwf	(??_interp+2+0),c,w
	movwf	c:fsr2l
	movlw	high(_ocaml_heap)
	addwfc	(??_interp+2+1),c,w
	movwf	1+c:fsr2l
	movff	postinc2,??_interp+4+0
	movff	postinc2,??_interp+4+0+1
	movff	postinc2,??_interp+4+0+2
	movff	postinc2,??_interp+4+0+3
	rlcf	(??_interp+4+3),c,w
	rrcf	(??_interp+4+3),c
	rrcf	(??_interp+4+2),c
	rrcf	(??_interp+4+1),c
	rrcf	(??_interp+4+0),c
	movf	(??_interp+4+0),c,w
	movwf	((c:_pc)),c
	line	585
	
l1463:
	movff	(c:_acc),(c:_env)
	movff	(c:_acc+1),(c:_env+1)
	movff	(c:_acc+2),(c:_env+2)
	movff	(c:_acc+3),(c:_env+3)
	line	586
	goto	l112
	
l120:
	line	587
	
l1465:
	call	_pop	;wreg free
	rlcf	(3+?_pop),c,w
	rrcf	(3+?_pop),c
	rrcf	(2+?_pop),c
	rrcf	(1+?_pop),c
	rrcf	(0+?_pop),c
	movf	(0+?_pop),c,w
	movwf	((c:_pc)),c
	line	588
	call	_pop	;wreg free
	movff	0+?_pop,(c:_env)
	movff	1+?_pop,(c:_env+1)
	movff	2+?_pop,(c:_env+2)
	movff	3+?_pop,(c:_env+3)
	
	line	589
	call	_pop	;wreg free
	rlcf	(3+?_pop),c,w
	rrcf	(3+?_pop),c
	rrcf	(2+?_pop),c
	rrcf	(1+?_pop),c
	rrcf	(0+?_pop),c
	movf	(0+?_pop),c,w
	movwf	((c:_extra_args)),c
	goto	l112
	line	590
	
l121:
	line	591
	goto	l112
	line	771
	
l122:
	line	772
	
l1467:
	movff	(c:_acc),(c:push@x)
	movff	(c:_acc+1),(c:push@x+1)
	movff	(c:_acc+2),(c:push@x+2)
	movff	(c:_acc+3),(c:push@x+3)
	call	_push	;wreg free
	line	783
	
l1469:
	movff	(c:_env),(c:_acc)
	movff	(c:_env+1),(c:_acc+1)
	movff	(c:_env+2),(c:_acc+2)
	movff	(c:_env+3),(c:_acc+3)
	line	784
	goto	l112
	line	1114
	
l123:
	line	1115
	
l1471:
	call	_read_ptr_1B	;wreg free
	movwf	((c:_pc)),c
	line	1116
	goto	l112
	line	1135
	
l124:
	line	1136
	
l1473:
		decf	((c:_acc)),c,w
iorwf	((c:_acc+1)),c,w
iorwf	((c:_acc+2)),c,w
iorwf	((c:_acc+3)),c,w
	btfsc	status,2
	goto	u501
	goto	u500

u501:
	goto	l1477
u500:
	line	1137
	
l1475:
	call	_read_ptr_1B	;wreg free
	movwf	((c:_pc)),c
	line	1138
	goto	l112
	
l125:
	line	1139
	
l1477:
	incf	((c:_pc)),c
	goto	l112
	line	1140
	
l126:
	line	1141
	goto	l112
	line	1329
	
l127:
	line	1330
	
l1479:
	movff	(c:_acc),(c:caml_write_reg@pin)
	movff	(c:_acc+1),(c:caml_write_reg@pin+1)
	movff	(c:_acc+2),(c:caml_write_reg@pin+2)
	movff	(c:_acc+3),(c:caml_write_reg@pin+3)
	movff	(c:_sp),fsr2l
	movff	(c:_sp+1),fsr2h
	movff	postinc2,(c:caml_write_reg@v)
	movff	postinc2,(c:caml_write_reg@v+1)
	movff	postinc2,(c:caml_write_reg@v+2)
	movff	postinc2,(c:caml_write_reg@v+3)
	call	_read_uint8	;wreg free
	
	call	_get_primitive
	call	u518
	goto	u519
u518:
	push
	movwf	pclath
	movf	(0+?_get_primitive),c,w
	movwf	tosl
	movf	(1+?_get_primitive),c,w
	movwf	tosl+1
	clrf	tosl+2
	movf	pclath,w
	
	return	;indir
	u519:
	movff	0+?_caml_write_reg,(c:_acc)
	movff	1+?_caml_write_reg,(c:_acc+1)
	movff	2+?_caml_write_reg,(c:_acc+2)
	movff	3+?_caml_write_reg,(c:_acc+3)
	
	line	1331
	
l1481:
	call	_pop	;wreg free
	line	1332
	goto	l112
	line	1385
	
l128:
	line	1386
	
l1483:
	movlw	low(03h)
	movwf	((c:_acc)),c
	movlw	high(03h)
	movwf	((c:_acc+1)),c
	movlw	low highword(03h)
	movwf	((c:_acc+2)),c
	movlw	high highword(03h)
	movwf	((c:_acc+3)),c
	line	1387
	goto	l112
	line	1427
	
l129:
	line	1428
	
l1485:
	movff	(c:_acc),(c:push@x)
	movff	(c:_acc+1),(c:push@x+1)
	movff	(c:_acc+2),(c:push@x+2)
	movff	(c:_acc+3),(c:push@x+3)
	call	_push	;wreg free
	line	1429
	
l1487:
	movlw	low(01h)
	movwf	((c:_acc)),c
	movlw	high(01h)
	movwf	((c:_acc+1)),c
	movlw	low highword(01h)
	movwf	((c:_acc+2)),c
	movlw	high highword(01h)
	movwf	((c:_acc+3)),c
	line	1430
	goto	l112
	line	1504
	
l130:
	line	1505
	
l1489:
	movff	(c:_acc),??_interp+0+0
	movff	(c:_acc+1),??_interp+0+0+1
	movff	(c:_acc+2),??_interp+0+0+2
	movff	(c:_acc+3),??_interp+0+0+3
	rlcf	(??_interp+0+3),c,w
	rrcf	(??_interp+0+3),c
	rrcf	(??_interp+0+2),c
	rrcf	(??_interp+0+1),c
	rrcf	(??_interp+0+0),c
	movff	??_interp+0+0,(c:___lmul@multiplier)
	movff	??_interp+0+1,(c:___lmul@multiplier+1)
	movff	??_interp+0+2,(c:___lmul@multiplier+2)
	movff	??_interp+0+3,(c:___lmul@multiplier+3)
	call	_pop	;wreg free
	rlcf	(3+?_pop),c,w
	rrcf	(3+?_pop),c
	rrcf	(2+?_pop),c
	rrcf	(1+?_pop),c
	rrcf	(0+?_pop),c
	movff	0+?_pop,(c:___lmul@multiplicand)
	movff	1+?_pop,(c:___lmul@multiplicand+1)
	movff	2+?_pop,(c:___lmul@multiplicand+2)
	movff	3+?_pop,(c:___lmul@multiplicand+3)
	call	___lmul	;wreg free
	bcf	status,0
	rlcf	(0+?___lmul),c,w
	movwf	(??_interp+4+0)&0ffh,c
	rlcf	(1+?___lmul),c,w
	movwf	1+(??_interp+4+0)&0ffh,c
	
	rlcf	(2+?___lmul),c,w
	movwf	2+(??_interp+4+0)&0ffh,c
	
	rlcf	(3+?___lmul),c,w
	movwf	3+(??_interp+4+0)&0ffh,c
	movlw	01h
	addwf	(??_interp+4+0),c,w
	movwf	((c:_acc)),c
	movlw	0
	addwfc	(??_interp+4+1),c,w
	movwf	1+((c:_acc)),c
	
	movlw	0
	addwfc	(??_interp+4+2),c,w
	movwf	2+((c:_acc)),c
	
	movlw	0
	addwfc	(??_interp+4+3),c,w
	movwf	3+((c:_acc)),c
	line	1506
	goto	l112
	line	1632
	
l131:
	line	1633
	
l1491:
	call	_read_int8	;wreg free
	movwf	(??_interp+0+0)&0ffh,c
	movlw	0
	btfsc	(??_interp+0+0)&0ffh,c,7
	movlw	255
	movwf	(??_interp+0+0+1)&0ffh,c
	movwf	(??_interp+0+0+2)&0ffh,c
	movwf	(??_interp+0+0+3)&0ffh,c
	movff	(c:_acc),??_interp+4+0
	movff	(c:_acc+1),??_interp+4+0+1
	movff	(c:_acc+2),??_interp+4+0+2
	movff	(c:_acc+3),??_interp+4+0+3
	rlcf	(??_interp+4+3),c,w
	rrcf	(??_interp+4+3),c
	rrcf	(??_interp+4+2),c
	rrcf	(??_interp+4+1),c
	rrcf	(??_interp+4+0),c
	movf	(??_interp+0+0),c,w
	addwf	(??_interp+4+0),c,w
	movwf	(??_interp+8+0)&0ffh,c
	movf	(??_interp+0+1),c,w
	addwfc	(??_interp+4+1),c,w
	movwf	1+(??_interp+8+0)&0ffh,c
	
	movf	(??_interp+0+2),c,w
	addwfc	(??_interp+4+2),c,w
	movwf	2+(??_interp+8+0)&0ffh,c
	
	movf	(??_interp+0+3),c,w
	addwfc	(??_interp+4+3),c,w
	movwf	3+(??_interp+8+0)&0ffh,c
	bcf	status,0
	rlcf	(??_interp+8+0),c,w
	movwf	(??_interp+12+0)&0ffh,c
	rlcf	(??_interp+8+1),c,w
	movwf	1+(??_interp+12+0)&0ffh,c
	
	rlcf	(??_interp+8+2),c,w
	movwf	2+(??_interp+12+0)&0ffh,c
	
	rlcf	(??_interp+8+3),c,w
	movwf	3+(??_interp+12+0)&0ffh,c
	movlw	01h
	addwf	(??_interp+12+0),c,w
	movwf	((c:_acc)),c
	movlw	0
	addwfc	(??_interp+12+1),c,w
	movwf	1+((c:_acc)),c
	
	movlw	0
	addwfc	(??_interp+12+2),c,w
	movwf	2+((c:_acc)),c
	
	movlw	0
	addwfc	(??_interp+12+3),c,w
	movwf	3+((c:_acc)),c
	line	1634
	goto	l112
	line	1983
	
l132:
	line	1984
;	Return value of _interp is never used
	goto	l133
	line	1988
	
l134:
	line	1992
	
l1493:
	movlw	high(07C8h)
	movwf	((c:__fassert@line+1)),c
	movlw	low(07C8h)
	movwf	((c:__fassert@line)),c
		movlw	low(STR_5)
	movwf	((c:__fassert@file)),c
	movlw	high(STR_5)
	movwf	((c:__fassert@file+1)),c

		movlw	low(STR_6)
	movwf	((c:__fassert@exp)),c
	movlw	high(STR_6)
	movwf	((c:__fassert@exp+1)),c

	call	__fassert	;wreg free
	goto	l112
	
l135:
	line	1994
	goto	l112
	line	207
	
l113:
	
l1495:
	movf	((c:interp@opcode)),c,w
	; Switch size 1, requested type "space"
; Number of cases is 14, Range of values is 0 to 13
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           43    22 (average)
;	Chosen strategy is simple_byte

	xorlw	0^0	; case 0
	skipnz
	goto	l1429
	xorlw	1^0	; case 1
	skipnz
	goto	l1431
	xorlw	2^1	; case 2
	skipnz
	goto	l1435
	xorlw	3^2	; case 3
	skipnz
	goto	l1437
	xorlw	4^3	; case 4
	skipnz
	goto	l1453
	xorlw	5^4	; case 5
	skipnz
	goto	l1467
	xorlw	6^5	; case 6
	skipnz
	goto	l1471
	xorlw	7^6	; case 7
	skipnz
	goto	l1473
	xorlw	8^7	; case 8
	skipnz
	goto	l1479
	xorlw	9^8	; case 9
	skipnz
	goto	l1483
	xorlw	10^9	; case 10
	skipnz
	goto	l1485
	xorlw	11^10	; case 11
	skipnz
	goto	l1489
	xorlw	12^11	; case 12
	skipnz
	goto	l1491
	xorlw	13^12	; case 13
	skipnz
	goto	l133
	goto	l1493

	line	1994
	
l115:
	goto	l112
	line	1995
	
l136:
	line	176
	goto	l112
	
l137:
	line	1997
;	Return value of _interp is never used
	
l133:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_interp
	__end_of_interp:
	signat	_interp,92
	global	_read_uint8

;; *************** function _read_uint8 *****************
;; Defined at:
;;		line 64 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    1
;; This function calls:
;;		_read_byte
;; This function is called by:
;;		_interp
;;		_read_uint16
;;		_read_uint32
;; This function uses a non-reentrant model
;;
psect	text4,class=CODE,space=0,reloc=2,group=0
	line	64
global __ptext4
__ptext4:
psect	text4
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	64
	global	__size_of_read_uint8
	__size_of_read_uint8	equ	__end_of_read_uint8-_read_uint8
	
_read_uint8:
;incstack = 0
	opt	stack 27
	line	65
	
l1365:
	call	_read_byte	;wreg free
	goto	l64
	
l1367:
	line	66
	
l64:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_read_uint8
	__end_of_read_uint8:
	signat	_read_uint8,89
	global	_read_ptr_1B

;; *************** function _read_ptr_1B *****************
;; Defined at:
;;		line 94 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  ofs             1    1[COMRAM] char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         1       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    2
;; This function calls:
;;		_read_int8
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text5,class=CODE,space=0,reloc=2,group=0
	line	94
global __ptext5
__ptext5:
psect	text5
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	94
	global	__size_of_read_ptr_1B
	__size_of_read_ptr_1B	equ	__end_of_read_ptr_1B-_read_ptr_1B
	
_read_ptr_1B:
;incstack = 0
	opt	stack 26
	line	95
	
l1369:
	call	_read_int8	;wreg free
	movwf	((c:read_ptr_1B@ofs)),c
	line	96
	
l1371:
	movf	((c:_pc)),c,w
	addwf	((c:read_ptr_1B@ofs)),c,w
	addlw	low(0FEh)
	goto	l82
	
l1373:
	line	97
	
l82:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_read_ptr_1B
	__end_of_read_ptr_1B:
	signat	_read_ptr_1B,89
	global	_read_int8

;; *************** function _read_int8 *****************
;; Defined at:
;;		line 68 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      char 
;; Registers used:
;;		wreg, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    1
;; This function calls:
;;		_read_byte
;; This function is called by:
;;		_read_ptr_1B
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text6,class=CODE,space=0,reloc=2,group=0
	line	68
global __ptext6
__ptext6:
psect	text6
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	68
	global	__size_of_read_int8
	__size_of_read_int8	equ	__end_of_read_int8-_read_int8
	
_read_int8:
;incstack = 0
	opt	stack 26
	line	69
	
l1353:
	call	_read_byte	;wreg free
	goto	l67
	
l1355:
	line	70
	
l67:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_read_int8
	__end_of_read_int8:
	signat	_read_int8,89
	global	_read_opcode

;; *************** function _read_opcode *****************
;; Defined at:
;;		line 60 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    1
;; This function calls:
;;		_read_byte
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text7,class=CODE,space=0,reloc=2,group=0
	line	60
global __ptext7
__ptext7:
psect	text7
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	60
	global	__size_of_read_opcode
	__size_of_read_opcode	equ	__end_of_read_opcode-_read_opcode
	
_read_opcode:
;incstack = 0
	opt	stack 27
	line	61
	
l1361:
	call	_read_byte	;wreg free
	goto	l61
	
l1363:
	line	62
	
l61:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_read_opcode
	__end_of_read_opcode:
	signat	_read_opcode,89
	global	_read_byte

;; *************** function _read_byte *****************
;; Defined at:
;;		line 49 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;  c               1    0[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      unsigned char 
;; Registers used:
;;		wreg, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         1       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        1 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_read_opcode
;;		_read_uint8
;;		_read_int8
;; This function uses a non-reentrant model
;;
psect	text8,class=CODE,space=0,reloc=2,group=0
	line	49
global __ptext8
__ptext8:
psect	text8
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	49
	global	__size_of_read_byte
	__size_of_read_byte	equ	__end_of_read_byte-_read_byte
	
_read_byte:
;incstack = 0
	opt	stack 27
	line	54
	
l1343:
	movf	((c:_pc)),c,w
	mullw	01h
	movlw	low((_ocaml_bytecode))
	addwf	(prodl),c,w
	movwf	tblptrl
	movlw	high((_ocaml_bytecode))
	addwfc	(prodh),c,w
	movwf	tblptrh
	if	1	;There are 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd	*
	
	movff	tablat,(c:read_byte@c)
	line	56
	
l1345:
	incf	((c:_pc)),c
	line	57
	
l1347:
	movf	((c:read_byte@c)),c,w
	goto	l58
	
l1349:
	line	58
	
l58:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_read_byte
	__end_of_read_byte:
	signat	_read_byte,89
	global	_push

;; *************** function _push *****************
;; Defined at:
;;		line 115 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;  x               4   36[COMRAM] long 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    4
;; This function calls:
;;		_caml_raise_stack_overflow
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text9,class=CODE,space=0,reloc=2,group=0
	line	115
global __ptext9
__ptext9:
psect	text9
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	115
	global	__size_of_push
	__size_of_push	equ	__end_of_push-_push
	
_push:
;incstack = 0
	opt	stack 24
	line	116
	
l1379:
	movlw	low((_ocaml_stack))
	movwf	(??_push+0+0)&0ffh,c
	movlw	high((_ocaml_stack))
	movwf	1+(??_push+0+0)&0ffh,c
		movf	(??_push+0+0),c,w
	subwf	((c:_sp)),c,w
	movf	(??_push+0+1),c,w
	subwfb	((c:_sp+1)),c,w
	btfsc	status,0
	goto	u461
	goto	u460

u461:
	goto	l1383
u460:
	line	117
	
l1381:
	call	_caml_raise_stack_overflow	;wreg free
	line	118
	goto	l96
	line	119
	
l94:
	line	120
	
l1383:
	movlw	04h
	subwf	((c:_sp)),c
	movlw	0
	subwfb	((c:_sp+1)),c
	movff	(c:_sp),fsr2l
	movff	(c:_sp+1),fsr2h
	movff	(c:push@x),postinc2
	movff	(c:push@x+1),postinc2
	movff	(c:push@x+2),postinc2
	movff	(c:push@x+3),postinc2

	goto	l96
	line	121
	
l95:
	line	122
	
l96:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_push
	__end_of_push:
	signat	_push,4217
	global	_caml_raise_stack_overflow

;; *************** function _caml_raise_stack_overflow *****************
;; Defined at:
;;		line 31 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    3
;; This function calls:
;;		__fassert
;; This function is called by:
;;		_push
;; This function uses a non-reentrant model
;;
psect	text10,class=CODE,space=0,reloc=2,group=0
	line	31
global __ptext10
__ptext10:
psect	text10
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	31
	global	__size_of_caml_raise_stack_overflow
	__size_of_caml_raise_stack_overflow	equ	__end_of_caml_raise_stack_overflow-_caml_raise_stack_overflow
	
_caml_raise_stack_overflow:
;incstack = 0
	opt	stack 24
	line	35
	
l1351:
	movlw	high(023h)
	movwf	((c:__fassert@line+1)),c
	movlw	low(023h)
	movwf	((c:__fassert@line)),c
		movlw	low(STR_1)
	movwf	((c:__fassert@file)),c
	movlw	high(STR_1)
	movwf	((c:__fassert@file+1)),c

		movlw	low(STR_2)
	movwf	((c:__fassert@exp)),c
	movlw	high(STR_2)
	movwf	((c:__fassert@exp+1)),c

	call	__fassert	;wreg free
	goto	l52
	
l51:
	line	37
	
l52:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_caml_raise_stack_overflow
	__end_of_caml_raise_stack_overflow:
	signat	_caml_raise_stack_overflow,89
	global	__fassert

;; *************** function __fassert *****************
;; Defined at:
;;		line 8 in file "/Applications/microchip/xc8/v1.44/sources/common/assert.c"
;; Parameters:    Size  Location     Type
;;  line            2   30[COMRAM] int 
;;  file            2   32[COMRAM] PTR const unsigned char 
;;		 -> STR_5(50), STR_3(50), STR_1(50), 
;;  exp             2   34[COMRAM] PTR const unsigned char 
;;		 -> STR_6(2), STR_4(2), STR_2(2), 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         6       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    2
;; This function calls:
;;		_printf
;; This function is called by:
;;		_caml_raise_stack_overflow
;;		_interp
;;		_caml_raise_division_by_zero
;; This function uses a non-reentrant model
;;
psect	text11,class=CODE,space=0,reloc=2,group=1
	file	"/Applications/microchip/xc8/v1.44/sources/common/assert.c"
	line	8
global __ptext11
__ptext11:
psect	text11
	file	"/Applications/microchip/xc8/v1.44/sources/common/assert.c"
	line	8
	global	__size_of__fassert
	__size_of__fassert	equ	__end_of__fassert-__fassert
	
__fassert:
;incstack = 0
	opt	stack 24
	line	10
	
l1341:
		movlw	low(STR_8)
	movwf	((c:printf@f)),c
	movlw	high(STR_8)
	movwf	((c:printf@f+1)),c

		movff	(c:__fassert@file),0+((c:?_printf)+02h)
	movff	(c:__fassert@file+1),1+((c:?_printf)+02h)

	movff	(c:__fassert@line),0+((c:?_printf)+04h)
	movff	(c:__fassert@line+1),1+((c:?_printf)+04h)
		movff	(c:__fassert@exp),0+((c:?_printf)+06h)
	movff	(c:__fassert@exp+1),1+((c:?_printf)+06h)

	call	_printf	;wreg free
	line	11
	
l397:
# 11 "/Applications/microchip/xc8/v1.44/sources/common/assert.c"
reset ;# 
psect	text11
	goto	l399
	
l398:
	line	12
	
l399:
	return	;funcret
	opt stack 0
GLOBAL	__end_of__fassert
	__end_of__fassert:
	signat	__fassert,12409
	global	_printf

;; *************** function _printf *****************
;; Defined at:
;;		line 464 in file "/Applications/microchip/xc8/v1.44/sources/common/doprnt.c"
;; Parameters:    Size  Location     Type
;;  f               2   12[COMRAM] PTR const unsigned char 
;;		 -> STR_8(36), 
;; Auto vars:     Size  Location     Type
;;  tmpval          4    0        struct .
;;  val             2   27[COMRAM] unsigned int 
;;  cp              2   25[COMRAM] PTR const unsigned char 
;;		 -> STR_7(7), STR_6(2), STR_5(50), STR_4(2), 
;;		 -> STR_3(50), STR_2(2), STR_1(50), 
;;  ap              2   23[COMRAM] PTR void [1]
;;		 -> ?_printf(2), 
;;  len             2    0        unsigned int 
;;  c               1   29[COMRAM] char 
;;  prec            1   22[COMRAM] char 
;;  flag            1   21[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2   12[COMRAM] int 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh, cstack
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         8       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         9       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          1       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:        18       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:       18 bytes
;; Hardware stack levels used:    1
;; Hardware stack levels required when called:    1
;; This function calls:
;;		___lwdiv
;;		___lwmod
;;		_putch
;; This function is called by:
;;		__fassert
;; This function uses a non-reentrant model
;;
psect	text12,class=CODE,space=0,reloc=2,group=0
	file	"/Applications/microchip/xc8/v1.44/sources/common/doprnt.c"
	line	464
global __ptext12
__ptext12:
psect	text12
	file	"/Applications/microchip/xc8/v1.44/sources/common/doprnt.c"
	line	464
	global	__size_of_printf
	__size_of_printf	equ	__end_of_printf-_printf
	
_printf:
;incstack = 0
	opt	stack 24
	line	533
	
l1277:
		movlw	low(?_printf+02h)
	movwf	((c:printf@ap)),c
	movlw	high(?_printf+02h)
	movwf	((c:printf@ap+1)),c

	line	536
	goto	l1339
	
l236:
	line	538
	
l1279:
		movlw	37
	xorwf	((c:printf@c)),c,w
	btfsc	status,2
	goto	u361
	goto	u360

u361:
	goto	l1283
u360:
	line	541
	
l1281:
	movf	((c:printf@c)),c,w
	
	call	_putch
	line	542
	goto	l1339
	line	543
	
l237:
	line	548
	
l1283:
	movlw	low(0)
	movwf	((c:printf@flag)),c
	line	635
	goto	l1301
	line	637
	
l239:
	line	638
	goto	l259
	line	697
	
l241:
	goto	l1303
	line	698
	
l242:
	line	699
	goto	l1303
	line	728
	
l244:
	line	734
	
l1285:
	movff	(c:printf@ap),fsr2l
	movff	(c:printf@ap+1),fsr2h
	movff	postinc2,(c:printf@cp)
	movff	postdec2,(c:printf@cp+1)
	
l1287:
	movlw	02h
	addwf	((c:printf@ap)),c
	movlw	0
	addwfc	((c:printf@ap+1)),c
	line	740
	
l1289:
	movf	((c:printf@cp)),c,w
iorwf	((c:printf@cp+1)),c,w
	btfss	status,2
	goto	u371
	goto	u370

u371:
	goto	l1297
u370:
	line	741
	
l1291:
		movlw	low(STR_7)
	movwf	((c:printf@cp)),c
	movlw	high(STR_7)
	movwf	((c:printf@cp+1)),c

	goto	l1297
	
l245:
	line	777
	goto	l1297
	
l247:
	line	778
	
l1293:
	movff	(c:printf@cp),tblptrl
	movff	(c:printf@cp+1),tblptrh
	if	1	;Program memory is < 0x10000, tblptru is always zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	
	call	_putch
	
l1295:
	infsnz	((c:printf@cp)),c
	incf	((c:printf@cp+1)),c
	goto	l1297
	
l246:
	line	777
	
l1297:
	movff	(c:printf@cp),tblptrl
	movff	(c:printf@cp+1),tblptrh
	if	1	;Program memory is < 0x10000, tblptru is always zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movf	tablat,w
	iorlw	0
	btfss	status,2
	goto	u381
	goto	u380
u381:
	goto	l1293
u380:
	goto	l1339
	
l248:
	line	779
	goto	l1339
	line	802
	
l249:
	line	813
	goto	l1339
	line	822
	
l1299:
	goto	l1303
	line	635
	
l238:
	
l1301:
	movff	(c:printf@f),tblptrl
	movff	(c:printf@f+1),tblptrh
	infsnz	((c:printf@f)),c
	incf	((c:printf@f+1)),c
	if	1	;Program memory is < 0x10000, tblptru is always zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movff	tablat,(c:printf@c)
	movf	((c:printf@c)),c,w
	; Switch size 1, requested type "space"
; Number of cases is 4, Range of values is 0 to 115
; switch strategies available:
; Name         Instructions Cycles
; simple_byte           13     7 (average)
;	Chosen strategy is simple_byte

	xorlw	0^0	; case 0
	skipnz
	goto	l259
	xorlw	100^0	; case 100
	skipnz
	goto	l1303
	xorlw	105^100	; case 105
	skipnz
	goto	l1303
	xorlw	115^105	; case 115
	skipnz
	goto	l1285
	goto	l1339

	line	822
	
l243:
	line	1259
	
l1303:
	movff	(c:printf@ap),fsr2l
	movff	(c:printf@ap+1),fsr2h
	movff	postinc2,(c:printf@val)
	movff	postdec2,(c:printf@val+1)
	
l1305:
	movlw	02h
	addwf	((c:printf@ap)),c
	movlw	0
	addwfc	((c:printf@ap+1)),c
	line	1261
	
l1307:
	btfsc	((c:printf@val+1)),c,7
	goto	u390
	goto	u391

u391:
	goto	l1313
u390:
	line	1262
	
l1309:
	movlw	(03h)&0ffh
	iorwf	((c:printf@flag)),c
	line	1263
	
l1311:
	negf	((c:printf@val)),c
	comf	((c:printf@val+1)),c
	btfsc	status,0
	incf	((c:printf@val+1)),c
	goto	l1313
	line	1264
	
l250:
	line	1305
	
l1313:
	movlw	low(01h)
	movwf	((c:printf@c)),c
	
l1315:
		movlw	5
	xorwf	((c:printf@c)),c,w
	btfss	status,2
	goto	u401
	goto	u400

u401:
	goto	l1319
u400:
	goto	l1327
	
l1317:
	goto	l1327
	line	1306
	
l251:
	
l1319:
	movf	((c:printf@c)),c,w
	mullw	02h
	movlw	low((_dpowers))
	addwf	(prodl),c,w
	movwf	tblptrl
	movlw	high((_dpowers))
	addwfc	(prodh),c,w
	movwf	tblptrh
	if	1	;There are 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
		tblrd	*+
	movf	tablat,w
	subwf	((c:printf@val)),c,w
	tblrd	*+
	movf	tablat,w
	subwfb	((c:printf@val+1)),c,w
	btfsc	status,0
	goto	u411
	goto	u410

u411:
	goto	l1323
u410:
	goto	l1327
	line	1307
	
l1321:
	goto	l1327
	
l253:
	line	1305
	
l1323:
	incf	((c:printf@c)),c
	
l1325:
		movlw	5
	xorwf	((c:printf@c)),c,w
	btfss	status,2
	goto	u421
	goto	u420

u421:
	goto	l1319
u420:
	goto	l1327
	
l252:
	line	1438
	
l1327:
	movff	(c:printf@flag),??_printf+0+0
	movlw	03h
	andwf	(??_printf+0+0),c
	btfsc	status,2
	goto	u431
	goto	u430
u431:
	goto	l1331
u430:
	line	1439
	
l1329:
	movlw	(02Dh)&0ffh
	
	call	_putch
	goto	l1331
	
l254:
	line	1472
	
l1331:
	movff	(c:printf@c),(c:printf@prec)
	line	1474
	goto	l1337
	
l256:
	line	1489
	
l1333:
	movf	((c:printf@prec)),c,w
	mullw	02h
	movlw	low((_dpowers))
	addwf	(prodl),c,w
	movwf	tblptrl
	movlw	high((_dpowers))
	addwfc	(prodh),c,w
	movwf	tblptrh
	if	1	;There are 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd*+
	
	movff	tablat,(c:___lwdiv@divisor)
	tblrd*-
	
	movff	tablat,(c:___lwdiv@divisor+1)

	movff	(c:printf@val),(c:___lwdiv@dividend)
	movff	(c:printf@val+1),(c:___lwdiv@dividend+1)
	call	___lwdiv	;wreg free
	movff	0+?___lwdiv,(c:___lwmod@dividend)
	movff	1+?___lwdiv,(c:___lwmod@dividend+1)
	movlw	high(0Ah)
	movwf	((c:___lwmod@divisor+1)),c
	movlw	low(0Ah)
	movwf	((c:___lwmod@divisor)),c
	call	___lwmod	;wreg free
	movf	(0+?___lwmod),c,w
	addlw	low(030h)
	movwf	((c:printf@c)),c
	line	1524
	
l1335:
	movf	((c:printf@c)),c,w
	
	call	_putch
	goto	l1337
	line	1525
	
l255:
	line	1474
	
l1337:
	decf	((c:printf@prec)),c
		incf	((c:printf@prec)),c,w
	btfss	status,2
	goto	u441
	goto	u440

u441:
	goto	l1333
u440:
	goto	l1339
	
l257:
	goto	l1339
	line	1533
	
l235:
	line	536
	
l1339:
	movff	(c:printf@f),tblptrl
	movff	(c:printf@f+1),tblptrh
	infsnz	((c:printf@f)),c
	incf	((c:printf@f+1)),c
	if	1	;Program memory is < 0x10000, tblptru is always zero
	clrf	tblptru
	endif
	if	0	;tblptru may be non-zero
	global __mediumconst
movlw	low highword(__mediumconst)
	movwf	tblptru
	endif
	tblrd	*
	
	movff	tablat,(c:printf@c)
	movf	((c:printf@c)),c,w
	btfss	status,2
	goto	u451
	goto	u450
u451:
	goto	l1279
u450:
	goto	l259
	
l258:
	goto	l259
	line	1535
	
l240:
	line	1541
;	Return value of _printf is never used
	
l259:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_printf
	__end_of_printf:
	signat	_printf,602
	global	_putch

;; *************** function _putch *****************
;; Defined at:
;;		line 7 in file "/Applications/microchip/xc8/v1.44/sources/common/putch.c"
;; Parameters:    Size  Location     Type
;;  c               1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  c               1    0[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        0 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_printf
;; This function uses a non-reentrant model
;;
psect	text13,class=CODE,space=0,reloc=2,group=1
	file	"/Applications/microchip/xc8/v1.44/sources/common/putch.c"
	line	7
global __ptext13
__ptext13:
psect	text13
	file	"/Applications/microchip/xc8/v1.44/sources/common/putch.c"
	line	7
	global	__size_of_putch
	__size_of_putch	equ	__end_of_putch-_putch
	
_putch:
;incstack = 0
	opt	stack 24
	line	9
	
l694:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_putch
	__end_of_putch:
	signat	_putch,4217
	global	___lwmod

;; *************** function ___lwmod *****************
;; Defined at:
;;		line 8 in file "/Applications/microchip/xc8/v1.44/sources/common/lwmod.c"
;; Parameters:    Size  Location     Type
;;  dividend        2    7[COMRAM] unsigned int 
;;  divisor         2    9[COMRAM] unsigned int 
;; Auto vars:     Size  Location     Type
;;  counter         1   11[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    7[COMRAM] unsigned int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         5       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        5 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_printf
;; This function uses a non-reentrant model
;;
psect	text14,class=CODE,space=0,reloc=2,group=1
	file	"/Applications/microchip/xc8/v1.44/sources/common/lwmod.c"
	line	8
global __ptext14
__ptext14:
psect	text14
	file	"/Applications/microchip/xc8/v1.44/sources/common/lwmod.c"
	line	8
	global	__size_of___lwmod
	__size_of___lwmod	equ	__end_of___lwmod-___lwmod
	
___lwmod:
;incstack = 0
	opt	stack 24
	line	13
	
l1261:
	movf	((c:___lwmod@divisor)),c,w
iorwf	((c:___lwmod@divisor+1)),c,w
	btfsc	status,2
	goto	u331
	goto	u330

u331:
	goto	l679
u330:
	line	14
	
l1263:
	movlw	low(01h)
	movwf	((c:___lwmod@counter)),c
	line	15
	goto	l1267
	
l681:
	line	16
	
l1265:
	bcf	status,0
	rlcf	((c:___lwmod@divisor)),c
	rlcf	((c:___lwmod@divisor+1)),c
	line	17
	incf	((c:___lwmod@counter)),c
	goto	l1267
	line	18
	
l680:
	line	15
	
l1267:
	
	btfss	((c:___lwmod@divisor+1)),c,(15)&7
	goto	u341
	goto	u340
u341:
	goto	l1265
u340:
	goto	l1269
	
l682:
	goto	l1269
	line	19
	
l683:
	line	20
	
l1269:
		movf	((c:___lwmod@divisor)),c,w
	subwf	((c:___lwmod@dividend)),c,w
	movf	((c:___lwmod@divisor+1)),c,w
	subwfb	((c:___lwmod@dividend+1)),c,w
	btfss	status,0
	goto	u351
	goto	u350

u351:
	goto	l1273
u350:
	line	21
	
l1271:
	movf	((c:___lwmod@divisor)),c,w
	subwf	((c:___lwmod@dividend)),c
	movf	((c:___lwmod@divisor+1)),c,w
	subwfb	((c:___lwmod@dividend+1)),c

	goto	l1273
	
l684:
	line	22
	
l1273:
	bcf	status,0
	rrcf	((c:___lwmod@divisor+1)),c
	rrcf	((c:___lwmod@divisor)),c
	line	23
	
l1275:
	decfsz	((c:___lwmod@counter)),c
	
	goto	l1269
	goto	l679
	
l685:
	line	24
	
l679:
	line	25
	movff	(c:___lwmod@dividend),(c:?___lwmod)
	movff	(c:___lwmod@dividend+1),(c:?___lwmod+1)
	line	26
	
l686:
	return	;funcret
	opt stack 0
GLOBAL	__end_of___lwmod
	__end_of___lwmod:
	signat	___lwmod,8314
	global	___lwdiv

;; *************** function ___lwdiv *****************
;; Defined at:
;;		line 8 in file "/Applications/microchip/xc8/v1.44/sources/common/lwdiv.c"
;; Parameters:    Size  Location     Type
;;  dividend        2    0[COMRAM] unsigned int 
;;  divisor         2    2[COMRAM] unsigned int 
;; Auto vars:     Size  Location     Type
;;  quotient        2    4[COMRAM] unsigned int 
;;  counter         1    6[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    0[COMRAM] unsigned int 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         3       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         7       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        7 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_printf
;; This function uses a non-reentrant model
;;
psect	text15,class=CODE,space=0,reloc=2,group=1
	file	"/Applications/microchip/xc8/v1.44/sources/common/lwdiv.c"
	line	8
global __ptext15
__ptext15:
psect	text15
	file	"/Applications/microchip/xc8/v1.44/sources/common/lwdiv.c"
	line	8
	global	__size_of___lwdiv
	__size_of___lwdiv	equ	__end_of___lwdiv-___lwdiv
	
___lwdiv:
;incstack = 0
	opt	stack 24
	line	14
	
l1239:
	movlw	high(0)
	movwf	((c:___lwdiv@quotient+1)),c
	movlw	low(0)
	movwf	((c:___lwdiv@quotient)),c
	line	15
	
l1241:
	movf	((c:___lwdiv@divisor)),c,w
iorwf	((c:___lwdiv@divisor+1)),c,w
	btfsc	status,2
	goto	u301
	goto	u300

u301:
	goto	l669
u300:
	line	16
	
l1243:
	movlw	low(01h)
	movwf	((c:___lwdiv@counter)),c
	line	17
	goto	l1247
	
l671:
	line	18
	
l1245:
	bcf	status,0
	rlcf	((c:___lwdiv@divisor)),c
	rlcf	((c:___lwdiv@divisor+1)),c
	line	19
	incf	((c:___lwdiv@counter)),c
	goto	l1247
	line	20
	
l670:
	line	17
	
l1247:
	
	btfss	((c:___lwdiv@divisor+1)),c,(15)&7
	goto	u311
	goto	u310
u311:
	goto	l1245
u310:
	goto	l1249
	
l672:
	goto	l1249
	line	21
	
l673:
	line	22
	
l1249:
	bcf	status,0
	rlcf	((c:___lwdiv@quotient)),c
	rlcf	((c:___lwdiv@quotient+1)),c
	line	23
	
l1251:
		movf	((c:___lwdiv@divisor)),c,w
	subwf	((c:___lwdiv@dividend)),c,w
	movf	((c:___lwdiv@divisor+1)),c,w
	subwfb	((c:___lwdiv@dividend+1)),c,w
	btfss	status,0
	goto	u321
	goto	u320

u321:
	goto	l1257
u320:
	line	24
	
l1253:
	movf	((c:___lwdiv@divisor)),c,w
	subwf	((c:___lwdiv@dividend)),c
	movf	((c:___lwdiv@divisor+1)),c,w
	subwfb	((c:___lwdiv@dividend+1)),c

	line	25
	
l1255:
	bsf	(0+(0/8)+(c:___lwdiv@quotient)),c,(0)&7
	goto	l1257
	line	26
	
l674:
	line	27
	
l1257:
	bcf	status,0
	rrcf	((c:___lwdiv@divisor+1)),c
	rrcf	((c:___lwdiv@divisor)),c
	line	28
	
l1259:
	decfsz	((c:___lwdiv@counter)),c
	
	goto	l1249
	goto	l669
	
l675:
	line	29
	
l669:
	line	30
	movff	(c:___lwdiv@quotient),(c:?___lwdiv)
	movff	(c:___lwdiv@quotient+1),(c:?___lwdiv+1)
	line	31
	
l676:
	return	;funcret
	opt stack 0
GLOBAL	__end_of___lwdiv
	__end_of___lwdiv:
	signat	___lwdiv,8314
	global	_pop_n

;; *************** function _pop_n *****************
;; Defined at:
;;		line 128 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;  n               2    1[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         2       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text16,class=CODE,space=0,reloc=2,group=0
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	128
global __ptext16
__ptext16:
psect	text16
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	128
	global	__size_of_pop_n
	__size_of_pop_n	equ	__end_of_pop_n-_pop_n
	
_pop_n:
;incstack = 0
	opt	stack 28
	line	129
	
l1389:
	movff	(c:pop_n@n),??_pop_n+0+0
	movff	(c:pop_n@n+1),??_pop_n+0+0+1
	bcf	status,0
	rlcf	(??_pop_n+0+0),c
	rlcf	(??_pop_n+0+1),c
	bcf	status,0
	rlcf	(??_pop_n+0+0),c
	rlcf	(??_pop_n+0+1),c
	movf	(??_pop_n+0+0),c,w
	addwf	((c:_sp)),c
	movf	(??_pop_n+0+1),c,w
	addwfc	((c:_sp+1)),c

	line	130
	
l102:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_pop_n
	__end_of_pop_n:
	signat	_pop_n,4217
	global	_pop

;; *************** function _pop *****************
;; Defined at:
;;		line 124 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;		None
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  4    0[COMRAM] long 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text17,class=CODE,space=0,reloc=2,group=0
	line	124
global __ptext17
__ptext17:
psect	text17
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	124
	global	__size_of_pop
	__size_of_pop	equ	__end_of_pop-_pop
	
_pop:
;incstack = 0
	opt	stack 28
	line	125
	
l1385:
	movff	(c:_sp),fsr2l
	movff	(c:_sp+1),fsr2h
	movlw	low(04h)
	addwf	((c:_sp)),c
	movlw	high(04h)
	addwfc	((c:_sp+1)),c
	movff	postinc2,(c:?_pop)
	movff	postinc2,(c:?_pop+1)
	movff	postinc2,(c:?_pop+2)
	movff	postinc2,(c:?_pop+3)
	goto	l99
	
l1387:
	line	126
	
l99:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_pop
	__end_of_pop:
	signat	_pop,92
	global	_peek

;; *************** function _peek *****************
;; Defined at:
;;		line 111 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;  n               2    0[COMRAM] int 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  4    0[COMRAM] long 
;; Registers used:
;;		wreg, fsr2l, fsr2h, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        4 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text18,class=CODE,space=0,reloc=2,group=0
	line	111
global __ptext18
__ptext18:
psect	text18
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	111
	global	__size_of_peek
	__size_of_peek	equ	__end_of_peek-_peek
	
_peek:
;incstack = 0
	opt	stack 28
	line	112
	
l1375:
	bcf	status,0
	rlcf	((c:peek@n)),c,w
	movwf	fsr2l
	rlcf	((c:peek@n+1)),c,w
	movwf	fsr2h
	bcf	status,0
	rlcf	fsr2l,f
	rlcf	fsr2h,f
	movf	((c:_sp)),c,w
	addwf	fsr2l
	movf	((c:_sp+1)),c,w
	addwfc	fsr2h

	movff	postinc2,(c:?_peek)
	movff	postinc2,(c:?_peek+1)
	movff	postinc2,(c:?_peek+2)
	movff	postinc2,(c:?_peek+3)
	goto	l91
	
l1377:
	line	113
	
l91:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_peek
	__end_of_peek:
	signat	_peek,4220
	global	_get_primitive

;; *************** function _get_primitive *****************
;; Defined at:
;;		line 41 in file "/Users/steven/github/OMicroB/src/byterun/interp.c"
;; Parameters:    Size  Location     Type
;;  prim_ind        1    wreg     unsigned char 
;; Auto vars:     Size  Location     Type
;;  prim_ind        1    2[COMRAM] unsigned char 
;; Return value:  Size  Location     Type
;;                  2    0[COMRAM] PTR void 
;; Registers used:
;;		wreg, status,2, status,0, tblptrl, tblptrh, tblptru, prodl, prodh
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         2       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         1       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         3       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        3 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text19,class=CODE,space=0,reloc=2,group=0
	line	41
global __ptext19
__ptext19:
psect	text19
	file	"/Users/steven/github/OMicroB/src/byterun/interp.c"
	line	41
	global	__size_of_get_primitive
	__size_of_get_primitive	equ	__end_of_get_primitive-_get_primitive
	
_get_primitive:
;incstack = 0
	opt	stack 28
	movwf	((c:get_primitive@prim_ind)),c
	line	45
	
l1357:
	movf	((c:get_primitive@prim_ind)),c,w
	mullw	02h
	movlw	low((_ocaml_primitives))
	addwf	(prodl),c,w
	movwf	tblptrl
	movlw	high((_ocaml_primitives))
	addwfc	(prodh),c,w
	movwf	tblptrh
	if	1	;There are 3 active tblptr bytes
	clrf	tblptru
	global __mediumconst
movlw	low highword(__mediumconst)
	addwfc	tblptru,f
	endif
	tblrd*+
	
	movff	tablat,(c:?_get_primitive)
	tblrd*-
	
	movff	tablat,(c:?_get_primitive+1)

	goto	l55
	
l1359:
	line	47
	
l55:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_get_primitive
	__end_of_get_primitive:
	signat	_get_primitive,4218
	global	_caml_write_reg

;; *************** function _caml_write_reg *****************
;; Defined at:
;;		line 20 in file "/Users/steven/github/OMicroB/src/byterun/stdlib.c"
;; Parameters:    Size  Location     Type
;;  pin             4    3[COMRAM] long 
;;  v               4    7[COMRAM] long 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  4    3[COMRAM] long 
;; Registers used:
;;		wreg, status,2
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         8       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         8       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        8 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text20,class=CODE,space=0,reloc=2,group=0
	file	"/Users/steven/github/OMicroB/src/byterun/stdlib.c"
	line	20
global __ptext20
__ptext20:
psect	text20
	file	"/Users/steven/github/OMicroB/src/byterun/stdlib.c"
	line	20
	global	__size_of_caml_write_reg
	__size_of_caml_write_reg	equ	__end_of_caml_write_reg-_caml_write_reg
	
_caml_write_reg:
;incstack = 0
	opt	stack 28
	line	21
	
l1391:
	movlw	low(0)
	movwf	((c:3989)),c	;volatile
	line	22
	movlw	low(01h)
	movwf	((c:?_caml_write_reg)),c
	movlw	high(01h)
	movwf	((c:?_caml_write_reg+1)),c
	movlw	low highword(01h)
	movwf	((c:?_caml_write_reg+2)),c
	movlw	high highword(01h)
	movwf	((c:?_caml_write_reg+3)),c
	goto	l151
	
l1393:
	line	23
	
l151:
	return	;funcret
	opt stack 0
GLOBAL	__end_of_caml_write_reg
	__end_of_caml_write_reg:
	signat	_caml_write_reg,8316
	global	___lmul

;; *************** function ___lmul *****************
;; Defined at:
;;		line 15 in file "/Applications/microchip/xc8/v1.44/sources/common/Umul32.c"
;; Parameters:    Size  Location     Type
;;  multiplier      4    4[COMRAM] unsigned long 
;;  multiplicand    4    8[COMRAM] unsigned long 
;; Auto vars:     Size  Location     Type
;;  product         4   12[COMRAM] unsigned long 
;; Return value:  Size  Location     Type
;;                  4    4[COMRAM] unsigned long 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         8       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:        12       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:       12 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_interp
;; This function uses a non-reentrant model
;;
psect	text21,class=CODE,space=0,reloc=2,group=1
	file	"/Applications/microchip/xc8/v1.44/sources/common/Umul32.c"
	line	15
global __ptext21
__ptext21:
psect	text21
	file	"/Applications/microchip/xc8/v1.44/sources/common/Umul32.c"
	line	15
	global	__size_of___lmul
	__size_of___lmul	equ	__end_of___lmul-___lmul
	
___lmul:
;incstack = 0
	opt	stack 28
	line	119
	
l1395:
	movlw	low(0)
	movwf	((c:___lmul@product)),c
	movlw	high(0)
	movwf	((c:___lmul@product+1)),c
	movlw	low highword(0)
	movwf	((c:___lmul@product+2)),c
	movlw	high highword(0)
	movwf	((c:___lmul@product+3)),c
	goto	l1397
	line	120
	
l271:
	line	121
	
l1397:
	
	btfss	((c:___lmul@multiplier)),c,(0)&7
	goto	u471
	goto	u470
u471:
	goto	l1401
u470:
	line	122
	
l1399:
	movf	((c:___lmul@multiplicand)),c,w
	addwf	((c:___lmul@product)),c
	movf	((c:___lmul@multiplicand+1)),c,w
	addwfc	((c:___lmul@product+1)),c
	movf	((c:___lmul@multiplicand+2)),c,w
	addwfc	((c:___lmul@product+2)),c
	movf	((c:___lmul@multiplicand+3)),c,w
	addwfc	((c:___lmul@product+3)),c
	goto	l1401
	
l272:
	line	123
	
l1401:
	bcf	status,0
	rlcf	((c:___lmul@multiplicand)),c
	rlcf	((c:___lmul@multiplicand+1)),c
	rlcf	((c:___lmul@multiplicand+2)),c
	rlcf	((c:___lmul@multiplicand+3)),c
	line	124
	
l1403:
	bcf	status,0
	rrcf	((c:___lmul@multiplier+3)),c
	rrcf	((c:___lmul@multiplier+2)),c
	rrcf	((c:___lmul@multiplier+1)),c
	rrcf	((c:___lmul@multiplier)),c
	line	125
	movf	((c:___lmul@multiplier)),c,w
iorwf	((c:___lmul@multiplier+1)),c,w
iorwf	((c:___lmul@multiplier+2)),c,w
iorwf	((c:___lmul@multiplier+3)),c,w
	btfss	status,2
	goto	u481
	goto	u480

u481:
	goto	l1397
u480:
	
l273:
	line	128
	movff	(c:___lmul@product),(c:?___lmul)
	movff	(c:___lmul@product+1),(c:?___lmul+1)
	movff	(c:___lmul@product+2),(c:?___lmul+2)
	movff	(c:___lmul@product+3),(c:?___lmul+3)
	line	129
	
l274:
	return	;funcret
	opt stack 0
GLOBAL	__end_of___lmul
	__end_of___lmul:
	signat	___lmul,8316
	global	_gc_init

;; *************** function _gc_init *****************
;; Defined at:
;;		line 62 in file "/Users/steven/github/OMicroB/src/byterun/gc.c"
;; Parameters:    Size  Location     Type
;;  heap_size       4    0[COMRAM] long 
;; Auto vars:     Size  Location     Type
;;		None
;; Return value:  Size  Location     Type
;;                  1    wreg      void 
;; Registers used:
;;		wreg, status,2, status,0
;; Tracked objects:
;;		On entry : 0/0
;;		On exit  : 0/0
;;		Unchanged: 0/0
;; Data sizes:     COMRAM   BANK0   BANK1   BANK2   BANK3   BANK4   BANK5   BANK6   BANK7   BANK8   BANK9  BANK10  BANK11  BANK12  BANK13  BANK14  BANK15
;;      Params:         4       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Locals:         0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Temps:          2       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;      Totals:         6       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0       0
;;Total ram usage:        6 bytes
;; Hardware stack levels used:    1
;; This function calls:
;;		Nothing
;; This function is called by:
;;		_setup
;; This function uses a non-reentrant model
;;
psect	text22,class=CODE,space=0,reloc=2,group=0
	file	"/Users/steven/github/OMicroB/src/byterun/gc.c"
	line	62
global __ptext22
__ptext22:
psect	text22
	file	"/Users/steven/github/OMicroB/src/byterun/gc.c"
	line	62
	global	__size_of_gc_init
	__size_of_gc_init	equ	__end_of_gc_init-_gc_init
	
_gc_init:
;incstack = 0
	opt	stack 29
	line	65
	
l1497:
		movff	(c:_ocaml_heap1),(c:_heap1_start)
	movff	(c:_ocaml_heap1+1),(c:_heap1_start+1)
	movf	((c:_heap1_start)),c,w
	iorwf	((c:_heap1_start+1)),c,w
	btfss	status,2
	movlw	020h
	movwf	((c:_heap1_start+2)),c

	line	67
	movff	(c:gc_init@heap_size),??_gc_init+0+0
	movff	(c:gc_init@heap_size+1),??_gc_init+0+0+1
	bcf	status,0
	rlcf	(??_gc_init+0+0),c
	rlcf	(??_gc_init+0+1),c
	bcf	status,0
	rlcf	(??_gc_init+0+0),c
	rlcf	(??_gc_init+0+1),c
	movf	(??_gc_init+0+0),c,w
	addwf	((c:_heap1_start)),c,w
	movlb	0	; () banked
	movwf	((_heap1_end))&0ffh
	movf	(??_gc_init+0+1),c,w
	addwfc	((c:_heap1_start+1)),c,w
	movwf	1+((_heap1_end))&0ffh
	
	movlw	0
	btfsc	(??_gc_init+0+1),c,7
	movlw	0ffh
	addwfc	((c:_heap1_start+2)),c,w
	movwf	2+((_heap1_end))&0ffh
	line	68
		movff	(c:_heap1_start),(c:_tab_heap_start)
	movff	(c:_heap1_start+1),(c:_tab_heap_start+1)
	movff	(c:_heap1_start+2),(c:_tab_heap_start+2)

	line	69
		movff	(_heap1_end),(_tab_heap_end)
	movff	(_heap1_end+1),(_tab_heap_end+1)
	movff	(_heap1_end+2),(_tab_heap_end+2)

	line	72
		movff	(c:_ocaml_heap2),(c:_heap2_start)
	movff	(c:_ocaml_heap2+1),(c:_heap2_start+1)
	movf	((c:_heap2_start)),c,w
	iorwf	((c:_heap2_start+1)),c,w
	btfss	status,2
	movlw	020h
	movwf	((c:_heap2_start+2)),c

	line	74
	movff	(c:gc_init@heap_size),??_gc_init+0+0
	movff	(c:gc_init@heap_size+1),??_gc_init+0+0+1
	bcf	status,0
	rlcf	(??_gc_init+0+0),c
	rlcf	(??_gc_init+0+1),c
	bcf	status,0
	rlcf	(??_gc_init+0+0),c
	rlcf	(??_gc_init+0+1),c
	movf	(??_gc_init+0+0),c,w
	addwf	((c:_heap2_start)),c,w
	movwf	((_heap2_end))&0ffh
	movf	(??_gc_init+0+1),c,w
	addwfc	((c:_heap2_start+1)),c,w
	movwf	1+((_heap2_end))&0ffh
	
	movlw	0
	btfsc	(??_gc_init+0+1),c,7
	movlw	0ffh
	addwfc	((c:_heap2_start+2)),c,w
	movwf	2+((_heap2_end))&0ffh
	line	75
		movff	(c:_heap2_start),0+((c:_tab_heap_start)+03h)
	movff	(c:_heap2_start+1),1+((c:_tab_heap_start)+03h)
	movff	(c:_heap2_start+2),2+((c:_tab_heap_start)+03h)

	line	76
		movff	(_heap2_end),0+(_tab_heap_end+03h)
	movff	(_heap2_end+1),1+(_tab_heap_end+03h)
	movff	(_heap2_end+2),2+(_tab_heap_end+03h)

	line	79
	movlw	low(08h)
	movwf	(??_gc_init+0+0)&0ffh,c
	movlw	high(08h)
	movwf	1+(??_gc_init+0+0)&0ffh,c
	movf	(??_gc_init+0+0),c,w
	addwf	((c:_heap1_start)),c,w
	movwf	((c:_heap_ptr)),c
	movf	(??_gc_init+0+1),c,w
	addwfc	((c:_heap1_start+1)),c,w
	movwf	1+((c:_heap_ptr)),c
	
	movlw	0
	btfsc	(??_gc_init+0+1),c,7
	movlw	0ffh
	addwfc	((c:_heap1_start+2)),c,w
	movwf	2+((c:_heap_ptr)),c
	line	84
	movff	(c:gc_init@heap_size),??_gc_init+0+0
	movff	(c:gc_init@heap_size+1),??_gc_init+0+0+1
	bcf	status,0
	rlcf	(??_gc_init+0+0),c
	rlcf	(??_gc_init+0+1),c
	bcf	status,0
	rlcf	(??_gc_init+0+0),c
	rlcf	(??_gc_init+0+1),c
	movf	(??_gc_init+0+0),c,w
	addwf	((c:_heap_ptr)),c,w
	movwf	((c:_heap_end)),c
	movf	(??_gc_init+0+1),c,w
	addwfc	((c:_heap_ptr+1)),c,w
	movwf	1+((c:_heap_end)),c
	
	movlw	0
	btfsc	(??_gc_init+0+1),c,7
	movlw	0ffh
	addwfc	((c:_heap_ptr+2)),c,w
	movwf	2+((c:_heap_end)),c
	line	86
	
l1499:; BSR set to: 0

	movlw	high(0)
	movwf	((c:_current_heap+1)),c
	movlw	low(0)
	movwf	((c:_current_heap)),c
	line	88
	
l199:; BSR set to: 0

	return	;funcret
	opt stack 0
GLOBAL	__end_of_gc_init
	__end_of_gc_init:
	signat	_gc_init,4217
psect	smallconst
	db 0	; dummy byte at the end
	global	__smallconst
	global	__mediumconst
	GLOBAL	__activetblptr
__activetblptr	EQU	3
	psect	intsave_regs,class=BIGRAM,space=1,noexec
	file ""
	line	0
psect	text23,class=CODE,space=0,reloc=2,group=0
global __ptext23
__ptext23:
fp__caml_write_reg:
	PSECT	rparam,class=COMRAM,space=1,noexec
	GLOBAL	__Lrparam
	FNCONF	rparam,??,?
	GLOBAL	___rparam_used
	___rparam_used EQU 1
	GLOBAL	___param_bank
	___param_bank EQU 0
GLOBAL	__Lparam, __Hparam
GLOBAL	__Lrparam, __Hrparam
__Lparam	EQU	__Lrparam
__Hparam	EQU	__Hrparam
	end
