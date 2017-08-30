#include <stdint.h>
#include "debug.h"
#include "values.h"

extern val_t *heap_ptr, *ocaml_heap;
extern val_t *heap_end;

extern void gc(mlsize_t wosize);
extern void gc_init(int32_t heap_size);

#define DEBUGassert(test) assert(test)
#define DEBUGclear(val, sz) do { for (int i = 0; i < sz; i ++) Field(val, i) = Val_unit; } while(0)

    //    DEBUGassert((tag_t) (tag) < 256);

#define Alloc_small(result, wosize, tag)                                \
  do {                                                                  \
    printf("val_t = %lu , size=%lu ,tag=%d , heap_ptr=%p , heap_end = %p \n",  sizeof(val_t), wosize,tag, heap_ptr, heap_end); \
    DEBUGassert((wosize) >= 1);                                         \
    if ((heap_ptr + (wosize + 1) * sizeof(val_t)) > heap_end) gc(wosize); \
    *heap_ptr = Make_header((wosize), (tag));				\
    printf("alloc \n");						\
    heap_ptr ++ ; \
    printf("alloc middle \n");			\
    printf("val_t = %lu , size=%lu ,tag=%d , heap_ptr=%p , heap_end = %p \n",  sizeof(val_t), wosize,tag, heap_ptr, heap_end); \
    result = Val_block(heap_ptr); \
    printf("alloc, heap_ptr = %p , result = %ld \n", heap_ptr, result); \
    /* (result) = Val_block(heap_ptr);                                     \ */ \
    heap_ptr += wosize ;						\
    /* DEBUGclear((result), (wosize));                                     \ */ \
    printf("alloc end, heap_ptr = %p , result = %ld \n", heap_ptr, result); \
  } while(0)
