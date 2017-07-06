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

val_t ocaml_arduboy_print_int(val_t i) {
  arduboy.print(Int_val(i));
  return Val_unit;
}

val_t ocaml_arduboy_display(val_t unit) {
  arduboy.display();
  return Val_unit;
}

val_t ocaml_arduboy_draw_rect(val_t x, val_t y, val_t w, val_t h, val_t color) {
  arduboy.drawRect(Int_val(x),Int_val(y),Int_val(w),Int_val(h),Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_draw_circle(val_t x0, val_t y0, val_t r, val_t color) {
  arduboy.drawCircle(Int_val(x0),Int_val(y0),Int_val(r),Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_draw_line(val_t x0, val_t y0, val_t x1, val_t y1, val_t color) {
  arduboy.drawLine(Int_val(x0),Int_val(y0),Int_val(x1),Int_val(y1),Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_draw_pixel(val_t x, val_t y, val_t color) {
  arduboy.drawPixel(Int_val(x),Int_val(y),Int_val(color));
  return Val_unit;
}


val_t ocaml_arduboy_fill_rect(val_t x, val_t y, val_t w, val_t h, val_t color) {
  arduboy.fillRect(Int_val(x),Int_val(y),Int_val(w),Int_val(h),Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_fill_circle(val_t x0, val_t y0, val_t r, val_t color) {
  arduboy.fillCircle(Int_val(x0),Int_val(y0),Int_val(r),Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_pressed(val_t button){
  int x =  arduboy.pressed(_BV((int)Int_val(button)));
  if(x) return Val_int(1);
  return Val_int(0);
}

val_t ocaml_arduboy_clear(val_t unit){
  arduboy.clear();
  return Val_unit;
}


val_t ocaml_arduino_millis(val_t k){
  return Val_int(millis());
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

val_t ocaml_arduboy_print_int(val_t i) {
  printf("ocaml_arduino_print_int(\"%d\")\n", (int)Int_val(i));
  return Val_unit;
}

val_t ocaml_arduboy_display(val_t unit) {
  printf("ocaml_arduino_print()\n");
  return Val_unit;
}


val_t ocaml_arduboy_draw_rect(val_t x, val_t y, val_t w, val_t h, val_t color) {
  printf("drawRect(%d,%d,%d,%d,%d)", (int)Int_val(x), (int)Int_val(y),(int)Int_val(w),(int)Int_val(h),(int)Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_draw_circle(val_t x0, val_t y0, val_t r, val_t color) {
  printf("drawCircle(%d,%d,%d,%d)", (int)Int_val(x0), (int)Int_val(y0),(int)Int_val(r),(int)Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_draw_line(val_t x0, val_t y0, val_t x1, val_t y1, val_t color) {
   printf("drawLine(%d,%d,%d,%d,%d)", (int)Int_val(x0), (int)Int_val(y0),(int)Int_val(x1),(int)Int_val(y1),(int)Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_draw_pixel(val_t x, val_t y, val_t color) {
   printf("drawPixel(%d,%d,%d)", (int)Int_val(x), (int)Int_val(y),(int)Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_fill_rect(val_t x, val_t y, val_t w, val_t h, val_t color) {
  printf("fillRect(%d,%d,%d,%d,%d)", (int)Int_val(x), (int)Int_val(y),(int)Int_val(w),(int)Int_val(h),(int)Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_fill_circle(val_t x0, val_t y0, val_t r, val_t color) {
  printf("fillCircle(%d,%d,%d,%d)", (int)Int_val(x0), (int)Int_val(y0),(int)Int_val(r),(int)Int_val(color));
  return Val_unit;
}

val_t ocaml_arduboy_pressed(val_t button){
  printf("pressed(%d)",(int)Int_val(button));
  return Val_unit;
}


val_t ocaml_arduboy_clear(val_t unit){
  printf("clear()");
  return Val_unit;
}


val_t ocaml_arduino_millis(val_t k){
  printf("millis()");
  return Val_int(0);
}
#endif

/******************************************************************************/
