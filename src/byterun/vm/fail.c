#include "values.h"
#include "fail.h"
/*
static val_t out_of_memory_s[] = {
  Make_header(4, String_tag, Color_white),
  Make_string_data('O', 'u', 't', '_'),
  Make_string_data('o', 'f', '_', 'm'),
  Make_string_data('e', 'm', 'o', 'r'),
  Make_string_data('y', '\0', '\0', '\2')
};

static val_t out_of_memory[] = {
  Make_header(2, Object_tag, Color_white),
  (val_t) ((intptr_t) &(out_of_memory_s[1]) | 0x7FF00000),
  Val_int(-1)
};
*/
void caml_raise(val_t v) {
  // TODO
}

void caml_invalid_argument(char const *msg) {
  // TODO
}

void caml_out_of_memory(void) {
  // TODO
}
