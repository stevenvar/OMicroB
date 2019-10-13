/*
 * hardware.h
 *
 * This file is part of the Phos operating system for microcontrollers
 * Copyright (c) 2018 J. M. Spivey
 * All rights reserved
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 * 3. The name of the author may not be used to endorse or promote products
 *    derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#define BIT(i) (1 << (i))

#define SET_BIT(reg, n) reg |= BIT(n)
#define CLR_BIT(reg, n) reg &= ~BIT(n)
#define READ_BIT(reg, n) reg & BIT(n)

#define SET_FIELD(reg, field, val)                \
  reg = (reg & ~MASK(field)) | FIELD(field, val)

#define GET_FIELD(reg, field)                   \
  ((reg >> field##_Pos) & MASK0(field))

#define FIELD(field, val)                       \
  (((val) & MASK0(field)) << field##_Pos)

#define MASK(field) (MASK0(field) << field##_Pos)

#define MASK0(field) (~((-2) << (field##_Wid-1)))

#define SET_BYTE(reg, n, v)                           \
  reg = (reg & ~(0xff << 8*n)) | ((v & 0xff) << 8*n)

#define ADDR(x) (* (unsigned volatile *) (x))
#define ARRAY(x) ((unsigned volatile *) (x))


/* Device pins */

// General purpose pins
#define PIN0 3
#define PIN1 2
#define PIN2 1
#define PIN8 18
#define PIN12 20
#define PIN16 16

// Buttons
#define BUTTON_A 17
#define BUTTON_B 26

// SPI
#define MOSI 21
#define MISO 22
#define SCK 23

// I2C
#define I2C_SDA 30
#define I2C_SCL 0

// Serial
#define USB_TX 24
#define USB_RX 25


/* Interrupts */
#define SVC_IRQ    -5
#define PENDSV_IRQ -2
#define RADIO_IRQ   1
#define UART_IRQ    2
#define I2C_IRQ     3
#define ADC_IRQ     7
#define TIMER0_IRQ  8
#define TIMER1_IRQ  9
#define TIMER2_IRQ 10
#define TEMP_IRQ   12
#define RNG_IRQ    13

/* System registers */
#define SCB_CPUID      ADDR(0xE000ED00)
#define SCB_ICSR       ADDR(0xE000ED04)
#define SCB_SHPR      ARRAY(0xE000ED1C)
#define NVIC_ISER     ARRAY(0xE000E100)
#define NVIC_ICER     ARRAY(0xE000E180)
#define NVIC_ISPR     ARRAY(0xE000E200)
#define NVIC_ICPR     ARRAY(0xE000E280)
#define NVIC_IPR      ARRAY(0xE000E400)

#define POWER_RAMON    ADDR(0x40000524)

#define SCB_ICSR_PendSVSet 28
#define SCB_ICSR_VECTACTIVE_Pos 0
#define SCB_ICSR_VECTACTIVE_Wid 6

/* Clock control */
#define CLOCK_HFCLKSTART ADDR(0x40000000)
#define CLOCK_LFCLKSTART ADDR(0x40000008)
#define CLOCK_HFCLKSTARTED ADDR(0x40000100)
#define CLOCK_LFCLKSTARTED ADDR(0x40000104)
#define CLOCK_LFCLKSRC  ADDR(0x40000518)
#define CLOCK_XTALFREQ  ADDR(0x40000550)

#define CLOCK_LFCLKSRC_RC 0
#define CLOCK_XTALFREQ_16MHz 0xFF

#define MPU_DISABLEINDEBUG ADDR(0x40000608)

/* GPIO */
#define GPIO_OUT       ADDR(0x50000504)
#define GPIO_OUTSET    ADDR(0x50000508)
#define GPIO_OUTCLR    ADDR(0x5000050c)
#define GPIO_IN        ADDR(0x50000510)
#define GPIO_DIR       ADDR(0x50000514)
#define GPIO_DIRSET    ADDR(0x50000518)
#define GPIO_DIRCLR    ADDR(0x5000051c)
#define GPIO_PINCNF   ARRAY(0x50000700)

#define GPIO_PINCNF_CONNECT_Pos 1
#define GPIO_PINCNF_CONNECT_Wid 1
#define GPIO_Connect 0x0

#define GPIO_PINCNF_PULL_Pos 2
#define GPIO_PINCNF_PULL_Wid 2
#define GPIO_Pullup 0x3

#define GPIO_PINCNF_DRIVE_Pos 8
#define GPIO_PINCNF_DRIVE_Wid 3
#define GPIO_S0D1 0x6 // Open drain

