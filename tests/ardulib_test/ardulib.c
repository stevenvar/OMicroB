#define OCAML_STACK_WOSIZE             32
#define OCAML_HEAP_WOSIZE              64
#define OCAML_HEAP_INITIAL_WOSIZE      55
#define OCAML_STACK_INITIAL_WOSIZE      1
#define OCAML_GLOBDATA_NUMBER           8
#define OCAML_BYTECODE_BSIZE          169
#define OCAML_PRIMITIVE_NUMBER          5
#define OCAML_VIRTUAL_ARCH             32

#include </Users/travail/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_ACC2                      2
#define OCAML_PUSHACC1                  3
#define OCAML_PUSHACC2                  4
#define OCAML_PUSHACC3                  5
#define OCAML_PUSHACC4                  6
#define OCAML_PUSHACC5                  7
#define OCAML_PUSHACC6                  8
#define OCAML_POP                       9
#define OCAML_APPLY1                   10
#define OCAML_APPLY2                   11
#define OCAML_APPLY3                   12
#define OCAML_APPTERM1                 13
#define OCAML_APPTERM2                 14
#define OCAML_RETURN                   15
#define OCAML_RESTART                  16
#define OCAML_GRAB                     17
#define OCAML_CLOSURE_1B               18
#define OCAML_PUSHOFFSETCLOSURE0       19
#define OCAML_GETGLOBAL_1B             20
#define OCAML_PUSHGETGLOBAL_1B         21
#define OCAML_GETFIELD0                22
#define OCAML_GETFIELD1                23
#define OCAML_BRANCH_1B                24
#define OCAML_BRANCH_2B                25
#define OCAML_BRANCHIF_1B              26
#define OCAML_BRANCHIFNOT_1B           27
#define OCAML_CHECK_SIGNALS            28
#define OCAML_C_CALL1                  29
#define OCAML_C_CALL2                  30
#define OCAML_CONST0                   31
#define OCAML_CONST1                   32
#define OCAML_CONST3                   33
#define OCAML_CONSTINT_1B              34
#define OCAML_PUSHCONST0               35
#define OCAML_PUSHCONST1               36
#define OCAML_PUSHCONST2               37
#define OCAML_PUSHCONST3               38
#define OCAML_PUSHCONSTINT_1B          39
#define OCAML_SUBINT                   40
#define OCAML_ANDINT                   41
#define OCAML_ORINT                    42
#define OCAML_XORINT                   43
#define OCAML_STOP                     44

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /*  0 */  Make_header(1, Closure_tag),
  /*  1 */  Val_codeptr(67),
  /*  2 */  Make_header(2, 0),
  /*  3 */  Val_int(213),
  /*  4 */  Init_val_block(4 * 6),
  /*  5 */  Make_header(2, 0),
  /*  6 */  Val_int(240),
  /*  7 */  Init_val_block(4 * 9),
  /*  8 */  Make_header(2, 0),
  /*  9 */  Val_int(141),
  /* 10 */  Init_val_block(4 * 12),
  /* 11 */  Make_header(2, 0),
  /* 12 */  Val_int(20),
  /* 13 */  Init_val_block(4 * 15),
  /* 14 */  Make_header(2, 0),
  /* 15 */  Val_int(161),
  /* 16 */  Init_val_block(4 * 18),
  /* 17 */  Make_header(2, 0),
  /* 18 */  Val_int(200),
  /* 19 */  Init_val_block(4 * 21),
  /* 20 */  Make_header(2, 0),
  /* 21 */  Val_int(129),
  /* 22 */  Init_val_block(4 * 24),
  /* 23 */  Make_header(2, 0),
  /* 24 */  Val_int(207),
  /* 25 */  Init_val_block(4 * 27),
  /* 26 */  Make_header(2, 0),
  /* 27 */  Val_int(217),
  /* 28 */  Init_val_block(4 * 30),
  /* 29 */  Make_header(2, 0),
  /* 30 */  Val_int(241),
  /* 31 */  Init_val_block(4 * 33),
  /* 32 */  Make_header(2, 0),
  /* 33 */  Val_int(175),
  /* 34 */  Init_val_block(4 * 36),
  /* 35 */  Make_header(2, 0),
  /* 36 */  Val_int(32),
  /* 37 */  Init_val_block(4 * 39),
  /* 38 */  Make_header(2, 0),
  /* 39 */  Val_int(0),
  /* 40 */  Val_int(0),
  /* 41 */  Make_header(1, Closure_tag),
  /* 42 */  Val_codeptr(103),
  /* 43 */  Make_header(1, Closure_tag),
  /* 44 */  Val_codeptr(3),
  /* 45 */  Make_header(1, Closure_tag),
  /* 46 */  Val_codeptr(9),
  /* 47 */  Make_header(1, 0),
  /* 48 */  Init_val_block(4 * 50),
  /* 49 */  Make_header(1, Closure_tag),
  /* 50 */  Val_codeptr(112),
  /* 51 */  Make_header(1, Closure_tag),
  /* 52 */  Val_codeptr(29),
  /* 53 */  Make_header(1, Closure_tag),
  /* 54 */  Val_codeptr(55)
};

