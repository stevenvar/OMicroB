#include <stdint.h>

/******************************************************************************/

/******************************************************************************/

#ifdef __OCAML__

typedef uint32_t value;

value caml_buffer_write(value x, value y, value color) {
  return 0;
}

value caml_buffer_read(value x, value y) {
  return 0;
}

value caml_buffer_get_byte(value x) {
  return 0;
}

value caml_buffer_display(value x){
  return 0;
}

#else

#ifdef __PC__

#define _BV(x) (1 << x)
#include "lib/buffer.c"

#define SPSR 16
#define SPDR 17
#define SPIF 0

value caml_buffer_write(value x, value y, value color) {
  buffer_write(Int_val(x), Int_val(y), Int_val(color));
  return Val_unit;
}

value caml_buffer_read(value x, value y) {
  return Val_int(buffer_read(Int_val(x), Int_val(y)));
}

value caml_buffer_get_byte(value x) {
  return Val_int(buffer_get_byte());
}

value caml_buffer_display(value x){
  for(int i = 0; i < 1024; i++){
    int b = buffer_get_byte ();
    write_register(SPDR,b);
  }
  return Val_unit;
}

#else

#ifdef __AVR__

#include "../../src/byterun/vm/values.h"
#include "lib/buffer.c"

value caml_buffer_write(value x, value y, value color) {
  buffer_write(Int_val(x), Int_val(y), Int_val(color));
  return Val_unit;
}

value caml_buffer_read(value x, value y) {
  return Val_int(buffer_read(Int_val(x), Int_val(y)));
}

value caml_buffer_get_byte(value x) {
  return Val_int(buffer_get_byte());
}

value caml_buffer_display(value x){
  display();
  return Val_unit;
}

#endif
#endif
#endif

/******************************************************************************/
