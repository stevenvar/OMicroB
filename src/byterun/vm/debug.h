#ifndef __DEBUG_H__
#define __DEBUG_H__

/*
  DEBUG levels:
    == 0: no debug, only traces from the OCaml program
    >= 1: trace GC runs
    >= 2: trace VM instructions
    >= 3: dump stack and heap at each VM instruction
*/

#if DEBUG >= 2 && defined(__PC__)
#define TRACE_INSTRUCTION(instr_name) printf("[%3d]: " instr_name "\n", pc - 1)
#else
#define TRACE_INSTRUCTION(instr_name)
#endif

void print_heap(void);
void print_global(void);
void print_stack(void);

#endif
