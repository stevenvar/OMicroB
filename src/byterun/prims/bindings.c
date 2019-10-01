#ifdef __OCAML__
#include <caml/mlvalues.h>
#else
#include "../vm/values.h"
#endif

#include "prims.h"
#include "../stdlib/random.h"
#include "../stdlib/trace.h"
#include "../stdlib/delay.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#if defined(__OCAML__) || defined(__AVR__) || defined(__PC__)

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
  stdlib_delay(Int_val(ms));
  return Val_unit;
}

value caml_pic32_millis() {
  return Val_int(pic32_millis());
}

/******************************************************************************/

value caml_avr_write_register(value reg, value val) {
  avr_write_register(Int_val(reg), Int_val(val));
  return Val_unit;
}

value caml_avr_read_register(value reg) {
  return Val_int(avr_read_register(Int_val(reg)));
}

#endif

/******************************************************************************/
/******************************************************************************/

#if defined(__OCAML__) || defined(__PIC32__) || defined(__PC__)

value caml_pic32_init(value unit) {
  pic32_init();
  return Val_unit;
}


value caml_pic32_schedule_task(value unit) {
  pic32_schedule_task();
  return Val_unit;
}

value caml_pic32_pin_mode(value pin, value mode) {
  pic32_pin_mode(Int_val(pin), Int_val(mode));
  return Val_unit;
}

value caml_pic32_digital_write(value pin, value level) {
  pic32_digital_write(Int_val(pin), Int_val(level));
  return Val_unit;
}

value caml_pic32_digital_read(value pin) {
  return Val_int(pic32_digital_read(Int_val(pin)));
}

// For lchip only
value caml_lchip_digital_write_lled(value level) {
  lchip_digital_write_lled(Int_val(level));
  return Val_unit;
}

// For lchip only
value caml_lchip_digital_write_rled(value level) {
  lchip_digital_write_rled(Int_val(level));
  return Val_unit;
}

value caml_pic32_analog_write(value pin, value level) {
  pic32_analog_write(Int_val(pin), Int_val(level));
  return Val_unit;
}

value caml_pic32_analog_read(value pin) {
  return Val_int(pic32_analog_read(Int_val(pin)));
}

value caml_pic32_delay(value ms) {
  pic32_delay(Int_val(ms));
  return Val_unit;
}

/******************************************************************************/

value caml_pic32_serial_init() {
  pic32_serial_init();
  return Val_unit;
}

value caml_pic32_serial_write_char(value c) {
  pic32_serial_write_char((char) Int_val(c));
  return Val_unit;
}

value caml_pic32_serial_read_char() {
  return Val_int(pic32_serial_read_char());
}

#endif

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
