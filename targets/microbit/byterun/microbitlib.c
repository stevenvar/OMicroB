#include <stdint.h>
#include <stdbool.h>
#include "hardware.h"
#include "microbitlib.h"

#define TICK 5               /* One timer interrupt per 5 millisec */

void init_timer(void) {
  TIMER1_STOP = 1;
  TIMER1_MODE = TIMER_Mode_Timer;
  TIMER1_BITMODE = TIMER_16Bit;
  TIMER1_PRESCALER = 4;      // 1MHz = 16MHz / 2^4
  TIMER1_CLEAR = 1;
  TIMER1_CC[0] = 1000 * TICK;
  TIMER1_SHORTS = BIT(TIMER_COMPARE0_CLEAR);
  TIMER1_INTENSET = BIT(TIMER_INT_COMPARE0);
  TIMER1_START = 1;

  irq_priority(TIMER1_IRQ, 3);
  enable_irq(TIMER1_IRQ);
}

static int txinit;

void serial_init(void) {
  GPIO_DIRSET = BIT(USB_TX);
  GPIO_DIRCLR = BIT(USB_RX);
  SET_FIELD(GPIO_PINCNF[USB_TX], GPIO_PINCNF_PULL, GPIO_Pullup);
  SET_FIELD(GPIO_PINCNF[USB_RX], GPIO_PINCNF_PULL, GPIO_Pullup);

  UART_BAUDRATE = UART_BAUD_9600;     // 9600 baud
  UART_CONFIG = 0;                    // format 8N1
  UART_PSELTXD = USB_TX;              // choose pins
  UART_PSELRXD = USB_RX;
  UART_ENABLE = UART_Enabled;
  UART_STARTTX = 1;
  UART_STARTRX = 1;
  UART_RXDRDY = 0;
  txinit = 1;
}

void microbit_init() {
  GPIO_DIR = 0xfff0;
  GPIO_PINCNF[BUTTON_A] = 0;
  GPIO_PINCNF[BUTTON_B] = 0;

  init_timer();
  serial_init();
}

/******************************************************************************/

volatile uint8_t *get_reg_addr(uint8_t reg) {
  // TODO
  return 0;
}

void set_bit(uint8_t reg, uint8_t bit) {
  SET_BIT(*(get_reg_addr(reg)), bit);
}

void clear_bit(uint8_t reg, uint8_t bit) {
  CLR_BIT(*(get_reg_addr(reg)), bit);
}

bool read_bit(uint8_t reg, uint8_t bit) {
  return READ_BIT(*(get_reg_addr(reg)), bit);
}

void write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
}

/******************************************************************************/

/* delay -- pause for n milliseconds */
void delay(int ms) {
  unsigned t = (ms * 1000) << 1;
  while (t > 0) {
    // 500nsec per iteration at 16MHz
    nop(); nop(); nop();
    t--;
  }
}

static long mils = 0;

int millis() {
  return mils;
}

/******************************************************************************/

// Current content of the screen
unsigned screenContent[] = { (1<<13)+(1<<13)-1, (1<<14)+(1<<13)-1, (1<<15)+(1<<13)-1 };
unsigned row = 0;

#define SCREEN_MASK (BIT(4)|BIT(5)|BIT(6)|BIT(7)|BIT(8)|BIT(9)|BIT(10)|BIT(11)|BIT(12)|BIT(13)|BIT(14)|BIT(15))

void advance_display() {
  row++; row = row % 3;
  GPIO_OUT &= ~SCREEN_MASK;
  GPIO_OUT |= (screenContent[row]&SCREEN_MASK);
}

// Timer1 handling.
// Timer1 is used to keep track of time and to refresh the screen
void timer1_handler(void) {
  if (TIMER1_COMPARE[0]) {
    advance_display();
    mils += TICK;
    TIMER1_COMPARE[0] = 0;
  }
}

