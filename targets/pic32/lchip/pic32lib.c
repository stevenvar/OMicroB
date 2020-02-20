#include <xc.h>
#include <p32xxxx.h>
//#include <plib.h>

#define SYS_FREQ 80000000L
// #define COUNTS_PER_MICRO_SEC ((SYS_FREQ/2L/1000000L))



/*****************************************************************************/
volatile uint32_t *get_reg_addr(uint8_t reg) {
  if (reg == 0)  return &LATA;
  if (reg == 1)  return &LATB;
  if (reg == 2)  return &LATC;
  if (reg == 3)  return &LATD;
  if (reg == 4)  return &LATE;
  if (reg == 5)  return &LATF;
  if (reg == 6)  return &LATG;
  if (reg == 7)  return &TRISA;
  if (reg == 8)  return &TRISB;
  if (reg == 9)  return &TRISC;
  if (reg == 10) return &TRISD;
  if (reg == 11) return &TRISE;
  if (reg == 12) return &TRISF;
  if (reg == 13) return &TRISG;
  if (reg == 14) return &PORTA;
  if (reg == 15) return &PORTB;
  if (reg == 16) return &PORTC;
  if (reg == 17) return &PORTD;
  if (reg == 18) return &PORTE;
  if (reg == 19) return &PORTF;
  if (reg == 20) return &PORTG;
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

