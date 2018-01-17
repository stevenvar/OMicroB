#include <stdint.h>
#include <avr/io.h>
#include "avr.h"

#define WIDTH 128
#define HEIGHT 64

volatile uint8_t* regs[] = {
   NOT_A_PORT,
   &PORTB,
   &PORTC,
   &PORTD,
   &PORTE,
   &PORTF,
   NOT_A_PORT,
   &DDRB,
   &DDRC,
   &DDRD,
   &DDRE,
   &DDRF,
   NOT_A_PORT,
   &PINB,
   &PINC,
   &PIND,
   &PINE,
   &PINF,
   &SPCR,
   &SPSR,
   &SPDR
};

/* unsigned char sBuffer[(HEIGHT*WIDTH)/8]; */

/* unsigned char sBuffer[1]; */
/* void paintScreen(unsigned char image[]) */
/* { */
/*   uint8_t c; */
/*   int i = 0; */

/*   SPDR = image[i++]; // set the first SPI data byte to get things started */

/*   // the code to iterate the loop and get the next byte from the buffer is */
/*   // executed while the previous byte is being sent out by the SPI controller */
/*   while (i < (HEIGHT * WIDTH) / 8) */
/*   { */
/*     // get the next byte. It's put in a local variable so it can be sent as */
/*     // as soon as possible after the sending of the previous byte has completed */
/*     c = image[i++]; */

/*     while (!(SPSR & _BV(SPIF))) { } // wait for the previous byte to be sent */

/*     // put the next byte in the SPI data register. The SPI controller will */
/*     // clock it out while the loop continues and gets the next byte ready */
/*     SPDR = c; */
/*   } */
/*   while (!(SPSR & _BV(SPIF))) { } // wait for the last byte to be sent */
/* } */

void drawPixel(uint8_t x,uint8_t y,uint8_t color){
  /* uint8_t row = (uint8_t)y / 8; */
  /* if (color) */
  /* { */
  /*   sBuffer[(row*WIDTH) + (uint8_t)x] |=   _BV((uint8_t)y % 8); */
  /* } */
  /* else */
  /* { */
  /*   sBuffer[(row*WIDTH) + (uint8_t)x] &= ~ _BV((uint8_t)y % 8); */
  /* } */
  /* paintScreen(sBuffer); */
}

void writeRegister(uint8_t reg,uint8_t val){
  volatile uint8_t* r = regs[reg];
  *r = val;
}

uint8_t readRegister(uint8_t reg){
  volatile uint8_t* r = regs[reg];
  return *r;
}

/* static const uint8_t SS   = 17; */
/* static const uint8_t SCK  = 15; */
/* static const uint8_t MOSI = 16; */

#define DC 4
#define CS 12
#define RST 6


char transfer(char _data) {
  SPDR = _data;
  while (!(SPSR & _BV(SPIF)))
    ;
  return SPDR;
}

void setBit(uint8_t reg,uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bit;
  *r |= _BV(b);
}

void clearBit(uint8_t reg, uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bit;
  *r &= ~_BV(b);
}

uint8_t readBit(uint8_t reg, uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bit;
  return (*r & _BV(b));
}

/* void pinMode(uint8_t pin, uint8_t mode) */
/* { */
/* 	uint8_t bit = digitalPinToBitMask(pin); */
/* 	uint8_t port = digitalPinToPort(pin); */
/* 	volatile uint8_t *reg, *out; */

/* 	reg = portModeRegister(port); */
/* 	out = portOutputRegister(port); */

/* 	if (mode == INPUT) { */
/* 		uint8_t oldSREG = SREG; */
/*                 cli(); */
/* 		*reg &= ~bit; */
/* 		*out &= ~bit; */
/* 		SREG = oldSREG; */
/* 	} else if (mode == INPUT_PULLUP) { */
/* 		uint8_t oldSREG = SREG; */
/*                 cli(); */
/* 		*reg &= ~bit; */
/* 		*out |= bit; */
/* 		SREG = oldSREG; */
/* 	} else { */
/* 		uint8_t oldSREG = SREG; */
/*                 cli(); */
/* 		*reg |= bit; */
/* 		SREG = oldSREG; */
/* 	} */
/* } */

