#define OCAML_STACK_WOSIZE               200
#define OCAML_STATIC_HEAP_WOSIZE           0
#define OCAML_DYNAMIC_HEAP_WOSIZE        200
#define OCAML_FLASH_HEAP_WOSIZE           53
#define OCAML_STACK_INITIAL_WOSIZE         2
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        6
#define OCAML_BYTECODE_BSIZE             763
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
#define OCAML_BRANCH_2B                  10
#define OCAML_BRANCHIF_1B                11
#define OCAML_BRANCHIFNOT_1B             12
#define OCAML_SWITCH_1B                  13
#define OCAML_SWITCH_2B                  14
#define OCAML_C_CALL2                    15
#define OCAML_CONST0                     16
#define OCAML_CONST1                     17
#define OCAML_CONST2                     18
#define OCAML_CONST3                     19
#define OCAML_CONSTINT_1B                20
#define OCAML_PUSHCONSTINT_1B            21
#define OCAML_OFFSETINT_1B               22
#define OCAML_BGTINT_1B                  23
#define OCAML_STOP                       24

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
  /* 44 */  Val_codeptr(631),
  /* 45 */  Make_header(1, Closure_tag, Color_white),
  /* 46 */  Val_codeptr(285),
  /* 47 */  Make_header(1, Closure_tag, Color_white),
  /* 48 */  Val_codeptr(515),
  /* 49 */  Make_header(1, Closure_tag, Color_white),
  /* 50 */  Val_codeptr(55),
  /* 51 */  Make_header(1, Closure_tag, Color_white),
  /* 52 */  Val_codeptr(4)
};

