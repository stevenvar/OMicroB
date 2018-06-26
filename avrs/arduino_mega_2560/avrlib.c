#include <stdbool.h>
#include <avr/io.h>

/******************************************************************************/

volatile uint8_t *get_reg_addr(uint8_t reg) {
  if (reg ==  0) return &PORTA;
  if (reg ==  1) return &PORTB;
  if (reg ==  2) return &PORTC;
  if (reg ==  3) return &PORTD;
  if (reg ==  4) return &PORTE;
  if (reg ==  5) return &PORTF;
  if (reg ==  6) return &PORTG;
  if (reg ==  7) return &PORTH;
  if (reg ==  8) return &PORTJ;
  if (reg ==  9) return &PORTK;
  if (reg == 10) return &PORTL;
  if (reg == 11) return &DDRA;
  if (reg == 12) return &DDRB;
  if (reg == 13) return &DDRC;
  if (reg == 14) return &DDRD;
  if (reg == 15) return &DDRE;
  if (reg == 16) return &DDRF;
  if (reg == 17) return &DDRG;
  if (reg == 18) return &DDRH;
  if (reg == 19) return &DDRJ;
  if (reg == 20) return &DDRK;
  if (reg == 21) return &DDRL;
  if (reg == 22) return &PINA;
  if (reg == 23) return &PINB;
  if (reg == 24) return &PINC;
  if (reg == 25) return &PIND;
  if (reg == 26) return &PINE;
  if (reg == 27) return &PINF;
  if (reg == 28) return &PING;
  if (reg == 28) return &PINH;
  if (reg == 30) return &PINJ;
  if (reg == 31) return &PINK;
  if (reg == 32) return &PINL;
  if (reg == 33) return &SPCR;
  if (reg == 34) return &SPSR;
  if (reg == 35) return &SPDR;
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
