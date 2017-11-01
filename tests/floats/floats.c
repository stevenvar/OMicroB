#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              16
#define OCAML_HEAP_INITIAL_WOSIZE       6
#define OCAML_STACK_INITIAL_WOSIZE      1
#define OCAML_GLOBDATA_NUMBER           9
#define OCAML_BYTECODE_BSIZE          119
#define OCAML_PRIMITIVE_NUMBER          8
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_ACC3                      2
#define OCAML_PUSH                      3
#define OCAML_PUSHACC1                  4
#define OCAML_PUSHACC2                  5
#define OCAML_PUSHACC3                  6
#define OCAML_PUSHACC4                  7
#define OCAML_POP                       8
#define OCAML_ASSIGN                    9
#define OCAML_ENVACC2                  10
#define OCAML_ENVACC3                  11
#define OCAML_PUSHENVACC1              12
#define OCAML_PUSH_RETADDR_1B          13
#define OCAML_APPLY                    14
#define OCAML_APPLY1                   15
#define OCAML_APPTERM                  16
#define OCAML_RETURN                   17
#define OCAML_RESTART                  18
#define OCAML_GRAB                     19
#define OCAML_CLOSUREREC_1B            20
#define OCAML_PUSHOFFSETCLOSURE0       21
#define OCAML_GETGLOBAL_1B             22
#define OCAML_PUSHGETGLOBAL_1B         23
#define OCAML_BRANCH_1B                24
#define OCAML_BRANCHIF_1B              25
#define OCAML_BRANCHIFNOT_1B           26
#define OCAML_CHECK_SIGNALS            27
#define OCAML_C_CALL1                  28
#define OCAML_C_CALL2                  29
#define OCAML_CONST0                   30
#define OCAML_CONST2                   31
#define OCAML_NEQ                      32
#define OCAML_GTINT                    33
#define OCAML_OFFSETINT_1B             34
#define OCAML_STOP                     35

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /* 0 */  Make_header(1, Closure_tag),
  /* 1 */  Val_codeptr(2),
  /* 2 */  Make_header(1, Closure_tag),
  /* 3 */  Val_codeptr(52),
  /* 4 */  Make_header(1, Closure_tag),
  /* 5 */  Val_codeptr(82)
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
  /* 0 */  Make_float(0x41, 0x20, 0x00, 0x00),
  /* 1 */  Make_float(0x3F, 0x80, 0x00, 0x00),
  /* 2 */  Make_float(0x00, 0x00, 0x00, 0x00),
  /* 3 */  Init_val_block(4 * 3),
  /* 4 */  Init_val_block(4 * 5),
  /* 5 */  Make_float(0x41, 0x20, 0x00, 0x00),
  /* 6 */  Make_float(0x3F, 0x80, 0x00, 0x00),
  /* 7 */  Make_float(0x00, 0x00, 0x00, 0x00),
  /* 8 */  Make_float(0x00, 0x00, 0x00, 0x00)
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_1B,
  /*   1 */  106,
  /*   2 */  OCAML_CONST0,
  /*   3 */  OCAML_PUSHACC1,
  /*   4 */  OCAML_OFFSETINT_1B,
  /*   5 */  -1,
  /*   6 */  OCAML_PUSH,
  /*   7 */  OCAML_PUSHACC2,
  /*   8 */  OCAML_GTINT,
  /*   9 */  OCAML_BRANCHIF_1B,
  /*  10 */  27,
  /*  11 */  OCAML_CHECK_SIGNALS,
  /*  12 */  OCAML_PUSH_RETADDR_1B,
  /*  13 */  14,
  /*  14 */  OCAML_GETGLOBAL_1B,
  /*  15 */  0,
  /*  16 */  OCAML_PUSHGETGLOBAL_1B,
  /*  17 */  1,
  /*  18 */  OCAML_PUSHGETGLOBAL_1B,
  /*  19 */  2,
  /*  20 */  OCAML_PUSHGETGLOBAL_1B,
  /*  21 */  3,
  /*  22 */  OCAML_PUSHGETGLOBAL_1B,
  /*  23 */  4,
  /*  24 */  OCAML_APPLY,
  /*  25 */  4,
  /*  26 */  OCAML_ACC1,
  /*  27 */  OCAML_PUSH,
  /*  28 */  OCAML_OFFSETINT_1B,
  /*  29 */  1,
  /*  30 */  OCAML_ASSIGN,
  /*  31 */  2,
  /*  32 */  OCAML_ACC1,
  /*  33 */  OCAML_NEQ,
  /*  34 */  OCAML_BRANCHIF_1B,
  /*  35 */  -23,
  /*  36 */  OCAML_CONST0,
  /*  37 */  OCAML_POP,
  /*  38 */  2,
  /*  39 */  OCAML_GETGLOBAL_1B,
  /*  40 */  5,
  /*  41 */  OCAML_PUSHGETGLOBAL_1B,
  /*  42 */  6,
  /*  43 */  OCAML_PUSHGETGLOBAL_1B,
  /*  44 */  7,
  /*  45 */  OCAML_PUSHGETGLOBAL_1B,
  /*  46 */  3,
  /*  47 */  OCAML_PUSHGETGLOBAL_1B,
  /*  48 */  4,
  /*  49 */  OCAML_APPTERM,
  /*  50 */  4,
  /*  51 */  5,
  /*  52 */  OCAML_ACC0,
  /*  53 */  OCAML_PUSHACC1,
  /*  54 */  OCAML_C_CALL2,
  /*  55 */  0,
  /*  56 */  OCAML_RETURN,
  /*  57 */  1,
  /*  58 */  OCAML_ENVACC2,
  /*  59 */  OCAML_PUSHACC1,
  /*  60 */  OCAML_C_CALL2,
  /*  61 */  1,
  /*  62 */  OCAML_BRANCHIFNOT_1B,
  /*  63 */  6,
  /*  64 */  OCAML_GETGLOBAL_1B,
  /*  65 */  8,
  /*  66 */  OCAML_RETURN,
  /*  67 */  1,
  /*  68 */  OCAML_ENVACC3,
  /*  69 */  OCAML_PUSHACC1,
  /*  70 */  OCAML_C_CALL2,
  /*  71 */  2,
  /*  72 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  73 */  OCAML_APPLY1,
  /*  74 */  OCAML_PUSHACC1,
  /*  75 */  OCAML_PUSHENVACC1,
  /*  76 */  OCAML_APPLY1,
  /*  77 */  OCAML_C_CALL2,
  /*  78 */  2,
  /*  79 */  OCAML_RETURN,
  /*  80 */  1,
  /*  81 */  OCAML_RESTART,
  /*  82 */  OCAML_GRAB,
  /*  83 */  3,
  /*  84 */  OCAML_ACC3,
  /*  85 */  OCAML_PUSHACC2,
  /*  86 */  OCAML_PUSHACC4,
  /*  87 */  OCAML_C_CALL2,
  /*  88 */  3,
  /*  89 */  OCAML_C_CALL2,
  /*  90 */  4,
  /*  91 */  OCAML_PUSH,
  /*  92 */  OCAML_PUSHACC4,
  /*  93 */  OCAML_PUSHACC3,
  /*  94 */  OCAML_CLOSUREREC_1B,
  /*  95 */  1,
  /*  96 */  3,
  /*  97 */  -36,
  /*  98 */  OCAML_ACC1,
  /*  99 */  OCAML_PUSHACC4,
  /* 100 */  OCAML_PUSHACC2,
  /* 101 */  OCAML_APPLY1,
  /* 102 */  OCAML_C_CALL2,
  /* 103 */  0,
  /* 104 */  OCAML_RETURN,
  /* 105 */  6,
  /* 106 */  OCAML_C_CALL1,
  /* 107 */  5,
  /* 108 */  OCAML_CONST2,
  /* 109 */  OCAML_PUSHACC1,
  /* 110 */  OCAML_APPLY1,
  /* 111 */  OCAML_C_CALL1,
  /* 112 */  6,
  /* 113 */  OCAML_CONST0,
  /* 114 */  OCAML_C_CALL1,
  /* 115 */  7,
  /* 116 */  OCAML_POP,
  /* 117 */  1,
  /* 118 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &caml_mul_float,
  (void *) &caml_ge_float,
  (void *) &caml_add_float,
  (void *) &caml_sub_float,
  (void *) &caml_div_float,
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduboy_print_float,
  (void *) &ocaml_arduboy_display
};
