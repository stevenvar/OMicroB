

/* #include "pins_arduino.h" */

void writeRegister(uint8_t reg,uint8_t val);
uint8_t readRegister(uint8_t reg);
void setBit(uint8_t reg,uint8_t bit);
void clearBit(uint8_t reg, uint8_t bit);
uint8_t readBit(uint8_t reg, uint8_t bit);
void pinMode(uint8_t pin, uint8_t mode);
void digitalWrite(uint8_t pin, uint8_t val);
void drawPixel(uint8_t x, uint8_t y, uint8_t color);

#define NOT_A_PORT 0x0
#define INPUT 0x0
#define OUTPUT 0x1
#define INPUT_PULLUP 0x2

#define true 0x1
#define false 0x0

/* #define cbi(sfr, bit) (_SFR_BYTE(sfr) &= ~_BV(bit)) */
/* #define sbi(sfr, bit) (_SFR_BYTE(sfr) |= _BV(bit)) */

/* #define digitalPinToTimer(P) ( pgm_read_byte( digital_pin_to_timer_PGM + (P) ) ) */

/* #define portOutputRegister(P) ( (volatile uint8_t *)( pgm_read_word( port_to_output_PGM + (P))) ) */

/* #define portModeRegister(P) ( (volatile uint8_t *)( pgm_read_word( port_to_mode_PGM + (P))) ) */

/* #define digitalPinToBitMask(P) ( pgm_read_byte( digital_pin_to_bit_mask_PGM + (P) ) ) */

/* #define digitalPinToPort(P) ( pgm_read_byte( digital_pin_to_port_PGM + (P) ) ) */
