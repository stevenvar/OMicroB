#include <xc.h>
#include <p32xxxx.h>
//#include <plib.h>


// #define SYS_FREQ(80000000L)
// #define COUNTS_PER_MICRO_SEC ((SYS_FREQ/2L/1000000L))

/*****************************************************************************/
volatile unsigned int *get_reg_addr(uint8_t reg) {
  if (reg == 0) return &LATA;
  if (reg == 1) return &LATB;
  if (reg == 2) return &LATC;
  if (reg == 3) return &TRISA;
  if (reg == 4) return &TRISB;
  if (reg == 5) return &TRISC;
  if (reg == 6) return &PORTA;
  if (reg == 7) return &PORTB;
  if (reg == 8) return &PORTC;
  return NULL;
}


/*****************************************************************************/


void set_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) |= ((uint8_t) 1 << bit);
}

void clear_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) &= ~((uint8_t) 1 << bit);
}

bool read_bit(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr(reg)) & ((uint8_t) 1 << bit);
}

void write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
}


int millis() {
  uint32_t time_ticks, time_ms;

  time_ticks = _CP0_GET_COUNT();
  time_ms = (uint32_t)((time_ticks * 2.0) / (SYS_FREQ / 1000));

  return time_ms;
}

void delay(int ms) {
  uint32_t begin;
  
  begin = millis();
  while ((millis() - begin) < (uint32_t) ms);
}

