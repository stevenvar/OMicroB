#include <stdint.h>
#include <math.h>
#include "values.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#if OCAML_VIRTUAL_ARCH == 16

union float_or_uint32 { float f; uint32_t n; };

value value_of_float(float x) {
  if (x != x) {
    return Val_nan;
  } else if (x == INFINITY) {
    return Val_inf;
  } else if (x == -INFINITY) {
    return Val_ninf;
  } else if (x == 0.) {
    return copysignf(1., x) > 0 ? Val_zero : Val_nzero;
  } else {
    union float_or_uint32 fou = { .f = x };
    uint32_t n = fou.n;
    uint8_t sign = n >> 31;
    uint8_t exponent = n >> 23;
    uint32_t mantissa = n & 0x7FFFFF;
    uint16_t m15 = mantissa >> 14;
    if (m15 != 0x1FF && (mantissa & 0x2000) != 0) m15 ++;
    if (exponent < 0x70) {
      return sign == 0 ? Val_zero : Val_nzero;
    } else if (exponent < 0x90) {
      uint8_t b1 = (sign << 7) | ((exponent & 0x80) >> 1) | ((exponent & 0x0F) << 2) | ((uint8_t) (m15 >> 7));
      uint8_t b0 = ((m15 << 1) & 0xFF) | 1;
      if (b1 == 0x80 && b0 == 0x01) {
        return Val_nzero;
      } else if (sign == 0) {
        return ((uint16_t) b1 << 8) | ((uint16_t) b0);
      } else {
        return (((uint16_t) b1 ^ 0x7F) << 8) | ((uint16_t) b0 ^ 0xFE);
      }
    } else if (sign == 0) {
      return Val_inf;
    } else {
      return Val_ninf;
    }
  }
}

float float_of_value(value v) {
  if (v == Val_nan) {
    return NAN;
  } else if (v == Val_zero) {
    return 0.;
  } else if (v == Val_nzero) {
    return -0.;
  } else if (v == Val_inf) {
    return INFINITY;
  } else if (v == Val_ninf) {
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

/******************************************************************************/

#if OCAML_VIRTUAL_ARCH == 32

union float_or_value { float f; value v; };

#define bitwise_value_of_float(x) (((union float_or_value) { .f = (x) }).v)
#define bitwise_float_of_value(x) (((union float_or_value) { .v = (x) }).f)

value value_of_float(float x) {
  if (x != x) {
    return Val_nan;
  } else if (x == 0.) {
    return copysignf(1., x) > 0 ? Val_zero : Val_nzero;
  } else {
    value v = bitwise_value_of_float(x);
    if (v < 0) {
      return v ^ 0x7FFFFFFF;
    } else {
      return v;
    }
  }
}

float float_of_value(value v) {
  if (v == Val_nzero) {
    return -0.;
  } else if (v < 0) {
    return bitwise_float_of_value(v ^ 0x7FFFFFFF);
  } else {
    return bitwise_float_of_value(v);
  }
}

#endif

/******************************************************************************/

#if OCAML_VIRTUAL_ARCH == 64

union double_or_value { double f; value v; };

#define bitwise_value_of_double(x) (((union double_or_value) { .f = (x) }).v)
#define bitwise_double_of_value(x) (((union double_or_value) { .v = (x) }).f)

value value_of_double(double x) {
  if (x != x) {
    return Val_nan;
  } else if (x == 0.l) {
    return copysign(1., x) > 0 ? Val_zero : Val_nzero;
  } else {
    value v = bitwise_value_of_double(x);
    if (v < 0) {
      return v ^ 0x7FFFFFFFFFFFFFFF;
    } else {
      return v;
    }
  }
}

double double_of_value(value v) {
  if (v == Val_nzero) {
    return -0.l;
  } else if (v < 0) {
    return bitwise_double_of_value(v ^ 0x7FFFFFFFFFFFFFFF);
  } else {
    return bitwise_double_of_value(v);
  }
}

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

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
  if (v1 == Val_zero && v2 == Val_nzero) return Val_int(0);
  if (v1 == Val_nzero && v2 == Val_zero) return Val_int(0);
  return v1 < v2 ? Val_int(-1) : Val_int(1);
}

value caml_cos_float(value v) {
  return Val_float(cos(Float_val(v)));
}

value caml_sin_float(value v) {
  return Val_float(sin(Float_val(v)));
}

value caml_abs_float(value v) {
  return Val_float(fabs(Float_val(v)));
}

value caml_sqrt_float(value v) {
  return Val_float(sqrt(Float_val(v)));
}

value caml_atan2_float(value v, value w) {
  return Val_float(atan2(Float_val(v), Float_val(w)));
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

value caml_fmod_float(value v1, value v2) {
  return Val_float(fmod(Float_val(v1), Float_val(v2)));
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

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
