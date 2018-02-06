#include <stdint.h>
#include <math.h>
#include "values.h"

#if OCAML_VIRTUAL_ARCH == 16

#define   NAN15 ((value) 0x7E01)
#define  ZERO15 ((value) 0x0001)
#define NZERO15 ((value) 0xFFFF)
#define   INF15 ((value) 0x7C01)
#define  NINF15 ((value) 0x83FF)

union float_or_uint32 { float f; uint32_t n; };

value value_of_float(float x) {
  if (x != x) {
    return NAN15;
  } else if (x == INFINITY) {
    return INF15;
  } else if (x == -INFINITY) {
    return NINF15;
  } else {
    union float_or_uint32 fou = { .f = x };
    uint32_t n = fou.n;
    uint8_t sign = n >> 31;
    uint8_t exponent = n >> 23;
    uint32_t mantissa = n & 0x7FFFFF;
    uint16_t m15 = mantissa >> 14;
    if (m15 != 0x1FF && (mantissa & 0x2000) != 0) m15 ++;
    if (exponent < 0x70) {
      return sign == 0 ? ZERO15 : NZERO15;
    } else if (exponent < 0x90) {
      uint8_t b1 = (sign << 7) | ((exponent & 0x80) >> 1) | ((exponent & 0x0F) << 2) | ((uint8_t) (m15 >> 7));
      uint8_t b0 = ((m15 << 1) & 0xFF) | 1;
      if (sign == 0) return ((uint16_t) b1 << 8) | ((uint16_t) b0);
      else return (((uint16_t) b1 ^ 0x7F) << 8) | ((uint16_t) b0 ^ 0xFE);
    } else if (sign == 0) {
      return INF15;
    } else {
      return NINF15;
    }
  }
}

float float_of_value(value v) {
  if (v == NAN15) {
    return NAN;
  } else if (v == ZERO15) {
    return 0.;
  } else if (v == NZERO15) {
    return -0.;
  } else if (v == INF15) {
    return INFINITY;
  } else if (v == NINF15) {
    return -INFINITY;
  } else {
    uint16_t n = (v < 0 ? v ^ 0x7FFE : v);
    uint8_t sign = n >> 15;
    uint8_t e15 = (n >> 10) & 0x1F;
    uint16_t m15 = (n >> 1) & 0x1FF;
    uint8_t exponent = ((e15 & 0x10) != 0 ? 0x80 : 0x70) | (e15 & 0x0F);
    uint32_t mantissa = (uint32_t) m15 << 14;
    uint32_t n32 = (uint32_t) sign << 31 | ((uint32_t) exponent << 23) | mantissa;
    union float_or_uint32 fou = { .n = n32 };
    return fou.f;
  }
}

#endif

value caml_neq_float(value v1, value v2) {
  return Val_bool(Float_val(v1) != Float_val(v2));
}

value caml_eq_float(value v1, value v2) {
  return Val_bool(Float_val(v1) == Float_val(v2));
}

value caml_le_float(value v1, value v2) {
  return Val_bool(Float_val(v1) <= Float_val(v2));
}

value caml_lt_float(value v1, value v2) {
  return Val_bool(Float_val(v1) < Float_val(v2));
}

value caml_ge_float(value v1, value v2) {
  return Val_bool(Float_val(v1) >= Float_val(v2));
}

value caml_gt_float(value v1, value v2) {
  return Val_bool(Float_val(v1) > Float_val(v2));
}

value caml_float_compare(value v1, value v2) {
  if (v1 == v2) return Val_int(0);
  if (v1 == Val_nan) return Val_int(-1);
  if (v2 == Val_nan) return Val_int(1);
  return v1 < v2 ? Val_int(-1) : Val_int(1);
}

value caml_neg_float(value v) {
  return Val_float(-Float_val(v));
}

value caml_add_float(value v1, value v2) {
  return Val_float(Float_val(v1) + Float_val(v2));
}

value caml_mul_float(value v1, value v2) {
  return Val_float(Float_val(v1) * Float_val(v2));
}

value caml_div_float(value v1, value v2) {
  return Val_float(Float_val(v1) / Float_val(v2));
}

value caml_sub_float(value v1, value v2){
  return Val_float(Float_val(v1) - Float_val(v2));
}

value caml_float_of_int(value i) {
  return Val_float(Int_val(i));
}

value caml_int_of_float(value x) {
  return Val_int(Float_val(x));
}
