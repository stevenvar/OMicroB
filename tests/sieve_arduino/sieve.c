#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              70
#define OCAML_HEAP_INITIAL_WOSIZE      13
#define OCAML_STACK_INITIAL_WOSIZE      4
#define OCAML_GLOBDATA_NUMBER           4
#define OCAML_BYTECODE_BSIZE          190
#define OCAML_PRIMITIVE_NUMBER          4
#define OCAML_VIRTUAL_ARCH             32

#include </Users/arcadium/github/OMicroB/src/byterun/values.h>

#define OCAML_ACC0                      0
#define OCAML_ACC1                      1
#define OCAML_PUSH                      2
#define OCAML_PUSHACC1                  3
#define OCAML_PUSHACC2                  4
#define OCAML_PUSHACC3                  5
#define OCAML_PUSHACC5                  6
#define OCAML_POP                       7
#define OCAML_ASSIGN                    8
#define OCAML_ENVACC1                   9
#define OCAML_PUSHENVACC1              10
#define OCAML_PUSHENVACC2              11
#define OCAML_APPLY1                   12
#define OCAML_APPLY2                   13
#define OCAML_APPTERM1                 14
#define OCAML_APPTERM2                 15
#define OCAML_RETURN                   16
#define OCAML_RESTART                  17
#define OCAML_GRAB                     18
#define OCAML_CLOSURE_1B               19
#define OCAML_CLOSUREREC_1B            20
#define OCAML_PUSHOFFSETCLOSURE0       21
#define OCAML_GETGLOBAL_1B             22
#define OCAML_PUSHGETGLOBAL_1B         23
#define OCAML_MAKEBLOCK2               24
#define OCAML_GETFIELD0                25
#define OCAML_GETFIELD1                26
#define OCAML_BRANCH_2B                27
#define OCAML_BRANCHIF_1B              28
#define OCAML_BRANCHIFNOT_1B           29
#define OCAML_CHECK_SIGNALS            30
#define OCAML_C_CALL1                  31
#define OCAML_CONST0                   32
#define OCAML_CONST1                   33
#define OCAML_CONSTINT_1B              34
#define OCAML_PUSHCONST0               35
#define OCAML_PUSHCONST2               36
#define OCAML_PUSHCONSTINT_1B          37
#define OCAML_SUBINT                   38
#define OCAML_MULINT                   39
#define OCAML_MODINT                   40
#define OCAML_NEQ                      41
#define OCAML_GTINT                    42
#define OCAML_OFFSETINT_1B             43
#define OCAML_STOP                     44

val_t ocaml_heap[OCAML_HEAP_WOSIZE * 2] = {
  /*  0 */  Make_header(1, Closure_tag),
  /*  1 */  Val_codeptr(57),
  /*  2 */  Make_header(1, Closure_tag),
  /*  3 */  Val_codeptr(106),
  /*  4 */  Make_header(1, Closure_tag),
  /*  5 */  Val_codeptr(26),
  /*  6 */  Make_header(1, Closure_tag),
  /*  7 */  Val_codeptr(4),
  /*  8 */  Make_header(1, Closure_tag),
  /*  9 */  Val_codeptr(132),
  /* 10 */  Make_header(2, String_tag),
  /* 11 */  Make_string_data('f', 'i', 'n', 'i'),
  /* 12 */  Make_string_data('s', 'h', '\0', '\1')
};

const val_t* ocaml_heap1 = ocaml_heap;
const val_t* ocaml_heap2 = ocaml_heap + OCAML_HEAP_WOSIZE;

