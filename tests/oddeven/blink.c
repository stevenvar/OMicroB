#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              64
#define OCAML_HEAP_INITIAL_WOSIZE       4
#define OCAML_STACK_INITIAL_WOSIZE      2
#define OCAML_GLOBDATA_NUMBER           0
#define OCAML_BYTECODE_BSIZE           69
#define OCAML_PRIMITIVE_NUMBER          4
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_PUSH                      2
#define OCAML_PUSHACC2                  3
#define OCAML_PUSHACC5                  4
#define OCAML_POP                       5
#define OCAML_ASSIGN                    6
#define OCAML_APPLY1                    7
#define OCAML_APPTERM1                  8
#define OCAML_RETURN                    9
#define OCAML_PUSHOFFSETCLOSUREM2      10
#define OCAML_PUSHOFFSETCLOSURE2       11
#define OCAML_BRANCH_1B                12
#define OCAML_BRANCHIF_1B              13
#define OCAML_CHECK_SIGNALS            14
#define OCAML_C_CALL1                  15
#define OCAML_CONST0                   16
#define OCAML_CONST1                   17
#define OCAML_PUSHCONST0               18
#define OCAML_PUSHCONSTINT_1B          19
#define OCAML_SUBINT                   20
#define OCAML_NEQ                      21
#define OCAML_GTINT                    22
#define OCAML_OFFSETINT_1B             23
#define OCAML_STOP                     24

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /* 0 */  Make_header(3, Closure_tag),
  /* 1 */  Val_codeptr(2),
  /* 2 */  Make_header(2, Infix_tag),
  /* 3 */  Val_codeptr(14)
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
  /* 62 */  Init_val_block(4 * 3),
  /* 63 */  Init_val_block(4 * 3)
};

val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*  0 */  OCAML_BRANCH_1B,
  /*  1 */  26,
  /*  2 */  OCAML_ACC0,
  /*  3 */  OCAML_BRANCHIF_1B,
  /*  4 */  5,
  /*  5 */  OCAML_CONST0,
  /*  6 */  OCAML_RETURN,
  /*  7 */  1,
  /*  8 */  OCAML_ACC0,
  /*  9 */  OCAML_OFFSETINT_1B,
  /* 10 */  -1,
  /* 11 */  OCAML_PUSHOFFSETCLOSURE2,
  /* 12 */  OCAML_APPTERM1,
  /* 13 */  2,
  /* 14 */  OCAML_ACC0,
  /* 15 */  OCAML_BRANCHIF_1B,
  /* 16 */  5,
  /* 17 */  OCAML_CONST1,
  /* 18 */  OCAML_RETURN,
  /* 19 */  1,
  /* 20 */  OCAML_ACC0,
  /* 21 */  OCAML_OFFSETINT_1B,
  /* 22 */  -1,
  /* 23 */  OCAML_PUSHOFFSETCLOSUREM2,
  /* 24 */  OCAML_APPTERM1,
  /* 25 */  2,
  /* 26 */  OCAML_C_CALL1,
  /* 27 */  0,
  /* 28 */  OCAML_CONST0,
  /* 29 */  OCAML_C_CALL1,
  /* 30 */  1,
  /* 31 */  OCAML_PUSHCONST0,
  /* 32 */  OCAML_PUSHCONSTINT_1B,
  /* 33 */  100,
  /* 34 */  OCAML_PUSH,
  /* 35 */  OCAML_PUSHACC2,
  /* 36 */  OCAML_GTINT,
  /* 37 */  OCAML_BRANCHIF_1B,
  /* 38 */  16,
  /* 39 */  OCAML_CHECK_SIGNALS,
  /* 40 */  OCAML_ACC1,
  /* 41 */  OCAML_PUSHACC5,
  /* 42 */  OCAML_APPLY1,
  /* 43 */  OCAML_ACC1,
  /* 44 */  OCAML_PUSH,
  /* 45 */  OCAML_OFFSETINT_1B,
  /* 46 */  1,
  /* 47 */  OCAML_ASSIGN,
  /* 48 */  2,
  /* 49 */  OCAML_ACC1,
  /* 50 */  OCAML_NEQ,
  /* 51 */  OCAML_BRANCHIF_1B,
  /* 52 */  -12,
  /* 53 */  OCAML_POP,
  /* 54 */  2,
  /* 55 */  OCAML_ACC0,
  /* 56 */  OCAML_PUSHCONST0,
  /* 57 */  OCAML_C_CALL1,
  /* 58 */  1,
  /* 59 */  OCAML_SUBINT,
  /* 60 */  OCAML_PUSH,
  /* 61 */  OCAML_C_CALL1,
  /* 62 */  2,
  /* 63 */  OCAML_CONST0,
  /* 64 */  OCAML_C_CALL1,
  /* 65 */  3,
  /* 66 */  OCAML_POP,
  /* 67 */  4,
  /* 68 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduino_millis,
  (void *) &ocaml_arduboy_print_int,
  (void *) &ocaml_arduboy_display
};
