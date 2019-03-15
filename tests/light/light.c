#define OCAML_STACK_WOSIZE               300
#define OCAML_STATIC_HEAP_WOSIZE          79
#define OCAML_DYNAMIC_HEAP_WOSIZE        721
#define OCAML_FLASH_HEAP_WOSIZE            0
#define OCAML_STACK_INITIAL_WOSIZE         0
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        7
#define OCAML_BYTECODE_BSIZE             193
#define OCAML_PRIMITIVE_NUMBER             7
#define OCAML_VIRTUAL_ARCH                16
#define OCAML_STARTING_OOID                1
#define OCAML_NO_FLASH_HEAP                1
#define OCAML_NO_FLASH_GLOBALS             0

#define OCAML_GC_MARK_AND_COMPACT

#include </home/steven/Development/OCaml/OMicroB/src/byterun/vm/values.h>

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
#define OCAML_BRANCH_2B                  20
#define OCAML_BRANCHIF_1B                21
#define OCAML_SWITCH_1B                  22
#define OCAML_CHECK_SIGNALS              23
#define OCAML_C_CALL1                    24
#define OCAML_CONST0                     25
#define OCAML_CONST1                     26
#define OCAML_CONST2                     27
#define OCAML_CONST3                     28
#define OCAML_CONSTINT_1B                29
#define OCAML_CONSTINT_2B                30
#define OCAML_NEQ                        31
#define OCAML_GTINT                      32
#define OCAML_OFFSETINT_1B               33
#define OCAML_STOP                       34

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
  /* 59 */  Val_codeptr(3),
  /* 60 */  Make_header(1, Closure_tag, Color_white),
  /* 61 */  Val_codeptr(54),
  /* 62 */  Make_header(1, Closure_tag, Color_white),
  /* 63 */  Val_codeptr(9),
  /* 64 */  Make_header(1, Closure_tag, Color_white),
  /* 65 */  Val_codeptr(72),
  /* 66 */  Make_header(1, Closure_tag, Color_white),
  /* 67 */  Val_codeptr(63),
  /* 68 */  Make_header(5, String_tag, Color_white),
  /* 69 */  Make_string_data('L', 'I'),
  /* 70 */  Make_string_data('G', 'H'),
  /* 71 */  Make_string_data('T', ' '),
  /* 72 */  Make_string_data('I', 'S'),
  /* 73 */  Make_string_data(' ', '\0'),
  /* 74 */  Make_header(2, 0, Color_white),
  /* 75 */  Val_static_block(&ocaml_ram_heap[61]),
  /* 76 */  Val_static_block(&ocaml_ram_heap[78]),
  /* 77 */  Make_header(1, Closure_tag, Color_white),
  /* 78 */  Val_codeptr(41)
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
  /* 0 */  Val_static_block(&ocaml_ram_heap[59]),
  /* 1 */  Val_static_block(&ocaml_ram_heap[61]),
  /* 2 */  Val_static_block(&ocaml_ram_heap[63]),
  /* 3 */  Val_static_block(&ocaml_ram_heap[65]),
  /* 4 */  Val_static_block(&ocaml_ram_heap[67]),
  /* 5 */  Val_static_block(&ocaml_ram_heap[69]),
  /* 6 */  Val_static_block(&ocaml_ram_heap[75])
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
  /*   0 */  OCAML_BRANCH_2B, 0, 154,
  /*   3 */  OCAML_ACC0,
  /*   4 */  OCAML_C_CALL1, 0,
  /*   6 */  OCAML_RETURN, 1,
  /*   8 */  OCAML_RESTART,
  /*   9 */  OCAML_GRAB, 1,
  /*  11 */  OCAML_CONST0,
  /*  12 */  OCAML_PUSHACC2,
  /*  13 */  OCAML_C_CALL1, 1,
  /*  15 */  OCAML_OFFSETINT_1B, (opcode_t) -1,
  /*  17 */  OCAML_PUSH,
  /*  18 */  OCAML_PUSHACC2,
  /*  19 */  OCAML_GTINT,
  /*  20 */  OCAML_BRANCHIF_1B, 18,
  /*  22 */  OCAML_CHECK_SIGNALS,
  /*  23 */  OCAML_ACC1,
  /*  24 */  OCAML_PUSHACC4,
  /*  25 */  OCAML_GETBYTESCHAR,
  /*  26 */  OCAML_PUSHACC3,
  /*  27 */  OCAML_APPLY1,
  /*  28 */  OCAML_ACC1,
  /*  29 */  OCAML_PUSH,
  /*  30 */  OCAML_OFFSETINT_1B, 1,
  /*  32 */  OCAML_ASSIGN, 2,
  /*  34 */  OCAML_ACC1,
  /*  35 */  OCAML_NEQ,
  /*  36 */  OCAML_BRANCHIF_1B, (opcode_t) -14,
  /*  38 */  OCAML_CONST0,
  /*  39 */  OCAML_RETURN, 4,
  /*  41 */  OCAML_ACC0,
  /*  42 */  OCAML_PUSHGETFLASHGLOBAL_1B, 0,
  /*  44 */  OCAML_APPLY1,
  /*  45 */  OCAML_PUSHGETFLASHGLOBAL_1B, 1,
  /*  47 */  OCAML_APPTERM1, 2,
  /*  49 */  OCAML_ACC0,
  /*  50 */  OCAML_C_CALL1, 2,
  /*  52 */  OCAML_RETURN, 1,
  /*  54 */  OCAML_ACC0,
  /*  55 */  OCAML_PUSH,
  /*  56 */  OCAML_CLOSURE_1B, 0, (opcode_t) -7,
  /*  59 */  OCAML_PUSHGETFLASHGLOBAL_1B, 2,
  /*  61 */  OCAML_APPTERM2, 3,
  /*  63 */  OCAML_ACC0,
  /*  64 */  OCAML_PUSHGETFLASHGLOBAL_1B, 3,
  /*  66 */  OCAML_APPLY1,
  /*  67 */  OCAML_PUSH,
  /*  68 */  OCAML_C_CALL1, 3,
  /*  70 */  OCAML_RETURN, 2,
  /*  72 */  OCAML_ACC0,
  /*  73 */  OCAML_OFFSETINT_1B, (opcode_t) -54,
  /*  75 */  OCAML_SWITCH_1B, 16, 0, 19, 22, 25, 28, 31, 35, 39, 43, 47, 51, 55, 59, 63, 67, 71, 75,
  /*  94 */  OCAML_CONST0,
  /*  95 */  OCAML_RETURN, 1,
  /*  97 */  OCAML_CONST1,
  /*  98 */  OCAML_RETURN, 1,
  /* 100 */  OCAML_CONST2,
  /* 101 */  OCAML_RETURN, 1,
  /* 103 */  OCAML_CONST3,
  /* 104 */  OCAML_RETURN, 1,
  /* 106 */  OCAML_CONSTINT_1B, 4,
  /* 108 */  OCAML_RETURN, 1,
  /* 110 */  OCAML_CONSTINT_1B, 5,
  /* 112 */  OCAML_RETURN, 1,
  /* 114 */  OCAML_CONSTINT_1B, 6,
  /* 116 */  OCAML_RETURN, 1,
  /* 118 */  OCAML_CONSTINT_1B, 7,
  /* 120 */  OCAML_RETURN, 1,
  /* 122 */  OCAML_CONSTINT_1B, 8,
  /* 124 */  OCAML_RETURN, 1,
  /* 126 */  OCAML_CONSTINT_1B, 9,
  /* 128 */  OCAML_RETURN, 1,
  /* 130 */  OCAML_CONSTINT_1B, 10,
  /* 132 */  OCAML_RETURN, 1,
  /* 134 */  OCAML_CONSTINT_1B, 11,
  /* 136 */  OCAML_RETURN, 1,
  /* 138 */  OCAML_CONSTINT_1B, 12,
  /* 140 */  OCAML_RETURN, 1,
  /* 142 */  OCAML_CONSTINT_1B, 13,
  /* 144 */  OCAML_RETURN, 1,
  /* 146 */  OCAML_CONSTINT_1B, 14,
  /* 148 */  OCAML_RETURN, 1,
  /* 150 */  OCAML_CONSTINT_1B, 15,
  /* 152 */  OCAML_RETURN, 1,
  /* 154 */  OCAML_C_CALL1, 4,
  /* 156 */  OCAML_CONST0,
  /* 157 */  OCAML_C_CALL1, 5,
  /* 159 */  OCAML_BRANCH_1B, 30,
  /* 161 */  OCAML_CHECK_SIGNALS,
  /* 162 */  OCAML_CONSTINT_1B, 54,
  /* 164 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 166 */  OCAML_APPLY1,
  /* 167 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 169 */  OCAML_PUSHGETFLASHGLOBAL_1B, 6,
  /* 171 */  OCAML_GETFIELD0,
  /* 172 */  OCAML_APPLY1,
  /* 173 */  OCAML_ACC0,
  /* 174 */  OCAML_PUSHGETFLASHGLOBAL_1B, 6,
  /* 176 */  OCAML_GETFIELD1,
  /* 177 */  OCAML_APPLY1,
  /* 178 */  OCAML_CONSTINT_1B, 10,
  /* 180 */  OCAML_C_CALL1, 2,
  /* 182 */  OCAML_CONSTINT_2B, 7, 208,
  /* 185 */  OCAML_C_CALL1, 6,
  /* 187 */  OCAML_POP, 1,
  /* 189 */  OCAML_CONST1,
  /* 190 */  OCAML_BRANCHIF_1B, (opcode_t) -29,
  /* 192 */  OCAML_STOP
};

#include </home/steven/Development/OCaml/OMicroB/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_string_of_int,
  /*  1 */  (void *) &caml_ml_string_length,
  /*  2 */  (void *) &caml_avr_serial_write,
  /*  3 */  (void *) &caml_avr_analog_read,
  /*  4 */  (void *) &caml_avr_serial_init,
  /*  5 */  (void *) &caml_avr_adc_init,
  /*  6 */  (void *) &caml_avr_delay,
};
