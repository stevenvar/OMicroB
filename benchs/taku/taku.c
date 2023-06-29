#define OCAML_STACK_WOSIZE            100000
#define OCAML_STATIC_HEAP_WOSIZE         108
#define OCAML_DYNAMIC_HEAP_WOSIZE        892
#define OCAML_FLASH_HEAP_WOSIZE            0
#define OCAML_STACK_INITIAL_WOSIZE         0
#define OCAML_RAM_GLOBDATA_NUMBER         15
#define OCAML_FLASH_GLOBDATA_NUMBER        0
#define OCAML_BYTECODE_BSIZE             105
#define OCAML_PRIMITIVE_NUMBER             0
#define OCAML_VIRTUAL_ARCH                32
#define OCAML_STARTING_OOID                0
#define OCAML_NO_FLASH_HEAP                1
#define OCAML_NO_FLASH_GLOBALS             1

#define OCAML_GC_MARK_AND_COMPACT

#include </home/benoit/info/ocaml/omicrob/src/byterun/vm/values.h>

#define OCAML_ACC0                        0
#define OCAML_ACC1                        1
#define OCAML_ACC2                        2
#define OCAML_PUSHACC1                    3
#define OCAML_PUSHACC2                    4
#define OCAML_PUSHACC4                    5
#define OCAML_POP                         6
#define OCAML_APPLY1                      7
#define OCAML_APPLY2                      8
#define OCAML_APPTERM1                    9
#define OCAML_APPTERM2                   10
#define OCAML_RETURN                     11
#define OCAML_RESTART                    12
#define OCAML_GRAB                       13
#define OCAML_CLOSUREREC_1B              14
#define OCAML_PUSHOFFSETCLOSURE0         15
#define OCAML_GETRAMGLOBAL_1B            16
#define OCAML_PUSHGETRAMGLOBAL_1B        17
#define OCAML_SETRAMGLOBAL_1B            18
#define OCAML_MAKEBLOCK2                 19
#define OCAML_MAKEBLOCK3                 20
#define OCAML_GETFIELD0                  21
#define OCAML_GETFIELD1                  22
#define OCAML_GETFIELD2                  23
#define OCAML_BRANCH_1B                  24
#define OCAML_BRANCHIFNOT_1B             25
#define OCAML_RAISE                      26
#define OCAML_CONST0                     27
#define OCAML_PUSHCONSTINT_2B            28
#define OCAML_ADDINT                     29
#define OCAML_GTINT                      30
#define OCAML_OFFSETINT_1B               31
#define OCAML_BNEQ_2B                    32
#define OCAML_BLTINT_1B                  33
#define OCAML_STOP                       34

PROGMEM value const ocaml_flash_heap[OCAML_FLASH_HEAP_WOSIZE] = {
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
};

struct {
  value ocaml_ram_heap[OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE];
  value ocaml_stack[OCAML_STACK_WOSIZE];
  value ocaml_ram_global_data[OCAML_RAM_GLOBDATA_NUMBER] = {
  /*  0 */  Val_static_block(&ocaml_ram_heap[2]),
  /*  1 */  Val_static_block(&ocaml_ram_heap[42]),
  /*  2 */  Val_static_block(&ocaml_ram_heap[10]),
  /*  3 */  Val_static_block(&ocaml_ram_heap[16]),
  /*  4 */  Val_static_block(&ocaml_ram_heap[49]),
  /*  5 */  Val_static_block(&ocaml_ram_heap[25]),
  /*  6 */  Val_static_block(&ocaml_ram_heap[56]),
  /*  7 */  Val_static_block(&ocaml_ram_heap[63]),
  /*  8 */  Val_static_block(&ocaml_ram_heap[34]),
  /*  9 */  Val_static_block(&ocaml_ram_heap[71]),
  /* 10 */  Val_static_block(&ocaml_ram_heap[79]),
  /* 11 */  Val_static_block(&ocaml_ram_heap[87]),
  /* 12 */  Val_static_block(&ocaml_ram_heap[98]),
  /* 13 */  Val_unit,
  /* 14 */  Val_static_block(&ocaml_ram_heap[102])
};
  value acc = Val_unit;
  value env = Val_unit;
} ocaml_ram;