static int rowMatrix[5][5] =
  {{0,1,0,1,0},
   {2,2,2,2,2},
   {1,0,1,2,1},
   {0,0,0,0,0},
   {2,1,2,1,2}};

static int offMatrix[5][5] =
  {{0,3,1,4,2},
   {3,4,5,6,7},
   {1,8,2,8,0},
   {7,6,5,4,3},
   {2,6,0,5,1}};

void microbit_write_pixel(int x, int y, int l) {
  if(l > 127) {
    screenContent[rowMatrix[y][x]] &= ~(1<<(offMatrix[y][x]+4));
  } else {
    screenContent[rowMatrix[y][x]] |= (1<<(offMatrix[y][x]+4));
  }
}

void microbit_print_image(char *s) {
  microbit_write_pixel(0,0,255);
  for(int y = 0; y < 5; y++) {
    for(int x = 0; x < 5; x++) {
      microbit_write_pixel(x, y, (int) s[y*5+x]);
    }
  }
}

void microbit_clear_screen() {
  for(int y = 0; y < 5; y++) {
    for(int x = 0; x < 5; x++) {
      microbit_write_pixel(x, y, 0);
    }
  }
}

// Taken from microbit-dal
static const unsigned char pendolino3[475] = {
0x0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x8, 0x8, 0x0, 0x8, 0xa, 0x4a, 0x40, 0x0, 0x0, 0xa, 0x5f, 0xea, 0x5f, 0xea, 0xe, 0xd9, 0x2e, 0xd3, 0x6e, 0x19, 0x32, 0x44, 0x89, 0x33, 0xc, 0x92, 0x4c, 0x92, 0x4d, 0x8, 0x8, 0x0, 0x0, 0x0, 0x4, 0x88, 0x8, 0x8, 0x4, 0x8, 0x4, 0x84, 0x84, 0x88, 0x0, 0xa, 0x44, 0x8a, 0x40, 0x0, 0x4, 0x8e, 0xc4, 0x80, 0x0, 0x0, 0x0, 0x4, 0x88, 0x0, 0x0, 0xe, 0xc0, 0x0, 0x0, 0x0, 0x0, 0x8, 0x0, 0x1, 0x22, 0x44, 0x88, 0x10, 0xc, 0x92, 0x52, 0x52, 0x4c, 0x4, 0x8c, 0x84, 0x84, 0x8e, 0x1c, 0x82, 0x4c, 0x90, 0x1e, 0x1e, 0xc2, 0x44, 0x92, 0x4c, 0x6, 0xca, 0x52, 0x5f, 0xe2, 0x1f, 0xf0, 0x1e, 0xc1, 0x3e, 0x2, 0x44, 0x8e, 0xd1, 0x2e, 0x1f, 0xe2, 0x44, 0x88, 0x10, 0xe, 0xd1, 0x2e, 0xd1, 0x2e, 0xe, 0xd1, 0x2e, 0xc4, 0x88, 0x0, 0x8, 0x0, 0x8, 0x0, 0x0, 0x4, 0x80, 0x4, 0x88, 0x2, 0x44, 0x88, 0x4, 0x82, 0x0, 0xe, 0xc0, 0xe, 0xc0, 0x8, 0x4, 0x82, 0x44, 0x88, 0xe, 0xd1, 0x26, 0xc0, 0x4, 0xe, 0xd1, 0x35, 0xb3, 0x6c, 0xc, 0x92, 0x5e, 0xd2, 0x52, 0x1c, 0x92, 0x5c, 0x92, 0x5c, 0xe, 0xd0, 0x10, 0x10, 0xe, 0x1c, 0x92, 0x52, 0x52, 0x5c, 0x1e, 0xd0, 0x1c, 0x90, 0x1e, 0x1e, 0xd0, 0x1c, 0x90, 0x10, 0xe, 0xd0, 0x13, 0x71, 0x2e, 0x12, 0x52, 0x5e, 0xd2, 0x52, 0x1c, 0x88, 0x8, 0x8, 0x1c, 0x1f, 0xe2, 0x42, 0x52, 0x4c, 0x12, 0x54, 0x98, 0x14, 0x92, 0x10, 0x10, 0x10, 0x10, 0x1e, 0x11, 0x3b, 0x75, 0xb1, 0x31, 0x11, 0x39, 0x35, 0xb3, 0x71, 0xc, 0x92, 0x52, 0x52, 0x4c, 0x1c, 0x92, 0x5c, 0x90, 0x10, 0xc, 0x92, 0x52, 0x4c, 0x86, 0x1c, 0x92, 0x5c, 0x92, 0x51, 0xe, 0xd0, 0xc, 0x82, 0x5c, 0x1f, 0xe4, 0x84, 0x84, 0x84, 0x12, 0x52, 0x52, 0x52, 0x4c, 0x11, 0x31, 0x31, 0x2a, 0x44, 0x11, 0x31, 0x35, 0xbb, 0x71, 0x12, 0x52, 0x4c, 0x92, 0x52, 0x11, 0x2a, 0x44, 0x84, 0x84, 0x1e, 0xc4, 0x88, 0x10, 0x1e, 0xe, 0xc8, 0x8, 0x8, 0xe, 0x10, 0x8, 0x4, 0x82, 0x41, 0xe, 0xc2, 0x42, 0x42, 0x4e, 0x4, 0x8a, 0x40, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1f, 0x8, 0x4, 0x80, 0x0, 0x0, 0x0, 0xe, 0xd2, 0x52, 0x4f, 0x10, 0x10, 0x1c, 0x92, 0x5c, 0x0, 0xe, 0xd0, 0x10, 0xe, 0x2, 0x42, 0x4e, 0xd2, 0x4e, 0xc, 0x92, 0x5c, 0x90, 0xe, 0x6, 0xc8, 0x1c, 0x88, 0x8, 0xe, 0xd2, 0x4e, 0xc2, 0x4c, 0x10, 0x10, 0x1c, 0x92, 0x52, 0x8, 0x0, 0x8, 0x8, 0x8, 0x2, 0x40, 0x2, 0x42, 0x4c, 0x10, 0x14, 0x98, 0x14, 0x92, 0x8, 0x8, 0x8, 0x8, 0x6, 0x0, 0x1b, 0x75, 0xb1, 0x31, 0x0, 0x1c, 0x92, 0x52, 0x52, 0x0, 0xc, 0x92, 0x52, 0x4c, 0x0, 0x1c, 0x92, 0x5c, 0x90, 0x0, 0xe, 0xd2, 0x4e, 0xc2, 0x0, 0xe, 0xd0, 0x10, 0x10, 0x0, 0x6, 0xc8, 0x4, 0x98, 0x8, 0x8, 0xe, 0xc8, 0x7, 0x0, 0x12, 0x52, 0x52, 0x4f, 0x0, 0x11, 0x31, 0x2a, 0x44, 0x0, 0x11, 0x31, 0x35, 0xbb, 0x0, 0x12, 0x4c, 0x8c, 0x92, 0x0, 0x11, 0x2a, 0x44, 0x98, 0x0, 0x1e, 0xc4, 0x88, 0x1e, 0x6, 0xc4, 0x8c, 0x84, 0x86, 0x8, 0x8, 0x8, 0x8, 0x8, 0x18, 0x8, 0xc, 0x88, 0x18, 0x0, 0x0, 0xc, 0x83, 0x60};

