/*************************************************************************/
/*                                                                       */
/*                                OCaPIC                                 */
/*                                                                       */
/*                             Benoit Vaugon                             */
/*                                                                       */
/*    This file is distributed under the terms of the CeCILL license.    */
/*    See file ../../LICENSE-en.                                         */
/*                                                                       */
/*************************************************************************/

#ifndef SF_REG_H
#define SF_REG_H

#include <caml/mlvalues.h>

void init_regs(int nb_proc, int is_slow);
void destroy_regs(void);
void dump_regs(void);
void exec_instr(char *instr, int size);
void pic_write_reg(int reg, unsigned char new_val);
void pic_clear_bit(int reg, int bit);
void pic_set_bit(int reg, int bit);
value caml_pic_write_reg(value reg, value val);
value caml_pic_read_reg(value reg);
value caml_pic_set_bit(value bit);
value caml_pic_clear_bit(value bit);
value caml_pic_test_bit(value bit);
void avr_set_bit(int reg,int bit);
#endif
