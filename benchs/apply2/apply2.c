#define OCAML_STACK_WOSIZE                64
#define OCAML_STATIC_HEAP_WOSIZE           6
#define OCAML_DYNAMIC_HEAP_WOSIZE        250
#define OCAML_FLASH_HEAP_WOSIZE           67
#define OCAML_STACK_INITIAL_WOSIZE         1
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        9
#define OCAML_BYTECODE_BSIZE             164
#define OCAML_PRIMITIVE_NUMBER             6
#define OCAML_VIRTUAL_ARCH                32
#define OCAML_STARTING_OOID                4
#define OCAML_NO_FLASH_HEAP                0
#define OCAML_NO_FLASH_GLOBALS             0

#define OCAML_GC_MARK_AND_COMPACT

#include </home/basile/Programming/ocaml/OMicroB/OMicroB/src/byterun/vm/values.h>

#define OCAML_ACC0                        0
#define OCAML_ACC1                        1
#define OCAML_PUSH                        2
#define OCAML_PUSHACC1                    3
#define OCAML_PUSHACC2                    4
#define OCAML_PUSHACC3                    5
#define OCAML_PUSHACC4                    6
#define OCAML_POP                         7
#define OCAML_ASSIGN                      8
#define OCAML_APPLY1                      9
#define OCAML_APPLY2                     10
#define OCAML_APPTERM1                   11
#define OCAML_APPTERM2                   12
#define OCAML_RETURN                     13
#define OCAML_RESTART                    14
#define OCAML_GRAB                       15
#define OCAML_CLOSURE_1B                 16
#define OCAML_PUSHOFFSETCLOSURE0         17
#define OCAML_PUSHGETFLASHGLOBAL_1B      18
#define OCAML_PUSHGETFLASHGLOBALFIELD_1B  19
#define OCAML_GETBYTESCHAR               20
#define OCAML_BRANCH_2B                  21
#define OCAML_BRANCHIF_1B                22
#define OCAML_CHECK_SIGNALS              23
#define OCAML_C_CALL1                    24
#define OCAML_CONST0                     25
#define OCAML_PUSHCONST0                 26
#define OCAML_PUSHCONSTINT_4B            27
#define OCAML_ADDINT                     28
#define OCAML_SUBINT                     29
#define OCAML_NEQ                        30
#define OCAML_GTINT                      31
#define OCAML_OFFSETINT_1B               32
#define OCAML_BLTINT_1B                  33
#define OCAML_STOP                       34

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
  /* 42 */  Val_codeptr(110),
  /* 43 */  Make_header(1, Closure_tag, Color_white),
  /* 44 */  Val_codeptr(3),
  /* 45 */  Make_header(1, Closure_tag, Color_white),
  /* 46 */  Val_codeptr(74),
  /* 47 */  Make_header(1, Closure_tag, Color_white),
  /* 48 */  Val_codeptr(9),
  /* 49 */  Make_header(1, Closure_tag, Color_white),
  /* 50 */  Val_codeptr(139),
  /* 51 */  Make_header(1, Closure_tag, Color_white),
  /* 52 */  Val_codeptr(144),
  /* 53 */  Make_header(1, Closure_tag, Color_white),
  /* 54 */  Val_codeptr(152),
  /* 55 */  Make_header(1, Closure_tag, Color_white),
  /* 56 */  Val_codeptr(41),
  /* 57 */  Make_header(1, Closure_tag, Color_white),
  /* 58 */  Val_codeptr(84),
  /* 59 */  Make_header(1, Closure_tag, Color_white),
  /* 60 */  Val_codeptr(46),
  /* 61 */  Make_header(1, Closure_tag, Color_white),
  /* 62 */  Val_codeptr(51),
  /* 63 */  Make_header(1, Closure_tag, Color_white),
  /* 64 */  Val_codeptr(56),
  /* 65 */  Make_header(1, Closure_tag, Color_white),
  /* 66 */  Val_codeptr(61)
};