void microbit_print_string(char *str) {
  for(; *str != '\0'; str++) {
    int start = (*str-32)*5;
    for(int i = start; i < start+5; i++) {
      unsigned char c = pendolino3[i];
      microbit_write_pixel(0, i-start, (c&0x10)*255);
      microbit_write_pixel(1, i-start, (c&0x08)*255);
      microbit_write_pixel(2, i-start, (c&0x04)*255);
      microbit_write_pixel(3, i-start, (c&0x02)*255);
      microbit_write_pixel(4, i-start, (c&0x01)*255);
    }
    delay(300);
  }
  microbit_clear_screen();
}

int microbit_button_is_pressed(int b) {
  if(b == 0) return (GPIO_IN & BIT(BUTTON_A)) > 127 ? 0 : 1;
  return (GPIO_IN & BIT(BUTTON_B)) > 127 ? 0 : 1;
}

/******************************************************************************/

static int pins[6] =
  { PIN0,
    PIN1,
    PIN2,
    PIN8,
    PIN12,
    PIN16 };

void microbit_pin_mode(int p, int m) {
  GPIO_PINCNF[pins[p]] = m;
}

void microbit_digital_write(int p, int l) {
  if(l == 0) CLR_BIT(GPIO_OUT, pins[p]);
  else SET_BIT(GPIO_OUT, pins[p]);
}

