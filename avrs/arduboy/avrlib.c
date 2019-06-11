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




/******************************************************************************/


#ifndef BAUD
#define BAUD 9600
#endif
#include <util/setbaud.h>

void serial_init(void) {
  /* /\* set SERIAL speed *\/ */
  /* UBRR0H = UBRRH_VALUE; */
  /* UBRR0L = UBRRL_VALUE; */
  /* /\* don't use double speed *\/ */
  /* UCSR0A &= ~(_BV(U2X0)); */
  /* /\* set data size (8 bits) *\/ */
  /* UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); */
  /* /\* enable RX and TX *\/ */
  /* UCSR0B = _BV(RXEN0) | _BV(TXEN0); */
}

int serial_write(char c, FILE *stream) {
    /* if (c == '\n') { */
    /*     serial_write('\r', stream); */
    /* } */
    /* loop_until_bit_is_set(UCSR0A, UDRE0); */
    /* UDR0 = c; */
    return 0;
}

int serial_read(FILE *stream) {
    /* loop_until_bit_is_set(UCSR0A, RXC0); */
    /* return UDR0; */
  return 1;
}

FILE serial_str;

void avr_serial_init(){
  fdev_setup_stream(&serial_str,serial_write, serial_read,_FDEV_SETUP_RW);
  serial_init();
  stdin = stdout = &serial_str;
}

void avr_serial_write(char val){
  printf("%c",val);
}

char avr_serial_read(){
  return (char)getchar();
}