PROGMEM value const ocaml_initial_static_heap[OCAML_STATIC_HEAP_WOSIZE] = {
  /* 0 */  Make_header(5, 0, Color_white),
  /* 1 */  Val_flash_block(&ocaml_flash_heap[60]),
  /* 2 */  Val_flash_block(&ocaml_flash_heap[62]),
  /* 3 */  Val_flash_block(&ocaml_flash_heap[64]),
  /* 4 */  Val_flash_block(&ocaml_flash_heap[46]),
  /* 5 */  Val_flash_block(&ocaml_flash_heap[66])
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
  /* 0 */  Val_unit
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
  /* 0 */  Val_flash_block(&ocaml_flash_heap[44]),
  /* 1 */  Val_flash_block(&ocaml_flash_heap[46]),
  /* 2 */  Val_flash_block(&ocaml_flash_heap[48]),
  /* 3 */  Val_flash_block(&ocaml_flash_heap[50]),
  /* 4 */  Val_flash_block(&ocaml_flash_heap[52]),
  /* 5 */  Val_flash_block(&ocaml_flash_heap[54]),
  /* 6 */  Val_flash_block(&ocaml_flash_heap[56]),
  /* 7 */  Val_flash_block(&ocaml_flash_heap[58]),
  /* 8 */  Val_static_block(&ocaml_ram_heap[1])
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
  /*   0 */  OCAML_BRANCH_2B, 0, 160,
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
  /*  42 */  OCAML_C_CALL1, 2,
  /*  44 */  OCAML_RETURN, 1,
  /*  46 */  OCAML_ACC0,
  /*  47 */  OCAML_C_CALL1, 3,
  /*  49 */  OCAML_RETURN, 1,
  /*  51 */  OCAML_ACC0,
  /*  52 */  OCAML_C_CALL1, 4,
  /*  54 */  OCAML_RETURN, 1,
  /*  56 */  OCAML_ACC0,
  /*  57 */  OCAML_C_CALL1, 5,
  /*  59 */  OCAML_RETURN, 1,
  /*  61 */  OCAML_ACC0,
  /*  62 */  OCAML_PUSHGETFLASHGLOBAL_1B, 0,
  /*  64 */  OCAML_APPLY1,
  /*  65 */  OCAML_PUSHGETFLASHGLOBAL_1B, 1,
  /*  67 */  OCAML_APPTERM1, 2,
  /*  69 */  OCAML_ACC0,
  /*  70 */  OCAML_C_CALL1, 5,
  /*  72 */  OCAML_RETURN, 1,
  /*  74 */  OCAML_ACC0,
  /*  75 */  OCAML_PUSH,
  /*  76 */  OCAML_CLOSURE_1B, 0, (opcode_t) -7,
  /*  79 */  OCAML_PUSHGETFLASHGLOBAL_1B, 2,
  /*  81 */  OCAML_APPTERM2, 3,
  /*  83 */  OCAML_RESTART,
  /*  84 */  OCAML_GRAB, 1,
  /*  86 */  OCAML_ACC1,
  /*  87 */  OCAML_BLTINT_1B, 0, 6,
  /*  90 */  OCAML_ACC0,
  /*  91 */  OCAML_RETURN, 2,
  /*  93 */  OCAML_ACC1,
  /*  94 */  OCAML_OFFSETINT_1B, (opcode_t) -1,
  /*  96 */  OCAML_PUSHACC2,
  /*  97 */  OCAML_PUSHGETFLASHGLOBAL_1B, 3,
  /*  99 */  OCAML_PUSHGETFLASHGLOBAL_1B, 4,
  /* 101 */  OCAML_APPLY1,
  /* 102 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 104 */  OCAML_APPLY2,
  /* 105 */  OCAML_PUSHACC2,
  /* 106 */  OCAML_ADDINT,
  /* 107 */  OCAML_PUSHOFFSETCLOSURE0,
  /* 108 */  OCAML_APPTERM2, 4,
  /* 110 */  OCAML_CONST0,
  /* 111 */  OCAML_PUSHGETFLASHGLOBAL_1B, 6,
  /* 113 */  OCAML_APPLY1,
  /* 114 */  OCAML_PUSHCONSTINT_4B, 0, 15, 66, 64,
  /* 119 */  OCAML_PUSHCONST0,
  /* 120 */  OCAML_PUSHGETFLASHGLOBAL_1B, 7,
  /* 122 */  OCAML_APPLY2,
  /* 123 */  OCAML_CONST0,
  /* 124 */  OCAML_CONST0,
  /* 125 */  OCAML_PUSHGETFLASHGLOBAL_1B, 6,
  /* 127 */  OCAML_APPLY1,
  /* 128 */  OCAML_PUSHACC1,
  /* 129 */  OCAML_PUSHACC1,
  /* 130 */  OCAML_SUBINT,
  /* 131 */  OCAML_PUSHGETFLASHGLOBAL_1B, 0,
  /* 133 */  OCAML_APPLY1,
  /* 134 */  OCAML_PUSHGETFLASHGLOBALFIELD_1B, 8, 3,
  /* 137 */  OCAML_APPTERM1, 4,
  /* 139 */  OCAML_ACC0,
  /* 140 */  OCAML_OFFSETINT_1B, 1,
  /* 142 */  OCAML_RETURN, 1,
  /* 144 */  OCAML_ACC0,
  /* 145 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 147 */  OCAML_PUSHGETFLASHGLOBAL_1B, 5,
  /* 149 */  OCAML_APPTERM2, 3,
  /* 151 */  OCAML_RESTART,
  /* 152 */  OCAML_GRAB, 1,
  /* 154 */  OCAML_ACC1,
  /* 155 */  OCAML_PUSHACC1,
  /* 156 */  OCAML_APPLY1,
  /* 157 */  OCAML_PUSHACC1,
  /* 158 */  OCAML_APPTERM1, 3,
  /* 160 */  OCAML_APPLY1,
  /* 161 */  OCAML_POP, 2,
  /* 163 */  OCAML_STOP
};

#include </home/basile/Programming/ocaml/OMicroB/OMicroB/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_string_of_int,
  /*  1 */  (void *) &caml_ml_string_length,
  /*  2 */  (void *) &caml_millis,
  /*  3 */  (void *) &caml_avr_serial_init,
  /*  4 */  (void *) &caml_avr_serial_read,
  /*  5 */  (void *) &caml_avr_serial_write,
};
