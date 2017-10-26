#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              64
#define OCAML_HEAP_INITIAL_WOSIZE       0
#define OCAML_STACK_INITIAL_WOSIZE      0
#define OCAML_GLOBDATA_NUMBER           0
#define OCAML_BYTECODE_BSIZE            1
#define OCAML_PRIMITIVE_NUMBER          0
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_STOP                      0

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
};

const val_t* ocaml_heap1 = ocaml_heap;
const val_t* ocaml_heap2 = ocaml_heap + OCAML_HEAP_WOSIZE;

val_t acc = Val_int(0);

val_t ocaml_stack[OCAML_STACK_WOSIZE] = {
  /*  0 */  Val_int(0),
  /*  1 */  Val_int(0),
  /*  2 */  Val_int(0),
  /*  3 */  Val_int(0),
  /*  4 */  Val_int(0),
  /*  5 */  Val_int(0),
  /*  6 */  Val_int(0),
  /*  7 */  Val_int(0),
  /*  8 */  Val_int(0),
  /*  9 */  Val_int(0),
  /* 10 */  Val_int(0),
  /* 11 */  Val_int(0),
  /* 12 */  Val_int(0),
  /* 13 */  Val_int(0),
  /* 14 */  Val_int(0),
  /* 15 */  Val_int(0),
  /* 16 */  Val_int(0),
  /* 17 */  Val_int(0),
  /* 18 */  Val_int(0),
  /* 19 */  Val_int(0),
  /* 20 */  Val_int(0),
  /* 21 */  Val_int(0),
  /* 22 */  Val_int(0),
  /* 23 */  Val_int(0),
  /* 24 */  Val_int(0),
  /* 25 */  Val_int(0),
  /* 26 */  Val_int(0),
  /* 27 */  Val_int(0),
  /* 28 */  Val_int(0),
  /* 29 */  Val_int(0),
  /* 30 */  Val_int(0),
  /* 31 */  Val_int(0),
  /* 32 */  Val_int(0),
  /* 33 */  Val_int(0),
  /* 34 */  Val_int(0),
  /* 35 */  Val_int(0),
  /* 36 */  Val_int(0),
  /* 37 */  Val_int(0),
  /* 38 */  Val_int(0),
  /* 39 */  Val_int(0),
  /* 40 */  Val_int(0),
  /* 41 */  Val_int(0),
  /* 42 */  Val_int(0),
  /* 43 */  Val_int(0),
  /* 44 */  Val_int(0),
  /* 45 */  Val_int(0),
  /* 46 */  Val_int(0),
  /* 47 */  Val_int(0),
  /* 48 */  Val_int(0),
  /* 49 */  Val_int(0),
  /* 50 */  Val_int(0),
  /* 51 */  Val_int(0),
  /* 52 */  Val_int(0),
  /* 53 */  Val_int(0),
  /* 54 */  Val_int(0),
  /* 55 */  Val_int(0),
  /* 56 */  Val_int(0),
  /* 57 */  Val_int(0),
  /* 58 */  Val_int(0),
  /* 59 */  Val_int(0),
  /* 60 */  Val_int(0),
  /* 61 */  Val_int(0),
  /* 62 */  Val_int(0),
  /* 63 */  Val_int(0)
};

val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /* 0 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
};