#define ocaml_stack ocaml_ram.ocaml_stack
#define ocaml_ram_heap ocaml_ram.ocaml_ram_heap
#define ocaml_ram_global_data ocaml_ram.ocaml_ram_global_data
#define acc ocaml_ram.acc
#define env ocaml_ram.env

PROGMEM value const ocaml_initial_static_heap[OCAML_STATIC_HEAP_WOSIZE] = {
  /*   0 */  Make_header(0, 0, Color_white),
  /*   1 */  Make_header(2, Object_tag, Color_white),
  /*   2 */  Val_static_block(&ocaml_ram_heap[5]),
  /*   3 */  Val_int(-1),
  /*   4 */  Make_header(4, String_tag, Color_white),
  /*   5 */  Make_string_data('O', 'u', 't', '_'),
  /*   6 */  Make_string_data('o', 'f', '_', 'm'),
  /*   7 */  Make_string_data('e', 'm', 'o', 'r'),
  /*   8 */  Make_string_data('y', '\0', '\0', '\2'),
  /*   9 */  Make_header(2, Object_tag, Color_white),
  /*  10 */  Val_static_block(&ocaml_ram_heap[13]),
  /*  11 */  Val_int(-3),
  /*  12 */  Make_header(2, String_tag, Color_white),
  /*  13 */  Make_string_data('F', 'a', 'i', 'l'),
  /*  14 */  Make_string_data('u', 'r', 'e', '\0'),
  /*  15 */  Make_header(2, Object_tag, Color_white),
  /*  16 */  Val_static_block(&ocaml_ram_heap[19]),
  /*  17 */  Val_int(-4),
  /*  18 */  Make_header(5, String_tag, Color_white),
  /*  19 */  Make_string_data('I', 'n', 'v', 'a'),
  /*  20 */  Make_string_data('l', 'i', 'd', '_'),
  /*  21 */  Make_string_data('a', 'r', 'g', 'u'),
  /*  22 */  Make_string_data('m', 'e', 'n', 't'),
  /*  23 */  Make_string_data('\0', '\0', '\0', '\3'),
  /*  24 */  Make_header(2, Object_tag, Color_white),
  /*  25 */  Val_static_block(&ocaml_ram_heap[28]),
  /*  26 */  Val_int(-6),
  /*  27 */  Make_header(5, String_tag, Color_white),
  /*  28 */  Make_string_data('D', 'i', 'v', 'i'),
  /*  29 */  Make_string_data('s', 'i', 'o', 'n'),
  /*  30 */  Make_string_data('_', 'b', 'y', '_'),
  /*  31 */  Make_string_data('z', 'e', 'r', 'o'),
  /*  32 */  Make_string_data('\0', '\0', '\0', '\3'),
  /*  33 */  Make_header(2, Object_tag, Color_white),
  /*  34 */  Val_static_block(&ocaml_ram_heap[37]),
  /*  35 */  Val_int(-9),
  /*  36 */  Make_header(4, String_tag, Color_white),
  /*  37 */  Make_string_data('S', 't', 'a', 'c'),
  /*  38 */  Make_string_data('k', '_', 'o', 'v'),
  /*  39 */  Make_string_data('e', 'r', 'f', 'l'),
  /*  40 */  Make_string_data('o', 'w', '\0', '\1'),
  /*  41 */  Make_header(2, Object_tag, Color_white),
  /*  42 */  Val_static_block(&ocaml_ram_heap[45]),
  /*  43 */  Val_int(-2),
  /*  44 */  Make_header(3, String_tag, Color_white),
  /*  45 */  Make_string_data('S', 'y', 's', '_'),
  /*  46 */  Make_string_data('e', 'r', 'r', 'o'),
  /*  47 */  Make_string_data('r', '\0', '\0', '\2'),
  /*  48 */  Make_header(2, Object_tag, Color_white),
  /*  49 */  Val_static_block(&ocaml_ram_heap[52]),
  /*  50 */  Val_int(-5),
  /*  51 */  Make_header(3, String_tag, Color_white),
  /*  52 */  Make_string_data('E', 'n', 'd', '_'),
  /*  53 */  Make_string_data('o', 'f', '_', 'f'),
  /*  54 */  Make_string_data('i', 'l', 'e', '\0'),
  /*  55 */  Make_header(2, Object_tag, Color_white),
  /*  56 */  Val_static_block(&ocaml_ram_heap[59]),
  /*  57 */  Val_int(-7),
  /*  58 */  Make_header(3, String_tag, Color_white),
  /*  59 */  Make_string_data('N', 'o', 't', '_'),
  /*  60 */  Make_string_data('f', 'o', 'u', 'n'),
  /*  61 */  Make_string_data('d', '\0', '\0', '\2'),
  /*  62 */  Make_header(2, Object_tag, Color_white),
  /*  63 */  Val_static_block(&ocaml_ram_heap[66]),
  /*  64 */  Val_int(-8),
  /*  65 */  Make_header(4, String_tag, Color_white),
  /*  66 */  Make_string_data('M', 'a', 't', 'c'),
  /*  67 */  Make_string_data('h', '_', 'f', 'a'),
  /*  68 */  Make_string_data('i', 'l', 'u', 'r'),
  /*  69 */  Make_string_data('e', '\0', '\0', '\2'),
  /*  70 */  Make_header(2, Object_tag, Color_white),
  /*  71 */  Val_static_block(&ocaml_ram_heap[74]),
  /*  72 */  Val_int(-10),
  /*  73 */  Make_header(4, String_tag, Color_white),
  /*  74 */  Make_string_data('S', 'y', 's', '_'),
  /*  75 */  Make_string_data('b', 'l', 'o', 'c'),
  /*  76 */  Make_string_data('k', 'e', 'd', '_'),
  /*  77 */  Make_string_data('i', 'o', '\0', '\1'),
  /*  78 */  Make_header(2, Object_tag, Color_white),
  /*  79 */  Val_static_block(&ocaml_ram_heap[82]),
  /*  80 */  Val_int(-11),
  /*  81 */  Make_header(4, String_tag, Color_white),
  /*  82 */  Make_string_data('A', 's', 's', 'e'),
  /*  83 */  Make_string_data('r', 't', '_', 'f'),
  /*  84 */  Make_string_data('a', 'i', 'l', 'u'),
  /*  85 */  Make_string_data('r', 'e', '\0', '\1'),
  /*  86 */  Make_header(2, Object_tag, Color_white),
  /*  87 */  Val_static_block(&ocaml_ram_heap[90]),
  /*  88 */  Val_int(-12),
  /*  89 */  Make_header(7, String_tag, Color_white),
  /*  90 */  Make_string_data('U', 'n', 'd', 'e'),
  /*  91 */  Make_string_data('f', 'i', 'n', 'e'),
  /*  92 */  Make_string_data('d', '_', 'r', 'e'),
  /*  93 */  Make_string_data('c', 'u', 'r', 's'),
  /*  94 */  Make_string_data('i', 'v', 'e', '_'),
  /*  95 */  Make_string_data('m', 'o', 'd', 'u'),
  /*  96 */  Make_string_data('l', 'e', '\0', '\1'),
  /*  97 */  Make_header(3, 0, Color_white),
  /*  98 */  Val_int(18),
  /*  99 */  Val_int(12),
  /* 100 */  Val_int(6),
  /* 101 */  Make_header(3, 0, Color_white),
  /* 102 */  Val_static_block(&ocaml_ram_heap[106]),
  /* 103 */  Val_int(20),
  /* 104 */  Val_int(8),
  /* 105 */  Make_header(2, String_tag, Color_white),
  /* 106 */  Make_string_data('t', 'a', 'k', 'u'),
  /* 107 */  Make_string_data('.', 'm', 'l', '\0')
};

