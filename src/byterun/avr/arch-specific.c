#include "arch-specific.h"
#include "avrlib.c"

/******************************************************************************/
/************************ General operations **********************************/
/******************************************************************************/

void device_init() {
  unsigned long ctc_match_overflow;

  cli();
  ctc_match_overflow = ((F_CPU / 1000) / 8); //when timer1 is this value, 1ms has passed

  // (Set timer to clear when matching ctc_match_overflow) | (Set clock divisor to 8)
  TCCR1B |= (1 << WGM12) | (1 << CS11);

  // high byte first, then low byte
  OCR1AH = (ctc_match_overflow >> 8);
  OCR1AL = ctc_match_overflow;

  // Enable the compare match interrupt
  TIMSK1 |= (1 << OCIE1A);

  avr_serial_init();
}

void device_finish() {
  while(1) _delay_ms(10);
}

/******************************************************************************/
/********************************** Debug *************************************/
/******************************************************************************/

void debug_blink_error(void) {
  DDRB = 0xFF;
  PORTB = 0xFF;
  while(1) {
    PORTB ^= _BV(6);
    _delay_ms(500);
  }
}

void debug_blink_uncatched_exception(void) {
  int i;
  DDRB = 0xFF;
  PORTB = 0xFF;
  while (1) {
    for (i = 0; i < 3; i ++) {
      PORTB &= ~_BV(6);
      _delay_ms(200);
      PORTB |= _BV(6);
      _delay_ms(200);
    }
    _delay_ms(1000);
  }
}

void debug_blink_message(int n) {
  int i;
  DDRB = 0xFF;
  PORTB = 0xFF;
  for (i = 0; i <= n; i ++) {
    PORTB &= ~_BV(5);
    _delay_ms(300);
    PORTB |= _BV(5);
    _delay_ms(300);
  }
  _delay_ms(1000);
}

void debug_blink_pause(void) {
  DDRB = 0xFF;
  PORTB = 0xFF;
  _delay_ms(500);
  PORTB &= ~_BV(7);
  _delay_ms(1000);
  PORTB |= _BV(7);
  _delay_ms(500);
}

#if DEBUG > 0
#define assert(x) do { if (!(x)) debug_blink_error();  } while(0);
#else
#define assert(x)
#endif

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

/* void print_dynamic_heap(void) {} */
/* void print_static_heap(void) {} */
void print_flash_heap(void) {}
void print_ram_global_data(void) {}
void print_flash_global_data(void) {}
void print_stack(void) {}

/******************************************************************************/
/**************************** Memory operations *******************************/
/******************************************************************************/

static inline char do_read_byte(const opcode_t *ocaml_bytecode, int pc) {
  return pgm_read_byte_near(ocaml_bytecode + pc);
}

static inline uint8_t do_read_byte_from_flash(const void *flash_ptr, int ind) {
  return pgm_read_byte_near(&((uint8_t *) flash_ptr)[ind]);
}

static inline void *do_get_primitive(void *const primitives[], uint8_t prim_ind) {
  return (void *) pgm_read_word_near(primitives + prim_ind);
}

static inline value do_read_flash_data_1B(const value flash_global_data[], uint8_t glob_ind) {
#if OCAML_VIRTUAL_ARCH == 16
  return (value) pgm_read_word_near(flash_global_data + glob_ind);
#elif OCAML_VIRTUAL_ARCH == 32
  return (value) pgm_read_dword_near(flash_global_data + glob_ind);
#elif OCAML_VIRTUAL_ARCH == 64
  value v1 = pgm_read_dword_near(flash_global_data + glob_ind);
  value v2 = pgm_read_dword_near((char *) (flash_global_data + glob_ind) + 4);
  return (v2 << 32) | v1;
#endif
}

static inline value do_read_flash_data_2B(const value flash_global_data[], uint8_t glob_ind) {
#if OCAML_VIRTUAL_ARCH == 16
  return (value) pgm_read_word_near(flash_global_data + glob_ind);
#elif OCAML_VIRTUAL_ARCH == 32
  return (value) pgm_read_dword_near(flash_global_data + glob_ind);
#elif OCAML_VIRTUAL_ARCH == 64
  value v1 = pgm_read_dword_near(flash_global_data + glob_ind);
  value v2 = pgm_read_dword_near((char *) (flash_global_data + glob_ind) + 4);
  return (v2 << 32) | v1;
#endif
}
