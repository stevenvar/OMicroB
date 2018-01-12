#include <stdint.h>
#include <avr/io.h>
#include "pins_arduino.h"
#include "avr.h"
/* #include <avr/iom32u4.h> */

uint8_t bits[] = {
  0, /* PORTB0, */
  1, /* PORTB1 */
  2, /* PORTB2 */
  3, /* PORTB3 */
  4, /* PORTB4 */
  5, /* PORTB5 */
  6, /* PORTB6 */
  7 /* PORTB7 */
};

volatile uint8_t* regs[] = {
  &DDRB,
  &PORTB
};

void writeRegister(uint8_t reg,uint8_t val){
  volatile uint8_t* r = regs[reg];
  *r = val;
}

void setBit(uint8_t reg,uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bits[bit];
  *r |= _BV(b);
}

void clearBit(uint8_t reg, uint8_t bit){
  volatile uint8_t* r = regs[reg];
  volatile uint8_t b = bits[bit];
  *r &= ~_BV(b);
}

void pinMode(uint8_t pin, uint8_t mode)
{
	uint8_t bit = digitalPinToBitMask(pin);
	uint8_t port = digitalPinToPort(pin);
	volatile uint8_t *reg, *out;

	if (port == NOT_A_PIN) return;

	// JWS: can I let the optimizer do this?
	reg = portModeRegister(port);
	out = portOutputRegister(port);

	if (mode == INPUT) {
		uint8_t oldSREG = SREG;
                cli();
		*reg &= ~bit;
		*out &= ~bit;
		SREG = oldSREG;
	} else if (mode == INPUT_PULLUP) {
		uint8_t oldSREG = SREG;
                cli();
		*reg &= ~bit;
		*out |= bit;
		SREG = oldSREG;
	} else {
		uint8_t oldSREG = SREG;
                cli();
		*reg |= bit;
		SREG = oldSREG;
	}
}
