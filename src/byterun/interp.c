#include <stdint.h>

#include "debug.h"
#include "values.h"
#include "gc.h"

#ifdef __PC__
#include <stdlib.h>
#endif

/******************************************************************************/

/* Registers for the abstract machine:
   pc          the code pointer
   sp          the stack pointer (grows downward)
   acc         the accumulator
   env         heap-allocated environment
   trapSp      pointer to the current trap frame
   extra_args  number of extra arguments provided by the caller
*/

val_t atom0_header = Make_header(0, 0);

PROGMEM extern void * const ocaml_primitives[];

code_t pc;
val_t env;
val_t *sp;
static val_t trapSp;
static uint8_t extra_args;


void caml_raise_stack_overflow(void) {
#ifdef __PC__
#include <stdio.h>
printf("stack overflow");
 /* exit(0); */
#endif
  /* assert(0); */
  /* TODO */
}

/******************************************************************************/

void *get_primitive(uint8_t prim_ind) {
#ifdef __AVR__
  return (void *) pgm_read_word_near(ocaml_primitives + prim_ind);
#else
  return ocaml_primitives[prim_ind];
#endif
}

 char read_byte(void) {
  char c;
#ifdef __AVR__
  c = pgm_read_byte_near(ocaml_bytecode + pc);
#else
  c = ocaml_bytecode[pc];
#endif
  pc ++;
  return c;
}

 opcode_t read_opcode(void) {
  return (opcode_t) read_byte();
}

 uint8_t read_uint8(void) {
  return (uint8_t) read_byte();
}

 int8_t read_int8(void) {
  return (int8_t) read_byte();
}

 uint16_t read_uint16(void) {
  uint8_t n1 = read_uint8();
  uint8_t n0 = read_uint8();
  return ((uint16_t) n1 << 8) | n0;
}

 int16_t read_int16(void) {
  return (int16_t) read_uint16();
}

 uint32_t read_uint32(void) {
  uint8_t n3 = read_uint8();
  uint8_t n2 = read_uint8();
  uint8_t n1 = read_uint8();
  uint8_t n0 = read_uint8();
  return ((uint32_t) n3 << 24) | ((uint32_t) n2 << 16) | ((uint32_t) n1 << 8) | n0;
}

 int32_t read_int32(void) {
  return (int32_t) read_uint32();
}

 code_t read_ptr_1B(void) {
  int8_t ofs = read_int8();
  return pc - 2 + ofs;
}

 code_t read_ptr_2B(void) {
  int16_t ofs = read_int16();
  return pc - 3 + ofs;
}

 code_t read_ptr_4B(void) {
  int32_t ofs = read_int32();
  return pc - 5 + ofs;
}

/******************************************************************************/

 val_t peek(int n) {
  return sp[n];
}

 void push(val_t x) {
  if(sp < ocaml_stack){
    caml_raise_stack_overflow();
  }
  else {
    *--sp = x;
  }
}

 val_t pop(void) {
  return *(sp++);
}

 void pop_n(int n) {
  sp += n;
}

/******************************************************************************/

#ifdef DEBUG
/* for debugging */

int cptinst = 0;

#ifdef __AVR__

void print_global(){
  Serial.println("GLOBALS =");
  for (int i = 0; i < OCAML_GLOBDATA_NUMBER; i ++){
    Serial.print("@0x");
    Serial.println((uval_t)ocaml_global_data+i,HEX);
    Serial.print(i);
    Serial.print(" : ");
    Serial.print(ocaml_global_data[i],HEX);
    Serial.print(" - ");
    if (Is_block(ocaml_global_data[i])){
      Serial.print("0x");
      Serial.println((uval_t)Block_val(ocaml_global_data[i]),HEX);
    }
    else
      Serial.print("int / float = ");
      Serial.println(Int_val(ocaml_global_data[i]));
  }
}

void print_stack(){
  Serial.println(" STACK :");
  int i = 0;
  for (val_t* ptr = ocaml_stack + OCAML_STACK_WOSIZE;
       ptr > sp; ptr --){
    Serial.print("@sp[");
    Serial.print(i);
    Serial.print("] = 0x");
    Serial.print((uval_t)&sp[i],HEX);
    Serial.print(" : ");
    if (Is_int(sp[i])){
      Serial.print("int/float =");
      Serial.print(Int_val(sp[i]),DEC);
      Serial.print("/");
      Serial.println(*(float *)&sp[i],5);
    }
    else if (Is_block(sp[i])){
      Serial.print("points to (0x");
      Serial.print((uval_t)Block_val(sp[i]),HEX);
      Serial.println(")");
    }
    else {
      Serial.print("0x");
      Serial.println((val_t)sp[i],HEX);
    }
    i++;
  }
}

#endif

#ifdef __PC__

void print_global(){
  printf("GLOBAL DATA : \n");
  for (int i = 0; i < OCAML_GLOBDATA_NUMBER; i ++){
    if (Is_block(ocaml_global_data[i])){
      printf("@%p : (%d) - 0x%04x -> pointer to %p\n",ocaml_global_data, i, ocaml_global_data[i], Block_val(ocaml_global_data[i]));
    }
    else
      printf("@%p (%d) - 0x%04x -> int / float %d\n",ocaml_global_data+i, i, ocaml_global_data[i], Int_val(ocaml_global_data[i]));
  }
}

int stack_size(){
  return ocaml_stack + OCAML_STACK_WOSIZE - sp;
}
void print_stack(){
  printf(" STACK : \n");
  int i = 0;
  for (val_t* ptr = ocaml_stack + OCAML_STACK_WOSIZE;
       ptr > sp; ptr --){
    float f = *(float *)&sp[i];
    printf("@%p ", &sp[i]);
    if (Is_int(sp[i])){
      printf("(%d) : %04x -> %d or %f \n", i, sp[i], Int_val(sp[i]), f);
    }
    else if (Is_block(sp[i])){
      printf("(%d) : 0x%X -> pointer to %p or %f \n", i, sp[i], Block_val(sp[i]), f);
    }
    else
      printf("(%d) : ? 0x%04x -> %f) \n", i, sp[i],f);
    i++;
  }
  printf("<size=%d>\n",stack_size());
}
#endif
#endif

