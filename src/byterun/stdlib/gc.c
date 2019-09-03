
#include <caml/mlvalues.h>
#include <caml/gc.h>

extern value caml_gc_compaction(value unit);

value caml_gc_run(value unit) {
  return caml_gc_compaction(unit);
}

value caml_gc_collections(value unit) {
  return Val_int(0);
}

value caml_gc_live_words(value unit) {
  return Val_int(0);
}

value caml_gc_free_words(value unit) {
  return Val_int(0);
}

value caml_gc_used_stack_size(value unit) {
  return Val_int(0);
}

value caml_gc_available_stack_size(value unit) {
  return Val_int(0);
}
