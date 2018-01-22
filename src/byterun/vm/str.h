#ifndef STR_H
#define STR_H

#include "values.h"

int string_length(value s);

value caml_string_length(value s);
value caml_string_equal(value s1, value s2);
value caml_bytes_equal(value s1, value s2);
value caml_string_notequal(value s1, value s2);

#endif
