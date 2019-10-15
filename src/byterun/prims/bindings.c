#ifdef __OCAML__
#include <caml/mlvalues.h>
#else
#include "../vm/values.h"
#endif

#include "prims.h"
#include "../stdlib/random.h"
#include "../stdlib/trace.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

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


/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

value caml_pic32_set_bit(value reg, value bit) {
  pic32_set_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

value caml_pic32_clear_bit(value reg, value bit) {
  pic32_clear_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

value caml_pic32_read_bit(value reg, value bit) {
  return Val_bool(pic32_read_bit(Int_val(reg), Int_val(bit)));
}

value caml_pic32_delay(value ms) {
  pic32_delay(Int_val(ms));
  return Val_unit;
}


/******************************************************************************/

value caml_pic32_write_register(value reg, value val) {
  pic32_write_register(Int_val(reg), Int_val(val));
  return Val_unit;
}

value caml_avr_read_register(value reg) {
  return Val_int(avr_read_register(Int_val(reg)));
}


/******************************************************************************/
/******************************************************************************/
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
