#include <stdint.h>
#include "debug.h"
#include "values.h"

extern val_t *heap_ptr;
extern val_t ocaml_heap[];
extern val_t *heap_end;

extern void gc(mlsize_t wosize);
extern void gc_init(int32_t heap_size);
extern void print_heap();

#define DEBUGassert(test) assert(test)
#define DEBUGclear(val, sz) do { for (int i = 0; i < sz; i ++) Field(val, i) = Val_unit; } while(0)

    //    DEBUGassert((tag_t) (tag) < 256);

#define Alloc_small(result, wosize, tag)                                \
  do {                                                                  \
    printf("alloc size = %d, tag = %d , sp = %p \n",wosize, tag, sp); \
    print_heap();							\
    DEBUGassert((wosize) >= 1);                                         \
    /* if ((heap_ptr + (wosize + 1) * sizeof(val_t)) > heap_end) gc(wosize); \ */ \
    printf("heap_ptr = %p \n",heap_ptr); \
    *heap_ptr = Make_header((wosize), (tag));				\
    heap_ptr ++ ; \
    result = Val_block(heap_ptr); \
    heap_ptr += wosize ;						\
    /* DEBUGclear((result), (wosize));                                     \ */ \
    printf("end of alloc \n"); \
    print_heap();	       \
  } while(0)
