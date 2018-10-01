#include "debug.h"
#include "gc.h"

value caml_make_vect(value len, value init) {
  value res;
  mlsize_t size, i;
  size = Int_val(len);
  if (size == 0) {
    res = OCAML_atom0;
  } else {
    OCamlAlloc(res, size, 0);
    for (i = 0; i < size; i ++) {
      Ram_field(res, i) = init;
    }
  }
  return res;
}

value caml_array_get_addr(value array, value index) {
  mlsize_t idx = Int_val(index);
  assert(Is_block(array));
  if (idx >= Wosize_val(array)) caml_raise_index_out_of_bounds();
  return Field(array, idx);
}

value caml_array_set_addr(value array, value index, value newval) {
  mlsize_t idx = Int_val(index);
  assert(Is_block(array));
  assert(Is_in_ram(array));
  if (idx >= Wosize_val(array)) caml_raise_index_out_of_bounds();
  Ram_field(array, idx) = newval;
  return Val_unit;
}

value caml_array_unsafe_get(value array, value index) {
  assert(Is_block(array));
  return Field(array, Int_val(index));
}

value caml_array_unsafe_set(value array, value index, value val) {
  assert(Is_block(array));
  assert(Is_in_ram(array));
  Ram_field(array, Int_val(index)) = val;
  return Val_unit;
}

value caml_array_get(value array, value index) {
  return caml_array_get_addr(array, index); // OK since floats are not boxed
}

value caml_array_set(value array, value index, value val) {
  return caml_array_set_addr(array, index, val); // OK since floats are not boxed
}

value caml_array_sub(value array, value ml_ofs, value ml_len) {
  mlsize_t ofs = Int_val(ml_ofs);
  mlsize_t len = Int_val(ml_len);
  value result;
  mlsize_t i;
  OCamlAlloc(result, len, 0);
  for (i = 0; i < len; i ++) {
    Ram_field(result, i) = Field(array, i + ofs);
  }
  return result;
}

value caml_array_append(value tbl1, value tbl2) {
  mlsize_t sz1 = Wosize_val(tbl1);
  mlsize_t sz2 = Wosize_val(tbl2);
  value result;
  mlsize_t i;
  OCamlAlloc(result, sz1 + sz2, 0);
  for (i = 0; i < sz1; i ++) {
    Ram_field(result, i) = Field(tbl1, i);
  }
  for (i = 0; i < sz2; i ++) {
    Ram_field(result, i + sz1) = Field(tbl2, i);
  }
  return result;
}

value caml_array_blit(value tbl1, value ml_ofs1, value tbl2, value ml_ofs2, value ml_n) {
  value i, n = Int_val(ml_n), ofs1 = Int_val(ml_ofs1), ofs2 = Int_val(ml_ofs2);
  for (i = 0; i < n; i ++) {
    Ram_field(tbl2, ofs2 + i) = Field(tbl1, ofs1 + i);
  }
  return Val_unit;
}
