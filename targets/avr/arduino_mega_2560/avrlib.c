#include <stdbool.h>
#include <avr/io.h>
#include "../vm/callback.h"

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

#include <avr/io.h>
#include <inttypes.h>
#include <avr/interrupt.h>

void write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
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

int r = 0;
int avr_random(int max){
  r = (r*109+89)%max;
  return r;
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
/* TIMER0 and TIMER2 are used for interrupts                                  */

// https://www.instructables.com/id/Arduino-Timer-Interrupts/
// En utilisant le timer1 avec un prescaler 64, pour une interruption toutes les ms, compare match register de 249
// Prescaler 64: (1<<CS01)|(1<<CS00) pour timer0 et (1<<CS22) pour timer2

value timer0_closure = 0;
unsigned int timer0_cmp = 0;
value timer2_closure = 0;
unsigned int timer2_cmp = 0;

void avr_timer_set_period(int num, unsigned int cmp) {
  if(num == 0) {
    if(timer0_cmp == 0) { // Initialize TIMER0
      TCCR0B = (1<<CS01)|(1<<CS00);
      OCR0A = 249;
      TIMSK0 |= (1 << OCIE0A);
      sei();
    }
    timer0_cmp = cmp;
  } else if(num == 2) {
    if(timer2_cmp == 0) { // Initialize TIMER2
      TCCR2B = (1<<CS22);
      OCR2A = 249;
      TIMSK2 |= (1 << OCIE2A);
      sei();
    }
    timer2_cmp = cmp;
  }
}

void avr_timer_set_callback(int num, value closure) {
  declare_waiting_for_interrupt();
  if(num == 0) {
    timer0_closure = closure;
  } else if(num == 2) {
    timer2_closure = closure;
  }
}

unsigned int timer0_counter = 0;
ISR(TIMER0_COMPA_vect) { // TIMER0 interrupts
  timer0_counter++;

  if(timer0_cmp != 0 && timer0_closure != 0 && timer0_counter >= timer0_cmp) {
    timer0_counter = 0;
    set_interrupt_callback(timer0_closure);
  }
}

// TIMER1 is used for millis()

unsigned int timer2_counter = 0;
ISR(TIMER2_COMPA_vect) { // TIMER2 interrupts
  timer2_counter++;

  if(timer2_cmp != 0 && timer2_closure != 0 && timer2_counter >= timer2_cmp) {
    timer2_counter = 0;
    set_interrupt_callback(timer2_closure);
  }
}

/******************************************************************************/

void delay(int ms) {
  while(ms--) {
    _delay_ms(1);
  }
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