/* UART */
#define UART_STARTRX   ADDR(0x40002000)
#define UART_STARTTX   ADDR(0x40002008)
#define UART_RXDRDY    ADDR(0x40002108)
#define UART_TXDRDY    ADDR(0x4000211c)
#define UART_ENABLE    ADDR(0x40002500)
#define UART_PSELTXD   ADDR(0x4000250c)
#define UART_PSELRXD   ADDR(0x40002514)
#define UART_RXD       ADDR(0x40002518)
#define UART_TXD       ADDR(0x4000251c)
#define UART_BAUDRATE  ADDR(0x40002524)
#define UART_CONFIG    ADDR(0x4000256c)
#define UART_INTEN     ADDR(0x40002300)
#define UART_INTENSET  ADDR(0x40002304)
#define UART_INTENCLR  ADDR(0x40002308)

#define UART_Enabled 0x4
#define UART_INT_TXDRDY 7
#define UART_INT_RXDRDY 2

#define UART_BAUD_9600 0x00275000


/* TIMERS */
#define TIMER0_START     ADDR(0x40008000)
#define TIMER0_STOP      ADDR(0x40008004)
#define TIMER0_COUNT     ADDR(0x40008008)
#define TIMER0_CLEAR     ADDR(0x4000800c)
#define TIMER0_SHUTDOWN  ADDR(0x40008010)
#define TIMER0_CAPTURE  ARRAY(0x40008040)
#define TIMER0_COMPARE  ARRAY(0x40008140)
#define TIMER0_SHORTS    ADDR(0x40008200)
#define TIMER0_INTENSET  ADDR(0x40008304)
#define TIMER0_INTENCLR  ADDR(0x40008308)
#define TIMER0_MODE      ADDR(0x40008504)
#define TIMER0_BITMODE   ADDR(0x40008508)
#define TIMER0_PRESCALER ADDR(0x40008510)
#define TIMER0_CC       ARRAY(0x40008540)

#define TIMER1_START     ADDR(0x40009000)
#define TIMER1_STOP      ADDR(0x40009004)
#define TIMER1_COUNT     ADDR(0x40009008)
#define TIMER1_CLEAR     ADDR(0x4000900c)
#define TIMER1_SHUTDOWN  ADDR(0x40009010)
#define TIMER1_CAPTURE  ARRAY(0x40009040)
#define TIMER1_COMPARE  ARRAY(0x40009140)
#define TIMER1_SHORTS    ADDR(0x40009200)
#define TIMER1_INTENSET  ADDR(0x40009304)
#define TIMER1_INTENCLR  ADDR(0x40009308)
#define TIMER1_MODE      ADDR(0x40009504)
#define TIMER1_BITMODE   ADDR(0x40009508)
#define TIMER1_PRESCALER ADDR(0x40009510)
#define TIMER1_CC       ARRAY(0x40009540)

#define TIMER2_START     ADDR(0x4000a000)
#define TIMER2_STOP      ADDR(0x4000a004)
#define TIMER2_COUNT     ADDR(0x4000a008)
#define TIMER2_CLEAR     ADDR(0x4000a00c)
#define TIMER2_SHUTDOWN  ADDR(0x4000a010)
#define TIMER2_CAPTURE  ARRAY(0x4000a040)
#define TIMER2_COMPARE  ARRAY(0x4000a140)
#define TIMER2_SHORTS    ADDR(0x4000a200)
#define TIMER2_INTENSET  ADDR(0x4000a304)
#define TIMER2_INTENCLR  ADDR(0x4000a308)
#define TIMER2_MODE      ADDR(0x4000a504)
#define TIMER2_BITMODE   ADDR(0x4000a508)
#define TIMER2_PRESCALER ADDR(0x4000a510)
#define TIMER2_CC       ARRAY(0x4000a540)

#define TIMER_COMPARE0_CLEAR 0
#define TIMER_INT_COMPARE0 16
#define TIMER_Mode_Timer 0
#define TIMER_Mode_Counter 1
#define TIMER_16Bit 0
#define TIMER_32Bit 3

