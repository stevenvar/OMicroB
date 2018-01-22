#ifndef FAIL_H
#define FAIL_H

#include "values.h"

void caml_raise(val_t v);
void caml_invalid_argument(char const *msg);
void caml_out_of_memory(void);
void caml_raise_division_by_zero(void);
void caml_raise_stack_overflow(void);

#endif
