#define OCAML_STACK_WOSIZE             96
#define OCAML_HEAP_WOSIZE              32
#define OCAML_HEAP_INITIAL_WOSIZE       6
#define OCAML_STACK_INITIAL_WOSIZE      1
#define OCAML_GLOBDATA_NUMBER           9
#define OCAML_BYTECODE_BSIZE          123
#define OCAML_PRIMITIVE_NUMBER          9
#define OCAML_VIRTUAL_ARCH             32

#include </home/steven/github/OMicroB/src/byterun/values.h>

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
#define OCAML_CONSTINT_1B              31
#define OCAML_NEQ                      32
#define OCAML_GTINT                    33
#define OCAML_OFFSETINT_1B             34
#define OCAML_STOP                     35

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /* 0 */  Make_header(1, Closure_tag),
  /* 1 */  Val_codeptr(2),
  /* 2 */  Make_header(1, Closure_tag),
  /* 3 */  Val_codeptr(55),
  /* 4 */  Make_header(1, Closure_tag),
  /* 5 */  Val_codeptr(85)
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
  /* 63 */  Val_int(0),
  /* 64 */  Val_int(0),
  /* 65 */  Val_int(0),
  /* 66 */  Val_int(0),
  /* 67 */  Val_int(0),
  /* 68 */  Val_int(0),
  /* 69 */  Val_int(0),
  /* 70 */  Val_int(0),
  /* 71 */  Val_int(0),
  /* 72 */  Val_int(0),
  /* 73 */  Val_int(0),
  /* 74 */  Val_int(0),
  /* 75 */  Val_int(0),
  /* 76 */  Val_int(0),
  /* 77 */  Val_int(0),
  /* 78 */  Val_int(0),
  /* 79 */  Val_int(0),
  /* 80 */  Val_int(0),
  /* 81 */  Val_int(0),
  /* 82 */  Val_int(0),
  /* 83 */  Val_int(0),
  /* 84 */  Val_int(0),
  /* 85 */  Val_int(0),
  /* 86 */  Val_int(0),
  /* 87 */  Val_int(0),
  /* 88 */  Val_int(0),
  /* 89 */  Val_int(0),
  /* 90 */  Val_int(0),
  /* 91 */  Val_int(0),
  /* 92 */  Val_int(0),
  /* 93 */  Val_int(0),
  /* 94 */  Val_int(0),
  /* 95 */  Init_val_block(4 * 1)
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
  /*   1 */  109,
  /*   2 */  OCAML_CONST0,
  /*   3 */  OCAML_PUSHACC1,
  /*   4 */  OCAML_OFFSETINT_1B,
  /*   5 */  -1,
  /*   6 */  OCAML_PUSH,
  /*   7 */  OCAML_PUSHACC2,
  /*   8 */  OCAML_GTINT,
  /*   9 */  OCAML_BRANCHIF_1B,
  /*  10 */  30,
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
  /*  26 */  OCAML_CONST0,
  /*  27 */  OCAML_C_CALL1,
  /*  28 */  0,
  /*  29 */  OCAML_ACC1,
  /*  30 */  OCAML_PUSH,
  /*  31 */  OCAML_OFFSETINT_1B,
  /*  32 */  1,
  /*  33 */  OCAML_ASSIGN,
  /*  34 */  2,
  /*  35 */  OCAML_ACC1,
  /*  36 */  OCAML_NEQ,
  /*  37 */  OCAML_BRANCHIF_1B,
  /*  38 */  -26,
  /*  39 */  OCAML_CONST0,
  /*  40 */  OCAML_POP,
  /*  41 */  2,
  /*  42 */  OCAML_GETGLOBAL_1B,
  /*  43 */  5,
  /*  44 */  OCAML_PUSHGETGLOBAL_1B,
  /*  45 */  6,
  /*  46 */  OCAML_PUSHGETGLOBAL_1B,
  /*  47 */  7,
  /*  48 */  OCAML_PUSHGETGLOBAL_1B,
  /*  49 */  3,
  /*  50 */  OCAML_PUSHGETGLOBAL_1B,
  /*  51 */  4,
  /*  52 */  OCAML_APPTERM,
  /*  53 */  4,
  /*  54 */  5,
  /*  55 */  OCAML_ACC0,
  /*  56 */  OCAML_PUSHACC1,
  /*  57 */  OCAML_C_CALL2,
  /*  58 */  1,
  /*  59 */  OCAML_RETURN,
  /*  60 */  1,
  /*  61 */  OCAML_ENVACC2,
  /*  62 */  OCAML_PUSHACC1,
  /*  63 */  OCAML_C_CALL2,
  /*  64 */  2,
  /*  65 */  OCAML_BRANCHIFNOT_1B,
  /*  66 */  6,
  /*  67 */  OCAML_GETGLOBAL_1B,
  /*  68 */  8,
  /*  69 */  OCAML_RETURN,
  /*  70 */  1,
  /*  71 */  OCAML_ENVACC3,
  /*  72 */  OCAML_PUSHACC1,
  /*  73 */  OCAML_C_CALL2,
  /*  74 */  3,
  /*  75 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  76 */  OCAML_APPLY1,
  /*  77 */  OCAML_PUSHACC1,
  /*  78 */  OCAML_PUSHENVACC1,
  /*  79 */  OCAML_APPLY1,
  /*  80 */  OCAML_C_CALL2,
  /*  81 */  3,
  /*  82 */  OCAML_RETURN,
  /*  83 */  1,
  /*  84 */  OCAML_RESTART,
  /*  85 */  OCAML_GRAB,
  /*  86 */  3,
  /*  87 */  OCAML_ACC3,
  /*  88 */  OCAML_PUSHACC2,
  /*  89 */  OCAML_PUSHACC4,
  /*  90 */  OCAML_C_CALL2,
  /*  91 */  4,
  /*  92 */  OCAML_C_CALL2,
  /*  93 */  5,
  /*  94 */  OCAML_PUSH,
  /*  95 */  OCAML_PUSHACC4,
  /*  96 */  OCAML_PUSHACC3,
  /*  97 */  OCAML_CLOSUREREC_1B,
  /*  98 */  1,
  /*  99 */  3,
  /* 100 */  -36,
  /* 101 */  OCAML_ACC1,
  /* 102 */  OCAML_PUSHACC4,
  /* 103 */  OCAML_PUSHACC2,
  /* 104 */  OCAML_APPLY1,
  /* 105 */  OCAML_C_CALL2,
  /* 106 */  1,
  /* 107 */  OCAML_RETURN,
  /* 108 */  6,
  /* 109 */  OCAML_C_CALL1,
  /* 110 */  6,
  /* 111 */  OCAML_CONSTINT_1B,
  /* 112 */  11,
  /* 113 */  OCAML_PUSHACC1,
  /* 114 */  OCAML_APPLY1,
  /* 115 */  OCAML_C_CALL1,
  /* 116 */  7,
  /* 117 */  OCAML_CONST0,
  /* 118 */  OCAML_C_CALL1,
  /* 119 */  8,
  /* 120 */  OCAML_POP,
  /* 121 */  1,
  /* 122 */  OCAML_STOP
};

#include </home/steven/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &caml_force_gc,
  (void *) &caml_mul_float,
  (void *) &caml_ge_float,
  (void *) &caml_add_float,
  (void *) &caml_sub_float,
  (void *) &caml_div_float,
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduboy_print_float,
  (void *) &ocaml_arduboy_display
};