/* I2C -- Interface 0 */
#define I2C_STARTRX    ADDR(0x40003000)
#define I2C_STARTTX    ADDR(0x40003008)
#define I2C_STOP       ADDR(0x40003014)
#define I2C_SUSPEND    ADDR(0x4000301c)
#define I2C_RESUME     ADDR(0x40003020)
#define I2C_STOPPED    ADDR(0x40003104)
#define I2C_RXDREADY   ADDR(0x40003108)
#define I2C_TXDSENT    ADDR(0x4000311c)
#define I2C_ERROR      ADDR(0x40003124)
#define I2C_BYTEBDRY   ADDR(0x40003138)
#define I2C_SUSPENDED  ADDR(0x40003148)
#define I2C_SHORTS     ADDR(0x40003200)
#define I2C_INTENSET   ADDR(0x40003304)
#define I2C_INTENCLR   ADDR(0x40003308)
#define I2C_ERRORSRC   ADDR(0x400034c4)
#define I2C_ENABLE     ADDR(0x40003500)
#define I2C_PSELSCL    ADDR(0x40003508)
#define I2C_PSELSDA    ADDR(0x4000350c)
#define I2C_RXD        ADDR(0x40003518)
#define I2C_TXD        ADDR(0x4000351c)
#define I2C_FREQUENCY  ADDR(0x40003524)
#define I2C_ADDRESS    ADDR(0x40003588)
#define I2C_POWER      ADDR(0x40003ffc)

// Shortcuts
#define I2C_BB_SUSPEND 0
#define I2C_BB_STOP 1

// Interrupt sources
#define I2C_INT_STOPPED 1
#define I2C_INT_RXDREADY 2
#define I2C_INT_TXDSENT 7
#define I2C_INT_ERROR 9
#define I2C_INT_BYTEBDRY 14

#define I2C_Enabled 0x5
#define I2C_FREQ_100kHz 0x01980000

// Errors
#define I2C_ERROR_OVERRUN 0
#define I2C_ERROR_ANACK 1
#define I2C_ERROR_DNACK 2
#define I2C_ERROR_ALL 0x7

/* Temperature sensor */
#define TEMP_START     ADDR(0x4000C000)
#define TEMP_STOP      ADDR(0x4000C004)
#define TEMP_DATARDY   ADDR(0x4000C100)
#define TEMP_INTEN     ADDR(0x4000C300)
#define TEMP_INTENSET  ADDR(0x4000C304)
#define TEMP_INTENCLR  ADDR(0x4000C308)
#define TEMP_TEMP      ADDR(0x4000C508)

#define TEMP_INT_DATARDY 0

/* Radio */
#define RADIO_TXEN     ADDR(0x40001000)
#define RADIO_RXEN     ADDR(0x40001004)
#define RADIO_START    ADDR(0x40001008)
#define RADIO_STOP     ADDR(0x4000100c)
#define RADIO_DISABLE  ADDR(0x40001010)
#define RADIO_RSSISTART  ADDR(0x40001014)
#define RADIO_RSSISTOP   ADDR(0x40001018)
#define RADIO_BCSTART  ADDR(0x4000101c)
#define RADIO_BCSTOP   ADDR(0x40001020)

#define RADIO_READY    ADDR(0x40001100)
#define RADIO_ADDRESS  ADDR(0x40001104)
#define RADIO_PAYLOAD  ADDR(0x40001108)
#define RADIO_END      ADDR(0x4000110c)
#define RADIO_DISABLED ADDR(0x40001110)
#define RADIO_DEVMATCH ADDR(0x40001114)
#define RADIO_DEVMISS  ADDR(0x40001118)
#define RADIO_RSSIEND  ADDR(0x4000111c)
#define RADIO_BCMATCH  ADDR(0x40001128)

