#include <avr/io.h>
#include <stdint.h>
#include "buffer.h"

#define WIDTH 64
#define HEIGHT 32

#define UP 1
#define DOWN 0

uint8_t sBuffer[(HEIGHT*WIDTH)/8] = { 0 };

void init_display(){
  for (int i = 0 ; i < WIDTH; i ++){
    for(int j = 0; j < HEIGHT; j++){
      buffer_write(i,j,0);
    }
  }
}

void buffer_write(int x, int y, int color){
  uint8_t row = (uint8_t)y / 8;
  if (color)
    {
      sBuffer[(row*WIDTH) + (uint8_t)x] |=   _BV((uint8_t)y % 8);
    }
  else
    {
      sBuffer[(row*WIDTH) + (uint8_t)x] &= ~ _BV((uint8_t)y % 8);
    }
}

uint8_t buffer_read(int x, int y){
  uint8_t row = y / 8;
  uint8_t bit_position = y % 8;
  return (sBuffer[(row*WIDTH) + x] & _BV(bit_position)) >> bit_position;
}

uint8_t* ptr = sBuffer;
int col = 0;
int mode = UP;
int total = 0;

uint8_t buffer_get_byte(int x){
  char b1, b2, b3, b4;
  uint8_t val = *ptr;
  uint8_t out = 0x00;

  if(mode == DOWN){ // Down mode : the 4 last bits become 8 bits
    val = val >> 4;
  }
  b1 = (val & 0b00000001);
  b2 = (val & 0b00000010) >> 1;
  b3 = (val & 0b00000100) >> 2;
  b4 = (val & 0b00001000) >> 3;
  out |= b1;
  out |= b1 << 1;
  out |= b2 << 2;
  out |= b2 << 3;
  out |= b3 << 4;
  out |= b3 << 5;
  out |= b4 << 6;
  out |= b4 << 7;

  if (col % 2 == 1){
    ptr++; // ptr increases only every 2 calls
  }
  /* ptr++; */

  col++;
  if(col/2 >= (WIDTH)){
    if (mode == UP){
      ptr -= (col/2); // go back for one turn
    }
    col = 0;
    mode = (mode + 1) % 2;
  }
  total++;
  if(total >= WIDTH*HEIGHT/2){ // shouldnt happen
    ptr = sBuffer;
    total = 0;
  }

  return out;
}