/******************************************************************************/

void caml_raise_division_by_zero(void) {
  /* assert(0); */
  /* TODO */
}

/******************************************************************************/

void init_heap_pointer(val_t *ptr) {
  val_t old_v = *ptr;
  if (Is_block(old_v)) {
    *ptr = Val_block((char *) ocaml_heap + (int) old_v);
  }
}

/******************************************************************************/

void init_heap_pointers(void) {
  int i;
  for (i = 0; i < OCAML_HEAP_INITIAL_WOSIZE; i ++) {
    init_heap_pointer(&ocaml_heap[i]);
  }
  for (i = 0; i < OCAML_GLOBDATA_NUMBER; i ++) {
    init_heap_pointer(&ocaml_global_data[i]);
  }
}

/******************************************************************************/

void interp_init(void) {
  sp = ocaml_stack + OCAML_STACK_WOSIZE - OCAML_STACK_INITIAL_WOSIZE;
  trapSp = Val_int(-1);
  env = Val_unit;
  extra_args = 0;
  pc = 0;
}

/******************************************************************************/

val_t interp(void) {


  while (1) {
    opcode_t opcode = read_opcode();
    /* sp pointe sur le dernier bloc écrit  */

#ifdef DEBUG
#ifdef __AVR__
    /* print_heap(); */
    print_global();
    print_stack();
    Serial.println("\n\n");
    Serial.print("pc=");
    Serial.println(pc-1);
    Serial.print("cpt=");
    Serial.println(cptinst);
    Serial.print("env=0x");
    Serial.println((uval_t)Block_val(env),HEX);
     Serial.print("@acc=0x");
     Serial.println((uval_t)&acc,HEX);
    Serial.print("acc=0x");
    Serial.print(acc,HEX);
    Serial.print(" -> points to 0x");
    Serial.println((uval_t)Block_val(acc),HEX);
#endif
#ifdef __PC__
    printf("=========\n");
    /* print_global(); */
    print_heap();
    print_stack();
    float f = *(float *)&acc;
    if (Is_int(acc)) {
      printf("acc = 0x%X - %d or %f \n", acc, Int_val(acc), f);
    } else {
      printf("acc = 0x%X -> points to %p or %f \n", acc, Block_val(acc), f);
    }
    printf("env = @(%p) \n", Block_val(env));
    printf("pc = %d\n", pc-1);
    printf("extra_args=%d \n",extra_args);
#endif
#endif


#ifdef DEBUG
    cptinst++;
#endif

#ifdef DEBUG
    if(pc > OCAML_BYTECODE_BSIZE || pc <= 0){
#ifdef __AVR__
      while(1){}
#endif
#ifdef __PC__
      printf("error : pc");
      exit(1);
#endif
    }
#endif

    switch(opcode){
#ifdef OCAML_ACC0
    case OCAML_ACC0 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC0\n");
#endif
      acc = peek(0);
      break;
    }
#endif

#ifdef OCAML_ACC1
    case OCAML_ACC1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC1\n");
#endif
      acc = peek(1);
      break;
    }
#endif

#ifdef OCAML_ACC2
    case OCAML_ACC2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC2\n");
#endif
      acc = peek(2);
      break;
    }
#endif

#ifdef OCAML_ACC3
    case OCAML_ACC3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC3\n");
#endif
      acc = peek(3);
      break;
    }
#endif

#ifdef OCAML_ACC4
    case OCAML_ACC4 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC4\n");
#endif
      acc = peek(4);
      break;
    }
#endif

#ifdef OCAML_ACC5
    case OCAML_ACC5 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC5\n");
#endif
      acc = peek(5);
      break;
    }
#endif

#ifdef OCAML_ACC6
    case OCAML_ACC6 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC6\n");
#endif
      acc = peek(6);
      break;
    }
#endif

#ifdef OCAML_ACC7
    case OCAML_ACC7 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC7\n");
#endif
      acc = peek(7);
      break;
    }
#endif

#ifdef OCAML_ACC
    case OCAML_ACC : {
#if defined(DEBUG) && defined (__PC__)
      printf("ACC\n");
#endif
      acc = peek(read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSH
    case OCAML_PUSH : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSH\n");
#endif
      push(acc);
      break;
    }
#endif

#ifdef OCAML_PUSHACC1
    case OCAML_PUSHACC1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC1\n");
#endif
      push(acc);
      acc = peek(1);
      break;
    }
#endif

#ifdef OCAML_PUSHACC2
    case OCAML_PUSHACC2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC2\n");
#endif
      push(acc);
      acc = peek(2);
      break;
    }
#endif

#ifdef OCAML_PUSHACC3
    case OCAML_PUSHACC3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC3\n");
#endif
      push(acc);
      acc = peek(3);
      break;
    }
#endif

#ifdef OCAML_PUSHACC4
    case OCAML_PUSHACC4 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC4\n");
#endif
      push(acc);
      acc = peek(4);
      break;
    }
#endif

#ifdef OCAML_PUSHACC5
    case OCAML_PUSHACC5 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC5\n");
#endif
      push(acc);
      acc = peek(5);
      break;
    }
#endif

#ifdef OCAML_PUSHACC6
    case OCAML_PUSHACC6 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC6\n");
#endif
      push(acc);
      acc = peek(6);
      break;
    }
#endif

#ifdef OCAML_PUSHACC7
    case OCAML_PUSHACC7 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC7\n");
#endif
      push(acc);
      acc = peek(7);
      break;
    }
#endif

#ifdef OCAML_PUSHACC
    case OCAML_PUSHACC : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHACC8\n");
#endif
      push(acc);
      acc = peek(read_uint8());
      break;
    }
#endif

#ifdef OCAML_POP
    case OCAML_POP : {
#if defined(DEBUG) && defined (__PC__)
      printf("POP\n");
#endif
      pop_n(read_uint8());
      break;
    }
#endif

#ifdef OCAML_ASSIGN
    case OCAML_ASSIGN : {
#if defined(DEBUG) && defined (__PC__)
      printf("ASSIGN\n");
#endif
      sp[read_uint8()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_ENVACC1
    case OCAML_ENVACC1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ENVACC1\n");
#endif
      acc = Field(env, 1);
      break;
    }
#endif

#ifdef OCAML_ENVACC2
    case OCAML_ENVACC2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ENVACC2\n");
#endif
      acc = Field(env, 2);
      break;
    }
