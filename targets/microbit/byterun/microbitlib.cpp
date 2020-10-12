#include "MicroBit.h"

MicroBit uBit;

void microbit_init() {
  uBit.init();
}

void microbit_delay(int ms) {
  uBit.sleep(ms);
}

int microbit_millis() {
  return uBit.systemTime();
}

void microbit_print_string(char *str) {
  uBit.display.scroll(str);
}

void microbit_print_int(int i) {
  uBit.display.scroll(i);
}

void microbit_write_pixel(int x, int y, int l) {
  uBit.display.image.setPixelValue(x, y, l);
}

void microbit_print_image(char *s) {
  MicroBitImage img(s);
  uBit.display.print(img);
}

void microbit_clear_screen() {
  uBit.display.clear();
}

int microbit_button_is_pressed(int b) {
  if(b == 0) return uBit.buttonA.isPressed();
  return uBit.buttonB.isPressed();
}

void microbit_digital_write(int p, int l) {
  uBit.io.pin[p].setDigitalValue(l);
}

int microbit_digital_read(int p) {
  return uBit.io.pin[p].getDigitalValue();
}

void microbit_analog_write(int p, int l) {
  uBit.io.pin[p].setAnalogValue(l);
}

int microbit_analog_read(int p) {
  return uBit.io.pin[p].getAnalogValue();
}

/******************************************************************************/

void microbit_serial_write_char(char c) {
  uBit.serial.sendChar(c);
}

char microbit_serial_read_char() {
  int r = uBit.serial.read(ASYNC);
  if(r == MICROBIT_NO_DATA) return 0;
  else return (char) r;
}

/******************************************************************************/

int microbit_accelerometer_x() {
  return uBit.accelerometer.getX();
}

int microbit_accelerometer_y() {
  return uBit.accelerometer.getY();
}

int microbit_accelerometer_z() {
  return uBit.accelerometer.getZ();
}

int microbit_accelerometer_pitch() {
  return uBit.accelerometer.getPitch();
}

int microbit_accelerometer_roll() {
  return uBit.accelerometer.getRoll();
}

void microbit_compass_calibrate() {
  uBit.compass.calibrate();
}

int microbit_compass_heading() {
  return uBit.compass.heading();
}

/******************************************************************************/

char *radBuffer;

void microbit_radio_init() {
  uBit.radio.enable();
  radBuffer = (char *) malloc(32*sizeof(char));
}

void microbit_radio_send(char *s) {
  uBit.radio.datagram.send(s);
}

const char *microbit_radio_recv() {
  PacketBuffer b = uBit.radio.datagram.recv();
  if(b.length() < 1) return "";
  ManagedString mn = ManagedString(b);
  return mn.toCharArray();
}

/******************************************************************************/

MicroBitI2C *i2c = nullptr;

void microbit_i2c_init() {
  if(i2c == nullptr) i2c = new MicroBitI2C(I2C_SDA0, I2C_SCL0);
  i2c->frequency(400000);
}

void microbit_i2c_write(int a, const char *buf, int l) {
  if(i2c == nullptr) microbit_i2c_init();
  i2c->write(a, buf, l);
}

int microbit_i2c_read(int a, char *buf) {
  int res = i2c->read(a, buf, 32);
  if(res == MICROBIT_I2C_ERROR) return 0;
  return strlen(buf);
}

/******************************************************************************/

SPI *spi;

void microbit_spi_init() {
  spi = new SPI(MOSI, MISO, SCK);
  spi->format(8,0);
}

char microbit_spi_transmit(char c) {
  return spi->write(c);
}
