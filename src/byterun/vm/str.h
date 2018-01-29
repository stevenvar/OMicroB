#ifndef STR_H
#define STR_H

#include "values.h"

mlsize_t string_length(value s);
int string_compare(value s1, value s2);
value copy_bytes(const char *str);

value caml_create_bytes(value len);
value caml_string_length(value s);
value caml_ml_string_length(value s);
value caml_ml_bytes_length(value b);
value caml_blit_string(value s, value sofs, value b, value bofs, value len);
value caml_blit_bytes(value in, value inofs, value out, value outofs, value len);
value caml_fill_bytes(value b, value ofs, value len, value c);
value caml_string_equal(value s1, value s2);
value caml_bytes_equal(value s1, value s2);
value caml_string_notequal(value s1, value s2);
value caml_string_compare(value s1, value s2);
value caml_bytes_compare(value b1, value b2);

#endif
