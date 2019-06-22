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

/******************************************************************************/

void avr_adc_init(){
   // AREF = AVcc
  ADMUX = (1<<REFS0);

  // ADC Enable and prescaler of 128
  // 16000000/128 = 125000
  ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
}

uint16_t avr_analog_read(uint8_t ch) {
  ch &= 0b00000111;  // AND operation with 7
  ADMUX = (ADMUX & 0xF8)|ch; // clears the bottom 3 bits before ORing
  // start single convertion
  // write ’1′ to ADSC
  ADCSRA |= (1<<ADSC);
  // wait for conversion to complete
  // ADSC becomes ’0′ again
  // till then, run loop continuously
  while(ADCSRA & (1<<ADSC));
  return (ADC);
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

int avr_millis() {
  int millis_return;

  // Ensure this cannot be disrupted
  ATOMIC_BLOCK(ATOMIC_FORCEON) {
    millis_return = timer1_millis;
  }
  return millis_return;

}





/******************************************************************************/


#ifndef BAUD
#define BAUD 9600
#endif
#include <util/setbaud.h>

void serial_init(void) {
  /* set SERIAL speed */
  UBRR0H = UBRRH_VALUE;
  UBRR0L = UBRRL_VALUE;
  /* don't use double speed */
  UCSR0A &= ~(_BV(U2X0));
  /* set data size (8 bits) */
  UCSR0C = _BV(UCSZ01) | _BV(UCSZ00);
  /* enable RX and TX */
  UCSR0B = _BV(RXEN0) | _BV(TXEN0);
}

int serial_write(char c, FILE *stream) {
    if (c == '\n') {
        serial_write('\r', stream);
    }
    loop_until_bit_is_set(UCSR0A, UDRE0);
    UDR0 = c;
    return 0;
}

int serial_read(FILE *stream) {
    loop_until_bit_is_set(UCSR0A, RXC0);
    return UDR0;
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
