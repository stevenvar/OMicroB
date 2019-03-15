#include <stdbool.h>
#include <avr/io.h>

/******************************************************************************/

#define NOT_ON_TIMER 0
#define TIMER0A 1
#define TIMER0B 2
#define TIMER1A 3
#define TIMER1B 4
#define TIMER1C 5
#define TIMER2  6
#define TIMER2A 7
#define TIMER2B 8

#define TIMER3A 9
#define TIMER3B 10
#define TIMER3C 11
#define TIMER4A 12
#define TIMER4B 13
#define TIMER4C 14
#define TIMER4D 15
#define TIMER5A 16
#define TIMER5B 17
#define TIMER5C 18

/******************************************************************************/

#ifdef DEVICE_ARDUBOY
volatile uint8_t *get_reg_addr(uint8_t reg) {
  if (reg ==  1) return &PORTB;
  if (reg ==  2) return &PORTC;
  if (reg ==  3) return &PORTD;
  if (reg ==  4) return &PORTE;
  if (reg ==  5) return &PORTF;
  if (reg ==  12) return &DDRB;
  if (reg ==  13) return &DDRC;
  if (reg ==  14) return &DDRD;
  if (reg ==  15) return &DDRE;
  if (reg ==  16) return &DDRF;
  if (reg == 23) return &PINB;
  if (reg == 24) return &PINC;
  if (reg == 25) return &PIND;
  if (reg == 26) return &PINE;
  if (reg == 27) return &PINF;
  if (reg == 33) return &SPCR;
  if (reg == 34) return &SPSR;
  if (reg == 35) return &SPDR;
  return NULL;
}

volatile uint8_t get_timer_of_pin(uint8_t pin) {
  // TODO
  return NOT_ON_TIMER;
}

#endif

#ifdef DEVICE_ARDUINO_MEGA
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

volatile uint8_t get_timer_of_pin(uint8_t pin) {
  if (pin == 2) return TIMER3B;
  if (pin == 3) return TIMER3C;
  if (pin == 4) return TIMER0B;
  if (pin == 5) return TIMER3A;
  if (pin == 6) return TIMER4A;
  if (pin == 7) return TIMER4B;
  if (pin == 8) return TIMER4C;
  if (pin == 9) return TIMER2B;
  if (pin == 10) return TIMER2A;
  if (pin == 11) return TIMER1A;
  if (pin == 12) return TIMER1B;
  if (pin == 13) return TIMER0A;
  if (pin == 44) return TIMER5C;
  if (pin == 45) return TIMER5B;
  if (pin == 46) return TIMER5A;
  return NOT_ON_TIMER;
}
#endif

#ifdef DEVICE_ARDUINO_UNO
volatile uint8_t *get_reg_addr(uint8_t reg) {
  if (reg ==  1) return &PORTB;
  if (reg ==  2) return &PORTC;
  if (reg ==  3) return &PORTD;
  if (reg ==  12) return &DDRB;
  if (reg ==  13) return &DDRC;
  if (reg ==  14) return &DDRD;
  if (reg ==  23) return &PINB;
  if (reg ==  24) return &PINC;
  if (reg ==  25) return &PIND;
  if (reg ==  33) return &SPCR;
  if (reg == 34) return &SPSR;
  if (reg == 35) return &SPDR;
  return NULL;
}

volatile uint8_t get_timer_of_pin(uint8_t pin) {
  if (pin == 3) return TIMER2B;
  if (pin == 5) return TIMER0B;
  if (pin == 6) return TIMER0A;
  if (pin == 9) return TIMER1A;
  if (pin == 10) return TIMER1B;
  if (pin == 11) return TIMER2A;
  return NOT_ON_TIMER;
}
#endif

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

#ifndef sbi
#define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit))
#endif

#ifndef cbi
#define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit))
#endif

