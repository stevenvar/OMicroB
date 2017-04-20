#include "values.h"
#include "prims.c"
#include "interp.c"
//#include "gc.c"

/******************************************************************************/

#include <assert.h>

val_t heap_ptr;
val_t heap_end;

void init_gc(void) {
  heap_ptr = Val_block(OCAML_HEAP_INITIAL_USAGE << 3);
  heap_end = Val_block(OCAML_HEAP_WOSIZE << 3);
}

void gc(mlsize_t wosize) {
  assert(0);
}

/******************************************************************************/
