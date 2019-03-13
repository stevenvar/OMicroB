#define OCAML_STACK_WOSIZE               300
#define OCAML_STATIC_HEAP_WOSIZE          75
#define OCAML_DYNAMIC_HEAP_WOSIZE        725
#define OCAML_FLASH_HEAP_WOSIZE            0
#define OCAML_STACK_INITIAL_WOSIZE         0
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        5
#define OCAML_BYTECODE_BSIZE              99
#define OCAML_PRIMITIVE_NUMBER             7
#define OCAML_VIRTUAL_ARCH                16
#define OCAML_STARTING_OOID                1
#define OCAML_NO_FLASH_HEAP                1
#define OCAML_NO_FLASH_GLOBALS             0

#define OCAML_GC_MARK_AND_COMPACT

#include </Users/steven/Travail/github/OMicroB/src/byterun/vm/values.h>

#define OCAML_ACC0                        0
#define OCAML_ACC1                        1
#define OCAML_PUSH                        2
#define OCAML_PUSHACC2                    3
#define OCAML_PUSHACC3                    4
#define OCAML_PUSHACC4                    5
#define OCAML_POP                         6
#define OCAML_ASSIGN                      7
#define OCAML_APPLY1                      8
#define OCAML_APPTERM1                    9
#define OCAML_APPTERM2                   10
#define OCAML_RETURN                     11
#define OCAML_RESTART                    12
#define OCAML_GRAB                       13
#define OCAML_CLOSURE_1B                 14
#define OCAML_PUSHGETFLASHGLOBAL_1B      15
#define OCAML_GETFIELD0                  16
#define OCAML_GETFIELD1                  17
#define OCAML_GETBYTESCHAR               18
#define OCAML_BRANCH_1B                  19
#define OCAML_BRANCHIF_1B                20
#define OCAML_CHECK_SIGNALS              21
#define OCAML_C_CALL1                    22
#define OCAML_CONST0                     23
#define OCAML_CONST1                     24
#define OCAML_CONSTINT_1B                25
#define OCAML_CONSTINT_2B                26
#define OCAML_NEQ                        27
#define OCAML_GTINT                      28
#define OCAML_OFFSETINT_1B               29
#define OCAML_STOP                       30

value ocaml_stack[OCAML_STACK_WOSIZE];
value ocaml_ram_heap[OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE];
value ocaml_ram_global_data[OCAML_RAM_GLOBDATA_NUMBER];

PROGMEM value const ocaml_flash_heap[OCAML_FLASH_HEAP_WOSIZE] = {
};

