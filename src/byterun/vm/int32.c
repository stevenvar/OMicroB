#include <stdint.h>
#include <inttypes.h>
#include "values.h"
#include "fail.h"
#include "gc.h"
#include "str.h"

#if OCAML_VIRTUAL_ARCH == 16
#define Int32_val(v) (Is_int(v) ? (int32_t) Int_val(v) : ((int32_t) (uint16_t) Field(v, 1)) | ((int32_t) Field(v, 2) << 16))
#elif OCAML_VIRTUAL_ARCH == 32
#define Int32_val(v) (Is_int(v) ? (int32_t) Int_val(v) : (int32_t) Field(v, 1))
#elif OCAML_VIRTUAL_ARCH == 64
#define Int32_val(v) ((int32_t) Int_val(v))
#endif

static value value_of_int32(int32_t n) {
#if OCAML_VIRTUAL_ARCH == 16
  if (-0x4000 <= n && n <= 0x3FFF) {
    return Val_int(n);
  } else {
    value result;
    OCamlAlloc(result, 3, Custom_tag);
    Ram_field(result, 0) = INT32_CUSTOM_FLAG;
    Ram_field(result, 1) = (value) ((n >> 16) & 0xFFFF);
    Ram_field(result, 2) = (value) (n & 0xFFFF);
    return result;
  }
#elif OCAML_VIRTUAL_ARCH == 32
  if (-0x40000000 <= n && n <= 0x3FFFFFFF) {
    return Val_int(n);
  } else {
    value result;
    OCamlAlloc(result, 2, Custom_tag);
    Ram_field(result, 0) = INT32_CUSTOM_FLAG;
    Ram_field(result, 1) = (value) n;
    return result;
  }
#elif OCAML_VIRTUAL_ARCH == 64
  return Val_int(n);
#endif
}

int8_t int32_compare(value v0, value v1) {
  int32_t n0 = Int32_val(v0);
  int32_t n1 = Int32_val(v1);
  if (n0 < n1) return -1;
  if (n0 > n1) return 1;
  return 0;
}

value caml_int32_compare(value v0, value v1) {
  return Val_int(int32_compare(v0, v1));
}

value caml_int32_neg(value v) {
  return value_of_int32(-Int32_val(v));
}

value caml_int32_add(value v0, value v1) {
  return value_of_int32(Int32_val(v0) + Int32_val(v1));
}

value caml_int32_sub(value v0, value v1) {
  return value_of_int32(Int32_val(v0) - Int32_val(v1));
}

value caml_int32_mul(value v0, value v1) {
  return value_of_int32(Int32_val(v0) * Int32_val(v1));
}

value caml_int32_div(value v0, value v1) {
  int32_t n0 = Int32_val(v0);
  int32_t n1 = Int32_val(v1);
  if (n1 == 0) caml_raise_division_by_zero();
  return value_of_int32(n0 / n1);
}

value caml_int32_mod(value v0, value v1) {
  int32_t n0 = Int32_val(v0);
  int32_t n1 = Int32_val(v1);
  if (n1 == 0) caml_raise_division_by_zero();
  return value_of_int32(n0 % n1);
}

value caml_int32_and(value v0, value v1) {
  return value_of_int32(Int32_val(v0) & Int32_val(v1));
}

value caml_int32_or(value v0, value v1) {
  return value_of_int32(Int32_val(v0) | Int32_val(v1));
}

value caml_int32_xor(value v0, value v1) {
  return value_of_int32(Int32_val(v0) ^ Int32_val(v1));
}

value caml_int32_lsl(value v0, value v1) {
  return value_of_int32(Int32_val(v0) << Int_val(v1));
}

value caml_int32_asr(value v0, value v1) {
  return value_of_int32(Int32_val(v0) >> Int_val(v1));
}

value caml_int32_lsr(value v0, value v1) {
  return value_of_int32((uint32_t) Int32_val(v0) >> Int_val(v1));
}

value caml_int32_of_int(value v) {
  return v;
}

value caml_int32_to_int(value v) {
  return Val_int(Int32_val(v));
}

value caml_int32_of_float(value v) {
  return value_of_int32((int32_t) Float_val(v));
}

value caml_int32_to_float(value v) {
  return Val_float((float) Int32_val(v));
}

value caml_string_of_int32(value v) {
  char buf[13];
  snprintf(buf, sizeof(buf), "%" PRId32, Int32_val(v));
  return copy_bytes(buf);
}

value caml_int32_of_string(value s) {
  caml_raise_failure("Int32.of_string not yet implemented"); // TODO
  return Val_unit;
}
