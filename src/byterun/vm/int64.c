#include <stdint.h>
#include <inttypes.h>
#include "values.h"
#include "fail.h"
#include "gc.h"
#include "str.h"

static value value_of_int64(int64_t n) {
#if OCAML_VIRTUAL_ARCH == 16
  if (-0x4000 <= n && n <= 0x3FFF) {
    return Val_int(n);
  } else {
    value result;
    OCamlAlloc(result, 5, Custom_tag);
    Ram_field(result, 0) = INT64_CUSTOM_FLAG;
    Ram_field(result, 1) = (value) ((n >> 48) & 0xFFFF);
    Ram_field(result, 2) = (value) ((n >> 32) & 0xFFFF);
    Ram_field(result, 3) = (value) ((n >> 16) & 0xFFFF);
    Ram_field(result, 4) = (value) (n & 0xFFFF);
    return result;
  }
#elif OCAML_VIRTUAL_ARCH == 32
  if (-0x40000000 <= n && n <= 0x3FFFFFFF) {
    return Val_int(n);
  } else {
    value result;
    OCamlAlloc(result, 3, Custom_tag);
    Ram_field(result, 0) = INT64_CUSTOM_FLAG;
    Ram_field(result, 1) = (value) ((n >> 32) & 0xFFFFFFFF);
    Ram_field(result, 2) = (value) (n & 0xFFFFFFFFFF);
    return result;
  }
#elif OCAML_VIRTUAL_ARCH == 64
  if (-0x4000000000000000ll <= n && n <= 0x3FFFFFFFFFFFFFFFll) {
    return Val_int(n);
  } else {
    value result;
    OCamlAlloc(result, 2, Custom_tag);
    Ram_field(result, 0) = INT64_CUSTOM_FLAG;
    Ram_field(result, 1) = (value) n;
    return result;
  }
#endif
}

int8_t int64_compare(value v0, value v1) {
  int64_t n0 = Int64_val(v0);
  int64_t n1 = Int64_val(v1);
  if (n0 < n1) return -1;
  if (n0 > n1) return 1;
  return 0;
}

value caml_int64_compare(value v0, value v1) {
  return Val_int(int64_compare(v0, v1));
}

value caml_int64_neg(value v) {
  return value_of_int64(-Int64_val(v));
}

value caml_int64_add(value v0, value v1) {
  return value_of_int64(Int64_val(v0) + Int64_val(v1));
}

value caml_int64_sub(value v0, value v1) {
  return value_of_int64(Int64_val(v0) - Int64_val(v1));
}

value caml_int64_mul(value v0, value v1) {
  return value_of_int64(Int64_val(v0) * Int64_val(v1));
}

value caml_int64_div(value v0, value v1) {
  int64_t n0 = Int64_val(v0);
  int64_t n1 = Int64_val(v1);
  if (n1 == 0) caml_raise_division_by_zero();
  return value_of_int64(n0 / n1);
}

value caml_int64_mod(value v0, value v1) {
  int64_t n0 = Int64_val(v0);
  int64_t n1 = Int64_val(v1);
  if (n1 == 0) caml_raise_division_by_zero();
  return value_of_int64(n0 % n1);
}

value caml_int64_and(value v0, value v1) {
  return value_of_int64(Int64_val(v0) & Int64_val(v1));
}

value caml_int64_or(value v0, value v1) {
  return value_of_int64(Int64_val(v0) | Int64_val(v1));
}

value caml_int64_xor(value v0, value v1) {
  return value_of_int64(Int64_val(v0) ^ Int64_val(v1));
}

value caml_int64_lsl(value v0, value v1) {
  return value_of_int64(Int64_val(v0) << Int_val(v1));
}

value caml_int64_asr(value v0, value v1) {
  return value_of_int64(Int64_val(v0) >> Int_val(v1));
}

value caml_int64_lsr(value v0, value v1) {
  return value_of_int64((uint64_t) Int64_val(v0) >> Int_val(v1));
}

value caml_int64_of_int(value v) {
  return v;
}

value caml_int64_to_int(value v) {
  return Val_int(Int64_val(v));
}

value caml_int64_of_float(value v) {
  return value_of_int64((int64_t) Float_val(v));
}

value caml_int64_to_float(value v) {
  return Val_float((float) Int64_val(v));
}

value caml_string_of_int64(value v) {
  char buf[26];
  format_int64(buf, sizeof(buf), v);
  return copy_bytes(buf);
}

value caml_int64_of_string(value s) {
  caml_raise_failure("Int64.of_string not yet implemented"); // TODO
  return Val_unit;
}
