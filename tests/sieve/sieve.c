#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              64
#define OCAML_HEAP_INITIAL_WOSIZE      14
#define OCAML_STACK_INITIAL_WOSIZE      4
#define OCAML_GLOBDATA_NUMBER           5
#define OCAML_BYTECODE_BSIZE          179
#define OCAML_PRIMITIVE_NUMBER          5
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_PUSH                      2
#define OCAML_PUSHACC1                  3
#define OCAML_PUSHACC2                  4
#define OCAML_PUSHACC3                  5
#define OCAML_POP                       6
#define OCAML_ENVACC1                   7
#define OCAML_PUSHENVACC1               8
#define OCAML_PUSHENVACC2               9
#define OCAML_APPLY1                   10
#define OCAML_APPLY2                   11
#define OCAML_APPTERM1                 12
#define OCAML_APPTERM2                 13
#define OCAML_RETURN                   14
#define OCAML_RESTART                  15
#define OCAML_GRAB                     16
#define OCAML_CLOSURE_1B               17
#define OCAML_CLOSUREREC_1B            18
#define OCAML_PUSHOFFSETCLOSURE0       19
#define OCAML_GETGLOBAL_1B             20
#define OCAML_PUSHGETGLOBAL_1B         21
#define OCAML_MAKEBLOCK2               22
#define OCAML_GETFIELD0                23
#define OCAML_GETFIELD1                24
#define OCAML_BRANCH_2B                25
#define OCAML_BRANCHIF_1B              26
#define OCAML_BRANCHIFNOT_1B           27
#define OCAML_C_CALL1                  28
#define OCAML_CONST0                   29
#define OCAML_CONST1                   30
#define OCAML_PUSHCONST0               31
#define OCAML_PUSHCONST2               32
#define OCAML_PUSHCONSTINT_1B          33
#define OCAML_SUBINT                   34
#define OCAML_MULINT                   35
#define OCAML_MODINT                   36
#define OCAML_GTINT                    37
#define OCAML_OFFSETINT_1B             38
#define OCAML_STOP                     39

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /*  0 */  Make_header(1, Closure_tag),
  /*  1 */  Val_codeptr(58),
  /*  2 */  Make_header(1, Closure_tag),
  /*  3 */  Val_codeptr(108),
  /*  4 */  Make_header(1, Closure_tag),
  /*  5 */  Val_codeptr(27),
  /*  6 */  Make_header(1, Closure_tag),
  /*  7 */  Val_codeptr(4),
  /*  8 */  Make_header(1, Closure_tag),
  /*  9 */  Val_codeptr(142),
  /* 10 */  Make_header(1, Closure_tag),
  /* 11 */  Val_codeptr(134),
  /* 12 */  Make_header(1, String_tag),
  /* 13 */  Make_string_data(0x0A, '\0', '\0', '\2')
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
  /* 60 */  Init_val_block(4 * 1),
  /* 61 */  Init_val_block(4 * 3),
  /* 62 */  Init_val_block(4 * 5),
  /* 63 */  Init_val_block(4 * 7)
};

