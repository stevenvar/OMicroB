#include "values.h"
#include "oo.h"

static value oo_last_id = Val_int(OCAML_STARTING_OOID);

value caml_fresh_oo_id (value v) {
  v = oo_last_id;
  oo_last_id += 2;
  return v;
}
