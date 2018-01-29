#ifndef FAIL_H
#define FAIL_H

#include <setjmp.h>
#include "values.h"

extern jmp_buf caml_exception_jmp_buf;

void caml_raise_out_of_memory(void);
void caml_raise_stack_overflow(void);
void caml_raise_division_by_zero(void);
void caml_raise_invalid_argument(char const *msg);
void caml_raise_failure(char const *msg);
void caml_raise_index_out_of_bounds(void);

#endif
