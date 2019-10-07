#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <caml/mlvalues.h>
#include <caml/alloc.h>

value caml_string_of_int(value v) {
  char buf[13];
  snprintf(buf, sizeof(buf), "%ld", Long_val(v));
  return caml_copy_string(buf);
}

value caml_string_of_float(value v) {
  char buf[13];
  snprintf(buf, sizeof(buf), "%.3g", Double_val(v));
  return caml_copy_string(buf);
}

value caml_string_of_int32(value v) {
  char buf[13];
  snprintf(buf, sizeof(buf), "%" PRId32, (int32_t) Field(v, 1));
  return caml_copy_string(buf);
}

value caml_string_of_int64(value v) {
  char buf[26];
  snprintf(buf, sizeof(buf), "%" PRId64, (int64_t) Field(v, 1));
  return caml_copy_string(buf);
}
