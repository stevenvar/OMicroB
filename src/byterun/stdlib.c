/* Binding to arduino libraries */

#ifdef  __AVR__
#ifdef __ARDUINO__
#include "gc.h"
#include "Arduino.h"
#endif
#include "values.h"
#ifdef DEBUG
#include "debug.h"
#endif
#elif defined(__PC__)
#include <stdio.h>
#include "gc.h"
#include "values.h"
#else
#include "simul.h"
#endif

#if defined(__AVR__)

/******************************************************************************/
/* Arduino specific libraries */

#ifdef __ARDUINO__

val_t caml_force_gc (val_t unit){
   #ifndef NOGC
  gc(0);
  #endif
  return Val_unit;
}

val_t caml_pin_mode(val_t pin, val_t mode) {
  pinMode(Int_val(pin), Int_val(mode));
  return Val_unit;
}
val_t ocaml_arduino_serial_begin(val_t i){
  Serial.begin(Int_val(i));
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
val_t ocaml_arduino_millis(val_t unit){
  return Val_int(millis());
}


val_t caml_print_float(val_t i){
  Serial.print((float)i);
  return Val_unit;
}

val_t caml_print_int(val_t i){
  Serial.print(Int_val(i));
  return Val_unit;
}

val_t caml_print_string(val_t s){
  Serial.print(StringVal(s));
  return Val_unit;
}
#endif

/******************************************************************************/
/* Arduboy specific libraries */



#ifdef OMICROB_WITH_ARDUBOY
#include "Arduboy.h"
Arduboy arduboy;

/* val_t ocaml_arduboy_reset_cursor(val_t unit){ */
/*   arduboy.resetCursor(); */
/*   return Val_unit; */
/* } */


val_t ocaml_arduboy_millis(val_t unit){
  return Val_int(millis());
}

val_t ocaml_arduboy_init(val_t unit) {
  arduboy.begin();
  arduboy.clear();
  return Val_unit;
}

val_t ocaml_arduboy_print(val_t str) {
  arduboy.print(StringVal(str));
  return Val_unit;
}

val_t ocaml_arduboy_print_float(val_t i) {
  alpha a;
  a.v = i;
  arduboy.print(a.f);
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


#ifdef __PC__
#include <unistd.h>
#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>
void debug(int n){
  printf("DEBUG(%d)\n",n);
}

void debug_init(void){

}


val_t caml_force_gc (val_t unit){
#ifdef DEBUG
  printf("HEAP before : \n");
  print_heap();
  #endif
#ifndef NOGC
  gc(0);
  #endif
  #ifdef DEBUG
  printf("HEAP after : \n");
  print_heap();
  #endif

  return Val_unit;
}

val_t caml_write_reg(val_t reg, val_t val){
  printf("REG n°%d = %d \n" , reg, Int_val(val));
}

/* val_t ocaml_arduboy_reset_cursor(val_t unit){ */
/*   printf("\n"); */
/*   return Val_unit; */
/* } */


val_t ocaml_arduboy_init(val_t unit) {
  printf("ocaml_arduboy_init()\n");
  return Val_unit;
}

val_t ocaml_arduboy_print(val_t str) {
  printf("%s", StringVal(str));
  return Val_unit;
}

val_t ocaml_arduboy_print_int(val_t i) {
  printf("%d", Int_val(i));
  return Val_unit;
}

val_t ocaml_arduboy_display(val_t unit) {
  printf("ocaml_arduboy_display()\n");
  return Val_unit;
}

val_t ocaml_arduboy_millis(val_t unit){
  return Val_int(5);
}


val_t ocaml_arduboy_clear(val_t unit){
  printf("ocaml_arduboy_clear()\n");
  return Val_unit;
}

val_t caml_delay(val_t millis){
  struct timespec req, rem;
  printf("delay(%d)\n", millis);
  req.tv_sec = millis / 1000;
  req.tv_nsec = 1000000 * (millis - 1000 * req.tv_sec);
  nanosleep(&req, &rem);
  return Val_unit;
}

val_t caml_pin_mode(val_t pin, val_t mode) {
  printf("pin_mode(%ld,%ld)\n", Val_int(pin),Val_int(mode));
  return Val_unit;
}

val_t caml_digital_write(val_t pin, val_t state) {
  printf("digital_write(%ld,%ld)\n", Val_int(pin),Val_int(state));
  return Val_unit;
}

val_t ocaml_arduino_millis(val_t unit){
  return Val_int(0);
}


val_t caml_print_int(val_t i){
  printf("%d",Int_val(i));
  return Val_unit;
}

val_t caml_print_string(val_t s){
  printf("%s",StringVal(s));
  return Val_unit;
}

val_t ocaml_arduino_serial_begin(val_t i){
  printf("serialbegin\n");
  return Val_unit;
}


val_t ocaml_arduboy_print_float(val_t i) {
  alpha a1;
  a1.v = i;
  printf("ocaml_arduino_print_float(\"%f\")\n", a1.f);
  return Val_unit;
}


val_t caml_print_float(val_t i){
  printf("print_float(%d)",Double_val(i));
  return Val_unit;
}

#else

val_t ocaml_arduboy_reset_cursor(val_t unit){
  printf("ocaml_arduboy_reset_cursor()");
  return Val_unit;
}

val_t caml_print_int(val_t x){
  printf("caml_print_int(%ld)",Val_int(x));
  return Val_unit;
}

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

val_t ocaml_arduboy_print_float(val_t i) {
  float f = Double_val(i);
  printf("ocaml_arduino_print_float(%f)\n",f);
  return Val_unit;
}


val_t ocaml_arduboy_display(val_t unit) {
  printf("ocaml_arduino_display()\n");
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

val_t ocaml_arduboy_millis(val_t unit){
  printf("millis()");
  return Val_int(0);
}


val_t ocaml_arduboy_clear(val_t unit){
  printf("clear()");
  return Val_unit;
}


val_t caml_delay(val_t i){
  printf("delay()");
  return Val_unit;
}


val_t caml_pin_mode(val_t pin, val_t mode) {
  printf("pin_mode(%ld,%ld)", Val_int(pin),Val_int(mode));
  return Val_unit;
}

val_t caml_digital_write(val_t pin, val_t state) {
  printf("digital_write(%ld,%ld)", Val_int(pin),Val_int(state));
  return Val_unit;
}

val_t ocaml_arduino_millis(val_t unit){
  return Val_int(0);
}


val_t ocaml_arduino_serial_begin(val_t i){
  printf("serial_begin\n");
  return Val_unit;
}


val_t caml_print_float(val_t i){
  printf("print_float(%f)\n",(float)Double_val(i));
  return Val_unit;
}


val_t caml_force_gc (val_t unit){
  printf("gc()\n");
  return Val_unit;
}

val_t caml_print_string(val_t s){
  printf("caml_print_string");
  return Val_unit;
}

#endif /* PC */
#endif /* __AVR__ */

/******************************************************************************/
