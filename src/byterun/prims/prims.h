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


void lchip_digital_write_rled(uint8_t level);
void lchip_digital_write_lled(uint8_t level);
