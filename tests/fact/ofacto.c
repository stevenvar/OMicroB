#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              64
#define OCAML_HEAP_INITIAL_WOSIZE       4
#define OCAML_STACK_INITIAL_WOSIZE      1
#define OCAML_GLOBDATA_NUMBER           1
#define OCAML_BYTECODE_BSIZE           66
#define OCAML_PRIMITIVE_NUMBER          5
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_PUSH                      2
#define OCAML_PUSHACC1                  3
#define OCAML_PUSHACC2                  4
#define OCAML_PUSHACC4                  5
#define OCAML_POP                       6
#define OCAML_ASSIGN                    7
#define OCAML_APPLY1                    8
#define OCAML_RETURN                    9
#define OCAML_PUSHOFFSETCLOSURE0       10
#define OCAML_PUSHGETGLOBAL_1B         11
#define OCAML_BRANCH_1B                12
#define OCAML_BRANCHIF_1B              13
#define OCAML_BRANCHIFNOT_1B           14
#define OCAML_CHECK_SIGNALS            15
#define OCAML_C_CALL1                  16
#define OCAML_CONST0                   17
#define OCAML_CONST1                   18
#define OCAML_PUSHCONST0               19
#define OCAML_PUSHCONSTINT_1B          20
#define OCAML_SUBINT                   21
#define OCAML_MULINT                   22
#define OCAML_NEQ                      23
#define OCAML_GTINT                    24
#define OCAML_OFFSETINT_1B             25
#define OCAML_STOP                     26

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /* 0 */  Make_header(1, Closure_tag),
  /* 1 */  Val_codeptr(2),
  /* 2 */  Make_header(1, String_tag),
  /* 3 */  Make_string_data(0x0A, '\0', '\0', '\2')
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
  /* 63 */  Init_val_block(4 * 1)
};

val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
  /* 0 */  Init_val_block(4 * 3)
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*  0 */  OCAML_BRANCH_1B,
  /*  1 */  17,
  /*  2 */  OCAML_ACC0,
  /*  3 */  OCAML_BRANCHIFNOT_1B,
  /*  4 */  11,
  /*  5 */  OCAML_ACC0,
  /*  6 */  OCAML_PUSHACC1,
  /*  7 */  OCAML_OFFSETINT_1B,
  /*  8 */  -1,
  /*  9 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 10 */  OCAML_APPLY1,
  /* 11 */  OCAML_MULINT,
  /* 12 */  OCAML_RETURN,
  /* 13 */  1,
  /* 14 */  OCAML_CONST1,
  /* 15 */  OCAML_RETURN,
  /* 16 */  1,
  /* 17 */  OCAML_C_CALL1,
  /* 18 */  0,
  /* 19 */  OCAML_CONST0,
  /* 20 */  OCAML_C_CALL1,
  /* 21 */  1,
  /* 22 */  OCAML_PUSHCONST0,
  /* 23 */  OCAML_PUSHCONSTINT_1B,
  /* 24 */  10,
  /* 25 */  OCAML_PUSH,
  /* 26 */  OCAML_PUSHACC2,
  /* 27 */  OCAML_GTINT,
  /* 28 */  OCAML_BRANCHIF_1B,
  /* 29 */  18,
  /* 30 */  OCAML_CHECK_SIGNALS,
  /* 31 */  OCAML_ACC1,
  /* 32 */  OCAML_PUSHACC4,
  /* 33 */  OCAML_APPLY1,
  /* 34 */  OCAML_C_CALL1,
  /* 35 */  2,
  /* 36 */  OCAML_ACC1,
  /* 37 */  OCAML_PUSH,
  /* 38 */  OCAML_OFFSETINT_1B,
  /* 39 */  1,
  /* 40 */  OCAML_ASSIGN,
  /* 41 */  2,
  /* 42 */  OCAML_ACC1,
  /* 43 */  OCAML_NEQ,
  /* 44 */  OCAML_BRANCHIF_1B,
  /* 45 */  -14,
  /* 46 */  OCAML_POP,
  /* 47 */  2,
  /* 48 */  OCAML_CONST0,
  /* 49 */  OCAML_C_CALL1,
  /* 50 */  1,
  /* 51 */  OCAML_PUSHGETGLOBAL_1B,
  /* 52 */  0,
  /* 53 */  OCAML_C_CALL1,
  /* 54 */  3,
  /* 55 */  OCAML_ACC1,
  /* 56 */  OCAML_PUSHACC1,
  /* 57 */  OCAML_SUBINT,
  /* 58 */  OCAML_C_CALL1,
  /* 59 */  2,
  /* 60 */  OCAML_CONST0,
  /* 61 */  OCAML_C_CALL1,
  /* 62 */  4,
  /* 63 */  OCAML_POP,
  /* 64 */  3,
  /* 65 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduboy_millis,
  (void *) &ocaml_arduboy_print_int,
  (void *) &ocaml_arduboy_print,
  (void *) &ocaml_arduboy_display
};
