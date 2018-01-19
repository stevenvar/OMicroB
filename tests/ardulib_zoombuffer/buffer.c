#include <stdint.h>

/******************************************************************************/

#define WIDTH (128 / 2)
#define HEIGHT (64 / 2)

static uint8_t sBuffer[WIDTH * HEIGHT / 8];

static void buffer_write(int x, int y, int color) {
  int xx = x / 2;
  int yy = x / 2;

  uint8_t row = (uint8_t) yy / 8;
  
  if (color) {
    sBuffer[row * WIDTH + (uint8_t) xx] |=   (1 << ((uint8_t) yy % 8));
  } else {
    sBuffer[row * WIDTH + (uint8_t) xx] &= ~ (1 << ((uint8_t) yy % 8));
  }
}

static uint8_t buffer_read(int x, int y) {
  int xx = x / 2;
  int yy = y / 2;
  uint8_t row = yy / 8;
  uint8_t bit_position = yy % 8;
  return (sBuffer[row * WIDTH + xx] >> bit_position) & 1;
}

static uint8_t buffer_get_byte(int x, int y) {
  int xx = x / 2;
  int yy = y / 2;
  uint8_t row = yy / 8;
  return sBuffer[row * WIDTH + xx];
}

/******************************************************************************/

#ifdef __OCAML__
#include <caml/mlvalues.h>
typedef value val_t;
#else
#include "../../src/byterun/vm/values.h"
#endif

val_t caml_buffer_write(val_t x, val_t y, val_t color) {
  buffer_write(Int_val(x), Int_val(y), Int_val(color));
  return Val_unit;
}

val_t caml_buffer_read(val_t x, val_t y) {
  return Val_int(buffer_read(Int_val(x), Int_val(y)));
}

val_t caml_buffer_get_byte(val_t x, val_t y) {
  return Val_int(buffer_get_byte(Int_val(x), Int_val(y)));
}

/******************************************************************************/
