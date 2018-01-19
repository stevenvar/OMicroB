#include <stdbool.h>
#include <avr/io.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

volatile uint8_t* regs[] = {
   &PORTB,
   &PORTC,
   &PORTD,
   &PORTE,
   &PORTF,
   &DDRB,
   &DDRC,
   &DDRD,
   &DDRE,
   &DDRF,
   &PINB,
   &PINC,
   &PIND,
   &PINE,
   &PINF,
   &SPCR,
   &SPSR,
   &SPDR
};

/******************************************************************************/

void avr_set_bit(uint8_t reg,uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bit;
  *r |= _BV(b);
}

void avr_clear_bit(uint8_t reg, uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bit;
  *r &= ~_BV(b);
}

bool avr_read_bit(uint8_t reg, uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bit;
  return (*r & _BV(b));
}

/******************************************************************************/

void avr_write_register(uint8_t reg,uint8_t val){
  volatile uint8_t* r = regs[reg];
  *r = val;
}

uint8_t avr_read_register(uint8_t reg){
  volatile uint8_t* r = regs[reg];
  return *r;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