val_t acc = Val_int(57600);

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
  /* 1 */  Init_val_block(4 * 7),
  /* 2 */  Init_val_block(4 * 5),
  /* 3 */  Init_val_block(4 * 11)
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_2B,
  /*   1 */  0,
  /*   2 */  140,
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
  /*  16 */  OCAML_OFFSETINT_1B,
  /*  17 */  1,
  /*  18 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  19 */  OCAML_APPLY2,
  /*  20 */  OCAML_PUSHACC1,
  /*  21 */  OCAML_MAKEBLOCK2,
  /*  22 */  0,
  /*  23 */  OCAML_RETURN,
  /*  24 */  2,
  /*  25 */  OCAML_RESTART,
  /*  26 */  OCAML_GRAB,
  /*  27 */  1,
  /*  28 */  OCAML_ACC1,
  /*  29 */  OCAML_BRANCHIFNOT_1B,
  /*  30 */  25,
  /*  31 */  OCAML_ACC1,
  /*  32 */  OCAML_GETFIELD1,
  /*  33 */  OCAML_PUSHACC2,
  /*  34 */  OCAML_GETFIELD0,
  /*  35 */  OCAML_PUSH,
  /*  36 */  OCAML_PUSHACC3,
  /*  37 */  OCAML_APPLY1,
  /*  38 */  OCAML_BRANCHIFNOT_1B,
  /*  39 */  11,
  /*  40 */  OCAML_ACC1,
  /*  41 */  OCAML_PUSHACC3,
  /*  42 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  43 */  OCAML_APPLY2,
  /*  44 */  OCAML_PUSHACC1,
  /*  45 */  OCAML_MAKEBLOCK2,
  /*  46 */  0,
  /*  47 */  OCAML_RETURN,
  /*  48 */  4,
  /*  49 */  OCAML_ACC1,
  /*  50 */  OCAML_PUSHACC3,
  /*  51 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  52 */  OCAML_APPTERM2,
  /*  53 */  6,
  /*  54 */  OCAML_RETURN,
  /*  55 */  2,
  /*  56 */  OCAML_RESTART,
  /*  57 */  OCAML_GRAB,
  /*  58 */  1,
  /*  59 */  OCAML_ACC1,
  /*  60 */  OCAML_BRANCHIFNOT_1B,
  /*  61 */  12,
  /*  62 */  OCAML_ACC1,
  /*  63 */  OCAML_GETFIELD0,
  /*  64 */  OCAML_PUSHACC1,
  /*  65 */  OCAML_APPLY1,
  /*  66 */  OCAML_ACC1,
  /*  67 */  OCAML_GETFIELD1,
  /*  68 */  OCAML_PUSHACC1,
  /*  69 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  70 */  OCAML_APPTERM2,
  /*  71 */  4,
  /*  72 */  OCAML_RETURN,
  /*  73 */  2,
  /*  74 */  OCAML_CONST0,
  /*  75 */  OCAML_RETURN,
  /*  76 */  1,
  /*  77 */  OCAML_ACC0,
  /*  78 */  OCAML_BRANCHIFNOT_1B,
  /*  79 */  26,
  /*  80 */  OCAML_ACC0,
  /*  81 */  OCAML_GETFIELD0,
  /*  82 */  OCAML_PUSHENVACC2,
  /*  83 */  OCAML_PUSHACC1,
  /*  84 */  OCAML_PUSHACC2,
  /*  85 */  OCAML_MULINT,
  /*  86 */  OCAML_GTINT,
  /*  87 */  OCAML_BRANCHIFNOT_1B,
  /*  88 */  5,
  /*  89 */  OCAML_ACC1,
  /*  90 */  OCAML_RETURN,
  /*  91 */  2,
  /*  92 */  OCAML_ACC1,
  /*  93 */  OCAML_GETFIELD1,
  /*  94 */  OCAML_PUSHACC1,
  /*  95 */  OCAML_PUSHENVACC1,
  /*  96 */  OCAML_APPLY2,
  /*  97 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  98 */  OCAML_APPLY1,
  /*  99 */  OCAML_PUSHACC1,
  /* 100 */  OCAML_MAKEBLOCK2,
  /* 101 */  0,
  /* 102 */  OCAML_POP,
  /* 103 */  1,
  /* 104 */  OCAML_RETURN,
  /* 105 */  1,
  /* 106 */  OCAML_ACC0,
  /* 107 */  OCAML_PUSHGETGLOBAL_1B,
  /* 108 */  0,
  /* 109 */  OCAML_CLOSUREREC_1B,
  /* 110 */  1,
  /* 111 */  2,
  /* 112 */  -32,
  /* 113 */  OCAML_ACC1,
  /* 114 */  OCAML_PUSHCONST2,
  /* 115 */  OCAML_PUSHGETGLOBAL_1B,
  /* 116 */  1,
  /* 117 */  OCAML_APPLY2,
  /* 118 */  OCAML_PUSHACC1,
  /* 119 */  OCAML_APPTERM1,
  /* 120 */  3,
  /* 121 */  OCAML_ENVACC1,
  /* 122 */  OCAML_PUSHACC1,
  /* 123 */  OCAML_MODINT,
  /* 124 */  OCAML_BRANCHIF_1B,
  /* 125 */  5,
  /* 126 */  OCAML_CONST0,
  /* 127 */  OCAML_RETURN,
  /* 128 */  1,
  /* 129 */  OCAML_CONST1,
  /* 130 */  OCAML_RETURN,
  /* 131 */  1,
  /* 132 */  OCAML_ACC0,
  /* 133 */  OCAML_CLOSURE_1B,
  /* 134 */  1,
  /* 135 */  -12,
  /* 136 */  OCAML_PUSHGETGLOBAL_1B,
  /* 137 */  2,
  /* 138 */  OCAML_APPTERM1,
  /* 139 */  2,
  /* 140 */  OCAML_C_CALL1,
  /* 141 */  0,
  /* 142 */  OCAML_CONST0,
  /* 143 */  OCAML_C_CALL1,
  /* 144 */  1,
  /* 145 */  OCAML_PUSHCONST0,
  /* 146 */  OCAML_PUSHCONSTINT_1B,
  /* 147 */  100,
  /* 148 */  OCAML_PUSH,
  /* 149 */  OCAML_PUSHACC2,
  /* 150 */  OCAML_GTINT,
  /* 151 */  OCAML_BRANCHIF_1B,
  /* 152 */  23,
  /* 153 */  OCAML_CHECK_SIGNALS,
  /* 154 */  OCAML_CONSTINT_1B,
  /* 155 */  10,
  /* 156 */  OCAML_PUSHACC5,
  /* 157 */  OCAML_APPLY1,
  /* 158 */  OCAML_PUSH,
  /* 159 */  OCAML_CLOSURE_1B,
  /* 160 */  0,
  /* 161 */  -85,
  /* 162 */  OCAML_PUSHACC5,
  /* 163 */  OCAML_APPLY2,
  /* 164 */  OCAML_ACC1,
  /* 165 */  OCAML_PUSH,
  /* 166 */  OCAML_OFFSETINT_1B,
  /* 167 */  1,
  /* 168 */  OCAML_ASSIGN,
  /* 169 */  2,
  /* 170 */  OCAML_ACC1,
  /* 171 */  OCAML_NEQ,
  /* 172 */  OCAML_BRANCHIF_1B,
  /* 173 */  -19,
  /* 174 */  OCAML_POP,
  /* 175 */  2,
  /* 176 */  OCAML_ACC0,
  /* 177 */  OCAML_PUSHCONST0,
  /* 178 */  OCAML_C_CALL1,
  /* 179 */  1,
  /* 180 */  OCAML_SUBINT,
  /* 181 */  OCAML_C_CALL1,
  /* 182 */  2,
  /* 183 */  OCAML_GETGLOBAL_1B,
  /* 184 */  3,
  /* 185 */  OCAML_C_CALL1,
  /* 186 */  3,
  /* 187 */  OCAML_POP,
  /* 188 */  5,
  /* 189 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduino_serial_begin,
  (void *) &ocaml_arduino_millis,
  (void *) &caml_print_int,
  (void *) &caml_print_string
};
