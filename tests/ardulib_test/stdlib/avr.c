#include <stdint.h>
#include <avr/io.h>
#include "avr.h"
#include <avr/interrupt.h>
/* #include <avr/iom32u4.h> */


volatile uint8_t* mode_regs[] = {
  NOT_A_PORT,
  &DDRB,
  NOT_A_PORT,
};

volatile uint8_t* regs[] = {
  &DDRB,
  &PORTB,
  &SPCR
};

void writeRegister(uint8_t reg,uint8_t val){
  volatile uint8_t* r = regs[reg];
  *r = val;
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

void pinMode(uint8_t pin, uint8_t mode)
{
	uint8_t bit = digitalPinToBitMask(pin);
	uint8_t port = digitalPinToPort(pin);
	volatile uint8_t *reg, *out;

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

void portMode(uint8_t port, uint8_t mode){

	volatile uint8_t *reg, *out;
	
	reg = mode_regs[port];
	out = regs[port];

	if (mode == INPUT) {
		uint8_t oldSREG = SREG;
                cli();
		*reg = 0x00;
		*out = 0x00;
		SREG = oldSREG;
	} else if (mode == INPUT_PULLUP) {
		uint8_t oldSREG = SREG;
                cli();
		*reg = 0x00;
		*out = 0xFF;
		SREG = oldSREG;
	} else {
		uint8_t oldSREG = SREG;
                cli();
		*reg = 0xFF;
		SREG = oldSREG;
	}
}

