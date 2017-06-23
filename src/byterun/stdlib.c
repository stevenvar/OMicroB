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

#ifdef __AVR__

#include <Arduboy.h>

Arduboy arduboy;

val_t ocaml_arduboy_init(val_t unit) {
  arduboy.begin();
  arduboy.clear();
  return Val_unit;
}

val_t ocaml_arduboy_print(val_t str) {
  arduboy.print(StringVal(str));
  return Val_unit;
}

val_t ocaml_arduboy_display(val_t unit) {
  arduboy.display();
  return Val_unit;
}

#else

#include <stdio.h>

val_t *ocaml_heap;

val_t ocaml_arduboy_init(val_t unit) {
  printf("ocaml_arduino_init()\n");
  return Val_unit;
}

val_t ocaml_arduboy_print(val_t str) {
  printf("ocaml_arduino_print(\"%s\")\n", StringVal(str));
  return Val_unit;
}

val_t ocaml_arduboy_display(val_t unit) {
  printf("ocaml_arduino_print()\n");
  return Val_unit;
}

#endif

/******************************************************************************/
