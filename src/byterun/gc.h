#ifdef DEBUG
#include <stdio.h>
#endif

#include <stdint.h>

#include "values.h"

extern val_t *heap_ptr;
extern val_t *heap_end;

void gc_init(void);
void gc(mlsize_t wosize);

#define OCamlAlloc(result, wosize, tag)                                \
  do {                                                                 \
    if (heap_ptr + (wosize + 1) > heap_end) gc(wosize);                \
    *heap_ptr = Make_header((wosize), (tag));                          \
    heap_ptr ++;                                                       \
    result = Val_block(heap_ptr);                                      \
    heap_ptr += wosize;                                                \
  } while(0)
