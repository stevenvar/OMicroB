#include <stdio.h>

#ifdef BUFFER

#include "buffer.h"

val_t caml_buffer_write(val_t x, val_t y, val_t color){
  buffer_write(Int_val(x),Int_val(y),Int_val(color));
  return Val_unit;
}

val_t caml_buffer_read(val_t x, val_t y){
  uint8_t v = buffer_read(Int_val(x),Int_val(y));
  return Val_int(v);
}

val_t caml_buffer_get_byte(val_t x){
  uint8_t v = buffer_get_byte(Int_val(x));
  return Val_int(v);
}

val_t caml_init_buffer(val_t x){
  init_display();
  return Val_unit;
}


#endif

val_t caml_avr_write_register(val_t reg, val_t val){
  writeRegister((uint8_t)Int_val(reg),(uint8_t)Int_val(val));
  return Val_unit;
}

val_t caml_avr_set_bit(val_t reg, val_t bit){
  setBit(Int_val(reg),Int_val(bit));
  return Val_unit;
}

val_t caml_avr_clear_bit(val_t reg, val_t bit){
  clearBit(Int_val(reg),Int_val(bit));
  return Val_unit;
}

val_t caml_avr_read_bit(val_t reg, val_t bit){
  readBit(Int_val(reg),Int_val(bit));
  return Val_unit;
}

val_t caml_avr_read_register(val_t reg){
  readRegister(Int_val(reg));
  return Val_unit;
}
