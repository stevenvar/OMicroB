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

value caml_obj_block(value tag, value size) {
  value res;
  mlsize_t sz, i;
  tag_t tg;

  sz = Int_val(size);
  tg = Int_val(tag);
  if (sz == 0) {
    assert(tg == 0);
    return OCAML_atom0;
  } else {
    OCamlAlloc(res, sz, tg);
    for (i = 0; i < sz; i++) {
      Ram_field(res, i) = Val_int(0);
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
      // Some fields may be considered as headers since the block
      // may be truncated by caml_update_dummy.
      Ram_field(res, i) = Make_header(0, 0, Color_white);
    }
    return res;
  }
}

value caml_alloc_dummy_function(value ml_size, value ml_arity) {
  return caml_alloc_dummy(ml_size);
}

value caml_update_dummy(value dummy, value newval) {
  mlsize_t i, size = Wosize_val(newval);
  assert(size <= Wosize_val(dummy));
  assert(Is_in_ram(dummy));
  Ram_hd_val(dummy) = Hd_val(newval);
  for (i = 0; i < size; i ++) {
    Ram_field(dummy, i) = Field(newval, i);
  }
  return Val_unit;
}