const val_t* ocaml_heap1 = ocaml_heap;
const val_t* ocaml_heap2 = ocaml_heap + OCAML_HEAP_WOSIZE;

val_t acc = Val_int(1);

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
  /* 31 */  Val_int(4)
};

val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
  /* 0 */  Init_val_block(4 * 1),
  /* 1 */  Init_val_block(4 * 3),
  /* 2 */  Init_val_block(4 * 42),
  /* 3 */  Init_val_block(4 * 44),
  /* 4 */  Init_val_block(4 * 46),
  /* 5 */  Init_val_block(4 * 48),
  /* 6 */  Init_val_block(4 * 52),
  /* 7 */  Init_val_block(4 * 54)
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_2B,
  /*   1 */  (opcode_t)0,
  /*   2 */  143,
  /*   3 */  OCAML_CONSTINT_1B,
  /*   4 */  (opcode_t)-1,
  /*   5 */  OCAML_PUSHACC1,
  /*   6 */  OCAML_XORINT,
  /*   7 */  OCAML_RETURN,
  /*   8 */  1,
  /*   9 */  OCAML_ACC0,
  /*  10 */  OCAML_PUSHCONST3,
  /*  11 */  OCAML_C_CALL2,
  /*  12 */  0,
  /*  13 */  OCAML_BRANCH_1B,
  /*  14 */  (opcode_t)4,
  /*  15 */  OCAML_CHECK_SIGNALS,
  /*  16 */  OCAML_CONST0,
  /*  17 */  OCAML_CONST0,
  /*  18 */  OCAML_PUSHCONST2,
  /*  19 */  OCAML_C_CALL2,
  /*  20 */  1,
  /*  21 */  OCAML_BRANCHIF_1B,
  /*  22 */  (opcode_t)-6,
  /*  23 */  OCAML_CONST3,
  /*  24 */  OCAML_C_CALL1,
  /*  25 */  2,
  /*  26 */  OCAML_RETURN,
  /*  27 */  1,
  /*  28 */  OCAML_RESTART,
  /*  29 */  OCAML_GRAB,
  /*  30 */  2,
  /*  31 */  OCAML_CONST1,
  /*  32 */  OCAML_PUSHACC1,
  /*  33 */  OCAML_C_CALL2,
  /*  34 */  3,
  /*  35 */  OCAML_CONSTINT_1B,
  /*  36 */  (opcode_t)4,
  /*  37 */  OCAML_PUSHCONST1,
  /*  38 */  OCAML_C_CALL2,
  /*  39 */  4,
  /*  40 */  OCAML_CONSTINT_1B,
  /*  41 */  (opcode_t)6,
  /*  42 */  OCAML_PUSHCONST1,
  /*  43 */  OCAML_C_CALL2,
  /*  44 */  4,
  /*  45 */  OCAML_CONST1,
  /*  46 */  OCAML_PUSHACC2,
  /*  47 */  OCAML_C_CALL2,
  /*  48 */  3,
  /*  49 */  OCAML_CONST1,
  /*  50 */  OCAML_PUSHACC3,
  /*  51 */  OCAML_C_CALL2,
  /*  52 */  3,
  /*  53 */  OCAML_RETURN,
  /*  54 */  3,
  /*  55 */  OCAML_CONST0,
  /*  56 */  OCAML_PUSHCONST0,
  /*  57 */  OCAML_PUSHGETGLOBAL_1B,
  /*  58 */  0,
  /*  59 */  OCAML_APPLY2,
  /*  60 */  OCAML_GETGLOBAL_1B,
  /*  61 */  1,
  /*  62 */  OCAML_PUSHGETGLOBAL_1B,
  /*  63 */  2,
  /*  64 */  OCAML_APPTERM1,
  /*  65 */  2,
  /*  66 */  OCAML_RESTART,
  /*  67 */  OCAML_GRAB,
  /*  68 */  1,
  /*  69 */  OCAML_ACC0,
  /*  70 */  OCAML_C_CALL1,
  /*  71 */  2,
  /*  72 */  OCAML_PUSHACC2,
  /*  73 */  OCAML_C_CALL1,
  /*  74 */  2,
  /*  75 */  OCAML_PUSHCONST0,
  /*  76 */  OCAML_PUSHCONST0,
  /*  77 */  OCAML_PUSHACC1,
  /*  78 */  OCAML_PUSHACC4,
  /*  79 */  OCAML_ORINT,
  /*  80 */  OCAML_PUSHACC5,
  /*  81 */  OCAML_C_CALL2,
  /*  82 */  0,
  /*  83 */  OCAML_ACC0,
  /*  84 */  OCAML_PUSHGETGLOBAL_1B,
  /*  85 */  3,
  /*  86 */  OCAML_APPLY1,
  /*  87 */  OCAML_PUSHACC3,
  /*  88 */  OCAML_ANDINT,
  /*  89 */  OCAML_PUSHACC6,
  /*  90 */  OCAML_C_CALL2,
  /*  91 */  0,
  /*  92 */  OCAML_ACC1,
  /*  93 */  OCAML_PUSHGETGLOBAL_1B,
  /*  94 */  3,
  /*  95 */  OCAML_APPLY1,
  /*  96 */  OCAML_PUSHACC4,
  /*  97 */  OCAML_ANDINT,
  /*  98 */  OCAML_PUSHACC5,
  /*  99 */  OCAML_C_CALL2,
  /* 100 */  0,
  /* 101 */  OCAML_RETURN,
  /* 102 */  6,
  /* 103 */  OCAML_ACC0,
  /* 104 */  OCAML_PUSHGETGLOBAL_1B,
  /* 105 */  4,
  /* 106 */  OCAML_PUSHGETGLOBAL_1B,
  /* 107 */  5,
  /* 108 */  OCAML_GETFIELD0,
  /* 109 */  OCAML_APPTERM2,
  /* 110 */  3,
  /* 111 */  OCAML_RESTART,
  /* 112 */  OCAML_GRAB,
  /* 113 */  1,
  /* 114 */  OCAML_ACC1,
  /* 115 */  OCAML_BRANCHIFNOT_1B,
  /* 116 */  (opcode_t)12,
  /* 117 */  OCAML_ACC1,
  /* 118 */  OCAML_GETFIELD0,
  /* 119 */  OCAML_PUSHACC1,
  /* 120 */  OCAML_APPLY1,
  /* 121 */  OCAML_ACC1,
  /* 122 */  OCAML_GETFIELD1,
  /* 123 */  OCAML_PUSHACC1,
  /* 124 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 125 */  OCAML_APPTERM2,
  /* 126 */  4,
  /* 127 */  OCAML_RETURN,
  /* 128 */  2,
  /* 129 */  OCAML_RESTART,
  /* 130 */  OCAML_GRAB,
  /* 131 */  2,
  /* 132 */  OCAML_ACC0,
  /* 133 */  OCAML_PUSHCONST0,
  /* 134 */  OCAML_C_CALL2,
  /* 135 */  0,
  /* 136 */  OCAML_ACC2,
  /* 137 */  OCAML_PUSHACC2,
  /* 138 */  OCAML_PUSHACC2,
  /* 139 */  OCAML_SUBINT,
  /* 140 */  OCAML_SUBINT,
  /* 141 */  OCAML_RETURN,
  /* 142 */  3,
  /* 143 */  OCAML_C_CALL2,
  /* 144 */  4,
  /* 145 */  OCAML_CLOSURE_1B,
  /* 146 */  0,
  /* 147 */  (opcode_t)-15,
  /* 148 */  OCAML_PUSHCONST1,
  /* 149 */  OCAML_PUSHCONST2,
  /* 150 */  OCAML_PUSHCONST3,
  /* 151 */  OCAML_PUSHACC3,
  /* 152 */  OCAML_APPLY3,
  /* 153 */  OCAML_CONSTINT_1B,
  /* 154 */  (opcode_t)16,
  /* 155 */  OCAML_PUSHCONSTINT_1B,
  /* 156 */  (opcode_t)15,
  /* 157 */  OCAML_PUSHCONSTINT_1B,
  /* 158 */  (opcode_t)17,
  /* 159 */  OCAML_PUSHGETGLOBAL_1B,
  /* 160 */  6,
  /* 161 */  OCAML_APPLY3,
  /* 162 */  OCAML_CONST0,
  /* 163 */  OCAML_PUSHGETGLOBAL_1B,
  /* 164 */  7,
  /* 165 */  OCAML_APPLY1,
  /* 166 */  OCAML_POP,
  /* 167 */  1,
  /* 168 */  OCAML_STOP
};

#include </Users/travail/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &caml_avr_write_register,
  (void *) &caml_avr_read_bit,
  (void *) &caml_avr_read_register,
  (void *) &caml_pin_mode,
  (void *) &caml_avr_set_bit
};
