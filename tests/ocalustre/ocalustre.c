#define OCAML_STACK_WOSIZE             16
#define OCAML_HEAP_WOSIZE               6
#define OCAML_HEAP_INITIAL_WOSIZE       6
#define OCAML_STACK_INITIAL_WOSIZE      2
#define OCAML_GLOBDATA_NUMBER           1
#define OCAML_BYTECODE_BSIZE           79
#define OCAML_PRIMITIVE_NUMBER          5
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_PUSH                      2
#define OCAML_PUSHACC1                  3
#define OCAML_PUSHACC2                  4
#define OCAML_PUSHACC3                  5
#define OCAML_PUSHACC6                  6
#define OCAML_POP                       7
#define OCAML_ASSIGN                    8
#define OCAML_APPLY1                    9
#define OCAML_APPLY2                   10
#define OCAML_RETURN                   11
#define OCAML_RESTART                  12
#define OCAML_GRAB                     13
#define OCAML_PUSHGETGLOBAL_1B         14
#define OCAML_MAKEBLOCK2               15
#define OCAML_GETFIELD0                16
#define OCAML_SETFIELD0                17
#define OCAML_SETFIELD1                18
#define OCAML_BRANCH_1B                19
#define OCAML_BRANCHIF_1B              20
#define OCAML_CHECK_SIGNALS            21
#define OCAML_C_CALL1                  22
#define OCAML_CONST0                   23
#define OCAML_PUSHCONST0               24
#define OCAML_PUSHCONSTINT_1B          25
#define OCAML_SUBINT                   26
#define OCAML_NEQ                      27
#define OCAML_GTINT                    28
#define OCAML_OFFSETINT_1B             29
#define OCAML_STOP                     30

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /* 0 */  Make_header(1, Closure_tag),
  /* 1 */  Val_codeptr(3),
  /* 2 */  Make_header(1, Closure_tag),
  /* 3 */  Val_codeptr(19),
  /* 4 */  Make_header(1, String_tag),
  /* 5 */  Make_string_data(0x0A, '\0', '\0', '\2')
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
  /* 14 */  Init_val_block(4 * 1),
  /* 15 */  Init_val_block(4 * 3)
};

val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
  /* 0 */  Init_val_block(4 * 5)
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*  0 */  OCAML_BRANCH_1B,
  /*  1 */  28,
  /*  2 */  OCAML_RESTART,
  /*  3 */  OCAML_GRAB,
  /*  4 */  1,
  /*  5 */  OCAML_ACC0,
  /*  6 */  OCAML_GETFIELD0,
  /*  7 */  OCAML_PUSH,
  /*  8 */  OCAML_OFFSETINT_1B,
  /*  9 */  1,
  /* 10 */  OCAML_PUSHACC1,
  /* 11 */  OCAML_PUSHACC3,
  /* 12 */  OCAML_SETFIELD1,
  /* 13 */  OCAML_ACC0,
  /* 14 */  OCAML_PUSHACC3,
  /* 15 */  OCAML_SETFIELD0,
  /* 16 */  OCAML_CONST0,
  /* 17 */  OCAML_RETURN,
  /* 18 */  4,
  /* 19 */  OCAML_ACC0,
  /* 20 */  OCAML_OFFSETINT_1B,
  /* 21 */  1,
  /* 22 */  OCAML_PUSHACC1,
  /* 23 */  OCAML_PUSHACC1,
  /* 24 */  OCAML_MAKEBLOCK2,
  /* 25 */  0,
  /* 26 */  OCAML_RETURN,
  /* 27 */  2,
  /* 28 */  OCAML_C_CALL1,
  /* 29 */  0,
  /* 30 */  OCAML_CONST0,
  /* 31 */  OCAML_C_CALL1,
  /* 32 */  1,
  /* 33 */  OCAML_PUSHCONST0,
  /* 34 */  OCAML_PUSHACC3,
  /* 35 */  OCAML_APPLY1,
  /* 36 */  OCAML_PUSHCONST0,
  /* 37 */  OCAML_PUSHCONSTINT_1B,
  /* 38 */  99,
  /* 39 */  OCAML_PUSH,
  /* 40 */  OCAML_PUSHACC2,
  /* 41 */  OCAML_GTINT,
  /* 42 */  OCAML_BRANCHIF_1B,
  /* 43 */  17,
  /* 44 */  OCAML_CHECK_SIGNALS,
  /* 45 */  OCAML_CONST0,
  /* 46 */  OCAML_PUSHACC3,
  /* 47 */  OCAML_PUSHACC6,
  /* 48 */  OCAML_APPLY2,
  /* 49 */  OCAML_ACC1,
  /* 50 */  OCAML_PUSH,
  /* 51 */  OCAML_OFFSETINT_1B,
  /* 52 */  1,
  /* 53 */  OCAML_ASSIGN,
  /* 54 */  2,
  /* 55 */  OCAML_ACC1,
  /* 56 */  OCAML_NEQ,
  /* 57 */  OCAML_BRANCHIF_1B,
  /* 58 */  -13,
  /* 59 */  OCAML_POP,
  /* 60 */  2,
  /* 61 */  OCAML_ACC1,
  /* 62 */  OCAML_PUSHCONST0,
  /* 63 */  OCAML_C_CALL1,
  /* 64 */  1,
  /* 65 */  OCAML_SUBINT,
  /* 66 */  OCAML_PUSHGETGLOBAL_1B,
  /* 67 */  0,
  /* 68 */  OCAML_C_CALL1,
  /* 69 */  2,
  /* 70 */  OCAML_ACC0,
  /* 71 */  OCAML_C_CALL1,
  /* 72 */  3,
  /* 73 */  OCAML_CONST0,
  /* 74 */  OCAML_C_CALL1,
  /* 75 */  4,
  /* 76 */  OCAML_POP,
  /* 77 */  5,
  /* 78 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduboy_millis,
  (void *) &ocaml_arduboy_print,
  (void *) &ocaml_arduboy_print_int,
  (void *) &ocaml_arduboy_display
};
