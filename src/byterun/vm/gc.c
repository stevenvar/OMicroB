#include <stdint.h>
#include "gc.h"

uint32_t gc_count = 0;

value caml_gc_run(value unit) {
  gc();
  return Val_unit;
}

value caml_gc_collections(value unit) {
  return Val_int(gc_count);
}

value caml_gc_live_words(value unit) {
#ifdef OCAML_GC_MARK_AND_COMPACT
  return Val_int(OCAML_DYNAMIC_HEAP_WOSIZE - (heap_end - heap_ptr));
#else
  return Val_int(OCAML_DYNAMIC_HEAP_WOSIZE / 2 - (heap_end - heap_ptr));
#endif
}

value caml_gc_free_words(value unit) {
  return Val_int(heap_end - heap_ptr);
}

value caml_gc_used_stack_size(value unit) {
  return Val_int(ocaml_stack + OCAML_STACK_WOSIZE - sp);
}

value caml_gc_available_stack_size(value unit) {
  return Val_int(sp - ocaml_stack);
}
