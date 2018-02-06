#include <string.h>
#include "debug.h"
#include "values.h"
#include "gc.h"
#include "obj.h"

value caml_obj_dup(value arg) {
  mlsize_t sz = Wosize_val(arg);
  if (sz == 0) {
    return arg;
  } else {
    value res;
    tag_t tg = Tag_val(arg);
    mlsize_t i;
    OCamlAlloc(res, sz, tg);
    for (i = 0; i < sz; i ++) {
      Ram_field(res, i) = Field(arg, i);
    }
    return res;
  }
}

value caml_alloc_dummy(value ml_size) {
  mlsize_t size = Int_val(ml_size);
  if (size == 0) {
    return OCAML_atom0;
  } else {
    value res;
    mlsize_t i;
    OCamlAlloc(res, size, 0);
    for (i = 0; i < size; i ++) {
      Ram_field(res, i) = Val_unit;
    }
    return res;
  }
}

value caml_update_dummy(value dummy, value newval) {
  mlsize_t i, size = Wosize_val(newval);
  assert(size == Wosize_val(dummy));
  assert(Is_in_ram(dummy));
  Ram_hd_val(dummy) = Hd_val(newval);
  for (i = 0; i < size; i ++) {
    Ram_field(dummy, i) = Field(newval, i);
  }
  return Val_unit;
}
