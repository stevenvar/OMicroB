#define DEBUG

#include <stdint.h>

#include "debug.h"
#include "values.h"
#include "gc.h"

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

static code_t pc;
static val_t env;
static val_t *sp;
static val_t trapSp;
static uint8_t extra_args;


void caml_raise_stack_overflow(void) {
#ifdef DEBUG
  debug(444);
#endif
  assert(0);
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
  return sp[(val_t) n + 1];
}

void push(val_t x) {
  if(sp <= ocaml_stack){
    caml_raise_stack_overflow();
  }
  else {
    *sp = x;
    sp --;
  }
}

val_t pop(void) {
  return *(++sp);
}

void pop_n(int n) {
  sp += n;
}

/******************************************************************************/

void caml_raise_division_by_zero(void) {
  assert(0);
  /* TODO */
}

/******************************************************************************/

void interp_init(void) {
  sp = ocaml_stack + OCAML_STACK_WOSIZE - 1 - OCAML_STACK_INITIAL_WOSIZE;
  trapSp = Val_int(0);
  env = Val_unit;
  extra_args = 0;
  pc = 0;
}

/******************************************************************************/

val_t interp(void) {
  while (1) {
#ifdef __AVR__
    if (serialEventRun) {
      serialEventRun();
    }
#endif

    opcode_t opcode = read_opcode();
/* #ifdef DEBUG */
/*     printf("sp[0] = %d \n", sp[0]); */
/*     printf("env = %d \n", Int_val(env)); */
/*     printf("accu = %d \n", Int_val(acc)); */
/*     printf("pc =%d \n",pc); */
/*     printf("opcode=%d\n",opcode); */
/* #endif */
    switch(opcode){

#ifdef OCAML_ACC0
    case OCAML_ACC0 : {
      acc = peek(0);
      break;
    }
#endif

#ifdef OCAML_ACC1
    case OCAML_ACC1 : {
      acc = peek(1);
      break;
    }
#endif

#ifdef OCAML_ACC2
    case OCAML_ACC2 : {
      acc = peek(2);
      break;
    }
#endif

#ifdef OCAML_ACC3
    case OCAML_ACC3 : {
      acc = peek(3);
      break;
    }
#endif

#ifdef OCAML_ACC4
    case OCAML_ACC4 : {
      acc = peek(4);
      break;
    }
#endif

#ifdef OCAML_ACC5
    case OCAML_ACC5 : {
      acc = peek(5);
      break;
    }
#endif

#ifdef OCAML_ACC6
    case OCAML_ACC6 : {
      acc = peek(6);
      break;
    }
#endif

#ifdef OCAML_ACC7
    case OCAML_ACC7 : {
      acc = peek(7);
      break;
    }
#endif

#ifdef OCAML_ACC
    case OCAML_ACC : {
      acc = peek(read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSH
    case OCAML_PUSH : {
      push(acc);
      break;
    }
#endif

#ifdef OCAML_PUSHACC1
    case OCAML_PUSHACC1 : {
      push(acc);
      acc = peek(1);
      break;
    }
#endif

#ifdef OCAML_PUSHACC2
    case OCAML_PUSHACC2 : {
      push(acc);
      acc = peek(2);
      break;
    }
#endif

#ifdef OCAML_PUSHACC3
    case OCAML_PUSHACC3 : {
      push(acc);
      acc = peek(3);
      break;
    }
#endif

#ifdef OCAML_PUSHACC4
    case OCAML_PUSHACC4 : {
      push(acc);
      acc = peek(4);
      break;
    }
#endif

#ifdef OCAML_PUSHACC5
    case OCAML_PUSHACC5 : {
      push(acc);
      acc = peek(5);
      break;
    }
#endif

#ifdef OCAML_PUSHACC6
    case OCAML_PUSHACC6 : {
      push(acc);
      acc = peek(6);
      break;
    }
#endif

#ifdef OCAML_PUSHACC7
    case OCAML_PUSHACC7 : {
      push(acc);
      acc = peek(7);
      break;
    }
#endif

#ifdef OCAML_PUSHACC
    case OCAML_PUSHACC : {
      push(acc);
      acc = peek(read_uint8());
      break;
    }
#endif

#ifdef OCAML_POP
    case OCAML_POP : {
      pop_n(read_uint8());
      break;
    }
#endif

#ifdef OCAML_ASSIGN
    case OCAML_ASSIGN : {
      sp[read_uint8() + 1] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_ENVACC1
    case OCAML_ENVACC1 : {
      acc = Field(env, 1);
      break;
    }
#endif

#ifdef OCAML_ENVACC2
    case OCAML_ENVACC2 : {
      acc = Field(env, 2);
      break;
    }
#endif

#ifdef OCAML_ENVACC3
    case OCAML_ENVACC3 : {
      acc = Field(env, 3);
      break;
    }
#endif

#ifdef OCAML_ENVACC4
    case OCAML_ENVACC4 : {
      acc = Field(env, 4);
      break;
    }
#endif

#ifdef OCAML_ENVACC
    case OCAML_ENVACC : {
      acc = Field(env, read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC1
    case OCAML_PUSHENVACC1 : {
      push(acc);
      acc = Field(env, 1);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC2
    case OCAML_PUSHENVACC2 : {
      push(acc);
      acc = Field(env, 2);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC3
    case OCAML_PUSHENVACC3 : {
      push(acc);
      acc = Field(env, 3);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC4
    case OCAML_PUSHENVACC4 : {
      push(acc);
      acc = Field(env, 4);
      break;
    }
#endif

#ifdef OCAML_PUSHENVACC
    case OCAML_PUSHENVACC : {
      push(acc);
      acc = Field(env, read_uint8());
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_1B
    case OCAML_PUSH_RETADDR_1B : {
      push(Val_int(extra_args));
      push(env);
      push(read_ptr_1B());
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_2B
    case OCAML_PUSH_RETADDR_2B : {
      push(Val_int(extra_args));
      push(env);
      push(read_ptr_2B());
      break;
    }
#endif

#ifdef OCAML_PUSH_RETADDR_4B
    case OCAML_PUSH_RETADDR_4B : {
      push(Val_int(extra_args));
      push(env);
      push(read_ptr_4B());
      break;
    }
#endif

#ifdef OCAML_APPLY
    case OCAML_APPLY : {
      extra_args = read_uint8() - 1;
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      break;
    }
#endif

#ifdef OCAML_APPLY1
    case OCAML_APPLY1 : {
      val_t arg1 = pop();
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(pc));
      push(arg1);
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      extra_args = 0;
      break;
    }
#endif

#ifdef OCAML_APPLY2
    case OCAML_APPLY2 : {
      val_t arg1 = pop();
      val_t arg2 = pop();
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(pc));
      push(arg2);
      push(arg1);
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      extra_args = 1;
      break;
    }
#endif

#ifdef OCAML_APPLY3
    case OCAML_APPLY3 : {
      val_t arg1 = pop();
      val_t arg2 = pop();
      val_t arg3 = pop();
      push(Val_int(extra_args));
      push(env);
      push(Val_codeptr(pc));
      push(arg3);
      push(arg2);
      push(arg1);
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      extra_args = 2;
      break;
    }
#endif

#ifdef OCAML_APPTERM
    case OCAML_APPTERM : {
      uint8_t nargs = read_uint8();
      uint8_t slotsize = read_uint8();
      val_t * newsp = sp + slotsize - nargs;
      for (int i = nargs ; i > 0; i --) {
        newsp[i] = sp[i];
      }
      sp = newsp;
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      extra_args += nargs - 1;
      break;
    }
#endif

#ifdef OCAML_APPTERM1
    case OCAML_APPTERM1 : {
      val_t arg = peek(0);
      pop_n(read_uint8() - 1);
      push(arg);
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      break;
    }
#endif

#ifdef OCAML_APPTERM2
    case OCAML_APPTERM2 : {
      val_t arg1 = peek(0);
      val_t arg2 = peek(1);
      pop_n(read_uint8() - 2);
      push(arg2);
      push(arg1);
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      extra_args ++;
      break;
    }
#endif

#ifdef OCAML_APPTERM3
    case OCAML_APPTERM3 : {
      val_t arg1 = peek(0);
      val_t arg2 = peek(1);
      val_t arg3 = peek(2);
      pop_n(read_uint8() - 3);
      push(arg3);
      push(arg2);
      push(arg1);
      pc = Codeptr_val(Code_val(acc));
      env = acc;
      extra_args += 2;
      break;
    }
#endif

#ifdef OCAML_RETURN
    case OCAML_RETURN : {
      pop_n(read_uint8());
      if (extra_args > 0){
        extra_args --;
        pc = Codeptr_val(Code_val(acc));
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
      uint8_t nargs = Wosize_val(env) - 2;
      uint8_t i;
      sp -= nargs;
      for (i = 1; i <= nargs; i ++) sp[i] = Field(env, i + 1);
      env = Field(env,1);
      extra_args += nargs;
      break;
    }
#endif

#ifdef OCAML_GRAB
    case OCAML_GRAB : {
      uint8_t n = read_uint8();
      uint8_t i;
      if (extra_args >= n){
        extra_args -= n;
      } else {
        Alloc_small(acc, extra_args + 3, Closure_tag);
        Code_val(acc) = Val_codeptr(pc - 3);
        Field(acc, 1) = env;
        for (i = 0 ; i < n; i ++) {
          Field(env, i + 1) = pop();
        }
        pc = Codeptr_val(pop());
        env = pop();
        extra_args = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSURE_1B
    case OCAML_CLOSURE_1B : {
      uint8_t n = read_uint8();
      code_t ptr = read_ptr_1B() - 1;
      uint8_t i;
      if (n != 0){
        push(acc);
      }
      Alloc_small(acc, n + 1, Closure_tag);
      Code_val(acc) = Val_int(ptr);
      for (i = 0; i < n; i ++){
        Field(acc, i + 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSURE_2B
    case OCAML_CLOSURE_2B : {
      uint8_t n = read_uint8();
      code_t ptr = read_ptr_2B() - 1;
      uint8_t i;
      if (n != 0){
        push(acc);
      }
      Alloc_small(acc, n + 1, Closure_tag);
      Code_val(acc) = Val_int(ptr);
      for (i = 0; i < n; i ++){
        Field(acc, i + 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSURE_4B
    case OCAML_CLOSURE_4B : {
      uint8_t n = read_uint8();
      code_t ptr = read_ptr_4B() - 1;
      uint8_t i;
      if (n != 0){
        push(acc);
      }
      Alloc_small(acc, n + 1, Closure_tag);
      Code_val(acc) = Val_int(ptr);
      for (i = 0; i < n; i ++){
        Field(acc, i + 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSUREREC_1B
    case OCAML_CLOSUREREC_1B : {
      uint8_t f = read_uint8();
      uint8_t v = read_uint8();
      code_t o = read_ptr_1B() - 2;
      int i;
      if (v > 0) {
        push(acc);
      }
      Alloc_small(acc, 2 * f - 1 + v, Closure_tag);
      Field(acc, 0) = o;
      for (i = 1; i < f; i ++) {
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag);
        Field(acc, 2 * i) = read_ptr_1B() - i - 2;
      }
      for (; i < 2 * f - 1 + v ; i ++) {
        Field(acc, i + 2 * f - 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_CLOSUREREC_2B
    case OCAML_CLOSUREREC_2B : {
      uint8_t f = read_uint8();
      uint8_t v = read_uint8();
      code_t o = read_ptr_2B() - 2;
      int i;
      if (v > 0) {
        push(acc);
      }
      Alloc_small(acc, 2 * f - 1 + v, Closure_tag);
      Field(acc, 0) = o;
      for (i = 1; i < f; i ++) {
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag);
        Field(acc, 2 * i) = read_ptr_2B() - 2 * i - 2;
      }
      for (; i < 2 * f - 1 + v ; i ++) {
        Field(acc, i + 2 * f - 1) = pop();
      }
       break;
    }
#endif

#ifdef OCAML_CLOSUREREC_4B
    case OCAML_CLOSUREREC_4B : {
      uint8_t f = read_uint8();
      uint8_t v = read_uint8();
      code_t o = read_ptr_4B() - 2;
      int i;
      if (v > 0) {
        push(acc);
      }
      Alloc_small(acc, 2 * f - 1 + v, Closure_tag);
      Field(acc, 0) = o;
      for (i = 1; i < f; i ++) {
        Field(acc, 2 * i - 1) = Make_header(2 * i, Infix_tag);
        Field(acc, 2 * i) = read_ptr_4B() - 4 * i - 2;
      }
      for (; i < 2 * f - 1 + v ; i ++) {
        Field(acc, i + 2 * f - 1) = pop();
      }
      break;
    }
#endif

#ifdef OCAML_PUSHOFFSETCLOSUREM2
    case OCAML_PUSHOFFSETCLOSUREM2 : {
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
        acc = env - 2 * sizeof(val_t);
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE0
    case OCAML_PUSHOFFSETCLOSURE0 : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE0
    case OCAML_OFFSETCLOSURE0 :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE0) || defined(OCAML_OFFSETCLOSURE0)
      {
        acc = env;
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE2
    case OCAML_PUSHOFFSETCLOSURE2 : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE2
    case OCAML_OFFSETCLOSURE2 :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE2) || defined(OCAML_OFFSETCLOSURE2)
      {
        acc = env + 2 * sizeof(val_t);
        break;
      }
#endif

#ifdef OCAML_PUSHOFFSETCLOSURE
    case OCAML_PUSHOFFSETCLOSURE : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_OFFSETCLOSURE
    case OCAML_OFFSETCLOSURE :
#endif

#if defined(OCAML_PUSHOFFSETCLOSURE) || defined(OCAML_OFFSETCLOSURE)
      {
        int n = read_int8();
        acc = env + n * sizeof(val_t);
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBAL_1B
    case OCAML_PUSHGETGLOBAL_1B : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBAL_1B
    case OCAML_GETGLOBAL_1B :
#endif

#if defined(OCAML_PUSHGETGLOBAL_1B) || defined(OCAML_GETGLOBAL_1B)
      {
        acc = ocaml_global_data[read_uint8()];
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBAL_2B
    case OCAML_PUSHGETGLOBAL_2B : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBAL_2B
    case OCAML_GETGLOBAL_2B :
#endif

#if defined(OCAML_PUSHGETGLOBAL_2B) || defined(OCAML_GETGLOBAL_2B)
      {
        acc = ocaml_global_data[read_uint16()];
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBALFIELD_1B
    case OCAML_PUSHGETGLOBALFIELD_1B : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBALFIELD_1B
    case OCAML_GETGLOBALFIELD_1B :
#endif

#if defined(OCAML_PUSHGETGLOBALFIELD_1B) || defined(OCAML_GETGLOBALFIELD_1B)
      {
        uint8_t n = read_uint8();
        uint8_t p = read_uint8();
        acc = Field(ocaml_global_data[n], p);
        break;
      }
#endif

#ifdef OCAML_PUSHGETGLOBALFIELD_2B
    case OCAML_PUSHGETGLOBALFIELD_2B : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_GETGLOBALFIELD_2B
    case OCAML_GETGLOBALFIELD_2B :
#endif

#if defined(OCAML_PUSHGETGLOBALFIELD_2B) || defined(OCAML_GETGLOBALFIELD_2B)
      {
        uint16_t n = read_uint16();
        uint8_t p = read_uint8();
        acc = Field(ocaml_global_data[n], p);
        break;
      }
#endif

#ifdef OCAML_SETGLOBAL_1B
    case OCAML_SETGLOBAL_1B : {
      ocaml_global_data[read_uint8()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETGLOBAL_2B
    case OCAML_SETGLOBAL_2B : {
      ocaml_global_data[read_uint16()] = acc;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_PUSHATOM0
    case OCAML_PUSHATOM0 : {
      push(acc);
      /* fallthrough */
    }
#endif

#ifdef OCAML_ATOM0
    case OCAML_ATOM0 :
#endif

#if defined(OCAML_PUSHATOM0) || defined(OCAML_ATOM0)
      {
        acc = Val_block(&((&atom0_header)[1]));
        break;
      }
#endif

#ifdef OCAML_MAKEBLOCK_1B
    case OCAML_MAKEBLOCK_1B : {
      tag_t tag = read_uint8();
      uint8_t size = read_uint8();
      val_t block;
      Alloc_small(block, size, tag);
      Field(block, 0) = acc;
      for (uint8_t i = 1; i < size; i ++) Field(block, i) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK_2B
    case OCAML_MAKEBLOCK_2B : {
      tag_t tag = read_uint8();
      uint16_t size = read_uint16();
      val_t block;
      Alloc_small(block, size, tag);
      Field(block, 0) = acc;
      for (uint16_t i = 1; i < size; i ++) Field(block, i) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK1
    case OCAML_MAKEBLOCK1 : {
      tag_t tag = read_uint8();
      val_t block;
      Alloc_small(block, 1, tag);
      Field(block, 0) = acc;
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK2
    case OCAML_MAKEBLOCK2 : {
      tag_t tag = read_uint8();
      val_t block;
      Alloc_small(block, 2, tag);
      Field(block, 0) = acc;
      Field(block, 1) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_MAKEBLOCK3
    case OCAML_MAKEBLOCK3 : {
      tag_t tag = read_uint8();
      val_t block;
      Alloc_small(block, 3, tag);
      Field(block, 0) = acc;
      Field(block, 1) = pop();
      Field(block, 2) = pop();
      acc = block;
      break;
    }
#endif

#ifdef OCAML_GETFIELD0
    case OCAML_GETFIELD0 : {
      acc = Field(acc, 0);
      break;
    }
#endif

#ifdef OCAML_GETFIELD1
    case OCAML_GETFIELD1 : {
      acc = Field(acc, 1);
      break;
    }
#endif

#ifdef OCAML_GETFIELD2
    case OCAML_GETFIELD2 : {
      acc = Field(acc, 2);
      break;
    }
#endif

#ifdef OCAML_GETFIELD3
    case OCAML_GETFIELD3 : {
      acc = Field(acc, 3);
      break;
    }
#endif

#ifdef OCAML_GETFIELD
    case OCAML_GETFIELD : {
      acc = Field(acc, read_uint8());
      break;
    }
#endif

#ifdef OCAML_SETFIELD0
    case OCAML_SETFIELD0 : {
      Field(acc, 0) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD1
    case OCAML_SETFIELD1 : {
      Field(acc, 1) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD2
    case OCAML_SETFIELD2 : {
      Field(acc, 2) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD3
    case OCAML_SETFIELD3 : {
      Field(acc, 3) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_SETFIELD
    case OCAML_SETFIELD : {
      Field(acc, read_uint8()) = pop();
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_VECTLENGTH
    case OCAML_VECTLENGTH : {
      acc = Wosize_val(acc);
      break;
    }
#endif

#ifdef OCAML_GETVECTITEM
    case OCAML_GETVECTITEM : {
      acc = Field(acc, Int_val(pop()));
      break;
    }
#endif

#ifdef OCAML_SETVECTITEM
    case OCAML_SETVECTITEM : {
      val_t ind = pop();
      val_t val = pop();
      Field(acc, Int_val(ind)) = val;
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_GETSTRINGCHAR
    case OCAML_GETSTRINGCHAR : {
      acc = Val_int(StringField(acc, Int_val(pop())));
      break;
    }
#endif

#ifdef OCAML_SETSTRINGCHAR
    case OCAML_SETSTRINGCHAR : {
      val_t ind = pop();
      val_t val = pop();
      StringField(acc, Int_val(ind)) = Int_val(val);
      acc = Val_unit;
      break;
    }
#endif

#ifdef OCAML_BRANCH_1B
    case OCAML_BRANCH_1B : {
      pc = read_ptr_1B();
      break;
    }
#endif

#ifdef OCAML_BRANCH_2B
    case OCAML_BRANCH_2B : {
      pc = read_ptr_2B();
      break;
    }
#endif

#ifdef OCAML_BRANCH_4B
    case OCAML_BRANCH_4B : {
      pc = read_ptr_4B();
      break;
    }
#endif

#ifdef OCAML_BRANCHIF_1B
    case OCAML_BRANCHIF_1B : {
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
      acc = acc ^ 2;
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_1B
    case OCAML_PUSHTRAP_1B : {
      push(Val_int(extra_args));
      push(trapSp);
      push(read_ptr_1B());
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_2B
    case OCAML_PUSHTRAP_2B : {
      push(Val_int(extra_args));
      push(trapSp);
      push(read_ptr_2B());
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_PUSHTRAP_4B
    case OCAML_PUSHTRAP_4B : {
      push(Val_int(extra_args));
      push(env);
      push(trapSp);
      push(read_ptr_4B());
      trapSp = Val_int(sp - ocaml_stack);
      break;
    }
#endif

#ifdef OCAML_POPTRAP
    case OCAML_POPTRAP : {
      pop();
      trapSp = pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_RAISE
    case OCAML_RAISE : {
      if (trapSp == 0) {
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
      /* TODO */
      break;
    }
#endif

#ifdef OCAML_C_CALL1
    case OCAML_C_CALL1 : {
      acc = ((val_t (*)(val_t)) (get_primitive(read_uint8())))(acc);
      break;
    }
#endif

#ifdef OCAML_C_CALL2
    case OCAML_C_CALL2 : {
      acc = ((val_t (*)(val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[1]);
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL3
    case OCAML_C_CALL3 : {
      acc = ((val_t (*)(val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[1], sp[2]);
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL4
    case OCAML_C_CALL4 : {
      acc = ((val_t (*)(val_t, val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[1], sp[2], sp[3]);
      pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALL5
    case OCAML_C_CALL5 : {
      acc = ((val_t (*)(val_t, val_t, val_t, val_t, val_t)) (get_primitive(read_uint8())))(acc, sp[1], sp[2], sp[3], sp[4]);
      pop();
      pop();
      pop();
      pop();
      break;
    }
#endif

#ifdef OCAML_C_CALLN
    case OCAML_C_CALLN : {
      uint8_t narg = read_uint8();
      uint8_t prim = read_uint8();
      push(acc);
      acc = ((val_t (*)(uint8_t, val_t *)) (get_primitive(prim)))(narg, sp + 1);
      pop_n(narg);
      break;
    }
#endif

#ifdef OCAML_CONST0
    case OCAML_CONST0 : {
      acc = Val_int(0);
      break;
    }
#endif

#ifdef OCAML_CONST1
    case OCAML_CONST1 : {
      acc = Val_int(1);
      break;
    }
#endif

#ifdef OCAML_CONST2
    case OCAML_CONST2 : {
      acc = Val_int(2);
      break;
    }
#endif

#ifdef OCAML_CONST3
    case OCAML_CONST3 : {
      acc = Val_int(3);
      break;
    }
#endif

#ifdef OCAML_CONSTINT_1B
    case OCAML_CONSTINT_1B : {
      acc = Val_int(read_int8());
      break;
    }
#endif

#ifdef OCAML_CONSTINT_2B
    case OCAML_CONSTINT_2B : {
      acc = Val_int(read_int16());
      break;
    }
#endif

#ifdef OCAML_CONSTINT_4B
    case OCAML_CONSTINT_4B : {
      acc = Val_int(read_int32());
      break;
    }
#endif

#ifdef OCAML_PUSHCONST0
    case OCAML_PUSHCONST0 : {
      push(acc);
      acc = Val_int(0);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST1
    case OCAML_PUSHCONST1 : {
      push(acc);
      acc = Val_int(1);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST2
    case OCAML_PUSHCONST2 : {
      push(acc);
      acc = Val_int(2);
      break;
    }
#endif

#ifdef OCAML_PUSHCONST3
    case OCAML_PUSHCONST3 : {
      push(acc);
      acc = Val_int(3);
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_1B
    case OCAML_PUSHCONSTINT_1B : {
      push(acc);
      acc = Val_int(read_int8());
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_2B
    case OCAML_PUSHCONSTINT_2B : {
      push(acc);
      acc = Val_int(read_int16());
      break;
    }
#endif

#ifdef OCAML_PUSHCONSTINT_4B
    case OCAML_PUSHCONSTINT_4B : {
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
      /* TODO MACRO */
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
      return acc;
    }
#endif

    default :
      assert(0);

    }
  }
}

/******************************************************************************/

void setup(void) {
  debug_init();
  interp_init();
  gc_init();
  interp();
}

void loop(void) {
  assert(0);
}

/******************************************************************************/

#ifndef __AVR__

int main(int argc, char** argv) {
  setup();
  /* while (1) loop(); */
  return 0;
}

#endif

/******************************************************************************/
