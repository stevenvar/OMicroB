/* C-interface between:                             */
/*   -> prims/std-bindings.c | prims/omc-bindings.c */
/*   -> simul/sf-regs.c | avr/avrlib.c              */

#include <stdbool.h>
#include <stdint.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void avr_set_bit(uint8_t reg, uint8_t bit);
void avr_clear_bit(uint8_t reg, uint8_t bit);
bool avr_read_bit(uint8_t reg, uint8_t bit);

/******************************************************************************/

void avr_serial_init();
void avr_serial_write(char val);
char avr_serial_read();

/******************************************************************************/

void avr_write_register(uint8_t reg, uint8_t val);
uint8_t avr_read_register(uint8_t reg);
int avr_random(int max);
int avr_millis();

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

void pic32_init();
void pic32_schedule_task();
void pic32_pin_mode(uint8_t p, uint8_t m);
void pic32_digital_write(uint8_t p, uint8_t l);
uint8_t pic32_digital_read(uint8_t p);
void pic32_delay(int ms);

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
