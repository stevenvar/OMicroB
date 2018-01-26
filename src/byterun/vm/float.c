#include "values.h"

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
