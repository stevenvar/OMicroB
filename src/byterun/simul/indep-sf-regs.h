#include <stdint.h>
#include <stdbool.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifndef SF_REG_H
#define SF_REG_H

void init_regs(int nb_proc, int is_slow);
void destroy_regs(void);
void dump_regs(void);
void exec_instr(char *instr, int size);

/******************************************************************************/

bool read_bit(uint8_t reg, uint8_t bit);
void set_bit(uint8_t reg, uint8_t bit);
void clear_bit(uint8_t reg, uint8_t bit);
void write_register(uint8_t reg, uint8_t val);
uint8_t read_register(uint8_t reg);

/******************************************************************************/

void delay(int ms);
int millis();

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
