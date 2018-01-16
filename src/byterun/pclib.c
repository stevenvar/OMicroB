
/* #ifdef ARDUBOY_SIMULATOR */

/* #include "arduboy_simulator.h" */

/* val_t caml_avr_set_bit(val_t reg, val_t bit){ */
/*   avr_set_bit(Int_val(reg),Int_val(bit)); */
/*   return Val_unit; */
/* } */

/* val_t caml_avr_clear_bit(val_t reg, val_t bit){ */
/*   avr_clear_bit(Int_val(reg),Int_val(bit)); */
/*   return Val_unit; */
/* } */

/* val_t caml_avr_read_bit(val_t reg, val_t bit){ */
/*   int val = avr_read_bit(Int_val(reg),Int_val(bit)); */
/*   return Val_int(val); */
/* } */

/* val_t caml_avr_write_register(val_t reg, val_t val){ */
/*   avr_write_register(Int_val(reg),Int_val(val)); */
/*   return Val_unit; */
/* } */

/* val_t caml_avr_read_register(val_t reg){ */
/*   int val = avr_read_register(Int_val(reg)); */
/*   return Val_int(val); */
/* } */

/* #else */

#include <stdio.h>

val_t caml_avr_write_register(val_t reg, val_t val){
  printf("caml_avr_write_register(%d,%d)\n",Int_val(reg),Int_val(val));
  return Val_unit;
}

val_t caml_avr_set_bit(val_t reg, val_t bit){
  printf("caml_avr_set_bit(%d,%d)\n",Int_val(reg),Int_val(bit));
  return Val_unit;
}

val_t caml_pin_mode(val_t pin, val_t mode) {
  printf("caml_pin_mode(%d,%d)\n",Int_val(pin),Int_val(mode));
  return Val_unit;
}

val_t caml_avr_port_mode(val_t port, val_t mode){
  printf("caml_port_mode(%d,%d)\n",Int_val(port),Int_val(mode));
  return Val_unit;
}

val_t caml_avr_digital_write(val_t port, val_t mode){
  printf("caml_avr_digital_write(%d,%d)\n",Int_val(port),Int_val(mode));
  return Val_unit;
}

val_t caml_avr_clear_bit(val_t reg, val_t bit){
  printf("caml_avr_clear_bit(%d,%d)\n",Int_val(reg),Int_val(bit));
  return Val_unit;
}


val_t caml_avr_read_bit(val_t reg, val_t bit){
  printf("caml_avr_read_bit(%d,%d)\n",Int_val(reg),Int_val(bit));
  return Val_int(0);
}

val_t caml_avr_read_register(val_t reg){
  printf("caml_avr_read_register(%d)\n",Int_val(reg));
  return Val_int(0xFF);
}


val_t caml_boot_lcd(){
  /* bootLCD(); */
  return Val_unit;
}


val_t ocaml_arduboy_init(val_t unit) {
  return Val_unit;
}

val_t ocaml_arduboy_print(val_t str) {
  return Val_unit;
}

val_t ocaml_arduboy_print_int(val_t i) {
  return Val_unit;
}

val_t ocaml_arduboy_display(val_t unit) {
  return Val_unit;
}
/* #endif */
