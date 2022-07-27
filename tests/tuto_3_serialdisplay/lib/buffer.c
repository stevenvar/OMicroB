#ifdef __AVR__

#include <avr/io.h>

#endif
#include <stdint.h>
#include "buffer.h"

#define WIDTH 128
#define HEIGHT 64

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
int total = 0;

uint8_t buffer_get_byte(){
  uint8_t val = *ptr;
  ptr++;
  total++;
  if(total >= WIDTH*HEIGHT/8){
    ptr = sBuffer;
    total = 0;
  }
  return val;
}

#ifdef __AVR__
void display(){
  for(int i = 0; i < 1024; i ++){
    uint8_t b = buffer_get_byte ();
   SPDR = b;
   while (!(SPSR & _BV(SPIF))){}
  }
}
#endif
