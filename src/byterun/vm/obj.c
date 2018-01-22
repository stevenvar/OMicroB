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
    OCamlAlloc(res, sz, tg);
    memcpy((char *) Block_val(res), (char *) Block_val(arg), sz * sizeof(value));
    return res;
  }
}
