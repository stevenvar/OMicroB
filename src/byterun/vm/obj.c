#include <string.h>
#include "values.h"
#include "gc.h"
#include "obj.h"

val_t caml_obj_dup(val_t arg) {
  mlsize_t sz = Wosize_val(arg);
  if (sz == 0) {
    return arg;
  } else {
    val_t res;
    tag_t tg = Tag_val(arg);
    OCamlAlloc(res, sz, tg);
    memcpy((char *) Block_val(res), (char *) Block_val(arg), sz * sizeof(val_t));
    return res;
  }
}
