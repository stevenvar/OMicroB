
val_t caml_avr_write_register(val_t reg, val_t val){
  writeRegister((uint8_t)Int_val(reg),(uint8_t)Int_val(val));
  return Val_unit;
}

val_t caml_avr_set_bit(val_t reg, val_t bit){
  setBit(Int_val(reg),Int_val(bit));
  return Val_unit;
}

/* val_t caml_avr_pin_mode(val_t pin, val_t mode) { */
/*   pinMode(Int_val(pin), Int_val(mode)); */
/*   return Val_unit; */
/* } */

/* val_t caml_avr_digital_write(val_t pin, val_t val){ */
/*   digitalWrite(Int_val(pin),Int_val(val)); */
/*   return Val_unit; */
/* } */

val_t caml_avr_clear_bit(val_t reg, val_t bit){
  clearBit(Int_val(reg),Int_val(bit));
  return Val_unit;
}

val_t caml_avr_draw_pixel(val_t x, val_t y, val_t color){
  drawPixel(Int_val(x),Int_val(y),Int_val(color));
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
