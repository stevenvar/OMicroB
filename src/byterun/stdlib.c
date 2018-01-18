/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Binding to arduino libraries */

#include "values.h"
#include "avr.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

val_t caml_avr_set_bit(val_t reg, val_t bit){
  avr_set_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

val_t caml_avr_clear_bit(val_t reg, val_t bit){
  avr_clear_bit(Int_val(reg), Int_val(bit));
  return Val_unit;
}

val_t caml_avr_read_bit(val_t reg, val_t bit){
  return Val_int(avr_read_bit(Int_val(reg), Int_val(bit)));
}

val_t caml_avr_read_register(val_t reg){
  return Val_int(avr_read_register(Int_val(reg)));
}

val_t caml_avr_write_register(val_t reg, val_t val){
  avr_write_register(Int_val(reg), Int_val(val));
  return Val_unit;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