val_t ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
  /* 0 */  Init_val_block(4 * 9),
  /* 1 */  Init_val_block(4 * 11),
  /* 2 */  Init_val_block(4 * 7),
  /* 3 */  Init_val_block(4 * 5),
  /* 4 */  Init_val_block(4 * 13)
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_2B,
  /*   1 */  0,
  /*   2 */  147,
  /*   3 */  OCAML_RESTART,
  /*   4 */  OCAML_GRAB,
  /*   5 */  1,
  /*   6 */  OCAML_ACC1,
  /*   7 */  OCAML_PUSHACC1,
  /*   8 */  OCAML_GTINT,
  /*   9 */  OCAML_BRANCHIFNOT_1B,
  /*  10 */  5,
  /*  11 */  OCAML_CONST0,
  /*  12 */  OCAML_RETURN,
  /*  13 */  2,
  /*  14 */  OCAML_ACC1,
  /*  15 */  OCAML_PUSHACC1,
  /*  16 */  OCAML_PUSHGETGLOBAL_1B,
  /*  17 */  0,
  /*  18 */  OCAML_APPLY1,
  /*  19 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  20 */  OCAML_APPLY2,
  /*  21 */  OCAML_PUSHACC1,
  /*  22 */  OCAML_MAKEBLOCK2,
  /*  23 */  0,
  /*  24 */  OCAML_RETURN,
  /*  25 */  2,
  /*  26 */  OCAML_RESTART,
  /*  27 */  OCAML_GRAB,
  /*  28 */  1,
  /*  29 */  OCAML_ACC1,
  /*  30 */  OCAML_BRANCHIFNOT_1B,
  /*  31 */  25,
  /*  32 */  OCAML_ACC1,
  /*  33 */  OCAML_GETFIELD1,
  /*  34 */  OCAML_PUSHACC2,
  /*  35 */  OCAML_GETFIELD0,
  /*  36 */  OCAML_PUSH,
  /*  37 */  OCAML_PUSHACC3,
  /*  38 */  OCAML_APPLY1,
  /*  39 */  OCAML_BRANCHIFNOT_1B,
  /*  40 */  11,
  /*  41 */  OCAML_ACC1,
  /*  42 */  OCAML_PUSHACC3,
  /*  43 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  44 */  OCAML_APPLY2,
  /*  45 */  OCAML_PUSHACC1,
  /*  46 */  OCAML_MAKEBLOCK2,
  /*  47 */  0,
  /*  48 */  OCAML_RETURN,
  /*  49 */  4,
  /*  50 */  OCAML_ACC1,
  /*  51 */  OCAML_PUSHACC3,
  /*  52 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  53 */  OCAML_APPTERM2,
  /*  54 */  6,
  /*  55 */  OCAML_RETURN,
  /*  56 */  2,
  /*  57 */  OCAML_RESTART,
  /*  58 */  OCAML_GRAB,
  /*  59 */  1,
  /*  60 */  OCAML_ACC1,
  /*  61 */  OCAML_BRANCHIFNOT_1B,
  /*  62 */  12,
  /*  63 */  OCAML_ACC1,
  /*  64 */  OCAML_GETFIELD0,
  /*  65 */  OCAML_PUSHACC1,
  /*  66 */  OCAML_APPLY1,
  /*  67 */  OCAML_ACC1,
  /*  68 */  OCAML_GETFIELD1,
  /*  69 */  OCAML_PUSHACC1,
  /*  70 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  71 */  OCAML_APPTERM2,
  /*  72 */  4,
  /*  73 */  OCAML_RETURN,
  /*  74 */  2,
  /*  75 */  OCAML_CONST0,
  /*  76 */  OCAML_CONST0,
  /*  77 */  OCAML_RETURN,
  /*  78 */  1,
  /*  79 */  OCAML_ACC0,
  /*  80 */  OCAML_BRANCHIFNOT_1B,
  /*  81 */  26,
  /*  82 */  OCAML_ACC0,
  /*  83 */  OCAML_GETFIELD0,
  /*  84 */  OCAML_PUSHENVACC2,
  /*  85 */  OCAML_PUSHACC1,
  /*  86 */  OCAML_PUSHACC2,
  /*  87 */  OCAML_MULINT,
  /*  88 */  OCAML_GTINT,
  /*  89 */  OCAML_BRANCHIFNOT_1B,
  /*  90 */  5,
  /*  91 */  OCAML_ACC1,
  /*  92 */  OCAML_RETURN,
  /*  93 */  2,
  /*  94 */  OCAML_ACC1,
  /*  95 */  OCAML_GETFIELD1,
  /*  96 */  OCAML_PUSHACC1,
  /*  97 */  OCAML_PUSHENVACC1,
  /*  98 */  OCAML_APPLY2,
  /*  99 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 100 */  OCAML_APPLY1,
  /* 101 */  OCAML_PUSHACC1,
  /* 102 */  OCAML_MAKEBLOCK2,
  /* 103 */  0,
  /* 104 */  OCAML_POP,
  /* 105 */  1,
  /* 106 */  OCAML_RETURN,
  /* 107 */  1,
  /* 108 */  OCAML_ACC0,
  /* 109 */  OCAML_PUSHGETGLOBAL_1B,
  /* 110 */  1,
  /* 111 */  OCAML_CLOSUREREC_1B,
  /* 112 */  1,
  /* 113 */  2,
  /* 114 */  -32,
  /* 115 */  OCAML_ACC1,
  /* 116 */  OCAML_PUSHCONST2,
  /* 117 */  OCAML_PUSHGETGLOBAL_1B,
  /* 118 */  2,
  /* 119 */  OCAML_APPLY2,
  /* 120 */  OCAML_PUSHACC1,
  /* 121 */  OCAML_APPTERM1,
  /* 122 */  3,
  /* 123 */  OCAML_ENVACC1,
  /* 124 */  OCAML_PUSHACC1,
  /* 125 */  OCAML_MODINT,
  /* 126 */  OCAML_BRANCHIF_1B,
  /* 127 */  5,
  /* 128 */  OCAML_CONST0,
  /* 129 */  OCAML_RETURN,
  /* 130 */  1,
  /* 131 */  OCAML_CONST1,
  /* 132 */  OCAML_RETURN,
  /* 133 */  1,
  /* 134 */  OCAML_ACC0,
  /* 135 */  OCAML_CLOSURE_1B,
  /* 136 */  1,
  /* 137 */  -12,
  /* 138 */  OCAML_PUSHGETGLOBAL_1B,
  /* 139 */  3,
  /* 140 */  OCAML_APPTERM1,
  /* 141 */  2,
  /* 142 */  OCAML_ACC0,
  /* 143 */  OCAML_OFFSETINT_1B,
  /* 144 */  1,
  /* 145 */  OCAML_RETURN,
  /* 146 */  1,
  /* 147 */  OCAML_C_CALL1,
  /* 148 */  0,
  /* 149 */  OCAML_CONST0,
  /* 150 */  OCAML_C_CALL1,
  /* 151 */  1,
  /* 152 */  OCAML_PUSHCONSTINT_1B,
  /* 153 */  10,
  /* 154 */  OCAML_PUSHACC3,
  /* 155 */  OCAML_APPLY1,
  /* 156 */  OCAML_PUSH,
  /* 157 */  OCAML_CLOSURE_1B,
  /* 158 */  0,
  /* 159 */  -82,
  /* 160 */  OCAML_PUSHACC3,
  /* 161 */  OCAML_APPLY2,
  /* 162 */  OCAML_ACC0,
  /* 163 */  OCAML_PUSHCONST0,
  /* 164 */  OCAML_C_CALL1,
  /* 165 */  1,
  /* 166 */  OCAML_SUBINT,
  /* 167 */  OCAML_C_CALL1,
  /* 168 */  2,
  /* 169 */  OCAML_GETGLOBAL_1B,
  /* 170 */  4,
  /* 171 */  OCAML_C_CALL1,
  /* 172 */  3,
  /* 173 */  OCAML_CONST0,
  /* 174 */  OCAML_C_CALL1,
  /* 175 */  4,
  /* 176 */  OCAML_POP,
  /* 177 */  5,
  /* 178 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduboy_millis,
  (void *) &ocaml_arduboy_print_int,
  (void *) &ocaml_arduboy_print,
  (void *) &ocaml_arduboy_display
};
