#define OCAML_STACK_WOSIZE               200
#define OCAML_STATIC_HEAP_WOSIZE           6
#define OCAML_DYNAMIC_HEAP_WOSIZE        194
#define OCAML_FLASH_HEAP_WOSIZE           63
#define OCAML_STACK_INITIAL_WOSIZE         2
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        7
#define OCAML_BYTECODE_BSIZE             412
#define OCAML_PRIMITIVE_NUMBER             7
#define OCAML_VIRTUAL_ARCH                32
#define OCAML_STARTING_OOID                0
#define OCAML_NO_FLASH_HEAP                0
#define OCAML_NO_FLASH_GLOBALS             0

#define OCAML_GC_MARK_AND_COMPACT

#include </home/adilla/Documents/VmMic/Tools/OMicroB/src/byterun/vm/values.h>

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
#define OCAML_PUSHGETFLASHGLOBALFIELD_1B  10
#define OCAML_BRANCH_1B                  11
#define OCAML_BRANCH_2B                  12
#define OCAML_BRANCHIF_1B                13
#define OCAML_BRANCHIFNOT_1B             14
#define OCAML_SWITCH_1B                  15
#define OCAML_CHECK_SIGNALS              16
#define OCAML_C_CALL1                    17
#define OCAML_C_CALL2                    18
#define OCAML_CONST0                     19
#define OCAML_CONST1                     20
#define OCAML_CONST2                     21
#define OCAML_CONST3                     22
#define OCAML_CONSTINT_1B                23
#define OCAML_CONSTINT_2B                24
#define OCAML_PUSHCONSTINT_1B            25
#define OCAML_STOP                       26

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
  /* 42 */  Val_codeptr(55),
  /* 43 */  Make_header(1, Closure_tag, Color_white),
  /* 44 */  Val_codeptr(314),
  /* 45 */  Make_header(1, Closure_tag, Color_white),
  /* 46 */  Val_codeptr(173),
  /* 47 */  Make_header(1, Closure_tag, Color_white),
  /* 48 */  Val_codeptr(266),
  /* 49 */  Make_header(1, Closure_tag, Color_white),
  /* 50 */  Val_codeptr(80),
  /* 51 */  Make_header(1, Closure_tag, Color_white),
  /* 52 */  Val_codeptr(29),
  /* 53 */  Make_header(1, Closure_tag, Color_white),
  /* 54 */  Val_codeptr(3),
  /* 55 */  Make_header(1, Closure_tag, Color_white),
  /* 56 */  Val_codeptr(8),
  /* 57 */  Make_header(1, Closure_tag, Color_white),
  /* 58 */  Val_codeptr(13),
  /* 59 */  Make_header(1, Closure_tag, Color_white),
  /* 60 */  Val_codeptr(18),
  /* 61 */  Make_header(1, Closure_tag, Color_white),
  /* 62 */  Val_codeptr(23)
};

