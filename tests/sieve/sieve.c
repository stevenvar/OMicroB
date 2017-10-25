#define OCAML_STACK_WOSIZE             64
#define OCAML_HEAP_WOSIZE              64
#define OCAML_HEAP_INITIAL_WOSIZE      16
#define OCAML_STACK_INITIAL_WOSIZE      4
#define OCAML_GLOBDATA_NUMBER           6
#define OCAML_BYTECODE_BSIZE          184
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
  /*  3 */  Val_codeptr(113),
  /*  4 */  Make_header(1, Closure_tag),
  /*  5 */  Val_codeptr(27),
  /*  6 */  Make_header(1, Closure_tag),
  /*  7 */  Val_codeptr(4),
  /*  8 */  Make_header(1, Closure_tag),
  /*  9 */  Val_codeptr(147),
  /* 10 */  Make_header(1, String_tag),
  /* 11 */  Make_string_data(' ', '\0', '\0', '\2'),
  /* 12 */  Make_header(1, Closure_tag),
  /* 13 */  Val_codeptr(139),
  /* 14 */  Make_header(1, String_tag),
  /* 15 */  Make_string_data(0x0A, '\0', '\0', '\2')
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
  /* 2 */  Init_val_block(4 * 13),
  /* 3 */  Init_val_block(4 * 7),
  /* 4 */  Init_val_block(4 * 5),
  /* 5 */  Init_val_block(4 * 15)
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_2B,
  /*   1 */  0,
  /*   2 */  152,
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
  /*  75 */  OCAML_ACC0,
  /*  76 */  OCAML_C_CALL1,
  /*  77 */  0,
  /*  78 */  OCAML_GETGLOBAL_1B,
  /*  79 */  1,
  /*  80 */  OCAML_C_CALL1,
  /*  81 */  1,
  /*  82 */  OCAML_RETURN,
  /*  83 */  1,
  /*  84 */  OCAML_ACC0,
  /*  85 */  OCAML_BRANCHIFNOT_1B,
  /*  86 */  26,
  /*  87 */  OCAML_ACC0,
  /*  88 */  OCAML_GETFIELD0,
  /*  89 */  OCAML_PUSHENVACC2,
  /*  90 */  OCAML_PUSHACC1,
  /*  91 */  OCAML_PUSHACC2,
  /*  92 */  OCAML_MULINT,
  /*  93 */  OCAML_GTINT,
  /*  94 */  OCAML_BRANCHIFNOT_1B,
  /*  95 */  5,
  /*  96 */  OCAML_ACC1,
  /*  97 */  OCAML_RETURN,
  /*  98 */  2,
  /*  99 */  OCAML_ACC1,
  /* 100 */  OCAML_GETFIELD1,
  /* 101 */  OCAML_PUSHACC1,
  /* 102 */  OCAML_PUSHENVACC1,
  /* 103 */  OCAML_APPLY2,
  /* 104 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 105 */  OCAML_APPLY1,
  /* 106 */  OCAML_PUSHACC1,
  /* 107 */  OCAML_MAKEBLOCK2,
  /* 108 */  0,
  /* 109 */  OCAML_POP,
  /* 110 */  1,
  /* 111 */  OCAML_RETURN,
  /* 112 */  1,
  /* 113 */  OCAML_ACC0,
  /* 114 */  OCAML_PUSHGETGLOBAL_1B,
  /* 115 */  2,
  /* 116 */  OCAML_CLOSUREREC_1B,
  /* 117 */  1,
  /* 118 */  2,
  /* 119 */  -32,
  /* 120 */  OCAML_ACC1,
  /* 121 */  OCAML_PUSHCONST2,
  /* 122 */  OCAML_PUSHGETGLOBAL_1B,
  /* 123 */  3,
  /* 124 */  OCAML_APPLY2,
  /* 125 */  OCAML_PUSHACC1,
  /* 126 */  OCAML_APPTERM1,
  /* 127 */  3,
  /* 128 */  OCAML_ENVACC1,
  /* 129 */  OCAML_PUSHACC1,
  /* 130 */  OCAML_MODINT,
  /* 131 */  OCAML_BRANCHIF_1B,
  /* 132 */  5,
  /* 133 */  OCAML_CONST0,
  /* 134 */  OCAML_RETURN,
  /* 135 */  1,
  /* 136 */  OCAML_CONST1,
  /* 137 */  OCAML_RETURN,
  /* 138 */  1,
  /* 139 */  OCAML_ACC0,
  /* 140 */  OCAML_CLOSURE_1B,
  /* 141 */  1,
  /* 142 */  -12,
  /* 143 */  OCAML_PUSHGETGLOBAL_1B,
  /* 144 */  4,
  /* 145 */  OCAML_APPTERM1,
  /* 146 */  2,
  /* 147 */  OCAML_ACC0,
  /* 148 */  OCAML_OFFSETINT_1B,
  /* 149 */  1,
  /* 150 */  OCAML_RETURN,
  /* 151 */  1,
  /* 152 */  OCAML_C_CALL1,
  /* 153 */  2,
  /* 154 */  OCAML_CONST0,
  /* 155 */  OCAML_C_CALL1,
  /* 156 */  3,
  /* 157 */  OCAML_PUSHCONSTINT_1B,
  /* 158 */  10,
  /* 159 */  OCAML_PUSHACC3,
  /* 160 */  OCAML_APPLY1,
  /* 161 */  OCAML_PUSH,
  /* 162 */  OCAML_CLOSURE_1B,
  /* 163 */  0,
  /* 164 */  -87,
  /* 165 */  OCAML_PUSHACC3,
  /* 166 */  OCAML_APPLY2,
  /* 167 */  OCAML_GETGLOBAL_1B,
  /* 168 */  5,
  /* 169 */  OCAML_C_CALL1,
  /* 170 */  1,
  /* 171 */  OCAML_ACC0,
  /* 172 */  OCAML_PUSHCONST0,
  /* 173 */  OCAML_C_CALL1,
  /* 174 */  3,
  /* 175 */  OCAML_SUBINT,
  /* 176 */  OCAML_C_CALL1,
  /* 177 */  0,
  /* 178 */  OCAML_CONST0,
  /* 179 */  OCAML_C_CALL1,
  /* 180 */  4,
  /* 181 */  OCAML_POP,
  /* 182 */  5,
  /* 183 */  OCAML_STOP
};

#include </Users/arcadium/github/OMicroB/src/byterun/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  (void *) &ocaml_arduboy_print_int,
  (void *) &ocaml_arduboy_print,
  (void *) &ocaml_arduboy_init,
  (void *) &ocaml_arduboy_millis,
  (void *) &ocaml_arduboy_display
};
