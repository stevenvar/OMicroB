#include "gc.h"

extern value atom0_header;

value caml_make_vect(value len, value init) {
  value res;
  mlsize_t size, i;
  size = Int_val(len);
  if (size == 0) {
    res = Val_block(&atom0_header + 1);
    /* Atom(0); */
  } else {
    OCamlAlloc(res, size, 0);
    for (i = 0; i < size; i++)
      Field(res, i) =  init;
    /* res = caml_check_urgent_gc (res); */
  }
  return res;
}

value caml_array_get_addr(value array, value index) {
  value idx = Int_val(index);
  /*if (idx < 0 || idx >= Wosize_val(array)) caml_array_bound_error();*/
  return Field(array, idx);
}

value caml_array_set_addr(value array, value index, value newval) {
  value idx = Int_val(index);
  /*if (idx < 0 || idx >= Wosize_val(array)) caml_array_bound_error();*/
  Field(array, idx) =  newval;
  return Val_unit;
}

value caml_array_unsafe_get(value array, value index)
{
  return Field(array, Int_val(index));
}

value caml_array_unsafe_set(value array, value index, value val)
{
  Field(array, Int_val(index)) = val;
  return Val_unit;
}


value caml_array_get(value array, value index)
{
  return Field(array, Int_val(index));
}

value caml_array_set(value array, value index, value val)
{
  Field(array, Int_val(index)) = val;
  return Val_unit;
}