void avr_analog_write(uint8_t pin, int val) {
  int timer = get_timer_of_pin(pin);
#if defined(TCCR0A) && defined(COM0A1)
  if(timer == TIMER0A) {
    OCR0A = val;
    sbi(TCCR0A, COM0A1);
    TCCR0A |= (1 << WGM01) | (1 << WGM00);
    TCCR0B |= (1 << CS01);
  }
#endif

  // TODO faire la meme pour les autres...
#if defined(TCCR0A) && defined(COM0B1)
  if(timer == TIMER0B) {
    OCR0B = val;
    sbi(TCCR0A, COM0B1);
    TCCR0A |= (1 << WGM01) | (1 << WGM00);
    TCCR0B |= (1 << CS01);
  }
#endif

#if defined(TCCR1A) && defined(COM1A1)
  if(timer == TIMER1A) {
    OCR1A = val;
    sbi(TCCR1A, COM1A1);
    TCCR1A |= (1 << WGM11) | (1 << WGM10);
    TCCR1B |= (1 << CS11);
  }
#endif

#if defined(TCCR1A) && defined(COM1B1)
  if(timer == TIMER1B) {
    OCR1B = val;
    sbi(TCCR1A, COM1B1);
    TCCR1A |= (1 << WGM11) | (1 << WGM10);
    TCCR1B |= (1 << CS11);
  }
#endif

#if defined(TCCR1A) && defined(COM1C1)
  if(timer == TIMER1C) {
    OCR1C = val;
    sbi(TCCR1A, COM1C1);
    TCCR1A |= (1 << WGM11) | (1 << WGM10);
    TCCR1B |= (1 << CS11);
  }
#endif

#if defined(TCCR2A) && defined(COM2A1)
  if(timer == TIMER2A) {
    OCR2A = val;
    sbi(TCCR2A, COM2A1);
    TCCR2A |= (1 << WGM21) | (1 << WGM20);
    TCCR2B |= (1 << CS21);
  }
#endif

#if defined(TCCR2A) && defined(COM2B1)
  if(timer == TIMER2B) {
    OCR2B = val;
    sbi(TCCR2A, COM2B1);
    TCCR2A |= (1 << WGM21) | (1 << WGM20);
    TCCR2B |= (1 << CS21);
  }
#endif

#if defined(TCCR3A) && defined(COM3A1)
  if(timer == TIMER3A) {
    OCR3A = val;
    sbi(TCCR3A, COM3A1);
    TCCR3A |= (1 << WGM31) | (1 << WGM30);
    TCCR3B |= (1 << CS31);
  }
#endif

#if defined(TCCR3A) && defined(COM3B1)
  if(timer == TIMER3B) {
    OCR3B = val;
    sbi(TCCR3A, COM3B1);
    TCCR3A |= (1 << WGM31) | (1 << WGM30);
    TCCR3B |= (1 << CS31);
  }
#endif

#if defined(TCCR3A) && defined(COM3C1)
  if(timer == TIMER3C) {
    OCR3C = val;
    sbi(TCCR3A, COM3C1);
    TCCR3A |= (1 << WGM31) | (1 << WGM30);
    TCCR3B |= (1 << CS31);
  }
#endif

#if defined(TCCR4A)
  if(timer == TIMER4A) {
    OCR4A = val;
    sbi(TCCR4A, COM4A1);
    TCCR4A |= (1 << WGM41) | (1 << WGM40);
    TCCR4B |= (1 << CS41);
  }
#endif

#if defined(TCCR4A) && defined(COM4B1)
  if(timer == TIMER4B) {
    OCR4B = val;
    sbi(TCCR4A, COM4B1);
    TCCR4A |= (1 << WGM41) | (1 << WGM40);
    TCCR4B |= (1 << CS41);
  }
#endif

#if defined(TCCR4A) && defined(COM4C1)
  if(timer == TIMER4C) {
    OCR4C = val;
    sbi(TCCR4A, COM4C1);
    TCCR4A |= (1 << WGM41) | (1 << WGM40);
    TCCR4B |= (1 << CS41);
  }
#endif

#if defined(TCCR4C) && defined(COM4D1)
    if(timer == TIMER4D) {
      OCR4D = val;
      sbi(TCCR4C, COM4D1);
      TCCR4A |= (1 << WGM41) | (1 << WGM40);
      TCCR4B |= (1 << CS41);
    }
#endif

#if defined(TCCR5A) && defined(COM5A1)
    if(timer == TIMER5A) {
      OCR5A = val;
      sbi(TCCR5A, COM5A1);
      TCCR5A |= (1 << WGM51) | (1 << WGM50);
      TCCR4B |= (1 << CS51);
    }
#endif

#if defined(TCCR5A) && defined(COM5B1)
      if(timer == TIMER5B) {
        OCR5B = val;
        sbi(TCCR5B, COM5B1);
        TCCR5A |= (1 << WGM51) | (1 << WGM50);
        TCCR4B |= (1 << CS51);
      }
#endif

#if defined(TCCR5A) && defined(COM5C1)
        if(timer == TIMER5C) {
          OCR5C = val;
          sbi(TCCR5A, COM5C1);
          TCCR5A |= (1 << WGM51) | (1 << WGM50);
          TCCR4B |= (1 << CS51);
        }
#endif
}

int is_inited = 0;

uint16_t avr_analog_read(uint8_t ch) {
  // We init the channel
  if(!is_inited) {
    ADMUX = (1<<REFS0);
    ADCSRA = (1<<ADEN)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);

    is_inited = 1;
  }

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

#include <avr/io.h>
#include <inttypes.h>
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

#if defined(DEVICE_ARDUINO_MEGA) || defined(DEVICE_ARDUINO_UNO)
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

#endif
