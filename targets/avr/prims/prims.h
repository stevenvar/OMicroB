/* C-interface between:                             */
/*   -> prims/bindings.c                            */
/*   -> simul/sf-regs.c | avr/avrlib.c              */

#include <stdint.h>
#include <stdbool.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifndef PRIMS_H_AVR
#define PRIMS_H_AVR

int avr_random(int max);
void avr_adc_init();
uint16_t avr_analog_read(uint8_t);

/******************************************************************************/

void avr_serial_init();
void avr_serial_write(char val);
char avr_serial_read();

/******************************************************************************/

void avr_timer_set_period(int num, unsigned int cmp);
void avr_timer_set_callback(int num, int closure);

/******************************************************************************/

void avr_pin_change_callback(uint8_t reg, uint8_t bit, int closure);

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
