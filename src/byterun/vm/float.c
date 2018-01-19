
typedef union caml_float
{
  float f;
  val_t v;
} caml_float;


val_t caml_neq_float(val_t v1, val_t v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f != f2.f);
}


val_t caml_eq_float(val_t v1, val_t v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f == f2.f);
}


val_t caml_le_float(val_t v1, val_t v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f <= f2.f);
}


val_t caml_lt_float(val_t v1, val_t v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f < f2.f);
}

val_t caml_ge_float(val_t v1, val_t v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f >= f2.f);
}


val_t caml_gt_float(val_t v1, val_t v2){
  union caml_float f1;
  union caml_float f2;
  
  f1.v = v1;
  f2.v = v2;

  return Val_bool(f1.f > f2.f);
}


val_t caml_add_float(val_t f1, val_t f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f + a2.f ;
  return a3.v;
}

val_t caml_mul_float(val_t f1, val_t f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f * a2.f ;
  return a3.v;
}
val_t caml_div_float(val_t f1, val_t f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f / a2.f ;
  return a3.v;
}

val_t caml_sub_float(val_t f1, val_t f2){
  caml_float a1, a2, a3;
  a1.v = f1;
  a2.v = f2;
  a3.f = a1.f - a2.f ;
  return a3.v;
}
