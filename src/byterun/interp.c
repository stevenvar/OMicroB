#include <stdint.h>
#include "inst.h"

/* Registers for the abstract machine:
   pc          the code pointer
   sp          the stack pointer (grows downward)
   accu        the accumulator
   env         heap-allocated environment
   caml_trapsp pointer to the current trap frame
   extra_args  number of extra arguments provided by the caller
   sp is a local copy of the global variable caml_extern_sp. */

typedef uint8_t opcode_t;
typedef int32_t code_t;
typedef int32_t val_t;

static code_t pc;
static val_t acc;
extern val_t *stack_end;
extern val_t stack[];
static val_t *sp;
static val_t extra_args;

inline opcode_t read_inst (code_t pc){
  return pgm_read_byte_far(pc);
}

inline val_t read_val (code_t pc){
  return pgm_read_byte_far(pc);
}

inline val_t peek (code_t n){
  return sp[n];
}

inline val_t push (val_t x){
  *(sp--) = x;
}

inline val_t pop (){
  return *(sp++);
}

inline val_t pop_n (code_t n){
  sp += n;
  return *(sp);
}

void interp(){
  sp = stack_end;
}

void interp_inst (){
  opcode_t curr_inst = read_inst(pc++);

  switch(curr_inst){
  case ACC0 :
    acc = peek(0);
    break;
  case ACC1 :
    acc = peek(1);
    break;
  case ACC2 :
    acc = peek(2);
    break;
  case ACC3 :
    acc = peek(3);
    break;
  case ACC4 :
    acc = peek(4);
    break;
  case ACC5 :
    acc = peek(5);
    break;
  case ACC6 :
    acc = peek(6);
    break;
  case ACC7 :
    acc = peek(7);
    break;
  case ACC :
    acc = read_val(pc++);
    break;
  case PUSH :
    push(acc);
    break;
  case PUSHACC0 :
    push (acc);
    break;
  case PUSHACC1 :
    push(acc);
    acc = peek(1);
    break;
  case PUSHACC2 :
    push(acc);
    acc = peek(2);
    break;
  case PUSHACC3 :
    push(acc);
    acc = peek(3);
    break;
  case PUSHACC4 :
    push(acc);
    acc = peek(4);
    break;
  case PUSHACC5 :
    push(acc);
    acc = peek(5);
    break;
  case PUSHACC6 :
    push(acc);
    acc = peek(6);
    break;
  case PUSHACC7 :
    push(acc);
    acc = peek(7);
    break;
  case PUSHACC :
    push(acc);
    acc = peek(pc++);
    break;
  case POP :
    sp += read_val(pc++);
    break;
  case ASSIGN :
    sp[pc++] = acc;
    acc = Val_unit;
    break;
  case ENVACC1 :
    acc = Field(env, 1);
    break;
  case ENVACC2 :
    acc = Field(env, 2);
    break;
  case ENVACC3 :
    acc = Field(env, 3);
    break;
  case ENVACC4 :
    acc = Field(env, 4);
    break;
  case ENVACC :
    accu = Field(env, read_val(pc++));
    break;
  case PUSHENVACC1 :
    push(acc);
    acc = Field(env,1);
    break;
  case PUSHENVACC2 :
    push(acc);
    acc = Field(env,2);
    break;
  case PUSHENVACC3 :
    push(acc);
    acc = Field(env,3);
    break;
  case PUSHENVACC4 :
    push(acc);
    acc = Field(env,4);
    break;
  case PUSHENVACC :
    push(acc);
    acc = Field(env,read_val(pc++));
    break;
  case PUSH_RETADDR :
    push(Val_int(extra_args));
    push(env);
    push(pc + read_val(pc++));
    break;
  case APPLY :
    extra_args = read_val(pc++) - 1;
    pc = Code_val(acc);
    env = acc;
    break;
  case APPLY1 :
    val_t arg1 = pop();
    push(Val_int(extra_args));
    push(env);
    push(Val_int(pc));
    push(arg1);
    pc = Code_val(acc);
    env = acc;
    extra_args = 0;
    break;
  case APPLY2 :
    val_t arg1 = pop();
    val_t arg2 = pop();
    push(Val_int(extra_args));
    push(env);
    push(Val_int(pc));
    push(arg1);
    push(arg2);
    pc = Code_val(acc);
    env = acc;
    extra_args = 1;
    break;
  case APPLY3 :
    val_t arg1 = pop();
    val_t arg2 = pop();
    val_t arg3 = pop();
    push(Val_int(extra_args));
    push(env);
    push(Val_int(pc));
    push(arg1);
    push(arg2);
    push(arg3);
    pc = Code_val(acc);
    env = acc;
    extra_args = 2;
    break;
    case APPTERM :
      int nargs = read_val(pc++);
      int slotsize = read_val(pc++);
      val_t * newsp;
      int i;
      // TODO Check
      /* Slide the nargs bottom words of the current frame to the top
         of the frame, and discard the remainder of the frame */
      newsp = sp + slotsize - nargs;
      for (i = nargs - 1; i >= 0; i--) newsp[i] = sp[i];
      sp = newsp;
      pc = Code_val(accu);
      env = accu;
      extra_args += nargs - 1;
    break;
  case APPTERM1 :
    int arg = peek(0);
    int r = pop_n(read_val(pc++)-1);
    push(arg);
    pc = Code_val(acc);
    env = acc;
    break;
  case APPTERM2 :
    int arg1 = peek(0);
    int arg2 = peek(1);
    int r = pop_n(read_val(pc++)-2);
    push(arg1);
    push(arg2);
    pc = Code_val(acc);
    env = acc;
    break;
  case APPTERM3 :
    int arg1 = peek(0);
    int arg2 = peek(1);
    int arg3 = peek(2);
    int r = pop_n(read_val(pc++)-3);
    push(arg1);
    push(arg2);
    push(arg3);
    pc = Code_val(acc);
    env = acc;
    break;
  case RETURN :
    int r = pop_n(read_val(pc++));
    if (extra_args > 0){
      extra_args--;
      pc = Code_val(acc);
      env = acc;
    }
    else {
      pc = pop();
      env = pop();
      extra_args = Int_val(pop());
    }
    break;
  case RESTART :
    break;
  default : break;
  }
}
