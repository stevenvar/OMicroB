#include "../vm/values.h"
#include "prims.h"
#include "../stdlib/random.h"
#include "../stdlib/trace.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

val_t caml_avr_set_bit(val_t reg, val_t bit) {
  avr_set_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

val_t caml_avr_clear_bit(val_t reg, val_t bit) {
  avr_clear_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

val_t caml_avr_read_bit(val_t reg, val_t bit) {
  return Val_bool(avr_read_bit(Int_val(reg), Int_val(bit)));
}

/******************************************************************************/

val_t caml_avr_write_register(val_t reg, val_t val) {
  avr_write_register(Int_val(reg), Int_val(val));
  return Val_unit;
}

val_t caml_avr_read_register(val_t reg) {
  return Val_int(avr_read_register(Int_val(reg)));
}

/******************************************************************************/

val_t caml_random_init(val_t n) {
  random_init(Int_val(n));
  return Val_unit;
}

val_t caml_random_bits(val_t bound) {
  return Int_val(random_bits(Val_int(bound)));
}

val_t caml_random_bool(val_t unit) {
  return Val_bool(random_bool());
}

/******************************************************************************/

val_t caml_debug_trace(val_t msg) {
  debug_trace(String_val(msg));
  return Val_unit;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