int microbit_digital_read(int p) {
  return READ_BIT(GPIO_IN, BIT(pins[p]));
}

void microbit_analog_write(int p, int l) {
  // uBit.io.pin[p].setAnalogValue(l);
  // TODO
}

int microbit_analog_read(int p) {
  // return uBit.io.pin[p].getAnalogValue();
  // TODO
  return 0;
}

/******************************************************************************/

void microbit_serial_write(char ch) {
  if (! txinit) {
    while (! UART_TXDRDY) { }
  }
  txinit = 0;
  UART_TXDRDY = 0;
  UART_TXD = ch;
}

char microbit_serial_read() {
  while (! UART_RXDRDY) { }
  char ch = UART_RXD;
  UART_RXDRDY = 0;
  return ch;
}

/******************************************************************************/

int microbit_accelerometer_x() {
  // return uBit.accelerometer.getX();
  // TODO
  return 0;
}

int microbit_accelerometer_y() {
  // return uBit.accelerometer.getY();
  // TODO
  return 0;
}

int microbit_accelerometer_z() {
  // return uBit.accelerometer.getZ();
  // TODO
  return 0;
}

int microbit_accelerometer_pitch() {
  // return uBit.accelerometer.getPitch();
  // TODO
  return 0;
}

int microbit_accelerometer_roll() {
  // return uBit.accelerometer.getRoll();
  // TODO
  return 0;
}

void microbit_compass_calibrate() {
  // uBit.compass.calibrate();
  // TODO
}

int microbit_compass_heading() {
  // return uBit.compass.heading();
  // TODO
  return 0;
}

/******************************************************************************/

char *radBuffer;

void microbit_radio_init() {
  // uBit.radio.enable();
  // radBuffer = (char *) malloc(32*sizeof(char));
  // TODO
}

void microbit_radio_send(char *s) {
  // uBit.radio.datagram.send(s);
  // TODO
}

const char *microbit_radio_recv() {
  // PacketBuffer b = uBit.radio.datagram.recv();
  // if(b.length() < 1) return "";
  // ManagedString mn = ManagedString(b);
  // return mn.toCharArray();
  // TODO
  return 0;
}

/******************************************************************************/

// MicroBitI2C *i2c = nullptr;

void microbit_i2c_init() {
  // if(i2c == nullptr) i2c = new MicroBitI2C(I2C_SDA0, I2C_SCL0);
  // i2c->frequency(400000);
  // TODO
}

void microbit_i2c_write(int a, const char *buf, int l) {
  // if(i2c == nullptr) microbit_i2c_init();
  // i2c->write(a, buf, l);
  // TODO
}

int microbit_i2c_read(int a, char *buf) {
  // int res = i2c->read(a, buf, 32);
  // if(res == MICROBIT_I2C_ERROR) return 0;
  // return strlen(buf);
  // TODO
  return 0;
}

/******************************************************************************/

// SPI *spi;

void microbit_spi_init() {
  // spi = new SPI(MOSI, MISO, SCK);
  // spi->format(8,0);
  // TODO
}

char microbit_spi_transmit(char c) {
  // return spi->write(c);
  // TODO
  return 0;
}
