/* PC specific includes and functions */
#include "arch-specific.h"

#include "simul.c"
#include "shared.c"
#include "sf-regs.c"

extern const char **global_argv; // used by simulator

void device_init(const char **argv) {
  global_argv = argv;
}

#if DEBUG >= 1
unsigned int cpt_instr = 0;
#endif

void device_finish() {
#if DEBUG >= 1
  printf("# of instructions = %d\n", cpt_instr);
#endif
}

/******************************************************************************/
/********************************** Debug *************************************/
/******************************************************************************/

void uncaught_exception(value acc) {
  value str;
  int i;
  char c;
  if (Is_block(acc) && Tag_val(acc) == Object_tag && Wosize_val(acc) > 0 && Is_block(Field(acc, 0)) && Tag_val(Field(acc, 0)) == String_tag) {
    str = Field(acc, 0);
  } else {
    str = Field(Field(acc, 0), 0);
  }
  printf("Error: uncaught exception: ");
  i = 0;
  c = String_field(str, 0);
  while (c != '\0') {
    printf("%c", c);
    i ++;
    c = String_field(str, i);
  }
  if (Is_block(acc) && Tag_val(acc) == 0 && Wosize_val(acc) > 1 && Is_block(Field(acc, 1)) && Tag_val(Field(acc, 1)) == String_tag) {
    printf(" \"");
    str = Field(acc, 1);
    i = 0;
    c = String_field(str, 0);
    while (c != '\0') {
      printf("%c", c);
      i ++;
      c = String_field(str, i);
    }
    printf("\"");
  }
  printf("\n");
}

/******************************************************************************/

#if DEBUG >= 2
#define TRACE_INSTRUCTION(instr_name) printf("[%3d]: " instr_name "\n", pc - 1); cpt_instr++; fflush(stdout)
#elif DEBUG >=1
#define TRACE_INSTRUCTION(instr_name) cpt_instr++;
#else
#define TRACE_INSTRUCTION(instr_name)
#endif

void print_value(value v) {
  printf("0x%08" PRIflag "x / ", v);
  if (OCAML_VIRTUAL_ARCH != 16 && Maybe_code_pointer(v)) {
    printf("@%" PRIflag "d (code pointer)", Codeptr_val(v));
  } else if (Is_int(v)) {
    printf("(int = %" PRIflag "d / float = %" PRIflag "f)", Int_val(v), Float_val(v));
  } else if (Is_block_in_dynamic_heap(v)) {
    printf("@%p (block in dynamic heap)", Ram_block_val(v));
  } else if (Is_block_in_static_heap(v)) {
    printf("@%p (block in static heap)", Ram_block_val(v));
  } else if (Is_block_in_flash_heap(v)) {
    printf("@%p (block in flash heap)", Flash_block_val(v));
  } else if (v == 0) {
    printf("NULL");
  } else if (Float_val(v) >= -1e6 && Float_val(v) <= 1e6) {
    printf("(maybe %f)", Float_val(v));
  } else {
    printf("(?)");
  }
  printf("\n");
  fflush(stdout);
}

static void print_table(const char *name, const value *table, uint32_t table_wosize) {
  const value *ptr;
  int i;

  printf("%s (starts at %p, ends at %p, size = %" PRIu32 " words) : \n", name, table, table + table_wosize, table_wosize);

  for (ptr = table, i = 0; ptr < table + table_wosize; ptr ++, i ++) {
#ifdef OCAML_GC_STOP_AND_COPY
    if (ptr == ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE / 2) {
      printf("======================================================\n");
    }
#endif
    printf("%d  @%p : ", i, ptr);
    print_value(*ptr);
  }
  printf("\n\n\n");
}

void print_dynamic_heap(void) {
  print_table("DYNAMIC HEAP", ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE, OCAML_DYNAMIC_HEAP_WOSIZE);
}

void print_static_heap(void) {
  print_table("STATIC HEAP", ocaml_ram_heap, OCAML_STATIC_HEAP_WOSIZE);
}

void print_ram_global_data(void) {
  print_table("RAM GLOBAL DATA", ocaml_ram_global_data, OCAML_RAM_GLOBDATA_NUMBER);
}

extern value *sp;

void print_stack(void) {
  print_table("STACK", sp, OCAML_STACK_WOSIZE - (sp - ocaml_stack));
}

void print_flash_heap(void) {
  print_table("FLASH HEAP", ocaml_flash_heap, OCAML_FLASH_HEAP_WOSIZE);
}

void print_flash_global_data(void) {
  print_table("FLASH GLOBAL DATA", ocaml_flash_global_data, OCAML_FLASH_GLOBDATA_NUMBER);
}

/******************************************************************************/
/**************************** Memory operations *******************************/
/******************************************************************************/

static inline char do_read_byte(const opcode_t *ocaml_bytecode, int pc) {
  return ocaml_bytecode[pc];
}

static inline uint8_t do_read_byte_from_flash(const void *flash_ptr, int ind) {
  return ((uint8_t *) flash_ptr)[ind];
}

static inline void *do_get_primitive(void *const primitives[], uint8_t prim_ind) {
  return primitives[prim_ind];
}

static inline value do_read_flash_data_1B(const value flash_global_data[], uint8_t glob_ind) {
  return flash_global_data[glob_ind];
}

static inline value do_read_flash_data_2B(const value flash_global_data[], uint8_t glob_ind) {
  return flash_global_data[glob_ind];
}

/******************************************************************************/
/********************************* Format *************************************/
/******************************************************************************/

void format_int64(char *buf, int bufsize, value v) {
  snprintf(buf, bufsize, "%ld", Int64_val(v));
}

#if OCAML_VIRTUAL_ARCH == 64
void format_long(char *buf, int bufsize, value v) {
  snprintf(buf, bufsize, "%lld", Int_val(v));
}
#endif
