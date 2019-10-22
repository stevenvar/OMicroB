#define OCAML_STACK_WOSIZE               200
#define OCAML_STATIC_HEAP_WOSIZE           0
#define OCAML_DYNAMIC_HEAP_WOSIZE        200
#define OCAML_FLASH_HEAP_WOSIZE           53
#define OCAML_STACK_INITIAL_WOSIZE         2
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        5
#define OCAML_BYTECODE_BSIZE             348
#define OCAML_PRIMITIVE_NUMBER             2
#define OCAML_VIRTUAL_ARCH                32
#define OCAML_STARTING_OOID                0
#define OCAML_NO_FLASH_HEAP                0
#define OCAML_NO_FLASH_GLOBALS             0

#define OCAML_GC_MARK_AND_COMPACT

#include </home/adilla/Documents/VmMic/Tools/OMicroBPIC32/src/byterun/vm/values.h>

#define OCAML_ACC0                        0
#define OCAML_PUSHACC1                    1
#define OCAML_PUSHACC2                    2
#define OCAML_PUSHACC3                    3
#define OCAML_APPLY1                      4
#define OCAML_APPLY2                      5
#define OCAML_RETURN                      6
#define OCAML_RESTART                     7
#define OCAML_GRAB                        8
#define OCAML_PUSHGETFLASHGLOBAL_1B       9
#define OCAML_BRANCH_1B                  10
#define OCAML_BRANCH_2B                  11
#define OCAML_BRANCHIF_1B                12
#define OCAML_BRANCHIFNOT_1B             13
#define OCAML_SWITCH_1B                  14
#define OCAML_CHECK_SIGNALS              15
#define OCAML_C_CALL2                    16
#define OCAML_CONST0                     17
#define OCAML_CONST1                     18
#define OCAML_CONST2                     19
#define OCAML_CONST3                     20
#define OCAML_CONSTINT_1B                21
#define OCAML_PUSHCONST1                 22
#define OCAML_STOP                       23

value ocaml_stack[OCAML_STACK_WOSIZE];
value ocaml_ram_heap[OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE];
value ocaml_ram_global_data[OCAML_RAM_GLOBDATA_NUMBER];

