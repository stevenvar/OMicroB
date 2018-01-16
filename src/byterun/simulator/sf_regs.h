
#ifndef SF_REG_H
#define SF_REG_H

#include <caml/mlvalues.h>

void init_regs(int nb_proc, int is_slow);
void destroy_regs(void);
void dump_regs(void);
void exec_instr(char *instr, int size);
void avr_set_bit(int reg,int bit);
void avr_clear_bit(int reg,int bit);
unsigned int avr_test_bit(int reg,int bit);
void avr_write_reg(int reg, unsigned char val);
unsigned int avr_read_reg(int reg);
#endif
