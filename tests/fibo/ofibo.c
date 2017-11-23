#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              64
#define OCAML_HEAP_INITIAL_WOSIZE       4
#define OCAML_STACK_INITIAL_WOSIZE      1
#define OCAML_GLOBDATA_NUMBER           1
#define OCAML_BYTECODE_BSIZE           90
#define OCAML_PRIMITIVE_NUMBER          5
#define OCAML_VIRTUAL_ARCH             32

#include </Users/steven/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_PUSH                      2
#define OCAML_PUSHACC1                  3
#define OCAML_PUSHACC2                  4
#define OCAML_PUSHACC6                  5
#define OCAML_POP                       6
#define OCAML_ASSIGN                    7
#define OCAML_APPLY1                    8
#define OCAML_RETURN                    9
#define OCAML_PUSHOFFSETCLOSURE0       10
#define OCAML_PUSHGETGLOBAL_1B         11
#define OCAML_BRANCH_1B                12
#define OCAML_BRANCHIF_1B              13
#define OCAML_CHECK_SIGNALS            14
#define OCAML_C_CALL1                  15
#define OCAML_CONST0                   16
#define OCAML_CONST1                   17
#define OCAML_PUSHCONST0               18
#define OCAML_PUSHCONSTINT_1B          19
#define OCAML_ADDINT                   20
#define OCAML_SUBINT                   21
#define OCAML_NEQ                      22
#define OCAML_GTINT                    23
#define OCAML_OFFSETINT_1B             24
#define OCAML_BLTINT_1B                25
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
  /*  1 */  22,
  /*  2 */  OCAML_ACC0,
  /*  3 */  OCAML_BLTINT_1B,
  /*  4 */  1,
  /*  5 */  6,
  /*  6 */  OCAML_CONST1,
  /*  7 */  OCAML_RETURN,
  /*  8 */  1,
  /*  9 */  OCAML_ACC0,
  /* 10 */  OCAML_OFFSETINT_1B,
  /* 11 */  -2,
  /* 12 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 13 */  OCAML_APPLY1,
  /* 14 */  OCAML_PUSHACC1,
  /* 15 */  OCAML_OFFSETINT_1B,
  /* 16 */  -1,
  /* 17 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 18 */  OCAML_APPLY1,
  /* 19 */  OCAML_ADDINT,
  /* 20 */  OCAML_RETURN,
  /* 21 */  1,
  /* 22 */  OCAML_C_CALL1,
  /* 23 */  0,
  /* 24 */  OCAML_CONST0,
  /* 25 */  OCAML_C_CALL1,
  /* 26 */  1,
  /* 27 */  OCAML_PUSHCONST0,
  /* 28 */  OCAML_PUSHCONSTINT_1B,
  /* 29 */  10,
  /* 30 */  OCAML_PUSH,
  /* 31 */  OCAML_PUSHACC2,
  /* 32 */  OCAML_GTINT,
  /* 33 */  OCAML_BRANCHIF_1B,
  /* 34 */  37,
  /* 35 */  OCAML_CHECK_SIGNALS,
  /* 36 */  OCAML_CONST0,
  /* 37 */  OCAML_PUSHCONSTINT_1B,
  /* 38 */  10,
  /* 39 */  OCAML_PUSH,
  /* 40 */  OCAML_PUSHACC2,
  /* 41 */  OCAML_GTINT,
  /* 42 */  OCAML_BRANCHIF_1B,
  /* 43 */  16,
  /* 44 */  OCAML_CHECK_SIGNALS,
  /* 45 */  OCAML_ACC1,
  /* 46 */  OCAML_PUSHACC6,
  /* 47 */  OCAML_APPLY1,
  /* 48 */  OCAML_ACC1,
  /* 49 */  OCAML_PUSH,
  /* 50 */  OCAML_OFFSETINT_1B,
  /* 51 */  1,
  /* 52 */  OCAML_ASSIGN,
  /* 53 */  2,
  /* 54 */  OCAML_ACC1,
  /* 55 */  OCAML_NEQ,
  /* 56 */  OCAML_BRANCHIF_1B,
  /* 57 */  -12,
  /* 58 */  OCAML_POP,
  /* 59 */  2,
  /* 60 */  OCAML_ACC1,
  /* 61 */  OCAML_PUSH,
  /* 62 */  OCAML_OFFSETINT_1B,
  /* 63 */  1,
  /* 64 */  OCAML_ASSIGN,
  /* 65 */  2,
  /* 66 */  OCAML_ACC1,
  /* 67 */  OCAML_NEQ,
  /* 68 */  OCAML_BRANCHIF_1B,
  /* 69 */  -33,
  /* 70 */  OCAML_POP,
  /* 71 */  2,
  /* 72 */  OCAML_CONST0,
  /* 73 */  OCAML_C_CALL1,
  /* 74 */  1,
  /* 75 */  OCAML_PUSHGETGLOBAL_1B,
  /* 76 */  0,
  /* 77 */  OCAML_C_CALL1,
  /* 78 */  2,
  /* 79 */  OCAML_ACC1,
  /* 80 */  OCAML_PUSHACC1,
  /* 81 */  OCAML_SUBINT,
  /* 82 */  OCAML_C_CALL1,
  /* 83 */  3,
  /* 84 */  OCAML_CONST0,
  /* 85 */  OCAML_C_CALL1,
  /* 86 */  4,
  /* 87 */  OCAML_POP,
  /* 88 */  3,
  /* 89 */  OCAML_STOP
};

#include </Users/steven/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduboy_millis,
  (void *) &ocaml_arduboy_print,
  (void *) &ocaml_arduboy_print_int,
  (void *) &ocaml_arduboy_display
};
