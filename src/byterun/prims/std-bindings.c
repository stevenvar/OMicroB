#include <caml/mlvalues.h>
#include "prims.h"

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

/******************************************************************************/

value caml_avr_write_register(value reg, value val) {
  avr_write_register(Int_val(reg), Int_val(val));
  return Val_unit;
}

value caml_avr_read_register(value reg) {
  return Val_int(avr_read_register(Int_val(reg)));
}

/* value caml_buffer_write(int x, int y, int color){ */
/*   return Val_unit; */
/* } */

/* value caml_buffer_read(int x, int y){ */
/*   return Val_int(0); */
/* } */

/* value caml_buffer_get_byte(){ */
/*   return Val_unit; */
/* } */

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
