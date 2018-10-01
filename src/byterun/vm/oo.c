#include "values.h"
#include "oo.h"

static value oo_last_id = Val_int(OCAML_STARTING_OOID);

value caml_fresh_oo_id (value v) {
  v = oo_last_id;
  oo_last_id += 2;
  return v;
}

value caml_set_oo_id(value obj) {
  Ram_field(obj, 1) = oo_last_id;
  oo_last_id += 2;
  return obj;
}
