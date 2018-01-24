#include <string.h>
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
