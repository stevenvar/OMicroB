#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>

/******************************************************************************/

void avr_set_bit(uint8_t reg, uint8_t bit) {
  printf("avr_set_bit(%d, %d)\n", (int) reg, (int) bit);
}

void avr_clear_bit(uint8_t reg, uint8_t bit) {
  printf("avr_clear_bit(%d, %d)\n", (int) reg, (int) bit);
}

bool avr_read_bit(uint8_t reg, uint8_t bit) {
  printf("avr_read_bit(%d, %d)\n", (int) reg, (int) bit);
  return false;
}

/******************************************************************************/

void avr_write_register(uint8_t reg, uint8_t val) {
  printf("avr_write_register(%d, %d)\n", (int) reg, (int) val);
}

uint8_t avr_read_register(uint8_t reg) {
  printf("avr_read_register(%d)\n", (int) reg);
  return 0;
}

/******************************************************************************/
