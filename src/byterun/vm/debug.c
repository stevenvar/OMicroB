/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __PC__
#include <stdio.h>
#endif

#ifdef __AVR__
#include <avr/io.h>
#include <util/delay.h>
#endif

#include "debug.h"
#include "values.h"
#include "gc.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __AVR__

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

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __PC__

void print_value(value v) {
  float f = ((union float_or_value) { .v = v }).f;
  printf("0x%08x / ", v);
  if (Is_int(v)) {
    printf("(int = %d / float = %f)", Int_val(v), f);
  } else if (Is_block_in_dynamic_heap(v)) {
    printf("@(%p) (block in dynamic heap)", Ram_block_val(v));
  } else if (Is_block_in_static_heap(v)) {
    printf("@(%p) (block in static heap)", Ram_block_val(v));
  } else if (Is_block_in_flash_heap(v)) {
    printf("@(%p) (block in flash heap)", Flash_block_val(v));
  } else if (v == 0) {
    printf("ZERO");
  } else if (f >= -1e6 && f <= 1e6) {
    printf("(maybe %f)", f);
  } else {
    printf("(?)");
  }
  printf("\n");
}

static void print_table(const char *name, const value *table, mlsize_t table_wosize) {
  const value *ptr;
  int i;

  printf("%s (starts at %p, ends at %p, size = %d words) : \n", name, table, table + table_wosize, table_wosize);

  for (ptr = table, i = 0; ptr < table + table_wosize; ptr ++, i ++) {
#ifdef OCAML_GC_STOP_AND_COPY
    if (ptr == ocaml_dynamic_heap + OCAML_DYNAMIC_HEAP_WOSIZE / 2) {
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

void print_stack(void) {
  print_table("STACK", ocaml_stack, OCAML_STACK_WOSIZE);
}

void print_flash_heap(void) {
  print_table("FLASH HEAP", ocaml_flash_heap, OCAML_FLASH_HEAP_WOSIZE);
}

void print_flash_global_data(void) {
  print_table("FLASH GLOBAL DATA", ocaml_flash_global_data, OCAML_FLASH_GLOBDATA_NUMBER);
}

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __AVR__

void print_dynamic_heap(void) {}
void print_static_heap(void) {}
void print_flash_heap(void) {}
void print_ram_global_data(void) {}
void print_flash_global_data(void) {}
void print_stack(void) {}

/******************************************************************************/

/*
void print_global() {
  Serial.println("GLOBALS =");
  for (int i = 0; i < OCAML_GLOBDATA_NUMBER; i ++){
    Serial.print("@0x");
    Serial.println((uvalue)ocaml_global_data+i,HEX);
    Serial.print(i);
    Serial.print(" : ");
    Serial.print(ocaml_global_data[i],HEX);
    Serial.print(" - ");
    if (Is_block(ocaml_global_data[i])){
      Serial.print("0x");
      Serial.println((uvalue)Block_val(ocaml_global_data[i]),HEX);
    }
    else
      Serial.print("int / float = ");
      Serial.println(Int_val(ocaml_global_data[i]));
  }
}
*/

/******************************************************************************/

/*
void print_stack(){
  Serial.println(" STACK :");
  int i = 0;
  for (value* ptr = ocaml_stack + OCAML_STACK_WOSIZE;
       ptr > sp; ptr --){
    Serial.print("@sp[");
    Serial.print(i);
    Serial.print("] = 0x");
    Serial.print((uvalue)&sp[i],HEX);
    Serial.print(" : ");
    if (Is_int(sp[i])){
      Serial.print("int/float =");
      Serial.print(Int_val(sp[i]),DEC);
      Serial.print("/");
      Serial.println(*(float *)&sp[i],5);
    }
    else if (Is_block(sp[i])){
      Serial.print("points to (0x");
      Serial.print((uvalue)Block_val(sp[i]),HEX);
      Serial.println(")");
    }
    else {
      Serial.print("0x");
      Serial.println((value)sp[i],HEX);
    }
    i++;
  }
}
*/

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