#endif

#ifdef OCAML_ENVACC3
    case OCAML_ENVACC3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ENVACC3\n");
#endif
      acc = Field(env, 3);
      break;
    }
#endif

#ifdef OCAML_ENVACC4
    case OCAML_ENVACC4 : {
#if defined(DEBUG) && defined (__PC__)
      printf("ENVACC4\n");
#endif
      acc = Field(env, 4);
      break;
    }
#endif

#ifdef OCAML_ENVACC
    case OCAML_ENVACC : {
#if defined(DEBUG) && defined (__PC__)
      printf("ENVACC\n");
#endif
      acc = Field(env, read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC1
    case OCAML_PUSHENVACC1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHENVACC1\n");
#endif
      push(acc);
      acc = Field(env, 1);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC2
    case OCAML_PUSHENVACC2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHENVACC2\n");
#endif
      push(acc);
      acc = Field(env, 2);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC3
    case OCAML_PUSHENVACC3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHENVACC3\n");
#endif
      push(acc);
      acc = Field(env, 3);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC4
    case OCAML_PUSHENVACC4 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHENVACC4\n");
#endif
      push(acc);
      acc = Field(env, 4);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC
    case OCAML_PUSHENVACC : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHENVACC\n");
#endif
      push(acc);
      acc = Field(env, read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_1B
    case OCAML_PUSH_RETADDR_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHRETADDR1B\n");
#endif
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(read_ptr_1B()));
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_2B
    case OCAML_PUSH_RETADDR_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHRETADDR2B\n");
#endif
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(read_ptr_2B()));
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_4B
    case OCAML_PUSH_RETADDR_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHRETADDR4B\n");
#endif
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(read_ptr_4B()));
      break;
    }
#endif

#ifdef OCAML_APPLY
    case OCAML_APPLY : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPLY\n");
#endif
      extra_args = read_uint8() - 1;
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      break;
    }
#endif

#ifdef OCAML_APPLY1
    case OCAML_APPLY1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPLY1\n");
#endif
      val_t arg1 = pop();
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(pc));
      push(arg1);
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      extra_args = 0;
      break;
    }
#endif

#ifdef OCAML_APPLY2
    case OCAML_APPLY2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPLY2\n");
#endif
      val_t arg1 = pop();
      val_t arg2 = pop();
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(pc));
      push(arg2);
      push(arg1);
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      extra_args = 1;
      break;
    }
#endif

#ifdef OCAML_APPLY3
    case OCAML_APPLY3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPLY3\n");
#endif
      val_t arg1 = pop();
      val_t arg2 = pop();
      val_t arg3 = pop();
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(pc));
      push(arg3);
      push(arg2);
      push(arg1);
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      extra_args = 2;
      break;
    }
#endif

#ifdef OCAML_APPTERM
    case OCAML_APPTERM : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPTERM\n");
#endif
      uint8_t nargs = read_uint8();
      uint8_t slotsize = read_uint8();
      val_t * newsp = sp + slotsize - nargs;
      for (int i = nargs -1 ; i >= 0; i --) {
        newsp[i] = sp[i];
      }
      sp = newsp;
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      extra_args += nargs - 1;
      break;
    }
#endif

#ifdef OCAML_APPTERM1
    case OCAML_APPTERM1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPTERM1\n");
#endif
      val_t arg = peek(0);
      pop_n(read_uint8());
      push(arg);
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      break;
    }
#endif

#ifdef OCAML_APPTERM2
    case OCAML_APPTERM2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPTERM2\n");
#endif
      val_t arg1 = peek(0);
      val_t arg2 = peek(1);
      pop_n(read_uint8());
      push(arg2);
      push(arg1);
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      extra_args ++;
      break;
    }
#endif

#ifdef OCAML_APPTERM3
    case OCAML_APPTERM3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("APPTERM3\n");
#endif
      val_t arg1 = peek(0);
      val_t arg2 = peek(1);
      val_t arg3 = peek(2);
      pop_n(read_uint8());
      push(arg3);
      push(arg2);
      push(arg1);
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      extra_args += 2;
      break;
    }
#endif

#ifdef OCAML_RETURN
    case OCAML_RETURN : {
#if defined(DEBUG) && defined (__PC__)
      printf("RETURN\n");
#endif
      uint8_t n = read_uint8();
      pop_n(n);
      if (extra_args > 0){
        extra_args --;
        pc = Codeptr_val(*(Block_val(acc)));

        env = acc;
      } else {
        pc = Codeptr_val(pop());
        env = pop();
        extra_args = Int_val(pop());
      }
      break;
    }
#endif

#ifdef OCAML_RESTART
    case OCAML_RESTART : {
#if defined(DEBUG) && defined (__PC__)
      printf("RESTART\n");
#endif
      uint8_t nargs = Wosize_val(env) - 2;
      uint8_t i;
      /* pop_n(nargs); */
      sp -= nargs;
      /* printf("NARGS = %d \n", nargs); */
      for (i = 0; i < nargs; i ++) sp[i] = Field(env, i+2);
      env = Field(env,1);
      extra_args += nargs;
      break;
    }
#endif

#ifdef OCAML_GRAB
    case OCAML_GRAB : {
#if defined(DEBUG) && defined (__PC__)
      printf("GRAB\n");
#endif
      uint8_t n = read_uint8();
      uint8_t i;
      if (extra_args >= n){
        extra_args -= n;
      } else {
	OCamlAlloc(acc, extra_args + 3, Closure_tag);
        Field(acc, 1) = env;
        Code_val(acc) = Val_codeptr(pc - 3);
        for (i = 0 ; i < n; i ++) {
          Field(acc, i + 2) = pop();
        }
        pc = Codeptr_val(pop());
        env = pop();
        extra_args = Int_val(pop());
      }
      break;
    }
#endif

#ifdef OCAML_CLOSURE_1B
    case OCAML_CLOSURE_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CLOSURE1B\n");
