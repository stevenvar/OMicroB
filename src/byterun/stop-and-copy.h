#ifdef DEBUG
#include <stdio.h>
#endif

#include <stdint.h>

#include "debug.h"
#include "values.h"

extern val_t *heap_ptr;
extern val_t ocaml_heap[OCAML_HEAP_WOSIZE*2];
extern val_t *heap_end;

extern void gc(mlsize_t wosize);
extern void gc_init(int32_t heap_size);

void print_heap();
void clean_heap();

#define OCamlAlloc(result, wosize, tag)                                \
  do {                                                                 \
    if (heap_ptr + (wosize + 1) > heap_end) gc(wosize);                \
    *heap_ptr = Make_header((wosize), (tag));                          \
    heap_ptr ++;                                                       \
    result = Val_block(heap_ptr);                                      \
    heap_ptr += wosize;                                                \
  } while(0)