#define RADIO_SHORTS   ADDR(0x40001200)
#define RADIO_INTENSET ADDR(0x40001304)
#define RADIO_INTENCLR ADDR(0x40001308)
#define RADIO_INT_READY 0
#define RADIO_INT_END 3
#define RADIO_INT_DISABLED 4
#define RADIO_CRCSTATUS ADDR(0x40001400)
#define RADIO_RXMATCH  ADDR(0x40001408)
#define RADIO_RXCRC    ADDR(0x4000140c)
#define RADIO_DAI      ADDR(0x40001410)
#define RADIO_PACKETPTR ADDR(0x40001504)
#define RADIO_FREQUENCY ADDR(0x40001508)
#define RADIO_TXPOWER  ADDR(0x4000150c)
#define RADIO_MODE     ADDR(0x40001510)
#define RADIO_MODE_NRF_1Mbit 0
#define RADIO_PCNF0    ADDR(0x40001514)
#define RADIO_PCNF1    ADDR(0x40001518)
#define RADIO_PCNF1_WHITEEN 25
#define RADIO_PCNF1_BALEN_Pos 16
#define RADIO_PCNF1_BALEN_Wid 3
#define RADIO_PCNF1_MAXLEN_Pos 0
#define RADIO_PCNF1_MAXLEN_Wid 8
#define RADIO_PCNF1_STATLEN_Pos 8
#define RADIO_PCNF1_STATLEN_Wid 8
#define RADIO_BASE0    ADDR(0x4000151c)
#define RADIO_BASE1    ADDR(0x40001520)
#define RADIO_PREFIX0  ADDR(0x40001524)
#define RADIO_PREFIX1  ADDR(0x40001528)
#define RADIO_TXADDRESS ADDR(0x4000152c)
#define RADIO_RXADDRESSES ADDR(0x40001530)
#define RADIO_CRCCNF   ADDR(0x40001534)
#define RADIO_CRCPOLY  ADDR(0x40001538)
#define RADIO_CRCINIT  ADDR(0x4000153c)
#define RADIO_TEST     ADDR(0x40001540)
#define RADIO_TIFS     ADDR(0x40001544)
#define RADIO_RSSISAMPLE ADDR(0x40001548)
#define RADIO_STATE    ADDR(0x40001550)
#define RADIO_DATAWHITEIV ADDR(0x40001554)
#define RADIO_BCC      ADDR(0x40001560)
#define RADIO_DAB     ARRAY(0x40001600)
#define RADIO_DAP     ARRAY(0x40001620)
#define RADIO_DACNF    ADDR(0x40001640)
#define RADIO_OVERRIDE ARRAY(0x40001724)
#define RADIO_POWER    ADDR(0x40001ffc)

/* ADC */
#define ADC_START      ADDR(0x40007000)
#define ADC_STOP       ADDR(0x40007004)

#define ADC_END        ADDR(0x40007100)

#define ADC_INTEN      ADDR(0x40007300)
#define ADC_INTENSET   ADDR(0x40007304)
#define ADC_INTENCLR   ADDR(0x40007308)
#define  ADC_INT_END 0
#define ADC_BUSY       ADDR(0x40007400)
#define ADC_ENABLE     ADDR(0x40007500)

#define ADC_CONFIG     ADDR(0x40007504)
#define ADC_CONFIG_RES_Pos 0
#define ADC_CONFIG_RES_Wid 2
#define  ADC_CONFIG_RES_8Bit 0
#define  ADC_CONFIG_RES_9bit 1
#define  ADC_CONFIG_RES_10bit 2
#define ADC_CONFIG_INPSEL_Pos 2
#define ADC_CONFIG_INPSEL_Wid 3
#define  ADC_CONFIG_INPSEL_AIn_1_1 0
#define  ADC_CONFIG_INPSEL_AIn_2_3 1
#define  ADC_CONFIG_INPSEL_AIn_1_3 2
#define  ADC_CONFIG_INPSEL_Vdd_2_3 5
#define  ADC_CONFIG_INPSEL_Vdd_1_3 6
#define ADC_CONFIG_REFSEL_Pos 5
#define ADC_CONFIG_REFSEL_Wid 2
#define  ADC_CONFIG_REFSEL_BGap 0
#define  ADC_CONFIG_REFSEL_Ext 1
#define  ADC_CONFIG_REFSEL_Vdd_1_2 2
#define  ADC_CONFIG_REFSEL_Vdd_1_3 3
#define ADC_CONFIG_PSEL_Pos 8
#define ADC_CONFIG_PSEL_Wid 8
#define ADC_CONFIG_EXTREFSEL_Pos 16
#define ADC_CONFIG_EXTREFSEL_Wid 2
#define  ADC_CONFIG_EXTREFSEL_Ref0 1
#define  ADC_CONFIG_EXTREFSEL_Ref1 2

#define ADC_RESULT     ADDR(0x40007508)

/* NVIC stuff */

/* irq_priority -- set priority of an IRQ from 0 (highest) to 3 */
void irq_priority(int irq, unsigned priority);

/* enable_irq -- enable interrupts from an IRQ */
void enable_irq(int irq);

/* disable_irq -- disable interrupts from a specific IRQ */
void disable_irq(int irq);

/* clear_pending -- clear pending interrupt from an IRQ */
void clear_pending(int irq);


/* One assembler macro -- forgive me! */
#define pause()         asm volatile ("wfe")

/* OK: three more.  But note that Phos uses lock/unlock in mpx.s */
#define intr_disable()  asm volatile ("cpsid i")
#define intr_enable()   asm volatile ("cpsie i")
#define nop()           asm volatile ("nop")
