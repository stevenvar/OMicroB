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

/* Arduboy specific libraries */

#ifdef __AVR__


val_t caml_buffer_write(val_t x, val_t y, val_t color){
  return Val_unit;
}

val_t caml_buffer_read(val_t x, val_t y){
  return Val_unit;
}

val_t caml_buffer_get_byte(val_t x){
  return Val_unit;
}

val_t caml_init_buffer(val_t x){
  return Val_unit;
}

#ifdef OMICROB_WITH_ARDUBOY

#include <Arduboy.h>

Arduboy arduboy;

val_t ocaml_arduboy_init(val_t unit) {
  arduboy.begin();
  arduboy.clear();
  return Val_unit;
}

val_t ocaml_arduboy_print(val_t str) {
  arduboy.print(String_val(str));
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


#endif /* OMICROB_USE_ARDUBOY */

#else /* __AVR__ */

#ifndef __PC__

#include "../simulator/simu.c"


val_t ocaml_arduboy_init(val_t unit) {
  printf("ocaml_arduino_init()\n");
  return Val_unit;
}

val_t ocaml_arduboy_print(val_t str) {
  printf("ocaml_arduino_print(\"%s\")\n", String_val(str));
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

val_t caml_buffer_write(val_t x, val_t y, val_t color){
  return Val_unit;
}

val_t caml_buffer_read(val_t x, val_t y){
  return Val_unit;
}

val_t caml_buffer_get_byte(val_t x){
  return Val_unit;
}

val_t caml_init_buffer(val_t x){
  return Val_unit;
}

#endif /* __PC__ */

#endif /* __AVR__ */
