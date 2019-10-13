#include "hardware.h"
#include "microbitlib.h"

#define TICK 5               /* One timer interrupt per 5 millisec */

void init_timer(void) {
  TIMER1_STOP = 1;
  TIMER1_MODE = TIMER_Timer_Mode;
  TIMER1_BITMODE = TIMER_16Bit;
  TIMER1_PRESCALER = 4;      // 1MHz = 16MHz / 2^4
  TIMER1_CLEAR = 1;
  TIMER1_CC[0] = 1000 * TICK;
  TIMER1_SHORTS = BIT(TIMER_COMPARE0_CLEAR);
  TIMER1_INTENSET = BIT(TIMER_INTEN_COMPARE0);
  TIMER1_START = 1;

  set_priority(TIMER1_IRQ, 3);
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

/* delay -- pause for n milliseconds */
void microbit_delay(int ms) {
  unsigned t = (ms * 1000) << 1;
  while (t > 0) {
    // 500nsec per iteration at 16MHz
    nop(); nop(); nop();
    t--;
  }
}

static long millis = 0;

int microbit_millis() {
  return millis;
}

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
    millis += TICK;
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

void microbit_print_string(char *str) {
  // uBit.display.scroll(str);
  // TODO
}

void microbit_print_int(int i) {
  // uBit.display.scroll(i);
  // TODO
}

int microbit_button_is_pressed(int b) {
  if(b == 0) return (GPIO_IN & BIT(BUTTON_A)) > 127 ? 0 : 1;
  return (GPIO_IN & BIT(BUTTON_B)) > 127 ? 0 : 1;
}

void microbit_pin_mode(int p, int m) {
  GPIO_PINCNF[pins[p]] = m;
}

void microbit_digital_write(int p, int l) {
  if(l == 0) CLR_BIT(GPIO_OUT, pins[p]);
  else SET_BIT(GPIO_OUT, pins[p]);
}

int microbit_digital_read(int p) {
  return GPIO_IN & BIT(pins[p]);
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

void microbit_serial_write_char(char ch) {
  if (! txinit) {
    while (! UART_TXDRDY) { }
  }
  txinit = 0;
  UART_TXDRDY = 0;
  UART_TXD = ch;
}

char microbit_serial_read_char() {
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
