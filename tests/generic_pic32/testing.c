#define OCAML_STACK_WOSIZE               200
#define OCAML_STATIC_HEAP_WOSIZE           2
#define OCAML_DYNAMIC_HEAP_WOSIZE        198
#define OCAML_FLASH_HEAP_WOSIZE           55
#define OCAML_STACK_INITIAL_WOSIZE         4
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        7
#define OCAML_BYTECODE_BSIZE             797
#define OCAML_PRIMITIVE_NUMBER             3
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
#define OCAML_POP                         4
#define OCAML_APPLY1                      5
#define OCAML_APPLY2                      6
#define OCAML_RETURN                      7
#define OCAML_RESTART                     8
#define OCAML_GRAB                        9
#define OCAML_PUSHGETFLASHGLOBAL_1B      10
#define OCAML_PUSHGETFLASHGLOBALFIELD_1B  11
#define OCAML_BRANCH_1B                  12
#define OCAML_BRANCH_2B                  13
#define OCAML_BRANCHIF_1B                14
#define OCAML_BRANCHIFNOT_1B             15
#define OCAML_SWITCH_1B                  16
#define OCAML_SWITCH_2B                  17
#define OCAML_CHECK_SIGNALS              18
#define OCAML_C_CALL1                    19
#define OCAML_C_CALL2                    20
#define OCAML_CONST0                     21
#define OCAML_CONST1                     22
#define OCAML_CONST2                     23
#define OCAML_CONST3                     24
#define OCAML_CONSTINT_1B                25
#define OCAML_CONSTINT_2B                26
#define OCAML_OFFSETINT_1B               27
#define OCAML_BGTINT_1B                  28
#define OCAML_STOP                       29

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
  /* 42 */  Val_codeptr(35),
  /* 43 */  Make_header(1, Closure_tag, Color_white),
  /* 44 */  Val_codeptr(636),
  /* 45 */  Make_header(1, Closure_tag, Color_white),
  /* 46 */  Val_codeptr(290),
  /* 47 */  Make_header(1, Closure_tag, Color_white),
  /* 48 */  Val_codeptr(520),
  /* 49 */  Make_header(1, Closure_tag, Color_white),
  /* 50 */  Val_codeptr(60),
  /* 51 */  Make_header(1, Closure_tag, Color_white),
  /* 52 */  Val_codeptr(9),
  /* 53 */  Make_header(1, Closure_tag, Color_white),
  /* 54 */  Val_codeptr(3)
};

