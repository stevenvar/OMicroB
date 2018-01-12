
val_t caml_avr_write_register(val_t reg, val_t val){
  writeRegister((uint8_t)Int_val(reg),(uint8_t)Int_val(val));
  return Val_unit;
}

val_t caml_avr_set_bit(val_t reg, val_t bit){
  setBit(Int_val(reg),Int_val(bit));
  return Val_unit;
}

val_t caml_pin_mode(val_t pin, val_t mode) {
  pinMode(Int_val(pin), Int_val(mode));
  return Val_unit;
}

val_t caml_avr_port_mode(val_t port, val_t mode){
  portMode(Int_val(port),Int_val(mode));
  return Val_unit;
}

val_t caml_avr_digital_write(val_t port, val_t mode){
  
  return Val_unit;
}
