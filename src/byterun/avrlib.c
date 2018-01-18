#include <stdbool.h>
#include <avr/io.h>

/******************************************************************************/

volatile uint8_t *get_reg_addr(uint8_t reg) {
  if (reg ==  0) return &PORTB;
  if (reg ==  1) return &PORTC;
  if (reg ==  2) return &PORTD;
  if (reg ==  3) return &PORTE;
  if (reg ==  4) return &PORTF;
  if (reg ==  5) return &DDRB;
  if (reg ==  6) return &DDRC;
  if (reg ==  7) return &DDRD;
  if (reg ==  8) return &DDRE;
  if (reg ==  9) return &DDRF;
  if (reg == 10) return &PINB;
  if (reg == 11) return &PINC;
  if (reg == 12) return &PIND;
  if (reg == 13) return &PINE;
  if (reg == 14) return &PINF;
  if (reg == 15) return &SPCR;
  if (reg == 16) return &SPSR;
  if (reg == 17) return &SPDR;
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

void avr_write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t avr_read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
}

/******************************************************************************/
