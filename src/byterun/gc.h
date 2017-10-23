#include <stdint.h>
#include "debug.h"
#include "values.h"

extern val_t *heap_ptr;
extern val_t ocaml_heap[OCAML_HEAP_WOSIZE*2];
extern val_t *heap_end;

extern void gc(mlsize_t wosize);
extern void gc_init(int32_t heap_size);
extern void print_heap();

#define DEBUGassert(test) assert(test)
#define DEBUGclear(val, sz) do { for (int i = 0; i < sz; i ++) Field(val, i) = Val_unit; } while(0)

    //    DEBUGassert((tag_t) (tag) < 256);

#define Alloc_small(result, wosize, tag)                                \
  do {                                                                  \
    DEBUGassert((wosize) >= 1);                                         \
    if (heap_ptr + (wosize + 1) > heap_end) gc(wosize); \
    *heap_ptr = Make_header((wosize), (tag));				\
    heap_ptr ++ ; \
    result = Val_block(heap_ptr); \
    heap_ptr += wosize ;						\
    /* DEBUGclear((result), (wosize));                                      \ */ \
  } while(0)
