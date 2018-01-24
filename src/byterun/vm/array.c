#include "debug.h"
#include "gc.h"

extern PROGMEM const value atom0_header;

value caml_make_vect(value len, value init) {
  value res;
  mlsize_t size, i;
  size = Int_val(len);
  if (size == 0) {
    res = Val_flash_block(&atom0_header + 1);
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
