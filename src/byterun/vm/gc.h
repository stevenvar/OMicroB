#ifndef GC_H
#define GC_H

#include <stdint.h>

#include "values.h"
#include "fail.h"

extern uint32_t gc_count;
extern value *heap_ptr;
extern value *heap_end;

void gc_init(void);
void gc(void);

#define OCamlAlloc(result, wosize, tag)                                \
  do {                                                                 \
    if (heap_ptr + (wosize) + 1 > heap_end) {                          \
      gc();                                                            \
      if (heap_ptr + (wosize) + 1 > heap_end) {                        \
        caml_raise_out_of_memory();                                    \
      }                                                                \
    }                                                                  \
    *heap_ptr = Make_header((wosize), (tag), Color_white);             \
    heap_ptr ++;                                                       \
    (result) = Val_dynamic_block(heap_ptr);                            \
    heap_ptr += (wosize);                                              \
  } while(0)

#endif