PROGMEM value const ocaml_initial_static_heap[OCAML_STATIC_HEAP_WOSIZE] = {
  /* 0 */  Make_header(1, 0, Color_white),
  /* 1 */  Val_flash_block(&ocaml_flash_heap[54])
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
  /* 0 */  Val_int(62),
  /* 1 */  Val_int(1),
  /* 2 */  Val_int(66),
  /* 3 */  Val_int(62)
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
  /*   0 */  OCAML_BRANCH_2B, 2, 236,
  /*   3 */  OCAML_ACC0,
  /*   4 */  OCAML_C_CALL1, 0,
  /*   6 */  OCAML_RETURN, 1,
  /*   8 */  OCAML_RESTART,
  /*   9 */  OCAML_GRAB, 1,
  /*  11 */  OCAML_ACC0,
  /*  12 */  OCAML_PUSHGETFLASHGLOBAL_1B, 0,
  /*  14 */  OCAML_APPLY1,
  /*  15 */  OCAML_PUSHACC1,
  /*  16 */  OCAML_PUSHGETFLASHGLOBAL_1B, 1,
  /*  18 */  OCAML_APPLY1,
  /*  19 */  OCAML_PUSHACC3,
  /*  20 */  OCAML_BRANCHIFNOT_1B, 8,
  /*  22 */  OCAML_ACC0,
  /*  23 */  OCAML_PUSHACC2,
  /*  24 */  OCAML_C_CALL2, 1,
  /*  26 */  OCAML_RETURN, 4,
  /*  28 */  OCAML_ACC0,
  /*  29 */  OCAML_PUSHACC2,
  /*  30 */  OCAML_C_CALL2, 2,
  /*  32 */  OCAML_RETURN, 4,
  /*  34 */  OCAML_RESTART,
  /*  35 */  OCAML_GRAB, 1,
  /*  37 */  OCAML_ACC0,
  /*  38 */  OCAML_PUSHGETFLASHGLOBAL_1B, 2,
  /*  40 */  OCAML_APPLY1,
  /*  41 */  OCAML_PUSHACC1,
  /*  42 */  OCAML_PUSHGETFLASHGLOBAL_1B, 3,
  /*  44 */  OCAML_APPLY1,
  /*  45 */  OCAML_PUSHACC3,
  /*  46 */  OCAML_BRANCHIFNOT_1B, 8,
  /*  48 */  OCAML_ACC0,
  /*  49 */  OCAML_PUSHACC2,
  /*  50 */  OCAML_C_CALL2, 1,
  /*  52 */  OCAML_RETURN, 4,
  /*  54 */  OCAML_ACC0,
  /*  55 */  OCAML_PUSHACC2,
  /*  56 */  OCAML_C_CALL2, 2,
  /*  58 */  OCAML_RETURN, 4,
  /*  60 */  OCAML_ACC0,
  /*  61 */  OCAML_SWITCH_2B, 83, 0, 0, 169, 0, 169, 0, 173, 0, 177, 0, 181, 0, 184, 0, 187, 0, 190, 0, 173, 0, 177, 0, 194, 0, 198, 0, 202, 0, 194, 0, 198, 0, 169, 0, 190, 0, 187, 0, 184, 0, 181, 0, 202, 0, 173, 0, 177, 0, 198, 0, 205, 0, 194, 0, 198, 0, 205, 0, 209, 0, 181, 0, 213, 0, 217, 0, 217, 0, 213, 0, 221, 0, 225, 0, 221, 0, 225, 0, 190, 0, 169, 0, 187, 0, 184, 0, 194, 0, 187, 0, 184, 0, 184, 0, 187, 0, 190, 0, 169, 0, 217, 0, 225, 0, 221, 0, 225, 0, 194, 0, 198, 0, 205, 0, 209, 0, 202, 0, 213, 0, 221, 0, 181, 0, 184, 0, 187, 0, 217, 0, 213, 0, 190, 0, 169, 0, 173, 0, 177, 0, 202, 0, 181, 0, 181, 0, 202, 0, 173, 0, 177, 0, 202, 0, 181, 0, 221, 0, 217, 0, 213, 0, 184, 0, 187, 0, 190,
  /* 230 */  OCAML_CONSTINT_1B, 5,
  /* 232 */  OCAML_RETURN, 1,
  /* 234 */  OCAML_CONSTINT_1B, 6,
  /* 236 */  OCAML_RETURN, 1,
  /* 238 */  OCAML_CONSTINT_1B, 7,
  /* 240 */  OCAML_RETURN, 1,
  /* 242 */  OCAML_CONST1,
  /* 243 */  OCAML_RETURN, 1,
  /* 245 */  OCAML_CONST2,
  /* 246 */  OCAML_RETURN, 1,
  /* 248 */  OCAML_CONST3,
  /* 249 */  OCAML_RETURN, 1,
  /* 251 */  OCAML_CONSTINT_1B, 4,
  /* 253 */  OCAML_RETURN, 1,
  /* 255 */  OCAML_CONSTINT_1B, 8,
  /* 257 */  OCAML_RETURN, 1,
  /* 259 */  OCAML_CONSTINT_1B, 9,
  /* 261 */  OCAML_RETURN, 1,
  /* 263 */  OCAML_CONST0,
  /* 264 */  OCAML_RETURN, 1,
  /* 266 */  OCAML_CONSTINT_1B, 10,
  /* 268 */  OCAML_RETURN, 1,
  /* 270 */  OCAML_CONSTINT_1B, 11,
  /* 272 */  OCAML_RETURN, 1,
  /* 274 */  OCAML_CONSTINT_1B, 13,
  /* 276 */  OCAML_RETURN, 1,
  /* 278 */  OCAML_CONSTINT_1B, 12,
  /* 280 */  OCAML_RETURN, 1,
  /* 282 */  OCAML_CONSTINT_1B, 14,
  /* 284 */  OCAML_RETURN, 1,
  /* 286 */  OCAML_CONSTINT_1B, 15,
  /* 288 */  OCAML_RETURN, 1,
  /* 290 */  OCAML_ACC0,
  /* 291 */  OCAML_SWITCH_2B, 83, 0, 0, 169, 0, 169, 0, 173, 0, 177, 0, 181, 0, 184, 0, 187, 0, 190, 0, 173, 0, 177, 0, 194, 0, 198, 0, 202, 0, 194, 0, 198, 0, 169, 0, 190, 0, 187, 0, 184, 0, 181, 0, 202, 0, 173, 0, 177, 0, 198, 0, 205, 0, 194, 0, 198, 0, 205, 0, 209, 0, 181, 0, 213, 0, 217, 0, 217, 0, 213, 0, 221, 0, 225, 0, 221, 0, 225, 0, 190, 0, 169, 0, 187, 0, 184, 0, 194, 0, 187, 0, 184, 0, 184, 0, 187, 0, 190, 0, 169, 0, 217, 0, 225, 0, 221, 0, 225, 0, 194, 0, 198, 0, 205, 0, 209, 0, 202, 0, 213, 0, 221, 0, 181, 0, 184, 0, 187, 0, 217, 0, 213, 0, 190, 0, 169, 0, 173, 0, 177, 0, 202, 0, 181, 0, 181, 0, 202, 0, 173, 0, 177, 0, 202, 0, 181, 0, 221, 0, 217, 0, 213, 0, 184, 0, 187, 0, 190,
  /* 460 */  OCAML_CONSTINT_1B, 5,
  /* 462 */  OCAML_RETURN, 1,
  /* 464 */  OCAML_CONSTINT_1B, 6,
  /* 466 */  OCAML_RETURN, 1,
  /* 468 */  OCAML_CONSTINT_1B, 7,
  /* 470 */  OCAML_RETURN, 1,
  /* 472 */  OCAML_CONST1,
  /* 473 */  OCAML_RETURN, 1,
  /* 475 */  OCAML_CONST2,
  /* 476 */  OCAML_RETURN, 1,
  /* 478 */  OCAML_CONST3,
  /* 479 */  OCAML_RETURN, 1,
  /* 481 */  OCAML_CONSTINT_1B, 4,
  /* 483 */  OCAML_RETURN, 1,
  /* 485 */  OCAML_CONSTINT_1B, 8,
  /* 487 */  OCAML_RETURN, 1,
  /* 489 */  OCAML_CONSTINT_1B, 9,
  /* 491 */  OCAML_RETURN, 1,
  /* 493 */  OCAML_CONST0,
  /* 494 */  OCAML_RETURN, 1,
  /* 496 */  OCAML_CONSTINT_1B, 10,
  /* 498 */  OCAML_RETURN, 1,
  /* 500 */  OCAML_CONSTINT_1B, 11,
  /* 502 */  OCAML_RETURN, 1,
  /* 504 */  OCAML_CONSTINT_1B, 13,
  /* 506 */  OCAML_RETURN, 1,
  /* 508 */  OCAML_CONSTINT_1B, 12,
  /* 510 */  OCAML_RETURN, 1,
  /* 512 */  OCAML_CONSTINT_1B, 14,
  /* 514 */  OCAML_RETURN, 1,
  /* 516 */  OCAML_CONSTINT_1B, 15,
  /* 518 */  OCAML_RETURN, 1,
  /* 520 */  OCAML_ACC0,
  /* 521 */  OCAML_BGTINT_1B, 4, 84,
  /* 524 */  OCAML_ACC0,
  /* 525 */  OCAML_BGTINT_1B, 12, 91,
  /* 528 */  OCAML_ACC0,
  /* 529 */  OCAML_OFFSETINT_1B, (opcode_t) -12,
  /* 531 */  OCAML_SWITCH_1B, 71, 0, 89, 81, 81, 93, 93, 93, 93, 93, 93, 93, 93, 89, 89, 93, 93, 93, 93, 89, 97, 97, 93, 93, 93, 93, 101, 101, 97, 97, 97, 97, 97, 77, 77, 89, 89, 89, 89, 85, 85, 89, 89, 101, 101, 101, 101, 101, 85, 85, 101, 101, 101, 101, 101, 101, 101, 101, 101, 97, 97, 77, 85, 89, 89, 81, 81, 77, 77, 77, 81, 81, 81,
  /* 605 */  OCAML_ACC0,
  /* 606 */  OCAML_BRANCHIF_1B, 6,
  /* 608 */  OCAML_CONSTINT_1B, 13,
  /* 610 */  OCAML_RETURN, 1,
  /* 612 */  OCAML_CONSTINT_1B, 11,
  /* 614 */  OCAML_RETURN, 1,
  /* 616 */  OCAML_CONSTINT_1B, 9,
  /* 618 */  OCAML_RETURN, 1,
  /* 620 */  OCAML_CONSTINT_1B, 7,
  /* 622 */  OCAML_RETURN, 1,
  /* 624 */  OCAML_CONSTINT_1B, 8,
  /* 626 */  OCAML_RETURN, 1,
  /* 628 */  OCAML_CONSTINT_1B, 12,
  /* 630 */  OCAML_RETURN, 1,
  /* 632 */  OCAML_CONSTINT_1B, 10,
  /* 634 */  OCAML_RETURN, 1,
  /* 636 */  OCAML_ACC0,
  /* 637 */  OCAML_BGTINT_1B, 4, 84,
  /* 640 */  OCAML_ACC0,
  /* 641 */  OCAML_BGTINT_1B, 12, 91,
  /* 644 */  OCAML_ACC0,
  /* 645 */  OCAML_OFFSETINT_1B, (opcode_t) -12,
  /* 647 */  OCAML_SWITCH_1B, 71, 0, 88, 81, 81, 91, 91, 91, 91, 91, 91, 91, 91, 88, 88, 91, 91, 91, 91, 88, 94, 94, 91, 91, 91, 91, 98, 98, 94, 94, 94, 94, 94, 77, 77, 88, 88, 88, 88, 85, 85, 88, 88, 98, 98, 98, 98, 98, 85, 85, 98, 98, 98, 98, 98, 98, 98, 98, 98, 94, 94, 77, 85, 88, 88, 81, 81, 77, 77, 77, 81, 81, 81,
  /* 721 */  OCAML_ACC0,
  /* 722 */  OCAML_BRANCHIF_1B, 6,
  /* 724 */  OCAML_CONSTINT_1B, 6,
  /* 726 */  OCAML_RETURN, 1,
  /* 728 */  OCAML_CONSTINT_1B, 4,
  /* 730 */  OCAML_RETURN, 1,
  /* 732 */  OCAML_CONST2,
  /* 733 */  OCAML_RETURN, 1,
  /* 735 */  OCAML_CONST0,
  /* 736 */  OCAML_RETURN, 1,
  /* 738 */  OCAML_CONST1,
  /* 739 */  OCAML_RETURN, 1,
  /* 741 */  OCAML_CONSTINT_1B, 5,
  /* 743 */  OCAML_RETURN, 1,
  /* 745 */  OCAML_CONST3,
  /* 746 */  OCAML_RETURN, 1,
  /* 748 */  OCAML_APPLY2,
  /* 749 */  OCAML_CONST1,
  /* 750 */  OCAML_PUSHACC1,
  /* 751 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 753 */  OCAML_APPLY2,
  /* 754 */  OCAML_BRANCH_1B, 37,
  /* 756 */  OCAML_CHECK_SIGNALS,
  /* 757 */  OCAML_CONST0,
  /* 758 */  OCAML_PUSHACC2,
  /* 759 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 761 */  OCAML_APPLY2,
  /* 762 */  OCAML_CONST0,
  /* 763 */  OCAML_PUSHACC1,
  /* 764 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 766 */  OCAML_APPLY2,
  /* 767 */  OCAML_CONSTINT_2B, 1, 44,
  /* 770 */  OCAML_PUSHGETFLASHGLOBALFIELD_1B, 6, 0,
  /* 773 */  OCAML_APPLY1,
  /* 774 */  OCAML_CONST1,
  /* 775 */  OCAML_PUSHACC2,
  /* 776 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 778 */  OCAML_APPLY2,
  /* 779 */  OCAML_CONST1,
  /* 780 */  OCAML_PUSHACC1,
  /* 781 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 783 */  OCAML_APPLY2,
  /* 784 */  OCAML_CONSTINT_2B, 1, 44,
  /* 787 */  OCAML_PUSHGETFLASHGLOBALFIELD_1B, 6, 0,
  /* 790 */  OCAML_APPLY1,
  /* 791 */  OCAML_CONST1,
  /* 792 */  OCAML_BRANCHIF_1B, (opcode_t) -36,
  /* 794 */  OCAML_POP, 2,
  /* 796 */  OCAML_STOP
};

#include </home/adilla/Documents/VmMic/Tools/OMicroBPIC32/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_delay,
  /*  1 */  (void *) &caml_clear_bit,
  /*  2 */  (void *) &caml_set_bit,
};
