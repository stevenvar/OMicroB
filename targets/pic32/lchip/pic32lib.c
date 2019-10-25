#include <xc.h>
#include <p32xxxx.h>
//#include <plib.h>


// #define SYS_FREQ(80000000L)
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


void pic32_set_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) |= ((uint8_t) 1 << bit);
}

void pic32_clear_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) &= ~((uint8_t) 1 << bit);
}

bool pic32_read_bit(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr(reg)) & ((uint8_t) 1 << bit);
}

void pic32_write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t pic32_read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
}


void pic32_delay(int ms) {
  int i;
  for (i = 0; i <= 14000000; i++);

  // int begin = ReadCoreTimer();
  // int end;
  // if (end >= begin) {
  //   while (ReadCoreTimer() < end);
  // } else {
  //   while (ReadCoreTimer() > begin);
  //   while (ReadCoreTimer() < end);
  // }
}
