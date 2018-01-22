#include <stdint.h>
#include <setjmp.h>

#ifdef __PC__
#include <stdlib.h>
#endif

#ifdef __AVR__
#include <util/delay.h>
#endif

#include "debug.h"
#include "values.h"
#include "fail.h"
#include "gc.h"

/******************************************************************************/

/*
  Registers for the abstract machine:
    * pc          the code pointer
    * sp          the stack pointer (grows downward)
    * acc         the accumulator (defined and intialized in the generated file)
    * env         heap-allocated environment
    * trapSp      pointer to the current trap frame
    * extra_args  number of extra arguments provided by the caller
*/

code_t pc;
val_t *sp;
val_t env;
val_t trapSp;
uint8_t extra_args;

val_t atom0_header = Make_header(0, 0, Color_white);

PROGMEM extern void * const ocaml_primitives[];

/******************************************************************************/
/* Read tools for program memory */

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
/* Stack tools */

val_t peek(int n) {
  return sp[n];
}

void push(val_t x) {
  if(sp < ocaml_stack) {
    caml_raise_stack_overflow();
  } else {
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
/* Initialization */

void interp_init(void) {
  sp = ocaml_stack + OCAML_STACK_WOSIZE - OCAML_STACK_INITIAL_WOSIZE;
  trapSp = Val_int(-1);
  env = Val_unit;
  extra_args = 0;
  pc = 0;
}

/******************************************************************************/
/* Interpretation */

void interp(void) {
  if (setjmp(caml_exception_jmp_buf)) {
    goto ocaml_raise;
  }
  
  while (1) {
#ifdef DEBUG
#ifdef __PC__
    printf("[%3d] ", pc);
    if (0) {
      printf("=========\n");
      /* print_global(); */
      print_heap();
      print_stack();
      union { val_t v; float f; } vf_acc;
      vf_acc.f = acc;
      float f = vf_acc.f;
      if (Is_int(acc)) {
        printf("acc = 0x%X - %d or %f \n", acc, Int_val(acc), f);
      } else {
        printf("acc = 0x%X -> points to %p or %f \n", acc, Block_val(acc), f);
      }
      printf("env = @(%p) \n", Block_val(env));
      printf("pc = %d\n", pc);
      printf("extra_args=%d \n", extra_args);
    }
#endif
#endif

#ifdef DEBUG
    if (pc < 0 || pc >= OCAML_BYTECODE_BSIZE) {
#ifdef __AVR__
      while(1){}
#endif
#ifdef __PC__
      printf("error : pc\n");
      exit(1);
#endif
    }
#endif

    switch(read_opcode()){
#ifdef OCAML_ACC0
    case OCAML_ACC0 : {
      TRACE("ACC0");
      acc = peek(0);
      break;
    }
#endif

#ifdef OCAML_ACC1
    case OCAML_ACC1 : {
      TRACE("ACC1");
      acc = peek(1);
      break;
    }
#endif

#ifdef OCAML_ACC2
    case OCAML_ACC2 : {
      TRACE("ACC2");
      acc = peek(2);
      break;
    }
#endif

#ifdef OCAML_ACC3
    case OCAML_ACC3 : {
      TRACE("ACC3");
      acc = peek(3);
      break;
    }
#endif

#ifdef OCAML_ACC4
    case OCAML_ACC4 : {
      TRACE("ACC4");
      acc = peek(4);
      break;
    }
#endif

#ifdef OCAML_ACC5
    case OCAML_ACC5 : {
      TRACE("ACC5");
      acc = peek(5);
      break;
    }
#endif

#ifdef OCAML_ACC6
    case OCAML_ACC6 : {
      TRACE("ACC6");
      acc = peek(6);
      break;
    }
#endif

#ifdef OCAML_ACC7
    case OCAML_ACC7 : {
      TRACE("ACC7");
      acc = peek(7);
      break;
    }
#endif

#ifdef OCAML_ACC
    case OCAML_ACC : {
      TRACE("ACC");
      acc = peek(read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSH
    case OCAML_PUSH : {
      TRACE("PUSH");
      push(acc);
      break;
    }
#endif

#ifdef OCAML_PUSHACC1
    case OCAML_PUSHACC1 : {
      TRACE("PUSHACC1");
      push(acc);
      acc = peek(1);
      break;
    }
#endif

#ifdef OCAML_PUSHACC2
    case OCAML_PUSHACC2 : {
      TRACE("PUSHACC2");
      push(acc);
      acc = peek(2);
      break;
    }
#endif

#ifdef OCAML_PUSHACC3
    case OCAML_PUSHACC3 : {
      TRACE("PUSHACC3");
      push(acc);
      acc = peek(3);
      break;
    }
#endif

#ifdef OCAML_PUSHACC4
    case OCAML_PUSHACC4 : {
      TRACE("PUSHACC4");
      push(acc);
      acc = peek(4);
      break;
    }
#endif

#ifdef OCAML_PUSHACC5
    case OCAML_PUSHACC5 : {
      TRACE("PUSHACC5");
      push(acc);
      acc = peek(5);
      break;
    }
#endif

#ifdef OCAML_PUSHACC6
    case OCAML_PUSHACC6 : {
      TRACE("PUSHACC6");
      push(acc);
      acc = peek(6);
      break;
    }
#endif

#ifdef OCAML_PUSHACC7
    case OCAML_PUSHACC7 : {
      TRACE("PUSHACC7");
      push(acc);
      acc = peek(7);
      break;
    }
#endif

#ifdef OCAML_PUSHACC
    case OCAML_PUSHACC : {
      TRACE("PUSHACC8");
      push(acc);
      acc = peek(read_uint8());
      break;
    }
#endif

#ifdef OCAML_POP
    case OCAML_POP : {
      TRACE("POP");
      pop_n(read_uint8());
      break;
    }
#endif

#ifdef OCAML_ASSIGN
    case OCAML_ASSIGN : {
      TRACE("ASSIGN");
      sp[read_uint8()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_ENVACC1
    case OCAML_ENVACC1 : {
      TRACE("ENVACC1");
      acc = Field(env, 1);
      break;
    }
#endif

#ifdef OCAML_ENVACC2
    case OCAML_ENVACC2 : {
      TRACE("ENVACC2");
      acc = Field(env, 2);
      break;
    }
#endif

#ifdef OCAML_ENVACC3
    case OCAML_ENVACC3 : {
      TRACE("ENVACC3");
      acc = Field(env, 3);
      break;
    }
#endif

#ifdef OCAML_ENVACC4
    case OCAML_ENVACC4 : {
      TRACE("ENVACC4");
      acc = Field(env, 4);
      break;
    }
#endif

#ifdef OCAML_ENVACC
    case OCAML_ENVACC : {
      TRACE("ENVACC");
      acc = Field(env, read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC1
    case OCAML_PUSHENVACC1 : {
      TRACE("PUSHENVACC1");
      push(acc);
      acc = Field(env, 1);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC2
    case OCAML_PUSHENVACC2 : {
      TRACE("PUSHENVACC2");
      push(acc);
      acc = Field(env, 2);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC3
    case OCAML_PUSHENVACC3 : {
      TRACE("PUSHENVACC3");
      push(acc);
      acc = Field(env, 3);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC4
    case OCAML_PUSHENVACC4 : {
      TRACE("PUSHENVACC4");
      push(acc);
      acc = Field(env, 4);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC
    case OCAML_PUSHENVACC : {
      TRACE("PUSHENVACC");
      push(acc);
      acc = Field(env, read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_1B
    case OCAML_PUSH_RETADDR_1B : {
      TRACE("PUSHRETADDR1B");
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(read_ptr_1B()));
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_2B
    case OCAML_PUSH_RETADDR_2B : {
      TRACE("PUSHRETADDR2B");
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(read_ptr_2B()));
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_4B
    case OCAML_PUSH_RETADDR_4B : {
      TRACE("PUSHRETADDR4B");
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(read_ptr_4B()));
      break;
    }
#endif

#ifdef OCAML_APPLY
    case OCAML_APPLY : {
      TRACE("APPLY");
      extra_args = read_uint8() - 1;
      pc = Codeptr_val(*(Block_val(acc)));
      env = acc;
      break;
    }
#endif

#ifdef OCAML_APPLY1
    case OCAML_APPLY1 : {
      TRACE("APPLY1");
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
      TRACE("APPLY2");
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
      TRACE("APPLY3");
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
      TRACE("APPTERM");
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
      TRACE("APPTERM1");
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
      TRACE("APPTERM2");
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
      TRACE("APPTERM3");
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
      TRACE("RETURN");
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
      TRACE("RESTART");
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
      TRACE("GRAB");
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
      TRACE("CLOSURE1B");
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
      TRACE("CLOSURE2B");
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
      TRACE("CLOSURE4B");
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
      TRACE("CLOSUREREC1B");
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
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag, Color_white);
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
      TRACE("CLOSUREREC2B");
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
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag, Color_white);
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
      TRACE("CLOSUREREC4B");
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
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag, Color_white);
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
      TRACE("PUSHOFFSETCLOSUREM2");
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
        TRACE("OFFSETCLOSUREM2");
        acc = Val_block(Block_val(env) - 2 * sizeof(val_t));
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE0
    case OCAML_PUSHOFFSETCLOSURE0 : {
      TRACE("PUSHOFFSETCLOSURE0");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE0
    case OCAML_OFFSETCLOSURE0 :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE0) || defined(OCAML_OFFSETCLOSURE0)
      {
        TRACE("OFFSETCLOSURE0");
        acc = env;
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE2
    case OCAML_PUSHOFFSETCLOSURE2 : {
      TRACE("PUSHOFFSETCLOSURE2");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE2
    case OCAML_OFFSETCLOSURE2 :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE2) || defined(OCAML_OFFSETCLOSURE2)
      {
        TRACE("OFFSETCLOSURE2");
        acc = Val_block(Block_val(env) + 2 * sizeof(val_t));
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE
    case OCAML_PUSHOFFSETCLOSURE : {
      TRACE("PUSHOFFSETCLOSURE");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE
    case OCAML_OFFSETCLOSURE :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE) || defined(OCAML_OFFSETCLOSURE)
      {
        TRACE("OFFSETCLOSURE");
        int n = read_int8();
        acc = Val_block(Block_val(env) + n * sizeof(val_t));
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBAL_1B
    case OCAML_PUSHGETGLOBAL_1B : {
      TRACE("PUSHGETGLOBAL1B");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBAL_1B
    case OCAML_GETGLOBAL_1B :
#endif

#if defined(OCAML_PUSHGETGLOBAL_1B) || defined(OCAML_GETGLOBAL_1B)
      {
        TRACE("GETGLOBAL1B");
        acc = ocaml_global_data[read_uint8()];
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBAL_2B
    case OCAML_PUSHGETGLOBAL_2B : {
      TRACE("PUSHGETGLOBAL2B");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBAL_2B
    case OCAML_GETGLOBAL_2B :
#endif

#if defined(OCAML_PUSHGETGLOBAL_2B) || defined(OCAML_GETGLOBAL_2B)
      {
        TRACE("GETGLOBAL2B");
        acc = ocaml_global_data[read_uint16()];
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBALFIELD_1B
    case OCAML_PUSHGETGLOBALFIELD_1B : {
      TRACE("PUSHGETGLOBALFIELD1B");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBALFIELD_1B
    case OCAML_GETGLOBALFIELD_1B :
#endif

#if defined(OCAML_PUSHGETGLOBALFIELD_1B) || defined(OCAML_GETGLOBALFIELD_1B)
      {
        TRACE("GETGLOBALFIELD1B");
        uint8_t n = read_uint8();
        uint8_t p = read_uint8();
        acc = Field(ocaml_global_data[n], p);
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBALFIELD_2B
    case OCAML_PUSHGETGLOBALFIELD_2B : {
      TRACE("PUSHGETGLOBALFIELD2B");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBALFIELD_2B
    case OCAML_GETGLOBALFIELD_2B :
#endif

#if defined(OCAML_PUSHGETGLOBALFIELD_2B) || defined(OCAML_GETGLOBALFIELD_2B)
      {
        TRACE("GETGLOBALFIELD2B");
        uint16_t n = read_uint16();
        uint8_t p = read_uint8();
        acc = Field(ocaml_global_data[n], p);
        break;
      }
#endif

#ifdef OCAML_SETGLOBAL_1B
    case OCAML_SETGLOBAL_1B : {
      TRACE("SETGLOBAL1B");
      ocaml_global_data[read_uint8()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETGLOBAL_2B
    case OCAML_SETGLOBAL_2B : {
      TRACE("SETGLOBAL2B");
      ocaml_global_data[read_uint16()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_PUSHATOM0
    case OCAML_PUSHATOM0 : {
      TRACE("PUSHATOM0");
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_ATOM0
    case OCAML_ATOM0 :
#endif

#if defined(OCAML_PUSHATOM0) || defined(OCAML_ATOM0)
      {
        TRACE("ATOM0");
        acc = Val_block(&((&atom0_header)[1]));
        break;
      }
#endif

#ifdef OCAML_MAKEBLOCK_1B
    case OCAML_MAKEBLOCK_1B : {
      TRACE("MAKEBLOCK1B");
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
      TRACE("MAKEBLOCK2B");
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
      TRACE("MAKEBLOCK1");
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
      TRACE("MAKEBLOCK2");
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
      TRACE("MAKEBLOCK3");
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
      TRACE("GETFIELD0");
      acc = Field(acc, 0);
      break;
    }
#endif

#ifdef OCAML_GETFIELD1
    case OCAML_GETFIELD1 : {
      TRACE("GETFIELD1");
      acc = Field(acc, 1);
      break;
    }
#endif

#ifdef OCAML_GETFIELD2
    case OCAML_GETFIELD2 : {
      TRACE("GETFIELD2");
      acc = Field(acc, 2);
      break;
    }
#endif

#ifdef OCAML_GETFIELD3
    case OCAML_GETFIELD3 : {
      TRACE("GETFIELD3");
      acc = Field(acc, 3);
      break;
    }
#endif

#ifdef OCAML_GETFIELD
    case OCAML_GETFIELD : {
      TRACE("GETFIELD");
      acc = Field(acc, read_uint8());
      break;
    }
#endif

#ifdef OCAML_SETFIELD0
    case OCAML_SETFIELD0 : {
      TRACE("SETFIELD0");
      Field(acc, 0) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD1
    case OCAML_SETFIELD1 : {
      TRACE("SETFIELD1");
      Field(acc, 1) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD2
    case OCAML_SETFIELD2 : {
      TRACE("SETFIELD2");
      Field(acc, 2) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD3
    case OCAML_SETFIELD3 : {
      TRACE("SETFIELD3");
      Field(acc, 3) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD
    case OCAML_SETFIELD : {
      TRACE("SETFIELD");
      Field(acc, read_uint8()) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_VECTLENGTH
    case OCAML_VECTLENGTH : {
      TRACE("VECTLENGTH");
      acc = Val_int(Wosize_val(acc));
      break;
    }
#endif

#ifdef OCAML_GETVECTITEM
    case OCAML_GETVECTITEM : {
      TRACE("GETVECTITEM");
      acc = Field(acc, Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_SETVECTITEM
    case OCAML_SETVECTITEM : {
      TRACE("SETVECTITEM");
      val_t ind = pop();
      val_t val = pop();
      Field(acc, Int_val(ind)) = val;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_GETSTRINGCHAR
    case OCAML_GETSTRINGCHAR : {
      TRACE("GETSTRINGCHAR");
      acc = Val_int(StringField(acc, Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_SETSTRINGCHAR
    case OCAML_SETSTRINGCHAR : {
      TRACE("SETSTRINGCHAR");
      val_t ind = pop();
      val_t val = pop();
      StringField(acc, Int_val(ind)) = Int_val(val);
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_BRANCH_1B
    case OCAML_BRANCH_1B : {
      TRACE("BRANCH1B");
      pc = read_ptr_1B();
      break;
    }
#endif

#ifdef OCAML_BRANCH_2B
    case OCAML_BRANCH_2B : {
      TRACE("BRANCH2B");
      pc = read_ptr_2B();
      break;
    }
#endif

#ifdef OCAML_BRANCH_4B
    case OCAML_BRANCH_4B : {
      TRACE("BRANCH4B");
      pc = read_ptr_4B();
      break;
    }
#endif

#ifdef OCAML_BRANCHIF_1B
    case OCAML_BRANCHIF_1B : {
      TRACE("BRANCHIF1B");
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
      TRACE("BRANCHIF2B");
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
      TRACE("BRANCHIF4B");
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
      TRACE("BRANCHIFNOT1B");
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
      TRACE("BRANCHIFNOT2B");
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
      TRACE("BRANCHIFNOT4B");
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
      TRACE("SWITCH1B");
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
      TRACE("SWITCH2B");
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
      TRACE("SWITCH4B");
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
      TRACE("BOOLNOT");
      acc = acc ^ 2;
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_1B
    case OCAML_PUSHTRAP_1B : {
      TRACE("PUSHTRAP1B");
      push(Val_int(extra_args));
      push(env);
      push(trapSp);
      push(Val_codeptr(read_ptr_1B()));
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_2B
    case OCAML_PUSHTRAP_2B : {
      TRACE("PUSHTRAP2B");
      push(Val_int(extra_args));
      push(env);
      push(trapSp);
      push(Val_codeptr(read_ptr_2B()));
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_4B
    case OCAML_PUSHTRAP_4B : {
      TRACE("PUSHTRAP4B");
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
      TRACE("POPTRAP");
      pop();
      trapSp = pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_RAISE
    case OCAML_RAISE :
#endif
    {
      ocaml_raise:
      TRACE("RAISE");
      if (trapSp == Val_int(-1)) {
#if defined (__PC__)
        printf("Error: uncatched exception: %s\n",
               Tag_val(acc) == Object_tag ?
               String_val(Field(acc, 0)) :
               String_val(Field(Field(acc, 0), 0)));
#endif
#if defined __AVR__
        DDRB |= _BV(5);
        while(1) {
          PORTB ^=_BV(5);
          _delay_ms(200);
        }
#endif
        return;
      } else {
        sp = ocaml_stack + Int_val(trapSp);
        pc = Codeptr_val(pop());
        trapSp = pop();
        env = pop();
        extra_args = Int_val(pop());
      }
      break;
    }

#ifdef OCAML_CHECK_SIGNALS
    case OCAML_CHECK_SIGNALS : {
      TRACE("CHECK_SIGNALS");
      /* TODO */
      break;
    }
#endif

#ifdef OCAML_C_CALL1
    case OCAML_C_CALL1 : {
      TRACE("CCALL1");
      acc = ((val_t (*)(val_t)) (get_primitive(read_uint8())))(acc);
      break;
    }
#endif

#ifdef OCAML_C_CALL2
    case OCAML_C_CALL2 : {
      TRACE("CCALL2");
      acc = ((val_t (*)(val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[0]);
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL3
    case OCAML_C_CALL3 : {
      TRACE("CCALL3");
      acc = ((val_t (*)(val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[0], sp[1]);
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL4
    case OCAML_C_CALL4 : {
      TRACE("CCALL4");
      acc = ((val_t (*)(val_t, val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[0], sp[1], sp[2]);
      pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL5
    case OCAML_C_CALL5 : {
      TRACE("CCALL5");
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
      TRACE("CCALLN");
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
      TRACE("CONST0");
      acc = Val_int(0);
      break;
    }
#endif

#ifdef OCAML_CONST1
    case OCAML_CONST1 : {
      TRACE("CONST1");
      acc = Val_int(1);
      break;
    }
#endif

#ifdef OCAML_CONST2
    case OCAML_CONST2 : {
      TRACE("CONST2");
      acc = Val_int(2);
      break;
    }
#endif

#ifdef OCAML_CONST3
    case OCAML_CONST3 : {
      TRACE("CONST3");
      acc = Val_int(3);
      break;
    }
#endif

#ifdef OCAML_CONSTINT_1B
    case OCAML_CONSTINT_1B : {
      TRACE("CONSTINT1B");
      acc = Val_int(read_int8());
      break;
    }
#endif

#ifdef OCAML_CONSTINT_2B
    case OCAML_CONSTINT_2B : {
      TRACE("CONSTINT2B");
      acc = Val_int(read_int16());
      break;
    }
#endif

#ifdef OCAML_CONSTINT_4B
    case OCAML_CONSTINT_4B : {
      TRACE("CONSTINT4B");
      acc = Val_int(read_int32());
      break;
    }
#endif

#ifdef OCAML_PUSHCONST0
    case OCAML_PUSHCONST0 : {
      TRACE("PUSHCONST0");
      push(acc);
      acc = Val_int(0);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST1
    case OCAML_PUSHCONST1 : {
      TRACE("PUSHCONST1");
      push(acc);
      acc = Val_int(1);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST2
    case OCAML_PUSHCONST2 : {
      TRACE("PUSHCONST2");
      push(acc);
      acc = Val_int(2);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST3
    case OCAML_PUSHCONST3 : {
      TRACE("PUSHCONST3");
      push(acc);
      acc = Val_int(3);
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_1B
    case OCAML_PUSHCONSTINT_1B : {
      TRACE("PUSHCONSTINT1B");
      push(acc);
      acc = Val_int(read_int8());
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_2B
    case OCAML_PUSHCONSTINT_2B : {
      TRACE("PUSHCONSTINT2B");
      push(acc);
      acc = Val_int(read_int16());
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_4B
    case OCAML_PUSHCONSTINT_4B : {
      TRACE("PUSHCONSTINT4B");
      push(acc);
      acc = Val_int(read_int32());
      break;
    }
#endif

#ifdef OCAML_NEGINT
    case OCAML_NEGINT : {
      TRACE("NEGINT");
      acc = Val_int(- Int_val(acc));
      break;
    }
#endif

#ifdef OCAML_ADDINT
    case OCAML_ADDINT : {
      TRACE("ADDINT");
      acc = Val_int((Int_val(acc) + Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_SUBINT
    case OCAML_SUBINT : {
      TRACE("SUBINT");
      acc = Val_int((Int_val(acc) - Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_MULINT
    case OCAML_MULINT : {
      TRACE("MULINT");
      acc = Val_int((Int_val(acc) * Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_DIVINT
    case OCAML_DIVINT : {
      TRACE("DIVINT");
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
      TRACE("MODINT");
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
      TRACE("ANDINT");
      acc = Val_int((Int_val(acc) & Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_ORINT
    case OCAML_ORINT : {
      TRACE("ORINT");
      acc = Val_int((Int_val(acc) | Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_XORINT
    case OCAML_XORINT : {
      TRACE("XORINT");
      acc = Val_int(Int_val(acc) ^ Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_LSLINT
    case OCAML_LSLINT : {
      TRACE("LSLINT");
      acc = Val_int(Int_val(acc) << Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_LSRINT
    case OCAML_LSRINT : {
      TRACE("LSRINT");
      acc = Val_int((uval_t)(Int_val(acc)) >> Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_ASRINT
    case OCAML_ASRINT : {
      TRACE("ASRINT");
      acc = Val_int(Int_val(acc) >> Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_EQ
    case OCAML_EQ : {
      TRACE("EQ");
      acc = (acc == pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_NEQ
    case OCAML_NEQ : {
      TRACE("NEQ");
      acc = (acc == pop()) ? Val_int(0) : Val_int(1);
      break;
    }
#endif

#ifdef OCAML_LTINT
    case OCAML_LTINT : {
      TRACE("LTINT");
      acc = (acc < pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_LEINT
    case OCAML_LEINT : {
      TRACE("LEINT");
      acc = (acc <= pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_GTINT
    case OCAML_GTINT : {
      TRACE("GTINT");
      acc = (acc > pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_GEINT
    case OCAML_GEINT : {
      TRACE("GEINT");
      acc = (acc >= pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_ULTINT
    case OCAML_ULTINT : {
      TRACE("ULTINT");
      acc = ((uval_t) acc < (uval_t) pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_UGEINT
    case OCAML_UGEINT : {
      TRACE("UGEINT");
      acc = ((uval_t) acc >= (uval_t) pop()) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_OFFSETINT_1B
    case OCAML_OFFSETINT_1B : {
      TRACE("OFFSETINT_1B");
      acc = Val_int(Int_val(acc) + read_int8());
      break;
    }
#endif

#ifdef OCAML_OFFSETINT_2B
    case OCAML_OFFSETINT_2B : {
      TRACE("OFFSETINT_2B");
      acc = Val_int(Int_val(acc) + read_int16());
      break;
    }
#endif

#ifdef OCAML_OFFSETINT_4B
    case OCAML_OFFSETINT_4B : {
      TRACE("OFFSETINT_4B");
      acc = Val_int(Int_val(acc) + read_int32());
      break;
    }
#endif

#ifdef OCAML_OFFSETREF_1B
    case OCAML_OFFSETREF_1B : {
      TRACE("OFFSETREF_1B");
      Field(acc, 0) = Val_int(Int_val(Field(acc, 0)) + read_int8());
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_OFFSETREF_2B
    case OCAML_OFFSETREF_2B : {
      TRACE("OFFSETREF_2B");
      Field(acc, 0) = Val_int(Int_val(Field(acc, 0)) + read_int16());
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_OFFSETREF_4B
    case OCAML_OFFSETREF_4B : {
      TRACE("OFFSETREF_4B");
      Field(acc, 0) = Val_int(Int_val(Field(acc, 0)) + read_int32());
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_ISINT
    case OCAML_ISINT : {
      TRACE("ISINT");
      acc = Is_int(acc) ? Val_int(1) : Val_int(0);
      break;
    }
#endif

#ifdef OCAML_GETMETHOD
    case OCAML_GETMETHOD : {
      TRACE("GETMETHOD");
      val_t x = peek(0);
      val_t y = Field(x, 0);
      acc = Field(y, Int_val(acc));
      break;
    }
#endif

#ifdef OCAML_BEQ_1B
    case OCAML_BEQ_1B : {
      TRACE("BEQ_1B");
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
      TRACE("BEQ_2B");
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
      TRACE("BEQ_4B");
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
      TRACE("BNEQ_1B");
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
      TRACE("BNEQ_2B");
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
      TRACE("BNEQ_4B");
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
      TRACE("BLTINT_1B");
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
      TRACE("BLTINT_2B");
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
      TRACE("BLTINT_4B");
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
      TRACE("BLEINT_1B");
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
      TRACE("BLEINT_2B");
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
      TRACE("BLEINT_4B");
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
      TRACE("BGTINT_1B");
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
      TRACE("BGTINT_2B");
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
      TRACE("BGTINT_4B");
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
      TRACE("BGEINT_1B");
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
      TRACE("BGEINT_2B");
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
      TRACE("BGEINT_4B");
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
      TRACE("BULTINT_1B");
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
      TRACE("BULTINT_2B");
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
      TRACE("BULTINT_4B");
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
      TRACE("BUGEINT_1B");
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
      TRACE("BUGEINT_2B");
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
      TRACE("BUGEINT_4B");
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
      TRACE("GETPUBMET");
      push(acc);
      acc = Val_int(read_uint32());
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETDYNMET
    case OCAML_GETDYNMET :
      TRACE("GETDYNMET");
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
      TRACE("STOP");
      return;
    }
#endif

    default:
#if defined(DEBUG) && defined(__PC__)
      printf("Invalid opcode\n");
      exit(1);
#endif
      break;
    }
  }
  return;
}

/******************************************************************************/
/* Main function */

#ifdef __PC__
extern const char **global_argv; // used by simulator
#endif

int main(int argc, const char **argv) {
#ifdef __PC__
  global_argv = argv;
#endif

  interp_init();
  gc_init();
  interp();

#ifdef __AVR__
  while(1) _delay_ms(10);
#endif

  return 0;
}

/******************************************************************************/
