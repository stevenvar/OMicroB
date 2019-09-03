#ifndef __DEBUG_H__
#define __DEBUG_H__

/******************************************************************************/

/*
  DEBUG levels:
    == 0: no debug, only traces from the OCaml program
    >= 1: trace GC runs
    >= 2: trace VM instructions
    >= 3: dump stack and heap at each GC
    >= 4: dump stack and heap at each VM instruction
*/

/******************************************************************************/

void print_value(value v);
void print_dynamic_heap(void);
void print_static_heap(void);
void print_flash_heap(void);
void print_ram_global_data(void);
void print_flash_global_data(void);
void print_stack(void);

/******************************************************************************/

#endif