PROGMEM value const ocaml_initial_static_heap[OCAML_STATIC_HEAP_WOSIZE] = {
  /*  0 */  Make_header(0, 0, Color_white),
  /*  1 */  Make_header(2, Object_tag, Color_white),
  /*  2 */  Val_static_block(&ocaml_ram_heap[5]),
  /*  3 */  Val_int(-1),
  /*  4 */  Make_header(7, String_tag, Color_white),
  /*  5 */  Make_string_data('O', 'u'),
  /*  6 */  Make_string_data('t', '_'),
  /*  7 */  Make_string_data('o', 'f'),
  /*  8 */  Make_string_data('_', 'm'),
  /*  9 */  Make_string_data('e', 'm'),
  /* 10 */  Make_string_data('o', 'r'),
  /* 11 */  Make_string_data('y', '\0'),
  /* 12 */  Make_header(2, Object_tag, Color_white),
  /* 13 */  Val_static_block(&ocaml_ram_heap[16]),
  /* 14 */  Val_int(-3),
  /* 15 */  Make_header(4, String_tag, Color_white),
  /* 16 */  Make_string_data('F', 'a'),
  /* 17 */  Make_string_data('i', 'l'),
  /* 18 */  Make_string_data('u', 'r'),
  /* 19 */  Make_string_data('e', '\0'),
  /* 20 */  Make_header(2, Object_tag, Color_white),
  /* 21 */  Val_static_block(&ocaml_ram_heap[24]),
  /* 22 */  Val_int(-4),
  /* 23 */  Make_header(9, String_tag, Color_white),
  /* 24 */  Make_string_data('I', 'n'),
  /* 25 */  Make_string_data('v', 'a'),
  /* 26 */  Make_string_data('l', 'i'),
  /* 27 */  Make_string_data('d', '_'),
  /* 28 */  Make_string_data('a', 'r'),
  /* 29 */  Make_string_data('g', 'u'),
  /* 30 */  Make_string_data('m', 'e'),
  /* 31 */  Make_string_data('n', 't'),
  /* 32 */  Make_string_data('\0', '\1'),
  /* 33 */  Make_header(2, Object_tag, Color_white),
  /* 34 */  Val_static_block(&ocaml_ram_heap[37]),
  /* 35 */  Val_int(-6),
  /* 36 */  Make_header(9, String_tag, Color_white),
  /* 37 */  Make_string_data('D', 'i'),
  /* 38 */  Make_string_data('v', 'i'),
  /* 39 */  Make_string_data('s', 'i'),
  /* 40 */  Make_string_data('o', 'n'),
  /* 41 */  Make_string_data('_', 'b'),
  /* 42 */  Make_string_data('y', '_'),
  /* 43 */  Make_string_data('z', 'e'),
  /* 44 */  Make_string_data('r', 'o'),
  /* 45 */  Make_string_data('\0', '\1'),
  /* 46 */  Make_header(2, Object_tag, Color_white),
  /* 47 */  Val_static_block(&ocaml_ram_heap[50]),
  /* 48 */  Val_int(-9),
  /* 49 */  Make_header(8, String_tag, Color_white),
  /* 50 */  Make_string_data('S', 't'),
  /* 51 */  Make_string_data('a', 'c'),
  /* 52 */  Make_string_data('k', '_'),
  /* 53 */  Make_string_data('o', 'v'),
  /* 54 */  Make_string_data('e', 'r'),
  /* 55 */  Make_string_data('f', 'l'),
  /* 56 */  Make_string_data('o', 'w'),
  /* 57 */  Make_string_data('\0', '\1'),
  /* 58 */  Make_header(1, Closure_tag, Color_white),
  /* 59 */  Val_codeptr(2),
  /* 60 */  Make_header(1, Closure_tag, Color_white),
  /* 61 */  Val_codeptr(53),
  /* 62 */  Make_header(1, Closure_tag, Color_white),
  /* 63 */  Val_codeptr(8),
  /* 64 */  Make_header(5, String_tag, Color_white),
  /* 65 */  Make_string_data('L', 'I'),
  /* 66 */  Make_string_data('G', 'H'),
  /* 67 */  Make_string_data('T', ' '),
  /* 68 */  Make_string_data('I', 'S'),
  /* 69 */  Make_string_data(' ', '\0'),
  /* 70 */  Make_header(2, 0, Color_white),
  /* 71 */  Val_static_block(&ocaml_ram_heap[61]),
  /* 72 */  Val_static_block(&ocaml_ram_heap[74]),
  /* 73 */  Make_header(1, Closure_tag, Color_white),
  /* 74 */  Val_codeptr(40)
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
  /* 0 */  Val_static_block(&ocaml_ram_heap[59]),
  /* 1 */  Val_static_block(&ocaml_ram_heap[61]),
  /* 2 */  Val_static_block(&ocaml_ram_heap[63]),
  /* 3 */  Val_static_block(&ocaml_ram_heap[65]),
  /* 4 */  Val_static_block(&ocaml_ram_heap[71])
};

value acc = Val_unit;
value env = Val_unit;

#define OCAML_Out_of_memory        Val_static_block(&ocaml_ram_heap[2])
#define OCAML_Failure              Val_static_block(&ocaml_ram_heap[13])
#define OCAML_Invalid_argument     Val_static_block(&ocaml_ram_heap[21])
#define OCAML_Division_by_zero     Val_static_block(&ocaml_ram_heap[34])
#define OCAML_Stack_overflow       Val_static_block(&ocaml_ram_heap[47])