#endif
      uint8_t n = read_uint8();
      code_t ptr = read_ptr_1B() - 1;
      uint8_t i;
      if (n != 0){
        push(acc);
      }
      OCamlAlloc(acc, n + 1, Closure_tag);
      Code_val(acc) = Val_int(ptr);
      for (i = 0; i < n; i ++){
        Field(acc, i + 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSURE_2B
    case OCAML_CLOSURE_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CLOSURE2B\n");
#endif
      uint8_t n = read_uint8();
      code_t ptr = read_ptr_2B() - 1;
      uint8_t i;
      if (n != 0){
        push(acc);
      }
      OCamlAlloc(acc, n + 1, Closure_tag);
      Code_val(acc) = Val_int(ptr);
      for (i = 0; i < n; i ++){
        Field(acc, i + 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSURE_4B
    case OCAML_CLOSURE_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CLOSURE4B\n");
#endif
      uint8_t n = read_uint8();
      code_t ptr = read_ptr_4B() - 1;
      uint8_t i;
      if (n != 0){
        push(acc);
      }
      OCamlAlloc(acc, n + 1, Closure_tag);
      Code_val(acc) = Val_int(ptr);
      for (i = 0; i < n; i ++){
        Field(acc, i + 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSUREREC_1B
    case OCAML_CLOSUREREC_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CLOSUREREC1B\n");
#endif
       /* f = number of functions */
       /* v = number of variables */
      /* o = offset   */
      uint8_t f = read_uint8();
      uint8_t v = read_uint8();
      code_t o = read_ptr_1B() -2 ;
      int blksize = f * 2 - 1 + v;
      int i;
      if (v > 0) {
        push(acc);
      }
      /* Alloc a closure of size blksize */
      OCamlAlloc(acc, blksize, Closure_tag);

      /* The acc contains the offset */
      Field(acc, 0) = Val_codeptr(o);

      /* Create f functions in the closure */
      for (i = 1; i < f; i ++) {
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag);
        Field(acc, 2 * i) = Val_codeptr(read_ptr_1B() - i - 2);
      }
        /* pop what should be elems of the closure */
      for (i = 0 ; i < v ; i ++) {
        Field(acc, i + 2 * f - 1) = pop();
      }
      push(acc);
      for (i = 1; i < f ; i ++){
        push(Field(acc,2*i));
      }
      break;
    }
#endif

#ifdef OCAML_CLOSUREREC_2B
    case OCAML_CLOSUREREC_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CLOSUREREC2B\n");
#endif
      uint8_t f = read_uint8();
      uint8_t v = read_uint8();
      code_t o = read_ptr_2B() - 2;
      int i;
      if (v > 0) {
        push(acc);
      }
      OCamlAlloc(acc, 2 * f - 1 + v, Closure_tag);
      Field(acc, 0) = Val_codeptr(o);
      for (i = 1; i < f; i ++) {
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag);
        Field(acc, 2 * i) = Val_codeptr(read_ptr_2B() - 2 * i - 2);
      }
      /* pop v elems into the closure */
      for (; i < v ; i ++) {
        Field(acc, i + 2 * f - 1) = pop();
      }
      push(acc);
      for (i = 1; i < f ; i ++){
        push(Field(acc,2*i));
      }
       break;
    }
#endif

#ifdef OCAML_CLOSUREREC_4B
    case OCAML_CLOSUREREC_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CLOSUREREC4B\n");
#endif
      uint8_t f = read_uint8();
      uint8_t v = read_uint8();
      code_t o = read_ptr_4B() - 2;
      int i;
      if (v > 0) {
        push(acc);
      }
      OCamlAlloc(acc, 2 * f - 1 + v, Closure_tag);
      Field(acc, 0) = o;
      for (i = 1; i < f; i ++) {
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag);
        Field(acc, 2 * i) = Val_codeptr(read_ptr_4B() - 4 * i - 2);
      }
      for (; i < v ; i ++) {
        Field(acc, i + 2 * f - 1) = pop();
      }
      push(acc);
      for (i = 1; i < f ; i ++){
        push(Field(acc,2*i));
      }
      break;
    }
#endif

#ifdef OCAML_PUSHOFFSETCLOSUREM2
    case OCAML_PUSHOFFSETCLOSUREM2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHOFFSETCLOSUREM2\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSUREM2
    case OCAML_OFFSETCLOSUREM2 :
#endif

#if defined(OCAML_PUSHOFFSETCLOSUREM2) || defined(OCAML_OFFSETCLOSUREM2)
      {
        /* value + header */
#if defined(DEBUG) && defined (__PC__)
        printf("OFFSETCLOSUREM2\n");
#endif
        acc = Val_block(Block_val(env) - 2 * sizeof(val_t));
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE0
    case OCAML_PUSHOFFSETCLOSURE0 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHOFFSETCLOSURE0\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE0
    case OCAML_OFFSETCLOSURE0 :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE0) || defined(OCAML_OFFSETCLOSURE0)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("OFFSETCLOSURE0\n");
#endif
        acc = env;
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE2
    case OCAML_PUSHOFFSETCLOSURE2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHOFFSETCLOSURE2\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE2
    case OCAML_OFFSETCLOSURE2 :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE2) || defined(OCAML_OFFSETCLOSURE2)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("OFFSETCLOSURE2\n");
#endif
        acc = Val_block(Block_val(env) + 2 * sizeof(val_t));
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE
    case OCAML_PUSHOFFSETCLOSURE : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHOFFSETCLOSURE\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE
    case OCAML_OFFSETCLOSURE :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE) || defined(OCAML_OFFSETCLOSURE)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("OFFSETCLOSURE\n");
#endif
        int n = read_int8();
        acc = Val_block(Block_val(env) + n * sizeof(val_t));
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBAL_1B
    case OCAML_PUSHGETGLOBAL_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHGETGLOBAL1B\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBAL_1B
    case OCAML_GETGLOBAL_1B :
#endif

#if defined(OCAML_PUSHGETGLOBAL_1B) || defined(OCAML_GETGLOBAL_1B)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("GETGLOBAL1B\n");
#endif
        acc = ocaml_global_data[read_uint8()];
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBAL_2B
    case OCAML_PUSHGETGLOBAL_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHGETGLOBAL2B\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBAL_2B
    case OCAML_GETGLOBAL_2B :
