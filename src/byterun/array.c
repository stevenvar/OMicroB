

/* #define Modify(fp,val) caml_modify((fp), (val)) */
val_t caml_make_vect(val_t len, val_t init)
{
  val_t res;
  mlsize_t size, i;
  size = Int_val(len);
  if (size == 0) {
    res = Val_unit; 
    /* Atom(0); */
  } else {
      Alloc_small(res,size, 0);
      for (i = 0; i < size; i++) 
        Field(res, i) =  init;
      /* res = caml_check_urgent_gc (res); */
  }
  return res;
}

val_t caml_array_get_addr(val_t array, val_t index)
{
  val_t idx = Int_val(index);
  /* if (idx < 0 || idx >= Wosize_val(array)) caml_array_bound_error(); */
  return Field(array, idx);
}

val_t caml_array_set_addr(val_t array, val_t index, val_t newval)
{
  val_t idx = Int_val(index);
  /* if (idx < 0 || idx >= Wosize_val(array)) caml_array_bound_error(); */
  Field(array, idx) =  newval;
  return Val_unit;
}
