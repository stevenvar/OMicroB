#ifdef __OCAML__
#include <caml/mlvalues.h>
#else
#include "../vm/values.h"
#endif

#include "prims.h"
#include "../stdlib/random.h"
#include "../stdlib/trace.h"

/******************************************************************************/

value caml_random_init(value n) {
  random_init(Int_val(n));
  return Val_unit;
}

value caml_random_bits(value bound) {
  return Val_int(random_bits((uint32_t) Int_val(bound)));
}

value caml_random_bool(value unit) {
  return Val_bool(random_bool());
}

/******************************************************************************/

value caml_unsafe_string_of_bytes(value b) {
  return b;
}

value caml_unsafe_bytes_of_string(value s) {
  return s;
}

/******************************************************************************/

#ifdef __OCAML__
#define String_field(val, i) String_val(val)[i]
#endif

value caml_debug_trace(value msg) {
  mlsize_t sz = string_length(msg);
  mlsize_t i;
  debug_trace_open();
  for (i = 0; i < sz; i ++) {
    debug_trace_char(String_field(msg, i));
  }
  debug_trace_close();
  return Val_unit;
}

value caml_debug_tracei(value n) {
  debug_trace_int(Int_val(n));
  return Val_unit;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#if defined(__AVR__) || defined(__OCAML__) || defined(__PC__)

value caml_avr_set_bit(value reg, value bit) {
  avr_set_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

value caml_avr_clear_bit(value reg, value bit) {
  avr_clear_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

value caml_avr_read_bit(value reg, value bit) {
  return Val_bool(avr_read_bit(Int_val(reg), Int_val(bit)));
}

value caml_avr_delay(value ms) {
  avr_delay(Int_val(ms));
  return Val_unit;
}

value caml_avr_millis(value unit) {
  return Val_int(avr_millis());
}

/******************************************************************************/

value caml_avr_write_register(value reg, value val) {
  avr_write_register(Int_val(reg), Int_val(val));
  return Val_unit;
}

value caml_avr_read_register(value reg) {
  return Val_int(avr_read_register(Int_val(reg)));
}

/******************************************************************************/

value caml_avr_adc_init(value unit){
  avr_adc_init();
  return Val_unit;
}

value caml_avr_analog_read(value channel){
  return Val_int(avr_analog_read(Int_val(channel)));
}


/******************************************************************************/


value caml_avr_serial_init(value unit){
  avr_serial_init();
  return Val_unit;
}

value caml_avr_serial_write(value val){
  avr_serial_write(Int_val(val));
  return Val_unit;
}


value caml_avr_serial_read(value unit){
  return Val_int(avr_serial_read());
}

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#if defined(__MICROBIT__) || defined(__OCAML__) || defined(__PC__)

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

value caml_microbit_delay(value ms) {
  microbit_delay(Int_val(ms));
  return Val_unit;
}

value caml_microbit_millis() {
  return Val_int(microbit_millis());
}

/******************************************************************************/

value caml_microbit_serial_write_char(value c) {
  microbit_serial_write_char((char) Int_val(c));
  return Val_unit;
}

value caml_microbit_serial_read_char() {
  return Val_int(microbit_serial_read_char());
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

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
