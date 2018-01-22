#ifndef GC_H
#define GC_H

#include <stdint.h>

#include "values.h"

extern value *heap_ptr;
extern value *heap_end;

void gc_init(void);
void gc(void);

#define OCamlAlloc(result, wosize, tag)                                \
  do {                                                                 \
    if (heap_ptr + (wosize) + 1 > heap_end) {                          \
      gc();                                                            \
      if (heap_ptr + (wosize) + 1 > heap_end) {                        \
        (result) = 0;                                                  \
      }                                                                \
    }                                                                  \
    *heap_ptr = Make_header((wosize), (tag), Color_white);             \
    heap_ptr ++;                                                       \
    (result) = Val_block(heap_ptr);                                    \
    heap_ptr += (wosize);                                              \
  } while(0)

#endif