PROGMEM value const ocaml_flash_heap[OCAML_FLASH_HEAP_WOSIZE] = {
  /*  0 */  Make_header(0, 0, Color_white),
  /*  1 */  Make_header(2, Object_tag, Color_white),
  /*  2 */  Val_flash_block(&ocaml_flash_heap[5]),
  /*  3 */  Val_int(-1),
  /*  4 */  Make_header(4, String_tag, Color_white),
  /*  5 */  Make_string_data('O', 'u', 't', '_'),
  /*  6 */  Make_string_data('o', 'f', '_', 'm'),
  /*  7 */  Make_string_data('e', 'm', 'o', 'r'),
  /*  8 */  Make_string_data('y', '\0', '\0', '\2'),
  /*  9 */  Make_header(2, Object_tag, Color_white),
  /* 10 */  Val_flash_block(&ocaml_flash_heap[13]),
  /* 11 */  Val_int(-3),
  /* 12 */  Make_header(2, String_tag, Color_white),
  /* 13 */  Make_string_data('F', 'a', 'i', 'l'),
  /* 14 */  Make_string_data('u', 'r', 'e', '\0'),
  /* 15 */  Make_header(2, Object_tag, Color_white),
  /* 16 */  Val_flash_block(&ocaml_flash_heap[19]),
  /* 17 */  Val_int(-4),
  /* 18 */  Make_header(5, String_tag, Color_white),
  /* 19 */  Make_string_data('I', 'n', 'v', 'a'),
  /* 20 */  Make_string_data('l', 'i', 'd', '_'),
  /* 21 */  Make_string_data('a', 'r', 'g', 'u'),
  /* 22 */  Make_string_data('m', 'e', 'n', 't'),
  /* 23 */  Make_string_data('\0', '\0', '\0', '\3'),
  /* 24 */  Make_header(2, Object_tag, Color_white),
  /* 25 */  Val_flash_block(&ocaml_flash_heap[28]),
  /* 26 */  Val_int(-6),
  /* 27 */  Make_header(5, String_tag, Color_white),
  /* 28 */  Make_string_data('D', 'i', 'v', 'i'),
  /* 29 */  Make_string_data('s', 'i', 'o', 'n'),
  /* 30 */  Make_string_data('_', 'b', 'y', '_'),
  /* 31 */  Make_string_data('z', 'e', 'r', 'o'),
  /* 32 */  Make_string_data('\0', '\0', '\0', '\3'),
  /* 33 */  Make_header(2, Object_tag, Color_white),
  /* 34 */  Val_flash_block(&ocaml_flash_heap[37]),
  /* 35 */  Val_int(-9),
  /* 36 */  Make_header(4, String_tag, Color_white),
  /* 37 */  Make_string_data('S', 't', 'a', 'c'),
  /* 38 */  Make_string_data('k', '_', 'o', 'v'),
  /* 39 */  Make_string_data('e', 'r', 'f', 'l'),
  /* 40 */  Make_string_data('o', 'w', '\0', '\1'),
  /* 41 */  Make_header(1, Closure_tag, Color_white),
  /* 42 */  Val_codeptr(30),
  /* 43 */  Make_header(1, Closure_tag, Color_white),
  /* 44 */  Val_codeptr(289),
  /* 45 */  Make_header(1, Closure_tag, Color_white),
  /* 46 */  Val_codeptr(148),
  /* 47 */  Make_header(1, Closure_tag, Color_white),
  /* 48 */  Val_codeptr(241),
  /* 49 */  Make_header(1, Closure_tag, Color_white),
  /* 50 */  Val_codeptr(55),
  /* 51 */  Make_header(1, Closure_tag, Color_white),
  /* 52 */  Val_codeptr(4)
};

PROGMEM value const ocaml_initial_static_heap[OCAML_STATIC_HEAP_WOSIZE] = {
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
  /* 0 */  Val_int(1),
  /* 1 */  Val_int(1)
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
  /* 0 */  Val_flash_block(&ocaml_flash_heap[44]),
  /* 1 */  Val_flash_block(&ocaml_flash_heap[46]),
  /* 2 */  Val_flash_block(&ocaml_flash_heap[48]),
  /* 3 */  Val_flash_block(&ocaml_flash_heap[50]),
  /* 4 */  Val_flash_block(&ocaml_flash_heap[52])
};

value acc = Val_flash_block(&ocaml_flash_heap[42]);
value env = Val_unit;

#define OCAML_Out_of_memory        Val_flash_block(&ocaml_flash_heap[2])
#define OCAML_Failure              Val_flash_block(&ocaml_flash_heap[10])
#define OCAML_Invalid_argument     Val_flash_block(&ocaml_flash_heap[16])
#define OCAML_Division_by_zero     Val_flash_block(&ocaml_flash_heap[25])
#define OCAML_Stack_overflow       Val_flash_block(&ocaml_flash_heap[34])

