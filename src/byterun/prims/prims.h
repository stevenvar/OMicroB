/* C-interface between:                             */
/*   -> prims/std-bindings.c | prims/omc-bindings.c */
/*   -> simul/sf-regs.c | avr/avrlib.c              */

#include <stdint.h>
#include <stdbool.h>



void pic32_set_bit(uint8_t reg, uint8_t bit);
void pic32_clear_bit(uint8_t reg, uint8_t bit);
bool pic32_read_bit(uint8_t reg, uint8_t bit);
void pic32_write_register(uint8_t reg, uint8_t val);
uint8_t pic32_read_register(uint8_t reg);
void pic32_delay(int ms);


/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

// void avr_set_bit(uint8_t reg, uint8_t bit);
// void avr_clear_bit(uint8_t reg, uint8_t bit);
// bool avr_read_bit(uint8_t reg, uint8_t bit);

// /******************************************************************************/

// void avr_adc_init();
// uint16_t avr_analog_read(uint8_t);

// /******************************************************************************/

// void avr_serial_init();
// void avr_serial_write(char val);
// char avr_serial_read();

// /******************************************************************************/

// void avr_write_register(uint8_t reg, uint8_t val);
// uint8_t avr_read_register(uint8_t reg);
// int avr_random(int max);
// void avr_delay(int ms);
// int avr_millis();

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
