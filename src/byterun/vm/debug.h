#ifndef __DEBUG_H__
#define __DEBUG_H__

/******************************************************************************/

#ifdef __PC__

#include <assert.h>

#else

#if DEBUG > 0
#define assert(x) do { if (!(x)) debug_blink_error();  } while(0);
#else
#define assert(x) 
#endif

void debug_blink_error(void);
void debug_blink_uncatched_exception(void);
void debug_blink_message(int n);
void debug_blink_pause(void);

#endif

/******************************************************************************/

/*
  DEBUG levels:
    == 0: no debug, only traces from the OCaml program
    >= 1: trace GC runs
    >= 2: trace VM instructions
    >= 3: dump stack and heap at each GC
    >= 4: dump stack and heap at each VM instruction
*/

#if DEBUG >= 2 && defined(__PC__)
#define TRACE_INSTRUCTION(instr_name) printf("[%3d]: " instr_name "\n", pc - 1)
#else
#define TRACE_INSTRUCTION(instr_name)
#endif

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