/* static void turnOffPWM(uint8_t timer) */
/* { */
/* 	switch (timer) */
/* 	{ */
/* 		#if defined(TCCR1A) && defined(COM1A1) */
/* 		case TIMER1A:   cbi(TCCR1A, COM1A1);    break; */
/* 		#endif */
/* 		#if defined(TCCR1A) && defined(COM1B1) */
/* 		case TIMER1B:   cbi(TCCR1A, COM1B1);    break; */
/* 		#endif */

/* 		#if defined(TCCR2) && defined(COM21) */
/* 		case  TIMER2:   cbi(TCCR2, COM21);      break; */
/* 		#endif */

/* 		#if defined(TCCR0A) && defined(COM0A1) */
/* 		case  TIMER0A:  cbi(TCCR0A, COM0A1);    break; */
/* 		#endif */

/* 		#if defined(TIMER0B) && defined(COM0B1) */
/* 		case  TIMER0B:  cbi(TCCR0A, COM0B1);    break; */
/* 		#endif */
/* 		#if defined(TCCR2A) && defined(COM2A1) */
/* 		case  TIMER2A:  cbi(TCCR2A, COM2A1);    break; */
/* 		#endif */
/* 		#if defined(TCCR2A) && defined(COM2B1) */
/* 		case  TIMER2B:  cbi(TCCR2A, COM2B1);    break; */
/* 		#endif */

/* 		#if defined(TCCR3A) && defined(COM3A1) */
/* 		case  TIMER3A:  cbi(TCCR3A, COM3A1);    break; */
/* 		#endif */
/* 		#if defined(TCCR3A) && defined(COM3B1) */
/* 		case  TIMER3B:  cbi(TCCR3A, COM3B1);    break; */
/* 		#endif */
/* 		#if defined(TCCR3A) && defined(COM3C1) */
/* 		case  TIMER3C:  cbi(TCCR3A, COM3C1);    break; */
/* 		#endif */

/* 		#if defined(TCCR4A) && defined(COM4A1) */
/* 		case  TIMER4A:  cbi(TCCR4A, COM4A1);    break; */
/* 		#endif */
/* 		#if defined(TCCR4A) && defined(COM4B1) */
/* 		case  TIMER4B:  cbi(TCCR4A, COM4B1);    break; */
/* 		#endif */
/* 		#if defined(TCCR4A) && defined(COM4C1) */
/* 		case  TIMER4C:  cbi(TCCR4A, COM4C1);    break; */
/* 		#endif */
/* 		#if defined(TCCR4C) && defined(COM4D1) */
/* 		case TIMER4D:	cbi(TCCR4C, COM4D1);	break; */
/* 		#endif */

/* 		#if defined(TCCR5A) */
/* 		case  TIMER5A:  cbi(TCCR5A, COM5A1);    break; */
/* 		case  TIMER5B:  cbi(TCCR5A, COM5B1);    break; */
/* 		case  TIMER5C:  cbi(TCCR5A, COM5C1);    break; */
/* 		#endif */
/* 	} */
/* } */


/* void digitalWrite(uint8_t pin, uint8_t val){ */
/* 	uint8_t timer = digitalPinToTimer(pin); */
/* 	uint8_t bit = digitalPinToBitMask(pin); */
/* 	uint8_t port = digitalPinToPort(pin); */
/* 	volatile uint8_t *out; */

/* 	if (port == NOT_A_PIN) return; */

/* 	// If the pin that support PWM output, we need to turn it off */
/* 	// before doing a digital write. */
/* 	if (timer != NOT_ON_TIMER) turnOffPWM(timer); */

/* 	out = portOutputRegister(port); */

/* 	uint8_t oldSREG = SREG; */
/* 	cli(); */

/* 	if (val == LOW) { */
/* 		*out &= ~bit; */
/* 	} else { */
/* 		*out |= bit; */
/* 	} */

/* 	SREG = oldSREG; */
/* } */
