/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#include "debug.h"
#include "values.h"
#include "gc.h"

#ifdef __PC__
#include <stdio.h>
#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __PC__

void print_heap(void) {
  value *ptr;
  int i = 0;

  printf("HEAP (starts at %p, ends at %p, size = %d words) : \n", ocaml_heap, ocaml_heap + OCAML_HEAP_WOSIZE, OCAML_HEAP_WOSIZE);

  for(ptr = ocaml_heap; ptr < ocaml_heap + OCAML_HEAP_WOSIZE; ptr ++){
    float f = *((float *) ptr);
#ifdef OCAML_GC_STOP_AND_COPY
    if (ptr == ocaml_heap + OCAML_HEAP_WOSIZE / 2) {
      printf("======================================================\n");
    }
#endif
    if (Is_int(*ptr)){
      printf("%d  @%p : 0x%08x (int = %d / float = %f)", i, ptr, *ptr, Int_val(*ptr), f);
    } else if (Is_block(*ptr)) {
      printf("%d  @%p : 0x%08x / @(%p)",i, ptr, *ptr, Block_val(*ptr));
    } else if (*ptr == 0) {
      printf("%d  @%p : _",i, ptr);
    } else if (f >= -1e6 && f <= 1e6) {
      printf("%d  @%p : 0x%08x (maybe %f)", i, ptr, *ptr, f);
    } else {
      printf("%d  @%p : 0x%08x", i, ptr, *ptr);
    }
    printf("\n");
    i ++;
  }
  printf("heap_ptr = %p", heap_ptr);
  printf("\n\n\n");
}

/******************************************************************************/

void print_global(void) {
  printf("GLOBAL DATA : \n");
  for (int i = 0; i < OCAML_GLOBDATA_NUMBER; i ++){
    if (Is_block(ocaml_global_data[i])){
      printf("@%p : (%d) - 0x%04x -> pointer to %p\n",ocaml_global_data, i, ocaml_global_data[i], Block_val(ocaml_global_data[i]));
    }
    else
      printf("@%p (%d) - 0x%04x -> int / float %d\n",ocaml_global_data+i, i, ocaml_global_data[i], Int_val(ocaml_global_data[i]));
  }
}

/******************************************************************************/

extern value *sp;

void print_stack(void) {
  printf(" STACK : \n");
  int i = 0;
  for (value* ptr = ocaml_stack + OCAML_STACK_WOSIZE;
       ptr > sp; ptr --){
    float f = *(float *)&sp[i];
    printf("@%p ", &sp[i]);
    if (Is_int(sp[i])){
      printf("(%d) : %04x -> %d or %f \n", i, sp[i], Int_val(sp[i]), f);
    } else if (Is_in_heap(sp[i])) {
      printf("(%d) : 0x%X -> pointer to %p\n", i, sp[i], Block_val(sp[i]));
    } else {
      printf("(%d) : ? 0x%04x -> %f) \n", i, sp[i], f);
    }
    i ++;
  }
  printf("<size=%ld>\n", ocaml_stack + OCAML_STACK_WOSIZE - sp);
}

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __AVR__

void print_heap(void) {
}

/******************************************************************************/

void print_global(void) {
}

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

void print_stack(void) {
}

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