#define OCAML_atom0                Val_static_block(&ocaml_ram_heap[1])

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*  0 */  OCAML_BRANCH_1B, 62,
  /*  2 */  OCAML_ACC0,
  /*  3 */  OCAML_C_CALL1, 0,
  /*  5 */  OCAML_RETURN, 1,
  /*  7 */  OCAML_RESTART,
  /*  8 */  OCAML_GRAB, 1,
  /* 10 */  OCAML_CONST0,
  /* 11 */  OCAML_PUSHACC2,
  /* 12 */  OCAML_C_CALL1, 1,
  /* 14 */  OCAML_OFFSETINT_1B, (opcode_t) -1,
  /* 16 */  OCAML_PUSH,
  /* 17 */  OCAML_PUSHACC2,
  /* 18 */  OCAML_GTINT,
  /* 19 */  OCAML_BRANCHIF_1B, 18,
  /* 21 */  OCAML_CHECK_SIGNALS,
  /* 22 */  OCAML_ACC1,
  /* 23 */  OCAML_PUSHACC4,
  /* 24 */  OCAML_GETBYTESCHAR,
  /* 25 */  OCAML_PUSHACC3,
  /* 26 */  OCAML_APPLY1,
  /* 27 */  OCAML_ACC1,
  /* 28 */  OCAML_PUSH,
  /* 29 */  OCAML_OFFSETINT_1B, 1,
  /* 31 */  OCAML_ASSIGN, 2,
  /* 33 */  OCAML_ACC1,
  /* 34 */  OCAML_NEQ,
  /* 35 */  OCAML_BRANCHIF_1B, (opcode_t) -14,
  /* 37 */  OCAML_CONST0,
  /* 38 */  OCAML_RETURN, 4,
  /* 40 */  OCAML_ACC0,
  /* 41 */  OCAML_PUSHGETFLASHGLOBAL_1B, 0,
  /* 43 */  OCAML_APPLY1,
  /* 44 */  OCAML_PUSHGETFLASHGLOBAL_1B, 1,
  /* 46 */  OCAML_APPTERM1, 2,
  /* 48 */  OCAML_ACC0,
  /* 49 */  OCAML_C_CALL1, 2,
  /* 51 */  OCAML_RETURN, 1,
  /* 53 */  OCAML_ACC0,
  /* 54 */  OCAML_PUSH,
  /* 55 */  OCAML_CLOSURE_1B, 0, (opcode_t) -7,
  /* 58 */  OCAML_PUSHGETFLASHGLOBAL_1B, 2,
  /* 60 */  OCAML_APPTERM2, 3,
  /* 62 */  OCAML_C_CALL1, 3,
  /* 64 */  OCAML_CONST0,
  /* 65 */  OCAML_C_CALL1, 4,
  /* 67 */  OCAML_BRANCH_1B, 28,
  /* 69 */  OCAML_CHECK_SIGNALS,
  /* 70 */  OCAML_CONST0,
  /* 71 */  OCAML_C_CALL1, 5,
  /* 73 */  OCAML_PUSHGETFLASHGLOBAL_1B, 3,
  /* 75 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 77 */  OCAML_GETFIELD0,
  /* 78 */  OCAML_APPLY1,
  /* 79 */  OCAML_ACC0,
  /* 80 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 82 */  OCAML_GETFIELD1,
  /* 83 */  OCAML_APPLY1,
  /* 84 */  OCAML_CONSTINT_1B, 10,
  /* 86 */  OCAML_C_CALL1, 2,
  /* 88 */  OCAML_CONSTINT_2B, 3, 232,
  /* 91 */  OCAML_C_CALL1, 6,
  /* 93 */  OCAML_POP, 1,
  /* 95 */  OCAML_CONST1,
  /* 96 */  OCAML_BRANCHIF_1B, (opcode_t) -27,
  /* 98 */  OCAML_STOP
};

#include </Users/steven/Travail/github/OMicroB/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_string_of_int,
  /*  1 */  (void *) &caml_ml_string_length,
  /*  2 */  (void *) &caml_avr_serial_write,
  /*  3 */  (void *) &caml_avr_serial_init,
  /*  4 */  (void *) &caml_avr_adc_init,
  /*  5 */  (void *) &caml_avr_analog_read,
  /*  6 */  (void *) &caml_avr_delay,
};
