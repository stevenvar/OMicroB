#include "arch-specific.h"
#include "microbitlib.h"

/******************************************************************************/
/************************ General operations **********************************/
/******************************************************************************/

void device_init(const char **argv) {
  microbit_init();
}

void device_finish() {
  delay(10);
}

/******************************************************************************/
/********************************** Debug *************************************/
/******************************************************************************/

void debug_blink_error(void) {
  while(1) {
    char s[] = "E";
    microbit_print_string(s);
    delay(300);
  }
}

void debug_blink_uncatched_exception(void) {
  while(1) {
    char s[] = "U";
    microbit_print_string(s);
    delay(300);
  }
}

void debug_blink_message(int n) {
  char buf[50];
  sprintf(buf, "%d", n);
  microbit_print_string(buf);
}

void debug_blink_pause(void) {
  char s[] = "P";
  microbit_print_string(s);
  delay(1000);
}

#if DEBUG > 0
#define assert(x) do { if (!(x)) debug_blink_error();  } while(0);
#else
#define assert(x)
#endif

void uncaught_exception(value acc) {
  debug_blink_error();
}

/******************************************************************************/

#define TRACE_INSTRUCTION(instr_name)

void print_value(value v) {
  printf("0x%08" PRIflag "lx / ", v);
  if (OCAML_VIRTUAL_ARCH != 16 && Maybe_code_pointer(v)) {
    printf("@%" PRIflag "ld (code pointer)", Codeptr_val(v));
  } else if (Is_int(v)) {
    printf("(int = %" PRIflag "ld / float = %" PRIflag "f)", Int_val(v), (double)Float_val(v));
  } else if (Is_block_in_dynamic_heap(v)) {
    printf("@%p (block in dynamic heap)", Ram_block_val(v));
  } else if (Is_block_in_static_heap(v)) {
    printf("@%p (block in static heap)", Ram_block_val(v));
  } else if (Is_block_in_flash_heap(v)) {
    printf("@%p (block in flash heap)", Flash_block_val(v));
  } else if (v == 0) {
    printf("NULL");
  } else if (Float_val(v) >= -1e6 && Float_val(v) <= 1e6) {
    printf("(maybe %f)", (double)Float_val(v));
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

void print_flash_heap(void) {}
void print_ram_global_data(void) {}
void print_flash_global_data(void) {}
void print_stack(void) {}

/******************************************************************************/
/**************************** Memory operations *******************************/
/******************************************************************************/

static inline char do_read_byte(const opcode_t *ocaml_bytecode, int pc) {
  return ocaml_bytecode[pc];
}

static inline uint8_t do_read_byte_from_flash(const void *flash_ptr, int ind) {
  return ((uint8_t *)flash_ptr)[ind];
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
  snprintf(buf, bufsize, "%lld", Int64_val(v));
}

#if OCAML_VIRTUAL_ARCH == 64
void format_long(char *buf, int bufsize, value v) {
  snprintf(buf, bufsize, "%ld", Int_val(v));
}
#endif