#endif

#if defined(OCAML_PUSHGETGLOBAL_2B) || defined(OCAML_GETGLOBAL_2B)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("GETGLOBAL2B\n");
#endif
        acc = ocaml_global_data[read_uint16()];
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBALFIELD_1B
    case OCAML_PUSHGETGLOBALFIELD_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHGETGLOBALFIELD1B\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBALFIELD_1B
    case OCAML_GETGLOBALFIELD_1B :
#endif

#if defined(OCAML_PUSHGETGLOBALFIELD_1B) || defined(OCAML_GETGLOBALFIELD_1B)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("GETGLOBALFIELD1B\n");
#endif
        uint8_t n = read_uint8();
        uint8_t p = read_uint8();
        acc = Field(ocaml_global_data[n], p);
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBALFIELD_2B
    case OCAML_PUSHGETGLOBALFIELD_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHGETGLOBALFIELD2B\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBALFIELD_2B
    case OCAML_GETGLOBALFIELD_2B :
#endif

#if defined(OCAML_PUSHGETGLOBALFIELD_2B) || defined(OCAML_GETGLOBALFIELD_2B)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("GETGLOBALFIELD2B\n");
#endif
        uint16_t n = read_uint16();
        uint8_t p = read_uint8();
        acc = Field(ocaml_global_data[n], p);
        break;
      }
#endif

#ifdef OCAML_SETGLOBAL_1B
    case OCAML_SETGLOBAL_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETGLOBAL1B\n");
#endif
      ocaml_global_data[read_uint8()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETGLOBAL_2B
    case OCAML_SETGLOBAL_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETGLOBAL2B\n");
#endif
      ocaml_global_data[read_uint16()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_PUSHATOM0
    case OCAML_PUSHATOM0 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHATOM0\n");
#endif
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_ATOM0
    case OCAML_ATOM0 :
#endif

#if defined(OCAML_PUSHATOM0) || defined(OCAML_ATOM0)
      {
#if defined(DEBUG) && defined (__PC__)
      printf("ATOM0\n");
#endif
        acc = Val_block(&((&atom0_header)[1]));
        break;
      }
#endif

#ifdef OCAML_MAKEBLOCK_1B
    case OCAML_MAKEBLOCK_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("MAKEBLOCK1B\n");
#endif
      tag_t tag = read_uint8();
      uint8_t size = read_uint8();
      val_t block;
      OCamlAlloc(block, size, tag);
      Field(block, 0) = acc;
      for (uint8_t i = 1; i < size; i ++) Field(block, i) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK_2B
    case OCAML_MAKEBLOCK_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("MAKEBLOCK2B\n");
#endif
      tag_t tag = read_uint8();
      uint16_t size = read_uint16();
      val_t block;
      OCamlAlloc(block, size, tag);
      Field(block, 0) = acc;
      for (uint16_t i = 1; i < size; i ++) Field(block, i) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK1
    case OCAML_MAKEBLOCK1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("MAKEBLOCK1\n");
#endif
      tag_t tag = read_uint8();
      val_t block;
      OCamlAlloc(block, 1, tag);
      Field(block, 0) = acc;
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK2
    case OCAML_MAKEBLOCK2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("MAKEBLOCK2\n");
#endif
      tag_t tag = read_uint8();
      val_t block;
      OCamlAlloc(block, 2, tag);
      Field(block, 0) = acc;
      Field(block, 1) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK3
    case OCAML_MAKEBLOCK3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("MAKEBLOCK3\n");
#endif
      tag_t tag = read_uint8();
      val_t block;
      OCamlAlloc(block, 3, tag);
      Field(block, 0) = acc;
      Field(block, 1) = pop();
      Field(block, 2) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_GETFIELD0
    case OCAML_GETFIELD0 : {
#if defined(DEBUG) && defined (__PC__)
      printf("GETFIELD0\n");
#endif
      acc = Field(acc, 0);
      break;
    }
#endif

#ifdef OCAML_GETFIELD1
    case OCAML_GETFIELD1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("GETFIELD1\n");
#endif
      acc = Field(acc, 1);
      break;
    }
#endif

#ifdef OCAML_GETFIELD2
    case OCAML_GETFIELD2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("GETFIELD2\n");
#endif
      acc = Field(acc, 2);
      break;
    }
#endif

#ifdef OCAML_GETFIELD3
    case OCAML_GETFIELD3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("GETFIELD3\n");
#endif
      acc = Field(acc, 3);
      break;
    }
#endif

#ifdef OCAML_GETFIELD
    case OCAML_GETFIELD : {
#if defined(DEBUG) && defined (__PC__)
      printf("GETFIELD\n");
#endif
      acc = Field(acc, read_uint8());
      break;
    }
#endif

#ifdef OCAML_SETFIELD0
    case OCAML_SETFIELD0 : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETFIELD0\n");
#endif
      Field(acc, 0) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD1
    case OCAML_SETFIELD1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETFIELD1\n");
#endif
      Field(acc, 1) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD2
    case OCAML_SETFIELD2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETFIELD2\n");
#endif
      Field(acc, 2) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD3
    case OCAML_SETFIELD3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETFIELD3\n");
#endif
      Field(acc, 3) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD
    case OCAML_SETFIELD : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETFIELD\n");
#endif
      Field(acc, read_uint8()) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_VECTLENGTH
    case OCAML_VECTLENGTH : {
#if defined(DEBUG) && defined (__PC__)
      printf("VECTLENGTH\n");
#endif
      acc = Val_int(Wosize_val(acc));
      break;
    }
#endif

