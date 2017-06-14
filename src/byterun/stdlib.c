/* Binding to arduino libraries */

#ifdef __AVR__
#include <Arduino.h>
#else
#include "simul.h"
#endif

#include "values.h"
#include "debug.h"

/******************************************************************************/
/* Arduino specific libraries   */

val_t caml_pin_mode(val_t pin, val_t mode) {
  pinMode(Int_val(pin), Int_val(mode));
  return Val_unit;
}

val_t caml_digital_write(val_t pin, val_t state) {
  digitalWrite(Int_val(pin), Int_val(state));
  return Val_unit;
}

val_t caml_digital_read(val_t pin) {
  return Val_int(digitalRead(Int_val(pin)));
}

val_t caml_delay(val_t millis) {
  delay(Int_val(millis));
  return Val_unit;
}

/******************************************************************************/