PROGMEM value const ocaml_initial_static_heap[OCAML_STATIC_HEAP_WOSIZE] = {
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
  /* 0 */  Val_int(62),
  /* 1 */  Val_int(1)
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
  /* 0 */  Val_flash_block(&ocaml_flash_heap[44]),
  /* 1 */  Val_flash_block(&ocaml_flash_heap[46]),
  /* 2 */  Val_flash_block(&ocaml_flash_heap[48]),
  /* 3 */  Val_flash_block(&ocaml_flash_heap[50]),
  /* 4 */  Val_flash_block(&ocaml_flash_heap[42]),
  /* 5 */  Val_flash_block(&ocaml_flash_heap[52])
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
  /*   0 */  OCAML_BRANCH_2B, 2, 231,
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
  /*  56 */  OCAML_SWITCH_2B, 83, 0, 0, 169, 0, 169, 0, 173, 0, 177, 0, 181, 0, 184, 0, 187, 0, 190, 0, 173, 0, 177, 0, 194, 0, 198, 0, 202, 0, 194, 0, 198, 0, 169, 0, 190, 0, 187, 0, 184, 0, 181, 0, 202, 0, 173, 0, 177, 0, 198, 0, 205, 0, 194, 0, 198, 0, 205, 0, 209, 0, 181, 0, 213, 0, 217, 0, 217, 0, 213, 0, 221, 0, 225, 0, 221, 0, 225, 0, 190, 0, 169, 0, 187, 0, 184, 0, 194, 0, 187, 0, 184, 0, 184, 0, 187, 0, 190, 0, 169, 0, 217, 0, 225, 0, 221, 0, 225, 0, 194, 0, 198, 0, 205, 0, 209, 0, 202, 0, 213, 0, 221, 0, 181, 0, 184, 0, 187, 0, 217, 0, 213, 0, 190, 0, 169, 0, 173, 0, 177, 0, 202, 0, 181, 0, 181, 0, 202, 0, 173, 0, 177, 0, 202, 0, 181, 0, 221, 0, 217, 0, 213, 0, 184, 0, 187, 0, 190,
  /* 225 */  OCAML_CONSTINT_1B, 5,
  /* 227 */  OCAML_RETURN, 1,
  /* 229 */  OCAML_CONSTINT_1B, 6,
  /* 231 */  OCAML_RETURN, 1,
  /* 233 */  OCAML_CONSTINT_1B, 7,
  /* 235 */  OCAML_RETURN, 1,
  /* 237 */  OCAML_CONST1,
  /* 238 */  OCAML_RETURN, 1,
  /* 240 */  OCAML_CONST2,
  /* 241 */  OCAML_RETURN, 1,
  /* 243 */  OCAML_CONST3,
  /* 244 */  OCAML_RETURN, 1,
  /* 246 */  OCAML_CONSTINT_1B, 4,
  /* 248 */  OCAML_RETURN, 1,
  /* 250 */  OCAML_CONSTINT_1B, 8,
  /* 252 */  OCAML_RETURN, 1,
  /* 254 */  OCAML_CONSTINT_1B, 9,
  /* 256 */  OCAML_RETURN, 1,
  /* 258 */  OCAML_CONST0,
  /* 259 */  OCAML_RETURN, 1,
  /* 261 */  OCAML_CONSTINT_1B, 10,
  /* 263 */  OCAML_RETURN, 1,
  /* 265 */  OCAML_CONSTINT_1B, 11,
  /* 267 */  OCAML_RETURN, 1,
  /* 269 */  OCAML_CONSTINT_1B, 13,
  /* 271 */  OCAML_RETURN, 1,
  /* 273 */  OCAML_CONSTINT_1B, 12,
  /* 275 */  OCAML_RETURN, 1,
  /* 277 */  OCAML_CONSTINT_1B, 14,
  /* 279 */  OCAML_RETURN, 1,
  /* 281 */  OCAML_CONSTINT_1B, 15,
  /* 283 */  OCAML_RETURN, 1,
  /* 285 */  OCAML_ACC0,
  /* 286 */  OCAML_SWITCH_2B, 83, 0, 0, 169, 0, 169, 0, 173, 0, 177, 0, 181, 0, 184, 0, 187, 0, 190, 0, 173, 0, 177, 0, 194, 0, 198, 0, 202, 0, 194, 0, 198, 0, 169, 0, 190, 0, 187, 0, 184, 0, 181, 0, 202, 0, 173, 0, 177, 0, 198, 0, 205, 0, 194, 0, 198, 0, 205, 0, 209, 0, 181, 0, 213, 0, 217, 0, 217, 0, 213, 0, 221, 0, 225, 0, 221, 0, 225, 0, 190, 0, 169, 0, 187, 0, 184, 0, 194, 0, 187, 0, 184, 0, 184, 0, 187, 0, 190, 0, 169, 0, 217, 0, 225, 0, 221, 0, 225, 0, 194, 0, 198, 0, 205, 0, 209, 0, 202, 0, 213, 0, 221, 0, 181, 0, 184, 0, 187, 0, 217, 0, 213, 0, 190, 0, 169, 0, 173, 0, 177, 0, 202, 0, 181, 0, 181, 0, 202, 0, 173, 0, 177, 0, 202, 0, 181, 0, 221, 0, 217, 0, 213, 0, 184, 0, 187, 0, 190,
  /* 455 */  OCAML_CONSTINT_1B, 5,
  /* 457 */  OCAML_RETURN, 1,
  /* 459 */  OCAML_CONSTINT_1B, 6,
  /* 461 */  OCAML_RETURN, 1,
  /* 463 */  OCAML_CONSTINT_1B, 7,
  /* 465 */  OCAML_RETURN, 1,
  /* 467 */  OCAML_CONST1,
  /* 468 */  OCAML_RETURN, 1,
  /* 470 */  OCAML_CONST2,
  /* 471 */  OCAML_RETURN, 1,
  /* 473 */  OCAML_CONST3,
  /* 474 */  OCAML_RETURN, 1,
  /* 476 */  OCAML_CONSTINT_1B, 4,
  /* 478 */  OCAML_RETURN, 1,
  /* 480 */  OCAML_CONSTINT_1B, 8,
  /* 482 */  OCAML_RETURN, 1,
  /* 484 */  OCAML_CONSTINT_1B, 9,
  /* 486 */  OCAML_RETURN, 1,
  /* 488 */  OCAML_CONST0,
  /* 489 */  OCAML_RETURN, 1,
  /* 491 */  OCAML_CONSTINT_1B, 10,
  /* 493 */  OCAML_RETURN, 1,
  /* 495 */  OCAML_CONSTINT_1B, 11,
  /* 497 */  OCAML_RETURN, 1,
  /* 499 */  OCAML_CONSTINT_1B, 13,
  /* 501 */  OCAML_RETURN, 1,
  /* 503 */  OCAML_CONSTINT_1B, 12,
  /* 505 */  OCAML_RETURN, 1,
  /* 507 */  OCAML_CONSTINT_1B, 14,
  /* 509 */  OCAML_RETURN, 1,
  /* 511 */  OCAML_CONSTINT_1B, 15,
  /* 513 */  OCAML_RETURN, 1,
  /* 515 */  OCAML_ACC0,
  /* 516 */  OCAML_BGTINT_1B, 4, 84,
  /* 519 */  OCAML_ACC0,
  /* 520 */  OCAML_BGTINT_1B, 12, 91,
  /* 523 */  OCAML_ACC0,
  /* 524 */  OCAML_OFFSETINT_1B, (opcode_t) -12,
  /* 526 */  OCAML_SWITCH_1B, 71, 0, 89, 81, 81, 93, 93, 93, 93, 93, 93, 93, 93, 89, 89, 93, 93, 93, 93, 89, 97, 97, 93, 93, 93, 93, 101, 101, 97, 97, 97, 97, 97, 77, 77, 89, 89, 89, 89, 85, 85, 89, 89, 101, 101, 101, 101, 101, 85, 85, 101, 101, 101, 101, 101, 101, 101, 101, 101, 97, 97, 77, 85, 89, 89, 81, 81, 77, 77, 77, 81, 81, 81,
  /* 600 */  OCAML_ACC0,
  /* 601 */  OCAML_BRANCHIF_1B, 6,
  /* 603 */  OCAML_CONSTINT_1B, 13,
  /* 605 */  OCAML_RETURN, 1,
  /* 607 */  OCAML_CONSTINT_1B, 11,
  /* 609 */  OCAML_RETURN, 1,
  /* 611 */  OCAML_CONSTINT_1B, 9,
  /* 613 */  OCAML_RETURN, 1,
  /* 615 */  OCAML_CONSTINT_1B, 7,
  /* 617 */  OCAML_RETURN, 1,
  /* 619 */  OCAML_CONSTINT_1B, 8,
  /* 621 */  OCAML_RETURN, 1,
  /* 623 */  OCAML_CONSTINT_1B, 12,
  /* 625 */  OCAML_RETURN, 1,
  /* 627 */  OCAML_CONSTINT_1B, 10,
  /* 629 */  OCAML_RETURN, 1,
  /* 631 */  OCAML_ACC0,
  /* 632 */  OCAML_BGTINT_1B, 4, 84,
  /* 635 */  OCAML_ACC0,
  /* 636 */  OCAML_BGTINT_1B, 12, 91,
  /* 639 */  OCAML_ACC0,
  /* 640 */  OCAML_OFFSETINT_1B, (opcode_t) -12,
  /* 642 */  OCAML_SWITCH_1B, 71, 0, 88, 81, 81, 91, 91, 91, 91, 91, 91, 91, 91, 88, 88, 91, 91, 91, 91, 88, 94, 94, 91, 91, 91, 91, 98, 98, 94, 94, 94, 94, 94, 77, 77, 88, 88, 88, 88, 85, 85, 88, 88, 98, 98, 98, 98, 98, 85, 85, 98, 98, 98, 98, 98, 98, 98, 98, 98, 94, 94, 77, 85, 88, 88, 81, 81, 77, 77, 77, 81, 81, 81,
  /* 716 */  OCAML_ACC0,
  /* 717 */  OCAML_BRANCHIF_1B, 6,
  /* 719 */  OCAML_CONSTINT_1B, 6,
  /* 721 */  OCAML_RETURN, 1,
  /* 723 */  OCAML_CONSTINT_1B, 4,
  /* 725 */  OCAML_RETURN, 1,
  /* 727 */  OCAML_CONST2,
  /* 728 */  OCAML_RETURN, 1,
  /* 730 */  OCAML_CONST0,
  /* 731 */  OCAML_RETURN, 1,
  /* 733 */  OCAML_CONST1,
  /* 734 */  OCAML_RETURN, 1,
  /* 736 */  OCAML_CONSTINT_1B, 5,
  /* 738 */  OCAML_RETURN, 1,
  /* 740 */  OCAML_CONST3,
  /* 741 */  OCAML_RETURN, 1,
  /* 743 */  OCAML_APPLY2,
  /* 744 */  OCAML_CONST1,
  /* 745 */  OCAML_PUSHCONSTINT_1B, 66,
  /* 747 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 749 */  OCAML_APPLY2,
  /* 750 */  OCAML_CONST0,
  /* 751 */  OCAML_PUSHCONSTINT_1B, 62,
  /* 753 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 755 */  OCAML_APPLY2,
  /* 756 */  OCAML_CONST0,
  /* 757 */  OCAML_PUSHCONSTINT_1B, 66,
  /* 759 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 761 */  OCAML_APPLY2,
  /* 762 */  OCAML_STOP
};

#include </home/adilla/Documents/VmMic/Tools/OMicroBPIC32/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_pic32_clear_bit,
  /*  1 */  (void *) &caml_pic32_set_bit,
};
