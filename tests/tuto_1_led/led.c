#define OCAML_STACK_WOSIZE                32
#define OCAML_STATIC_HEAP_WOSIZE           0
#define OCAML_DYNAMIC_HEAP_WOSIZE         32
#define OCAML_FLASH_HEAP_WOSIZE           34
#define OCAML_STACK_INITIAL_WOSIZE         0
#define OCAML_RAM_GLOBDATA_NUMBER          0
#define OCAML_FLASH_GLOBDATA_NUMBER        0
#define OCAML_BYTECODE_BSIZE               1
#define OCAML_PRIMITIVE_NUMBER             0
#define OCAML_VIRTUAL_ARCH                32
#define OCAML_STARTING_OOID                0

#define OCAML_GC_MARK_AND_COMPACT

#include </Users/travail/github/OMicroB/src/byterun/vm/values.h>

#define OCAML_STOP                        0

PROGMEM extern const value ocaml_flash_heap[OCAML_FLASH_HEAP_WOSIZE];

value ocaml_ram_heap[OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE] = {
};

PROGMEM value const ocaml_flash_heap[OCAML_FLASH_HEAP_WOSIZE] = {
  /*  0 */  Make_header(2, Object_tag, Color_white),
  /*  1 */  Val_flash_block(&ocaml_flash_heap[4]),
  /*  2 */  Val_int(-1),
  /*  3 */  Make_header(4, String_tag, Color_white),
  /*  4 */  Make_string_data('O', 'u', 't', '_'),
  /*  5 */  Make_string_data('o', 'f', '_', 'm'),
  /*  6 */  Make_string_data('e', 'm', 'o', 'r'),
  /*  7 */  Make_string_data('y', '\0', '\0', '\2'),
  /*  8 */  Make_header(2, Object_tag, Color_white),
  /*  9 */  Val_flash_block(&ocaml_flash_heap[12]),
  /* 10 */  Val_int(-9),
  /* 11 */  Make_header(4, String_tag, Color_white),
  /* 12 */  Make_string_data('S', 't', 'a', 'c'),
  /* 13 */  Make_string_data('k', '_', 'o', 'v'),
  /* 14 */  Make_string_data('e', 'r', 'f', 'l'),
  /* 15 */  Make_string_data('o', 'w', '\0', '\1'),
  /* 16 */  Make_header(2, Object_tag, Color_white),
  /* 17 */  Val_flash_block(&ocaml_flash_heap[20]),
  /* 18 */  Val_int(-6),
  /* 19 */  Make_header(5, String_tag, Color_white),
  /* 20 */  Make_string_data('D', 'i', 'v', 'i'),
  /* 21 */  Make_string_data('s', 'i', 'o', 'n'),
  /* 22 */  Make_string_data('_', 'b', 'y', '_'),
  /* 23 */  Make_string_data('z', 'e', 'r', 'o'),
  /* 24 */  Make_string_data('\0', '\0', '\0', '\3'),
  /* 25 */  Make_header(2, Object_tag, Color_white),
  /* 26 */  Val_flash_block(&ocaml_flash_heap[29]),
  /* 27 */  Val_int(-4),
  /* 28 */  Make_header(5, String_tag, Color_white),
  /* 29 */  Make_string_data('I', 'n', 'v', 'a'),
  /* 30 */  Make_string_data('l', 'i', 'd', '_'),
  /* 31 */  Make_string_data('a', 'r', 'g', 'u'),
  /* 32 */  Make_string_data('m', 'e', 'n', 't'),
  /* 33 */  Make_string_data('\0', '\0', '\0', '\3')
};

value acc = Val_int(0);

value ocaml_stack[OCAML_STACK_WOSIZE] = {
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
  /* 31 */  Val_int(0)
};

value ocaml_ram_global_data[OCAML_RAM_GLOBDATA_NUMBER] = {
};

PROGMEM value const ocaml_flash_global_data[OCAML_FLASH_GLOBDATA_NUMBER] = {
};

#define OCAML_Out_of_memory        Val_flash_block(&ocaml_flash_heap[1])
#define OCAML_Stack_overflow       Val_flash_block(&ocaml_flash_heap[9])
#define OCAML_Division_by_zero     Val_flash_block(&ocaml_flash_heap[17])
#define OCAML_Invalid_argument     Val_flash_block(&ocaml_flash_heap[26])

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /* 0 */  OCAML_STOP
};

#include </Users/travail/github/OMicroB/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
};