PROGMEM value const ocaml_initial_stack[OCAML_STACK_INITIAL_WOSIZE] = {
};

#define OCAML_Out_of_memory        Val_static_block(&ocaml_ram_heap[2])
#define OCAML_Failure              Val_static_block(&ocaml_ram_heap[10])
#define OCAML_Invalid_argument     Val_static_block(&ocaml_ram_heap[16])
#define OCAML_Division_by_zero     Val_static_block(&ocaml_ram_heap[25])
#define OCAML_Stack_overflow       Val_static_block(&ocaml_ram_heap[34])

#define OCAML_atom0                Val_static_block(&ocaml_ram_heap[1])

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_1B, 71,
  /*   2 */  OCAML_ACC0,
  /*   3 */  OCAML_GETFIELD2,
  /*   4 */  OCAML_PUSHACC1,
  /*   5 */  OCAML_GETFIELD1,
  /*   6 */  OCAML_PUSHACC2,
  /*   7 */  OCAML_GETFIELD0,
  /*   8 */  OCAML_PUSHACC1,
  /*   9 */  OCAML_PUSHACC1,
  /*  10 */  OCAML_GTINT,
  /*  11 */  OCAML_BRANCHIFNOT_1B, 34,
  /*  13 */  OCAML_ACC1,
  /*  14 */  OCAML_PUSHACC1,
  /*  15 */  OCAML_PUSHACC4,
  /*  16 */  OCAML_OFFSETINT_1B, (opcode_t) -1,
  /*  18 */  OCAML_MAKEBLOCK3, 0,
  /*  20 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  21 */  OCAML_APPLY1,
  /*  22 */  OCAML_PUSHACC1,
  /*  23 */  OCAML_PUSHACC4,
  /*  24 */  OCAML_PUSHACC4,
  /*  25 */  OCAML_OFFSETINT_1B, (opcode_t) -1,
  /*  27 */  OCAML_MAKEBLOCK3, 0,
  /*  29 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  30 */  OCAML_APPLY1,
  /*  31 */  OCAML_PUSHACC4,
  /*  32 */  OCAML_PUSHACC4,
  /*  33 */  OCAML_PUSHACC4,
  /*  34 */  OCAML_OFFSETINT_1B, (opcode_t) -1,
  /*  36 */  OCAML_MAKEBLOCK3, 0,
  /*  38 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  39 */  OCAML_APPLY1,
  /*  40 */  OCAML_MAKEBLOCK3, 0,
  /*  42 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  43 */  OCAML_APPTERM1, 5,
  /*  45 */  OCAML_ACC2,
  /*  46 */  OCAML_RETURN, 4,
  /*  48 */  OCAML_RESTART,
  /*  49 */  OCAML_GRAB, 1,
  /*  51 */  OCAML_ACC0,
  /*  52 */  OCAML_BLTINT_1B, 0, 6,
  /*  55 */  OCAML_ACC1,
  /*  56 */  OCAML_RETURN, 2,
  /*  58 */  OCAML_ACC1,
  /*  59 */  OCAML_PUSHGETRAMGLOBAL_1B, 12,
  /*  61 */  OCAML_PUSHGETRAMGLOBAL_1B, 13,
  /*  63 */  OCAML_APPLY1,
  /*  64 */  OCAML_ADDINT,
  /*  65 */  OCAML_PUSHACC1,
  /*  66 */  OCAML_OFFSETINT_1B, (opcode_t) -1,
  /*  68 */  OCAML_PUSHOFFSETCLOSURE0,
  /*  69 */  OCAML_APPTERM2, 4,
  /*  71 */  OCAML_CLOSUREREC_1B, 1, 0, (opcode_t) -69,
  /*  75 */  OCAML_ACC0,
  /*  76 */  OCAML_SETRAMGLOBAL_1B, 13,
  /*  78 */  OCAML_CLOSUREREC_1B, 1, 0, (opcode_t) -29,
  /*  82 */  OCAML_CONST0,
  /*  83 */  OCAML_PUSHCONSTINT_2B, 7, 208,
  /*  86 */  OCAML_PUSHACC2,
  /*  87 */  OCAML_APPLY2,
  /*  88 */  OCAML_BNEQ_2B, 54, 176, 0, 7,
  /*  93 */  OCAML_BRANCH_1B, 9,
  /*  95 */  OCAML_GETRAMGLOBAL_1B, 14,
  /*  97 */  OCAML_PUSHGETRAMGLOBAL_1B, 10,
  /*  99 */  OCAML_MAKEBLOCK2, 0,
  /* 101 */  OCAML_RAISE,
  /* 102 */  OCAML_POP, 2,
  /* 104 */  OCAML_STOP
};

#include </home/benoit/info/ocaml/omicrob/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
};
