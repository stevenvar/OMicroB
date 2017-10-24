#define OCAML_STACK_WOSIZE             16
#define OCAML_HEAP_WOSIZE             100
#define OCAML_HEAP_INITIAL_WOSIZE       2
#define OCAML_STACK_INITIAL_WOSIZE      1
#define OCAML_GLOBDATA_NUMBER           0
#define OCAML_BYTECODE_BSIZE           47
#define OCAML_PRIMITIVE_NUMBER          2
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_PUSH                      2
#define OCAML_PUSHACC1                  3
#define OCAML_PUSHACC2                  4
#define OCAML_POP                       5
#define OCAML_ASSIGN                    6
#define OCAML_APPLY1                    7
#define OCAML_RETURN                    8
#define OCAML_PUSHOFFSETCLOSURE0        9
#define OCAML_BRANCH_1B                10
#define OCAML_BRANCHIF_1B              11
#define OCAML_CHECK_SIGNALS            12
#define OCAML_C_CALL1                  13
#define OCAML_CONST0                   14
#define OCAML_CONST1                   15
#define OCAML_PUSHCONSTINT_2B          16
#define OCAML_MULINT                   17
#define OCAML_NEQ                      18
#define OCAML_GTINT                    19
#define OCAML_OFFSETINT_1B             20
#define OCAML_STOP                     21

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /* 0 */  Make_header(1, Closure_tag),
  /* 1 */  Val_codeptr(2)
};

const val_t* ocaml_heap1 = ocaml_heap;
const val_t* ocaml_heap2 = ocaml_heap + OCAML_HEAP_WOSIZE;

val_t acc = Val_int(24);

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
  /* 15 */  Init_val_block(4 * 1)
};

val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*  0 */  OCAML_BRANCH_1B,
  /*  1 */  17,
  /*  2 */  OCAML_ACC0,
  /*  3 */  OCAML_BRANCHIF_1B,
  /*  4 */  5,
  /*  5 */  OCAML_CONST1,
  /*  6 */  OCAML_RETURN,
  /*  7 */  1,
  /*  8 */  OCAML_ACC0,
  /*  9 */  OCAML_PUSHACC1,
  /* 10 */  OCAML_OFFSETINT_1B,
  /* 11 */  -1,
  /* 12 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 13 */  OCAML_APPLY1,
  /* 14 */  OCAML_MULINT,
  /* 15 */  OCAML_RETURN,
  /* 16 */  1,
  /* 17 */  OCAML_C_CALL1,
  /* 18 */  0,
  /* 19 */  OCAML_CONST0,
  /* 20 */  OCAML_PUSHCONSTINT_2B,
  /* 21 */  39,
  /* 22 */  16,
  /* 23 */  OCAML_PUSH,
  /* 24 */  OCAML_PUSHACC2,
  /* 25 */  OCAML_GTINT,
  /* 26 */  OCAML_BRANCHIF_1B,
  /* 27 */  13,
  /* 28 */  OCAML_CHECK_SIGNALS,
  /* 29 */  OCAML_ACC1,
  /* 30 */  OCAML_PUSH,
  /* 31 */  OCAML_OFFSETINT_1B,
  /* 32 */  1,
  /* 33 */  OCAML_ASSIGN,
  /* 34 */  2,
  /* 35 */  OCAML_ACC1,
  /* 36 */  OCAML_NEQ,
  /* 37 */  OCAML_BRANCHIF_1B,
  /* 38 */  -9,
  /* 39 */  OCAML_POP,
  /* 40 */  2,
  /* 41 */  OCAML_CONST0,
  /* 42 */  OCAML_C_CALL1,
  /* 43 */  1,
  /* 44 */  OCAML_POP,
  /* 45 */  1,
  /* 46 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduboy_print_int,
  (void *) &ocaml_arduboy_display
};
