#include <stdint.h>
#include <assert.h>
#include "values.h"

extern val_t heap_ptr;
extern val_t heap_end;

extern void gc(mlsize_t wosize);
extern void init_gc(void);

#define DEBUGassert(test) assert(test)
#define DEBUGclear(val, sz) do { for (int i = 0; i < sz; i ++) Field(val, i) = Val_unit; } while(0)

#define Alloc_small(result, wosize, tag)                                \
  do {                                                                  \
    DEBUGassert((wosize) >= 1);                                         \
    DEBUGassert((tag_t) (tag) < 256);                                   \
    if (heap_ptr + (wosize + 1) * sizeof(val_t) > heap_end) gc(wosize); \
    heap_ptr += sizeof(val_t);                                          \
    Header(heap_ptr) = Make_header((wosize), (tag));                    \
    (result) = Val_block(heap_ptr);                                     \
    heap_ptr += wosize * sizeof(val_t);                                 \
    DEBUGclear((result), (wosize));                                     \
  } while(0)
