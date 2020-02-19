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

void set_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) |= ((uint8_t) 1 << bit);
}

void clear_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) &= ~((uint8_t) 1 << bit);
}

bool read_bit(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr(reg)) & ((uint8_t) 1 << bit);
}

/******************************************************************************/

#include <avr/interrupt.h>

void write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
}

int r = 0;
int avr_random(int max){
  r = (r*109+89)%max;
  return r;
}

/******************************************************************************/

void delay(int ms) {
  while(ms--) {
    _delay_ms(1);
  }
}

/******************************************************************************/

/* milli function from https://github.com/monoclecat/avr-millis-function */
#include <util/atomic.h>
#include <avr/interrupt.h>


volatile int timer1_millis;

ISR(TIMER1_COMPA_vect)
{
  timer1_millis++;
}

int millis() {
  int millis_return;

  // Ensure this cannot be disrupted
  ATOMIC_BLOCK(ATOMIC_FORCEON) {
    millis_return = timer1_millis;
  }
  return millis_return;

}


/******************************************************************************/


void avr_serial_init(){
  return;
}

void avr_serial_write(char val){
  return;
}

char avr_serial_read(){
  return 0;
}
