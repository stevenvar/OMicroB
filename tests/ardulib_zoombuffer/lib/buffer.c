#include <avr/io.h>
#include <stdint.h>

#define WIDTH 128/4
#define HEIGHT 64/4


char sBuffer[WIDTH*HEIGHT/8] = { 0 };

void buffer_write(int x, int y, int color){
  int xx = x;
  int yy = y;
  uint8_t row = (uint8_t)yy / 8;
  if (color)
  {
    sBuffer[(row*WIDTH) + (uint8_t)xx] |=   _BV((uint8_t)yy % 8);
  }
  else
  {
    sBuffer[(row*WIDTH) + (uint8_t)xx] &= ~ _BV((uint8_t)yy % 8);
  }
}

uint8_t buffer_read(int x, int y){
  int xx = x/2;
  int yy = y/2;
  uint8_t row = yy / 8;
  uint8_t bit_position = yy % 8;
  return (sBuffer[(row*WIDTH) + xx] & _BV(bit_position)) >> bit_position;
}

char* ptr = sBuffer;
int row = 0;
int cpt = 0;
int cpt_identical_rows = 0;
uint8_t buffer_get_byte(int x){
  if (cpt % 4 == 0){
    ptr++; // ptr increases only every 4 calls
  }
  /*  if (ptr - sBuffer == WIDTH && cpt_identical_rows < 4) { // if we drew a row, we go back */
  /*    ptr -= WIDTH; */
  /*    cpt = 0; */
  /*    cpt_identical_rows++; */
  /* } */
   uint8_t val = *ptr;
  cpt++;
  if(val == 0x01){ val = 0xFF; };
  if(cpt >= WIDTH*HEIGHT*4){ // Shouldn't happen
    val = 0xFF;
    cpt = 0;
    ptr = sBuffer;
  }
  return val;
}
