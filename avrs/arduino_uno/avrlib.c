#include <stdbool.h>
#include <avr/io.h>

/******************************************************************************/

volatile uint8_t *get_reg_addr(uint8_t reg) {
  if (reg ==  0) return &PORTB;
  if (reg ==  1) return &PORTC;
  if (reg ==  2) return &PORTD;
  if (reg ==  3) return &DDRB;
  if (reg ==  4) return &DDRC;
  if (reg ==  5) return &DDRD;
  if (reg ==  6) return &PINB;
  if (reg ==  7) return &PINC;
  if (reg ==  8) return &PIND;
  if (reg ==  9) return &SPCR;
  if (reg == 10) return &SPSR;
  if (reg == 11) return &SPDR;
  return NULL;
}

/******************************************************************************/

void avr_set_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) |= ((uint8_t) 1 << bit);
}

void avr_clear_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) &= ~((uint8_t) 1 << bit);
}

bool avr_read_bit(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr(reg)) & ((uint8_t) 1 << bit);
}

/******************************************************************************/

#include <avr/interrupt.h>

void avr_write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t avr_read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
}

int r = 0;
int avr_random(int max){
  r = (r*109+89)%max;
  return r;
}