#define OCAML_atom0                Val_flash_block(&ocaml_flash_heap[1])

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_2B, 1, 79,
  /*   3 */  OCAML_RESTART,
  /*   4 */  OCAML_GRAB, 1,
  /*   6 */  OCAML_ACC0,
  /*   7 */  OCAML_PUSHGETFLASHGLOBAL_1B, 0,
  /*   9 */  OCAML_APPLY1,
  /*  10 */  OCAML_PUSHACC1,
  /*  11 */  OCAML_PUSHGETFLASHGLOBAL_1B, 1,
  /*  13 */  OCAML_APPLY1,
  /*  14 */  OCAML_PUSHACC3,
  /*  15 */  OCAML_BRANCHIFNOT_1B, 8,
  /*  17 */  OCAML_ACC0,
  /*  18 */  OCAML_PUSHACC2,
  /*  19 */  OCAML_C_CALL2, 0,
  /*  21 */  OCAML_RETURN, 4,
  /*  23 */  OCAML_ACC0,
  /*  24 */  OCAML_PUSHACC2,
  /*  25 */  OCAML_C_CALL2, 1,
  /*  27 */  OCAML_RETURN, 4,
  /*  29 */  OCAML_RESTART,
  /*  30 */  OCAML_GRAB, 1,
  /*  32 */  OCAML_ACC0,
  /*  33 */  OCAML_PUSHGETFLASHGLOBAL_1B, 2,
  /*  35 */  OCAML_APPLY1,
  /*  36 */  OCAML_PUSHACC1,
  /*  37 */  OCAML_PUSHGETFLASHGLOBAL_1B, 3,
  /*  39 */  OCAML_APPLY1,
  /*  40 */  OCAML_PUSHACC3,
  /*  41 */  OCAML_BRANCHIFNOT_1B, 8,
  /*  43 */  OCAML_ACC0,
  /*  44 */  OCAML_PUSHACC2,
  /*  45 */  OCAML_C_CALL2, 0,
  /*  47 */  OCAML_RETURN, 4,
  /*  49 */  OCAML_ACC0,
  /*  50 */  OCAML_PUSHACC2,
  /*  51 */  OCAML_C_CALL2, 1,
  /*  53 */  OCAML_RETURN, 4,
  /*  55 */  OCAML_ACC0,
  /*  56 */  OCAML_SWITCH_1B, 33, 0, 36, 56, 60, 40, 44, 64, 67, 64, 67, 70, 73, 64, 67, 70, 70, 73, 76, 80, 80, 84, 73, 80, 88, 88, 60, 76, 84, 48, 60, 76, 84, 56, 52,
  /*  92 */  OCAML_CONSTINT_1B, 13,
  /*  94 */  OCAML_RETURN, 1,
  /*  96 */  OCAML_CONSTINT_1B, 14,
  /*  98 */  OCAML_RETURN, 1,
  /* 100 */  OCAML_CONSTINT_1B, 15,
  /* 102 */  OCAML_RETURN, 1,
  /* 104 */  OCAML_CONSTINT_1B, 6,
  /* 106 */  OCAML_RETURN, 1,
  /* 108 */  OCAML_CONSTINT_1B, 11,
  /* 110 */  OCAML_RETURN, 1,
  /* 112 */  OCAML_CONSTINT_1B, 10,
  /* 114 */  OCAML_RETURN, 1,
  /* 116 */  OCAML_CONSTINT_1B, 7,
  /* 118 */  OCAML_RETURN, 1,
  /* 120 */  OCAML_CONST0,
  /* 121 */  OCAML_RETURN, 1,
  /* 123 */  OCAML_CONST1,
  /* 124 */  OCAML_RETURN, 1,
  /* 126 */  OCAML_CONST2,
  /* 127 */  OCAML_RETURN, 1,
  /* 129 */  OCAML_CONST3,
  /* 130 */  OCAML_RETURN, 1,
  /* 132 */  OCAML_CONSTINT_1B, 8,
  /* 134 */  OCAML_RETURN, 1,
  /* 136 */  OCAML_CONSTINT_1B, 4,
  /* 138 */  OCAML_RETURN, 1,
  /* 140 */  OCAML_CONSTINT_1B, 9,
  /* 142 */  OCAML_RETURN, 1,
  /* 144 */  OCAML_CONSTINT_1B, 5,
  /* 146 */  OCAML_RETURN, 1,
  /* 148 */  OCAML_ACC0,
  /* 149 */  OCAML_SWITCH_1B, 33, 0, 36, 56, 60, 40, 44, 64, 67, 64, 67, 70, 73, 64, 67, 70, 70, 73, 76, 80, 80, 84, 73, 80, 88, 88, 60, 76, 84, 48, 60, 76, 84, 56, 52,
  /* 185 */  OCAML_CONSTINT_1B, 13,
  /* 187 */  OCAML_RETURN, 1,
  /* 189 */  OCAML_CONSTINT_1B, 14,
  /* 191 */  OCAML_RETURN, 1,
  /* 193 */  OCAML_CONSTINT_1B, 15,
  /* 195 */  OCAML_RETURN, 1,
  /* 197 */  OCAML_CONSTINT_1B, 6,
  /* 199 */  OCAML_RETURN, 1,
  /* 201 */  OCAML_CONSTINT_1B, 11,
  /* 203 */  OCAML_RETURN, 1,
  /* 205 */  OCAML_CONSTINT_1B, 10,
  /* 207 */  OCAML_RETURN, 1,
  /* 209 */  OCAML_CONSTINT_1B, 7,
  /* 211 */  OCAML_RETURN, 1,
  /* 213 */  OCAML_CONST0,
  /* 214 */  OCAML_RETURN, 1,
  /* 216 */  OCAML_CONST1,
  /* 217 */  OCAML_RETURN, 1,
  /* 219 */  OCAML_CONST2,
  /* 220 */  OCAML_RETURN, 1,
  /* 222 */  OCAML_CONST3,
  /* 223 */  OCAML_RETURN, 1,
  /* 225 */  OCAML_CONSTINT_1B, 8,
  /* 227 */  OCAML_RETURN, 1,
  /* 229 */  OCAML_CONSTINT_1B, 4,
  /* 231 */  OCAML_RETURN, 1,
  /* 233 */  OCAML_CONSTINT_1B, 9,
  /* 235 */  OCAML_RETURN, 1,
  /* 237 */  OCAML_CONSTINT_1B, 5,
  /* 239 */  OCAML_RETURN, 1,
  /* 241 */  OCAML_ACC0,
  /* 242 */  OCAML_SWITCH_1B, 33, 0, 36, 40, 40, 36, 36, 40, 40, 36, 36, 36, 36, 43, 43, 43, 40, 40, 40, 36, 40, 40, 43, 43, 43, 36, 36, 36, 36, 43, 43, 43, 43, 36, 36,
  /* 278 */  OCAML_CONSTINT_1B, 4,
  /* 280 */  OCAML_RETURN, 1,
  /* 282 */  OCAML_CONST3,
  /* 283 */  OCAML_RETURN, 1,
  /* 285 */  OCAML_CONSTINT_1B, 5,
  /* 287 */  OCAML_RETURN, 1,
  /* 289 */  OCAML_ACC0,
  /* 290 */  OCAML_SWITCH_1B, 33, 0, 36, 39, 39, 36, 36, 39, 39, 36, 36, 36, 36, 42, 42, 42, 39, 39, 39, 36, 39, 39, 42, 42, 42, 36, 36, 36, 36, 42, 42, 42, 42, 36, 36,
  /* 326 */  OCAML_CONST1,
  /* 327 */  OCAML_RETURN, 1,
  /* 329 */  OCAML_CONST0,
  /* 330 */  OCAML_RETURN, 1,
  /* 332 */  OCAML_CONST2,
  /* 333 */  OCAML_RETURN, 1,
  /* 335 */  OCAML_APPLY2,
  /* 336 */  OCAML_BRANCH_1B, 8,
  /* 338 */  OCAML_CHECK_SIGNALS,
  /* 339 */  OCAML_CONST0,
  /* 340 */  OCAML_PUSHCONST1,
  /* 341 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 343 */  OCAML_APPLY2,
  /* 344 */  OCAML_CONST1,
  /* 345 */  OCAML_BRANCHIF_1B, (opcode_t) -7,
  /* 347 */  OCAML_STOP
};

#include </home/adilla/Documents/VmMic/Tools/OMicroBPIC32/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_pic32_clear_bit,
  /*  1 */  (void *) &caml_pic32_set_bit,
};
