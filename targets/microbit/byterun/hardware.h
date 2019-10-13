// hardware.h
// Copyright (c) 2018 J. M. Spivey

#define BIT(i) (1 << (i))

#define SET_BIT(reg, n) reg |= BIT(n)
#define CLR_BIT(reg, n) reg &= ~BIT(n)

#define SET_FIELD(reg, field, val) \
     reg = (reg & ~field##_Msk) | ((val) << field##_Pos)

#define SET_BYTE(reg, n, v) \
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

static int pins[6] = {
  PIN0,
  PIN1,
  PIN2,
  PIN8,
  PIN12,
  PIN16
};

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

#define SVC_IRQ -5
#define PENDSV_IRQ -2
#define UART_IRQ 2
#define I2C_IRQ 3
#define TIMER1_IRQ 9


/* System registers */

#define SCB_SHPR      ARRAY(0xE000ED1C)
#define SCB_ICSR       ADDR(0xE000ED04)
#define NVIC_ISER     ARRAY(0xE000E100)
#define NVIC_ICER     ARRAY(0xE000E180)
#define NVIC_ISPR     ARRAY(0xE000E200)
#define NVIC_ICPR     ARRAY(0xE000E280)
#define NVIC_IPR      ARRAY(0xE000E400)

#define POWER_RAMON    ADDR(0x40000524)

#define CLOCK_LFCLKSRC  ADDR(0x40000518)
#define CLOCK_LFCLKSTARTED ADDR(0x40000104)
#define CLOCK_LFCLKSTART ADDR(0x40000008)

#define LFCLKSRC_RC 0

#define MPU_DISABLEINDEBUG ADDR(0x40000608)
#define PENDSV 28           // Bit in SCB_ICSR


/* GPIO */

#define GPIO_OUT       ADDR(0x50000504)
#define GPIO_OUTSET    ADDR(0x50000508)
#define GPIO_OUTCLR    ADDR(0x5000050c)
#define GPIO_IN        ADDR(0x50000510)
#define GPIO_DIR       ADDR(0x50000514)
#define GPIO_DIRSET    ADDR(0x50000518)
#define GPIO_DIRCLR    ADDR(0x5000051c)
#define GPIO_PINCNF   ARRAY(0x50000700)

#define GPIO_PINCNF_PULL_Pos 2
#define GPIO_PINCNF_PULL_Msk (0x3 << 2)
#define GPIO_Pullup 0x3

#define GPIO_PINCNF_DRIVE_Pos 8
#define GPIO_PINCNF_DRIVE_Msk (0x7 << 8)
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


/* TIMER1 */

#define TIMER1_START   ADDR(0x40009000)
#define TIMER1_STOP    ADDR(0x40009004)
#define TIMER1_COUNT   ADDR(0x40009008)
#define TIMER1_CLEAR   ADDR(0x4000900c)
#define TIMER1_SHUTDOWN ADDR(0x40009010)
#define TIMER1_CAPTURE ARRAY(0x40009040)
#define TIMER1_COMPARE ARRAY(0x40009140)
#define TIMER1_SHORTS  ADDR(0x40009200)
#define TIMER1_INTENSET ADDR(0x40009304)
#define TIMER1_INTENCLR ADDR(0x40009308)
#define TIMER1_MODE     ADDR(0x40009504)
#define TIMER1_BITMODE  ADDR(0x40009508)
#define TIMER1_PRESCALER ADDR(0x40009510)
#define TIMER1_CC       ARRAY(0x40009540)

#define TIMER_COMPARE0_CLEAR 0
#define TIMER_INTEN_COMPARE0 16
#define TIMER_Timer_Mode 0
#define TIMER_16Bit 0


/* I2C */

// We use TWI0 and call it I2C

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


/* NVIC stuff */

/* set_priority -- set priority of an IRQ from 0 (highest) to 3 */
void set_priority(int irq, unsigned priority);

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
