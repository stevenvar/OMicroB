#include "values.h"
#include "oo.h"

static val_t oo_last_id = Val_int(OCAML_STARTING_OOID);

val_t caml_fresh_oo_id (val_t v) {
  v = oo_last_id;
  oo_last_id += 2;
  return v;
}