PROGMEM value const ocaml_initial_static_heap[OCAML_STATIC_HEAP_WOSIZE] = {
  /* 0 */  Make_header(5, 0, Color_white),
  /* 1 */  Val_flash_block(&ocaml_flash_heap[54]),
  /* 2 */  Val_flash_block(&ocaml_flash_heap[56]),
  /* 3 */  Val_flash_block(&ocaml_flash_heap[58]),
  /* 4 */  Val_flash_block(&ocaml_flash_heap[60]),
  /* 5 */  Val_flash_block(&ocaml_flash_heap[62])
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
  /* 0 */  Val_int(28),
  /* 1 */  Val_int(1)
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
  /* 0 */  Val_flash_block(&ocaml_flash_heap[44]),
  /* 1 */  Val_flash_block(&ocaml_flash_heap[46]),
  /* 2 */  Val_flash_block(&ocaml_flash_heap[48]),
  /* 3 */  Val_flash_block(&ocaml_flash_heap[50]),
  /* 4 */  Val_flash_block(&ocaml_flash_heap[42]),
  /* 5 */  Val_flash_block(&ocaml_flash_heap[52]),
  /* 6 */  Val_static_block(&ocaml_ram_heap[1])
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
  /*   0 */  OCAML_BRANCH_2B, 1, 104,
  /*   3 */  OCAML_ACC0,
  /*   4 */  OCAML_C_CALL1, 0,
  /*   6 */  OCAML_RETURN, 1,
  /*   8 */  OCAML_ACC0,
  /*   9 */  OCAML_C_CALL1, 1,
  /*  11 */  OCAML_RETURN, 1,
  /*  13 */  OCAML_ACC0,
  /*  14 */  OCAML_C_CALL1, 2,
  /*  16 */  OCAML_RETURN, 1,
  /*  18 */  OCAML_ACC0,
  /*  19 */  OCAML_C_CALL1, 3,
  /*  21 */  OCAML_RETURN, 1,
  /*  23 */  OCAML_ACC0,
  /*  24 */  OCAML_C_CALL1, 4,
  /*  26 */  OCAML_RETURN, 1,
  /*  28 */  OCAML_RESTART,
  /*  29 */  OCAML_GRAB, 1,
  /*  31 */  OCAML_ACC0,
  /*  32 */  OCAML_PUSHGETFLASHGLOBAL_1B, 0,
  /*  34 */  OCAML_APPLY1,
  /*  35 */  OCAML_PUSHACC1,
  /*  36 */  OCAML_PUSHGETFLASHGLOBAL_1B, 1,
  /*  38 */  OCAML_APPLY1,
  /*  39 */  OCAML_PUSHACC3,
  /*  40 */  OCAML_BRANCHIFNOT_1B, 8,
  /*  42 */  OCAML_ACC0,
  /*  43 */  OCAML_PUSHACC2,
  /*  44 */  OCAML_C_CALL2, 5,
  /*  46 */  OCAML_RETURN, 4,
  /*  48 */  OCAML_ACC0,
  /*  49 */  OCAML_PUSHACC2,
  /*  50 */  OCAML_C_CALL2, 6,
  /*  52 */  OCAML_RETURN, 4,
  /*  54 */  OCAML_RESTART,
  /*  55 */  OCAML_GRAB, 1,
  /*  57 */  OCAML_ACC0,
  /*  58 */  OCAML_PUSHGETFLASHGLOBAL_1B, 2,
  /*  60 */  OCAML_APPLY1,
  /*  61 */  OCAML_PUSHACC1,
  /*  62 */  OCAML_PUSHGETFLASHGLOBAL_1B, 3,
  /*  64 */  OCAML_APPLY1,
  /*  65 */  OCAML_PUSHACC3,
  /*  66 */  OCAML_BRANCHIFNOT_1B, 8,
  /*  68 */  OCAML_ACC0,
  /*  69 */  OCAML_PUSHACC2,
  /*  70 */  OCAML_C_CALL2, 5,
  /*  72 */  OCAML_RETURN, 4,
  /*  74 */  OCAML_ACC0,
  /*  75 */  OCAML_PUSHACC2,
  /*  76 */  OCAML_C_CALL2, 6,
  /*  78 */  OCAML_RETURN, 4,
  /*  80 */  OCAML_ACC0,
  /*  81 */  OCAML_SWITCH_1B, 33, 0, 36, 56, 60, 40, 44, 64, 67, 64, 67, 70, 73, 64, 67, 70, 70, 73, 76, 80, 80, 84, 73, 80, 88, 88, 60, 76, 84, 48, 60, 76, 84, 56, 52,
  /* 117 */  OCAML_CONSTINT_1B, 13,
  /* 119 */  OCAML_RETURN, 1,
  /* 121 */  OCAML_CONSTINT_1B, 14,
  /* 123 */  OCAML_RETURN, 1,
  /* 125 */  OCAML_CONSTINT_1B, 15,
  /* 127 */  OCAML_RETURN, 1,
  /* 129 */  OCAML_CONSTINT_1B, 6,
  /* 131 */  OCAML_RETURN, 1,
  /* 133 */  OCAML_CONSTINT_1B, 11,
  /* 135 */  OCAML_RETURN, 1,
  /* 137 */  OCAML_CONSTINT_1B, 10,
  /* 139 */  OCAML_RETURN, 1,
  /* 141 */  OCAML_CONSTINT_1B, 7,
  /* 143 */  OCAML_RETURN, 1,
  /* 145 */  OCAML_CONST0,
  /* 146 */  OCAML_RETURN, 1,
  /* 148 */  OCAML_CONST1,
  /* 149 */  OCAML_RETURN, 1,
  /* 151 */  OCAML_CONST2,
  /* 152 */  OCAML_RETURN, 1,
  /* 154 */  OCAML_CONST3,
  /* 155 */  OCAML_RETURN, 1,
  /* 157 */  OCAML_CONSTINT_1B, 8,
  /* 159 */  OCAML_RETURN, 1,
  /* 161 */  OCAML_CONSTINT_1B, 4,
  /* 163 */  OCAML_RETURN, 1,
  /* 165 */  OCAML_CONSTINT_1B, 9,
  /* 167 */  OCAML_RETURN, 1,
  /* 169 */  OCAML_CONSTINT_1B, 5,
  /* 171 */  OCAML_RETURN, 1,
  /* 173 */  OCAML_ACC0,
  /* 174 */  OCAML_SWITCH_1B, 33, 0, 36, 56, 60, 40, 44, 64, 67, 64, 67, 70, 73, 64, 67, 70, 70, 73, 76, 80, 80, 84, 73, 80, 88, 88, 60, 76, 84, 48, 60, 76, 84, 56, 52,
  /* 210 */  OCAML_CONSTINT_1B, 13,
  /* 212 */  OCAML_RETURN, 1,
  /* 214 */  OCAML_CONSTINT_1B, 14,
  /* 216 */  OCAML_RETURN, 1,
  /* 218 */  OCAML_CONSTINT_1B, 15,
  /* 220 */  OCAML_RETURN, 1,
  /* 222 */  OCAML_CONSTINT_1B, 6,
  /* 224 */  OCAML_RETURN, 1,
  /* 226 */  OCAML_CONSTINT_1B, 11,
  /* 228 */  OCAML_RETURN, 1,
  /* 230 */  OCAML_CONSTINT_1B, 10,
  /* 232 */  OCAML_RETURN, 1,
  /* 234 */  OCAML_CONSTINT_1B, 7,
  /* 236 */  OCAML_RETURN, 1,
  /* 238 */  OCAML_CONST0,
  /* 239 */  OCAML_RETURN, 1,
  /* 241 */  OCAML_CONST1,
  /* 242 */  OCAML_RETURN, 1,
  /* 244 */  OCAML_CONST2,
  /* 245 */  OCAML_RETURN, 1,
  /* 247 */  OCAML_CONST3,
  /* 248 */  OCAML_RETURN, 1,
  /* 250 */  OCAML_CONSTINT_1B, 8,
  /* 252 */  OCAML_RETURN, 1,
  /* 254 */  OCAML_CONSTINT_1B, 4,
  /* 256 */  OCAML_RETURN, 1,
  /* 258 */  OCAML_CONSTINT_1B, 9,
  /* 260 */  OCAML_RETURN, 1,
  /* 262 */  OCAML_CONSTINT_1B, 5,
  /* 264 */  OCAML_RETURN, 1,
  /* 266 */  OCAML_ACC0,
  /* 267 */  OCAML_SWITCH_1B, 33, 0, 36, 40, 40, 36, 36, 40, 40, 36, 36, 36, 36, 43, 43, 43, 40, 40, 40, 36, 40, 40, 43, 43, 43, 36, 36, 36, 36, 43, 43, 43, 43, 36, 36,
  /* 303 */  OCAML_CONSTINT_1B, 4,
  /* 305 */  OCAML_RETURN, 1,
  /* 307 */  OCAML_CONST3,
  /* 308 */  OCAML_RETURN, 1,
  /* 310 */  OCAML_CONSTINT_1B, 5,
  /* 312 */  OCAML_RETURN, 1,
  /* 314 */  OCAML_ACC0,
  /* 315 */  OCAML_SWITCH_1B, 33, 0, 36, 39, 39, 36, 36, 39, 39, 36, 36, 36, 36, 42, 42, 42, 39, 39, 39, 36, 39, 39, 42, 42, 42, 36, 36, 36, 36, 42, 42, 42, 42, 36, 36,
  /* 351 */  OCAML_CONST1,
  /* 352 */  OCAML_RETURN, 1,
  /* 354 */  OCAML_CONST0,
  /* 355 */  OCAML_RETURN, 1,
  /* 357 */  OCAML_CONST2,
  /* 358 */  OCAML_RETURN, 1,
  /* 360 */  OCAML_APPLY2,
  /* 361 */  OCAML_CONST1,
  /* 362 */  OCAML_PUSHCONSTINT_1B, 10,
  /* 364 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 366 */  OCAML_APPLY2,
  /* 367 */  OCAML_BRANCH_1B, 41,
  /* 369 */  OCAML_CHECK_SIGNALS,
  /* 370 */  OCAML_CONST0,
  /* 371 */  OCAML_PUSHCONSTINT_1B, 10,
  /* 373 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 375 */  OCAML_APPLY2,
  /* 376 */  OCAML_CONST0,
  /* 377 */  OCAML_PUSHCONSTINT_1B, 28,
  /* 379 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 381 */  OCAML_APPLY2,
  /* 382 */  OCAML_CONSTINT_2B, 9, 196,
  /* 385 */  OCAML_PUSHGETFLASHGLOBALFIELD_1B, 6, 0,
  /* 388 */  OCAML_APPLY1,
  /* 389 */  OCAML_CONST1,
  /* 390 */  OCAML_PUSHCONSTINT_1B, 10,
  /* 392 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 394 */  OCAML_APPLY2,
  /* 395 */  OCAML_CONST1,
  /* 396 */  OCAML_PUSHCONSTINT_1B, 28,
  /* 398 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 400 */  OCAML_APPLY2,
  /* 401 */  OCAML_CONSTINT_2B, 9, 196,
  /* 404 */  OCAML_PUSHGETFLASHGLOBALFIELD_1B, 6, 0,
  /* 407 */  OCAML_APPLY1,
  /* 408 */  OCAML_CONST1,
  /* 409 */  OCAML_BRANCHIF_1B, (opcode_t) -40,
  /* 411 */  OCAML_STOP
};

#include </home/adilla/Documents/VmMic/Tools/OMicroB/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_delay,
  /*  1 */  (void *) &caml_init_system,
  /*  2 */  (void *) &caml_init_interrupts,
  /*  3 */  (void *) &caml_wait_int_flag_ad1,
  /*  4 */  (void *) &caml_read_adc10,
  /*  5 */  (void *) &caml_clear_bit,
  /*  6 */  (void *) &caml_set_bit,
};
