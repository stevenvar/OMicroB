/* Entry point including the whole runtime */

#include "values.h"
#ifdef DEBUG
#include "debug.c"
#endif
#include "prims.c"
#include "interp.c"
#include "stdlib.c"
#include "simul.c"

#include "gc.h"
#include "gc.c"

/******************************************************************************/
// GC dummy implementation, remove me later

/* #include "debug.h" */

//val_t heap_ptr;
//val_t heap_end;

//void gc_init(void) {
//  heap_ptr = Val_block(OCAML_HEAP_INITIAL_WOSIZE << 3);
//  heap_end = Val_block(OCAML_HEAP_WOSIZE << 3);
//}

//void gc(mlsize_t wosize) {
//  assert(0);
//}

/******************************************************************************/