#ifdef OCAML_GETVECTITEM
    case OCAML_GETVECTITEM : {
#if defined(DEBUG) && defined (__PC__)
      printf("GETVECTITEM\n");
#endif
      acc = Field(acc, Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_SETVECTITEM
    case OCAML_SETVECTITEM : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETVECTITEM\n");
#endif
      val_t ind = pop();
      val_t val = pop();
      Field(acc, Int_val(ind)) = val;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_GETSTRINGCHAR
    case OCAML_GETSTRINGCHAR : {
#if defined(DEBUG) && defined (__PC__)
      printf("GETSTRINGCHAR\n");
#endif
      acc = Val_int(StringField(acc, Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_SETSTRINGCHAR
    case OCAML_SETSTRINGCHAR : {
#if defined(DEBUG) && defined (__PC__)
      printf("SETSTRINGCHAR\n");
#endif
      val_t ind = pop();
      val_t val = pop();
      StringField(acc, Int_val(ind)) = Int_val(val);
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_BRANCH_1B
    case OCAML_BRANCH_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCH1B\n");
#endif
      pc = read_ptr_1B();
      break;
    }
#endif

#ifdef OCAML_BRANCH_2B
    case OCAML_BRANCH_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCH2B\n");
#endif
      pc = read_ptr_2B();
      break;
    }
#endif

#ifdef OCAML_BRANCH_4B
    case OCAML_BRANCH_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCH4B\n");
#endif
      pc = read_ptr_4B();
      break;
    }
#endif

#ifdef OCAML_BRANCHIF_1B
    case OCAML_BRANCHIF_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCHIF1B\n");
#endif
      if (acc != Val_false) {
        pc = read_ptr_1B();
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BRANCHIF_2B
    case OCAML_BRANCHIF_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCHIF2B\n");
#endif
      if (acc != Val_false) {
        pc = read_ptr_2B();
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BRANCHIF_4B
    case OCAML_BRANCHIF_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCHIF4B\n");
#endif
      if (acc != Val_false) {
        pc = read_ptr_4B();
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BRANCHIFNOT_1B
    case OCAML_BRANCHIFNOT_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCHIFNOT1B\n");
#endif
      if (acc == Val_false){
        pc = read_ptr_1B();
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BRANCHIFNOT_2B
    case OCAML_BRANCHIFNOT_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCHIFNOT2B\n");
#endif
      if (acc == Val_false){
        pc = read_ptr_2B();
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BRANCHIFNOT_4B
    case OCAML_BRANCHIFNOT_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("BRANCHIFNOT4B\n");
#endif
      if (acc == Val_false){
        pc = read_ptr_4B();
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_SWITCH_1B
    case OCAML_SWITCH_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("SWITCH1B\n");
#endif
      if (Is_int(acc)){
        uint8_t ofs = Int_val(acc) + 2;
        pc += ofs;
        pc = read_ptr_1B() - ofs;
      } else {
        tag_t idx = Tag_val(acc);
        uint16_t n = read_uint8();
        uint16_t ofs = n + idx + 1;
        pc += ofs;
        pc = read_ptr_1B() - ofs - 1;
      }
      break;
    }
#endif

#ifdef OCAML_SWITCH_2B
    case OCAML_SWITCH_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("SWITCH2B\n");
#endif
      if (Is_int(acc)){
        uint8_t ofs = 2 * Int_val(acc) + 2;
        pc += ofs;
        pc = read_ptr_2B() - ofs;
      } else {
        tag_t idx = Tag_val(acc);
        uint16_t n = read_uint8();
        uint16_t ofs = 2 * (n + idx) + 1;
        pc += ofs;
        pc = read_ptr_2B() - ofs - 1;
      }
      break;
    }
#endif

#ifdef OCAML_SWITCH_4B
    case OCAML_SWITCH_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("SWITCH4B\n");
#endif
      if (Is_int(acc)){
        uint8_t ofs = 4 * Int_val(acc) + 2;
        pc += ofs;
        pc = read_ptr_4B() - ofs;
      } else {
        tag_t idx = Tag_val(acc);
        uint16_t n = read_uint8();
        uint16_t ofs = 4 * (n + idx) + 1;
        pc += ofs;
        pc = read_ptr_4B() - ofs - 1;
      }
      break;
    }
#endif

#ifdef OCAML_BOOLNOT
    case OCAML_BOOLNOT : {
#if defined(DEBUG) && defined (__PC__)
      printf("BOOLNOT\n");
#endif
      acc = acc ^ 2;
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_1B
    case OCAML_PUSHTRAP_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHTRAP1B\n");
#endif
      push(Val_int(extra_args));
      push(trapSp);
      push(Val_codeptr(read_ptr_1B()));
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_2B
    case OCAML_PUSHTRAP_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHTRAP2B\n");
#endif
      push(Val_int(extra_args));
      push(trapSp);
      push(Val_codeptr(read_ptr_2B()));
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_4B
    case OCAML_PUSHTRAP_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHTRAP4B\n");
#endif
      push(Val_int(extra_args));
      push(env);
      push(trapSp);
      push(Val_codeptr(read_ptr_4B()));
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_POPTRAP
    case OCAML_POPTRAP : {
#if defined(DEBUG) && defined (__PC__)
      printf("POPTRAP\n");
#endif
      pop();
      trapSp = pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_RAISE
    case OCAML_RAISE : {
#if defined(DEBUG) && defined (__PC__)
      printf("RAISE\n");
#endif
      if (trapSp == Val_int(-1)) {
#if defined (__PC__)
        printf("Error: uncatched exception\n");
#endif
#if defined __AVR__
        DDRB |= _BV(6);
        while (1) {
          unsigned int i, j;
          PORTB ^= _BV(6);
          for (i = 0; i < 1000; i ++) {
            for (j = 0; j < 1000; j ++);
          }
        }
#endif
        return Val_unit;
      } else {
        sp = ocaml_stack + Int_val(trapSp);
        pc = Codeptr_val(pop());
        trapSp = pop();
        env = pop();
        extra_args = Int_val(pop());
      }
      break;
    }
#endif

#ifdef OCAML_CHECK_SIGNALS
    case OCAML_CHECK_SIGNALS : {
#if defined(DEBUG) && defined (__PC__)
      printf("CHECK_SIGNALS\n");
#endif
      /* TODO */
      break;
    }
#endif

#ifdef OCAML_C_CALL1
    case OCAML_C_CALL1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CCALL1\n");
#endif
      acc = ((val_t (*)(val_t)) (get_primitive(read_uint8())))(acc);
      break;
    }
#endif

#ifdef OCAML_C_CALL2
    case OCAML_C_CALL2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CCALL2\n");
#endif
      acc = ((val_t (*)(val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[0]);
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL3
    case OCAML_C_CALL3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CCALL3\n");
#endif
      acc = ((val_t (*)(val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[0], sp[1]);
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL4
    case OCAML_C_CALL4 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CCALL4\n");
#endif
      acc = ((val_t (*)(val_t, val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[0], sp[1], sp[2]);
      pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL5
    case OCAML_C_CALL5 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CCALL5\n");
#endif
      acc = ((val_t (*)(val_t, val_t, val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[0], sp[1], sp[2], sp[3]);
      pop();
      pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALLN
    case OCAML_C_CALLN : {
#if defined(DEBUG) && defined (__PC__)
      printf("CCALLN\n");
#endif
      uint8_t narg = read_uint8();
      uint8_t prim = read_uint8();
      push(acc);
      acc = ((val_t (*)(uint8_t, val_t *)) (get_primitive(prim)))(narg, sp);
      pop_n(narg);
      break;
    }
#endif

#ifdef OCAML_CONST0
    case OCAML_CONST0 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CONST0\n");
#endif
      acc = Val_int(0);
      break;
    }
#endif

#ifdef OCAML_CONST1
    case OCAML_CONST1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CONST1\n");
#endif
      acc = Val_int(1);
      break;
    }
#endif

#ifdef OCAML_CONST2
    case OCAML_CONST2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CONST2\n");
#endif
      acc = Val_int(2);
      break;
    }
#endif

#ifdef OCAML_CONST3
    case OCAML_CONST3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("CONST3\n");
#endif
      acc = Val_int(3);
      break;
    }
#endif

#ifdef OCAML_CONSTINT_1B
    case OCAML_CONSTINT_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CONSTINT1B\n");
#endif
      acc = Val_int(read_int8());
      break;
    }
#endif

#ifdef OCAML_CONSTINT_2B
    case OCAML_CONSTINT_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CONSTINT2B\n");
#endif
      acc = Val_int(read_int16());
      break;
    }
#endif

#ifdef OCAML_CONSTINT_4B
    case OCAML_CONSTINT_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("CONSTINT4B\n");
#endif
      acc = Val_int(read_int32());
      break;
    }
#endif

#ifdef OCAML_PUSHCONST0
    case OCAML_PUSHCONST0 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHCONST0\n");
#endif
      push(acc);
      acc = Val_int(0);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST1
    case OCAML_PUSHCONST1 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHCONST1\n");
#endif
      push(acc);
      acc = Val_int(1);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST2
    case OCAML_PUSHCONST2 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHCONST2\n");
#endif
      push(acc);
      acc = Val_int(2);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST3
    case OCAML_PUSHCONST3 : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHCONST3\n");
#endif
      push(acc);
      acc = Val_int(3);
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_1B
    case OCAML_PUSHCONSTINT_1B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHCONSTINT1B\n");
#endif
      push(acc);
      acc = Val_int(read_int8());
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_2B
    case OCAML_PUSHCONSTINT_2B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHCONSTINT2B\n");
#endif
      push(acc);
      acc = Val_int(read_int16());
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_4B
    case OCAML_PUSHCONSTINT_4B : {
#if defined(DEBUG) && defined (__PC__)
      printf("PUSHCONSTINT4B\n");
#endif
      push(acc);
      acc = Val_int(read_int32());
      break;
    }
#endif

#ifdef OCAML_NEGINT
    case OCAML_NEGINT : {
      acc = Val_int(- Int_val(acc));
      break;
    }
#endif

#ifdef OCAML_ADDINT
    case OCAML_ADDINT : {
      acc = Val_int((Int_val(acc) + Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_SUBINT
    case OCAML_SUBINT : {
      acc = Val_int((Int_val(acc) - Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_MULINT
    case OCAML_MULINT : {
      acc = Val_int((Int_val(acc) * Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_DIVINT
    case OCAML_DIVINT : {
      int32_t divisor = Int_val(pop());
      if (divisor == 0){
        caml_raise_division_by_zero();
      }
      acc = Val_int(Int_val(acc) / divisor);
      break;
    }
#endif

#ifdef OCAML_MODINT
    case OCAML_MODINT : {
      int32_t divisor = Int_val(pop());
      if (divisor == 0){
        caml_raise_division_by_zero();
      }
      acc = Val_int(Int_val(acc) % divisor);
      break;
    }
#endif

#ifdef OCAML_ANDINT
    case OCAML_ANDINT : {
      acc = Val_int((Int_val(acc) & Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_ORINT
    case OCAML_ORINT : {
      acc = Val_int((Int_val(acc) | Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_XORINT
    case OCAML_XORINT : {
      acc = Val_int(Int_val(acc) ^ Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_LSLINT
    case OCAML_LSLINT : {
      acc = Val_int(Int_val(acc) << Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_LSRINT
    case OCAML_LSRINT : {
      acc = Val_int((uval_t)(Int_val(acc)) >> Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_ASRINT
    case OCAML_ASRINT : {
      acc = Val_int(Int_val(acc) >> Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_EQ
    case OCAML_EQ : {
      acc = (acc == pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_NEQ
    case OCAML_NEQ : {
      acc = (acc == pop()) ? Val_int(0) : Val_int(1);
      break;
    }
#endif

#ifdef OCAML_LTINT
    case OCAML_LTINT : {
      acc = (acc < pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_LEINT
    case OCAML_LEINT : {
      acc = (acc <= pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_GTINT
    case OCAML_GTINT : {
      acc = (acc > pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_GEINT
    case OCAML_GEINT : {
      acc = (acc >= pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_ULTINT
    case OCAML_ULTINT : {
      acc = ((uval_t) acc < (uval_t) pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_UGEINT
    case OCAML_UGEINT : {
      acc = ((uval_t) acc >= (uval_t) pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_OFFSETINT_1B
    case OCAML_OFFSETINT_1B : {
      acc = Val_int(Int_val(acc) + read_int8());
      break;
    }
#endif

#ifdef OCAML_OFFSETINT_2B
    case OCAML_OFFSETINT_2B : {
      acc = Val_int(Int_val(acc) + read_int16());
      break;
    }
#endif

#ifdef OCAML_OFFSETINT_4B
    case OCAML_OFFSETINT_4B : {
      acc = Val_int(Int_val(acc) + read_int32());
      break;
    }
#endif

#ifdef OCAML_OFFSETREF_1B
    case OCAML_OFFSETREF_1B : {
      Field(acc, 0) = Val_int(Int_val(Field(acc, 0)) + read_int8());
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_OFFSETREF_2B
    case OCAML_OFFSETREF_2B : {
      Field(acc, 0) = Val_int(Int_val(Field(acc, 0)) + read_int16());
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_OFFSETREF_4B
    case OCAML_OFFSETREF_4B : {
      Field(acc, 0) = Val_int(Int_val(Field(acc, 0)) + read_int32());
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_ISINT
    case OCAML_ISINT : {
      acc = Is_int(acc) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_GETMETHOD
    case OCAML_GETMETHOD : {
      val_t x = peek(0);
      val_t y = Field(x, 0);
      acc = Field(y, Int_val(acc));
      break;
    }
#endif

#ifdef OCAML_BEQ_1B
    case OCAML_BEQ_1B : {
      if (Val_int(read_int8()) == acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BEQ_2B
    case OCAML_BEQ_2B : {
      if (Val_int(read_int16()) == acc) {
        pc = read_ptr_2B() - 2;
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BEQ_4B
    case OCAML_BEQ_4B : {
      if (Val_int(read_int32()) == acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BNEQ_1B
    case OCAML_BNEQ_1B : {
      if (Val_int(read_int8()) != acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BNEQ_2B
    case OCAML_BNEQ_2B : {
      if (Val_int(read_int16()) != acc) {
        pc = read_ptr_2B() - 2;
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BNEQ_4B
    case OCAML_BNEQ_4B : {
      if (Val_int(read_int32()) != acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BLTINT_1B
    case OCAML_BLTINT_1B : {
      if (Val_int(read_int8()) < acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BLTINT_2B
    case OCAML_BLTINT_2B : {
      if (Val_int(read_int16()) < acc) {
        pc = read_ptr_2B() - 2;
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BLTINT_4B
    case OCAML_BLTINT_4B : {
      if (Val_int(read_int32()) < acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BLEINT_1B
    case OCAML_BLEINT_1B : {
      if (Val_int(read_int8()) <= acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BLEINT_2B
    case OCAML_BLEINT_2B : {
      if (Val_int(read_int16()) <= acc) {
        pc = read_ptr_2B() - 2;
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BLEINT_4B
    case OCAML_BLEINT_4B : {
      if (Val_int(read_int32()) <= acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BGTINT_1B
    case OCAML_BGTINT_1B : {
      if (Val_int(read_int8()) > acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BGTINT_2B
    case OCAML_BGTINT_2B : {
      if (Val_int(read_int16()) > acc) {
        pc = read_ptr_2B() - 2;
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BGTINT_4B
    case OCAML_BGTINT_4B : {
      if (Val_int(read_int32()) > acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BGEINT_1B
    case OCAML_BGEINT_1B : {
      if (Val_int(read_int8()) >= acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BGEINT_2B
    case OCAML_BGEINT_2B : {
      if (Val_int(read_int16()) >= acc) {
        pc = read_ptr_2B() - 2;
      } else {
        pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BGEINT_4B
    case OCAML_BGEINT_4B : {
      if (Val_int(read_int32()) >= acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BULTINT_1B
    case OCAML_BULTINT_1B : {
      if ((uval_t) Val_int(read_int8()) < (uval_t) acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BULTINT_2B
    case OCAML_BULTINT_2B : {
      if ((uval_t) Val_int(read_int16()) < (uval_t) acc) {
        pc = read_ptr_2B() - 2;
      } else {
       pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BULTINT_4B
    case OCAML_BULTINT_4B : {
      if ((uval_t) Val_int(read_int32()) < (uval_t) acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_BUGEINT_1B
    case OCAML_BUGEINT_1B : {
      if ((uval_t) Val_int(read_int8()) >= (uval_t) acc) {
        pc = read_ptr_1B() - 1;
      } else {
        pc += 1;
      }
      break;
    }
#endif

#ifdef OCAML_BUGEINT_2B
    case OCAML_BUGEINT_2B : {
      if ((uval_t) Val_int(read_int16()) >= (uval_t) acc) {
        pc = read_ptr_2B() - 2;
      } else {
       pc += 2;
      }
      break;
    }
#endif

#ifdef OCAML_BUGEINT_4B
    case OCAML_BUGEINT_4B : {
      if ((uval_t) Val_int(read_int32()) >= (uval_t) acc) {
        pc = read_ptr_4B() - 4;
      } else {
        pc += 4;
      }
      break;
    }
#endif

#ifdef OCAML_GETPUBMET
    case OCAML_GETPUBMET : {
      push(acc);
      acc = Val_int(read_uint32());
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETDYNMET
    case OCAML_GETDYNMET :
#endif

#if defined(OCAML_GETPUBMET) || defined(OCAML_GETDYNMET)
    {
      val_t meths = Field(peek(0),0);
      int li = 3, hi = Field(meths,0), mi;
      while (li < hi){
        mi = ((li+hi) >> 1) | 1;
        if (acc < Field (meths,mi)) hi = mi-2;
        else li = mi;
      }
      acc = Field(meths,li-1);
      break;
    }
#endif

#ifdef OCAML_STOP
    case OCAML_STOP : {
#if defined(DEBUG) && defined (__PC__)
      printf("STOP\n");
#endif
#ifdef __PC__
      exit(0);
#endif
      return acc;
    }
#endif

    default :
#ifdef DEBUG
      printf("OPCODE = %d\n", opcode);
#endif
      break;
    }
  }
  return 0;
}

/******************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

void setup(void) {
  #ifdef __AVR__
  init_heap_pointers();
  #endif
  interp_init();
  gc_init();
  interp();
}

void loop(void) {
  // Here we should wait for the serial port (in order to easily flash the uC)
}

#ifdef __cplusplus
}
#endif

/******************************************************************************/

#ifdef __PC__
extern const char **global_argv;
#endif

int main(int argc, const char **argv) {
#ifdef __PC__
  global_argv = argv;
#endif
  setup();
#ifdef __AVR__
  while(1) loop();
#endif
  return 0;
}

/******************************************************************************/
