/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#if defined(__OCAML__) || defined(__PC__) || defined(__MICROBIT__)

#include "prims.h"

value caml_microbit_print_string(value s) {
  #ifdef __OCAML__
  microbit_print_string(String_val(s));
  #else
  int n = string_length(s); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(s, i);
  buf[n] = '\0';
  microbit_print_string(buf);
  #endif
  return Val_unit;
}

value caml_microbit_write_pixel(value x, value y, value l) {
  microbit_write_pixel(Int_val(x), Int_val(y), Int_val(l)*255);
  return Val_unit;
}

value caml_microbit_print_image(value s) {
  #ifdef __OCAML__
  microbit_print_image(String_val(s));
  #else
  int n = string_length(s); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(s, i);
  buf[n] = '\0';
  microbit_print_image(buf);
  #endif
  return Val_unit;
}

value caml_microbit_clear_screen() {
  microbit_clear_screen();
  return Val_unit;
}

value caml_microbit_button_is_pressed(value b) {
  return Val_bool(microbit_button_is_pressed(Int_val(b)));
}

value caml_microbit_pin_mode(value p, value m) {
  microbit_pin_mode(Int_val(p), Int_val(m));
  return Val_unit;
}

value caml_microbit_digital_write(value p, value l) {
  microbit_digital_write(Int_val(p), Int_val(l));
  return Val_unit;
}

value caml_microbit_digital_read(value p) {
  return Val_bool(microbit_digital_read(Int_val(p)));
}

value caml_microbit_analog_write(value p, value l) {
  microbit_analog_write(Int_val(p), Int_val(l));
  return Val_unit;
}

value caml_microbit_analog_read(value p) {
  return Val_int(microbit_analog_read(Int_val(p)));
}

/******************************************************************************/

value caml_microbit_serial_write(value c) {
  microbit_serial_write((char) Int_val(c));
  return Val_unit;
}

value caml_microbit_serial_read() {
  return Val_int(microbit_serial_read());
}

/******************************************************************************/

value caml_microbit_accelerometer_x() {
  return Val_int(microbit_accelerometer_x());
}

value caml_microbit_accelerometer_y() {
  return Val_int(microbit_accelerometer_y());
}

value caml_microbit_accelerometer_z() {
  return Val_int(microbit_accelerometer_z());
}

value caml_microbit_accelerometer_pitch() {
  return Val_int(microbit_accelerometer_pitch());
}

value caml_microbit_accelerometer_roll() {
  return Val_int(microbit_accelerometer_roll());
}

/******************************************************************************/

value caml_microbit_compass_calibrate() {
  microbit_compass_calibrate();
  return Val_unit;
}

value caml_microbit_compass_heading() {
  return Val_int(microbit_compass_heading());
}

/******************************************************************************/

value caml_microbit_radio_init() {
  microbit_radio_init();
  return Val_unit;
}

value caml_microbit_radio_send(value s) {
#ifdef __OCAML__
  microbit_radio_send(String_val(s));
#else
  int n = string_length(s);
  char buf[n+1];
  memcpy(buf, Ram_string_val(s), n);
  buf[n] = '\0';
  microbit_radio_send(buf);
#endif
  return Val_unit;
}

value caml_microbit_radio_recv() {
#ifdef __OCAML__
  return alloc_string(0);
#else
  const char *buf = microbit_radio_recv();
  return copy_bytes(buf);
#endif
}

/******************************************************************************/

value caml_microbit_i2c_init() {
  microbit_i2c_init();
  return Val_unit;
}

value caml_microbit_i2c_write(value a, value s) {
#ifdef __OCAML__
  microbit_i2c_write(a, String_val(s), string_length(s));
#else
  int n = string_length(s);
  microbit_i2c_write(a, (const char *)Ram_string_val(s), n);
#endif
  return Val_unit;
}

value caml_microbit_i2c_read(value a) {
#ifdef __OCAML__
  return caml_alloc_string(0);
#else
  char buf[32];
  int l = microbit_i2c_read(a, buf);
  value s = create_bytes(l);
  memcpy(Ram_string_val(s), buf, l);
  return s;
#endif
}

/******************************************************************************/

value caml_microbit_spi_init_master() {
  microbit_spi_init();
  return Val_unit;
}

value caml_microbit_spi_transmit(value c) {
  return Val_int(microbit_spi_transmit(Int_val(c)));
}

#endif
