
typedef union caml_float
{
  float f;
  value v;
} caml_float;


value caml_neq_float(value v1, value v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f != f2.f);
}


value caml_eq_float(value v1, value v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f == f2.f);
}


value caml_le_float(value v1, value v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f <= f2.f);
}


value caml_lt_float(value v1, value v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f < f2.f);
}

value caml_ge_float(value v1, value v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f >= f2.f);
}


value caml_gt_float(value v1, value v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f > f2.f);
}


value caml_add_float(value f1, value f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f + a2.f ;
  return a3.v;
}

value caml_mul_float(value f1, value f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f * a2.f ;
  return a3.v;
}
value caml_div_float(value f1, value f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f / a2.f ;
  return a3.v;
}

value caml_sub_float(value f1, value f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f - a2.f ;
  return a3.v;
}
