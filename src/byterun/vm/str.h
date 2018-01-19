#ifndef STR_H
#define STR_H

#include "values.h"

int string_length(val_t s);

val_t caml_string_length(val_t s);
val_t caml_string_equal(val_t s1, val_t s2);
val_t caml_bytes_equal(val_t s1, val_t s2);
val_t caml_string_notequal(val_t s1, val_t s2);

#endif
