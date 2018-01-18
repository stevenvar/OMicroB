#include <avr/io.h>
#include <stdint>

#define WIDTH 128/2
#define HEIGHT 64/2

uint8_t sBuffer[WIDTH*HEIGHT/8];

void buffer_write(int x, int y, int color){
  int xx = x/2;
  int yy = x/2;

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
  return sBuffer[(row*WIDTH) + xx] & _BV(bit_position)) >> bit_position;
}

void buffer_get_byte(int x){
  return sBuffer[(row*WIDTH+x)];
}
