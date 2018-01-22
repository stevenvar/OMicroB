#include <stdint.h>

/******************************************************************************/

/******************************************************************************/

#ifdef __OCAML__

typedef uint32_t val_t;

val_t caml_buffer_write(val_t x, val_t y, val_t color) {
  return 0;
}

val_t caml_buffer_read(val_t x, val_t y) {
  return 0;
}

val_t caml_buffer_get_byte(val_t x) {
  return 0;
}

val_t caml_buffer_display(val_t x){
  return 0;
}

#else

#ifdef __PC__

#define _BV(x) (1 << x)
#include "lib/buffer.c"

#define SPSR 16

#define SPIF 0

val_t caml_buffer_write(val_t x, val_t y, val_t color) {
  buffer_write(Int_val(x), Int_val(y), Int_val(color));
  return Val_unit;
}

val_t caml_buffer_read(val_t x, val_t y) {
  return Val_int(buffer_read(Int_val(x), Int_val(y)));
}

val_t caml_buffer_get_byte(val_t x) {
  return Val_int(buffer_get_byte());
}

val_t caml_buffer_display(val_t x){
  for(int i = 0; i < 1024; i++){
    int b = buffer_get_byte ();
    avr_write_register(SPDR,b);
  }

}

#else

#ifdef __AVR__

#include "../../src/byterun/vm/values.h"
#include "lib/buffer.h"

val_t caml_buffer_write(val_t x, val_t y, val_t color) {
  buffer_write(Int_val(x), Int_val(y), Int_val(color));
  return Val_unit;
}

val_t caml_buffer_read(val_t x, val_t y) {
  return Val_int(buffer_read(Int_val(x), Int_val(y)));
}

val_t caml_buffer_get_byte(val_t x) {
  return Val_int(buffer_get_byte());
}

val_t caml_buffer_display(val_t x){
  display();
  return Val_unit;
}

#endif
#endif
#endif

/******************************************************************************/
