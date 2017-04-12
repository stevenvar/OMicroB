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
extern val_t *env;
static val_t *sp;
static val_t *global_data;
static int extra_args;

inline opcode_t read_inst (code_t pc){
  return pgm_read_byte_far(pc);
}

inline val_t read_val (code_t pc){
  return pgm_read_byte_far(pc);
}

inline int read_int (code_t pc){
  return Int_val(read_val(pc));
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
    acc = Field(env, read_val(pc++));
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
      pc = Code_val(acc);
      env = acc;
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
    int nargs = Wosize_val(env) - 2;
    int i;
    for (i = nargs - 1 ; i < 2, i--){
      push(Field(env,i));
    }
    env = Field(env,1);
    extra_args += nargs;
    break;
  case GRAB :
    int n = read_int(pc++);
    if (extra_args >= n){
      extra_args -= n;
    }
    else {
      int i;
      Alloc_small(acc, extra_args + 3, Closure_tag);
      Code_val(acc) = pc - 3;
      Field(acc,1) = env;
      for (i = 0 ; i < n) {
	Field(env,i+1) = pop();
      }
      pc = pop();
      env = pop();
      extra_args = pop();
    }
    break;
  case CLOSURE :
    int n = read_int(pc++);
    val_t ofs = read_int(pc++);
    int i;
    if (n > 0){
      push(acc);
    }
    Alloc_small(acc, n+1, Closure_tag);
    Code_val(acc) = pc + ofs;
    for (i = 0; i < n; i++){
      Field(acc, i+1) = pop();
    }
    break;
  case CLOSUREREC :
    int f = read_int(pc++);
    int v = read_int(pc++);
    int o = read_int(pc++);
    int i;
    if (v > 0){
      push(acc);
    }
    Alloc_small(acc, 2*f - 1 + v, Closure_tag);
    Code_val(acc, pc+o);
    for (i = 0; i < v; i++){
      Field(acc,i+1) = pop();
    }
    for(i = 0; i < 2*f; i++){
      /* Field(acc,i+v) = read_val(pc++); */
      /* The last 2f remaining elements are set to created infix blocks whose values are read from t, each of these infix block being pushed onto the stack (each infix block takes two consecutive fields: the first one being the header, the second one being the actual value). */
      /* TODO */
    }
    break;
  case PUSHOFFSETCLOSUREM2 :
    push(acc);
    /* fallthrough */
  case OFFSETCLOSUREM2 :
    /* value + header */
    acc = env - 2 * sizeof(val_t);
    break;
  case PUSHOFFSETCLOSURE0 :
    push(acc);
    /* fallthrough */
  case OFFSETCLOSURE0 :
    acc = env;
    break;
  case PUSHOFFSETCLOSURE2 :
    push(acc);
    /* fallthrough */
  case OFFSETCLOSURE2 :
    acc = env + 2 * sizeof(val_t);
    break;
  case PUSHOFFSETCLOSURE :
    push(acc);
    /* fallthrough */
  case OFFSETCLOSURE :
    int n = read_int(pc++);
    acc = env + n * sizeof(val_t);
    break;
  case PUSHGETGLOBAL :
    push(acc);
    /* fallthrough */
  case GETGLOBAL :
    int n = read_int(pc++);
    acc = Field(global_data,n);
    break;
  case PUSHGETGLOBALFIELD :
    push(acc);
    /* fallthrough */
  case GETGLOBALFIELD :
    int n = read_int(pc++);
    int p = read_int(pc++);
    acc = Field(Field(global_data,n),p);
    break;
  case SETGLOBAL :
    int n = read_int(pc++);
    Field(global_data,n) = acc;
    acc = Val_unit;
    break;
  case PUSHATOM0 :
    push(acc);
    /* fallthrough */
  case ATOM0 :
    acc = Atom(0);
    break;
  case PUSHATOM :
    push(acc);
    /* fallthrough */
  case ATOM :
    int n = read_int(pc++);
    acc = Atom(n);
    break;
  case MAKEBLOCK :
    int n =read_int(pc++);
    tag_t t = read_val(pc++);
    val_t block;
    Alloc_small(block, n, t);
    Field(block,0) = acc;
    acc = block;
    break;
  case MAKEBLOCK1 :
    tag_t t = read_val(pc++);
    val_t block;
    Alloc_small(block, 1, t);
    Field(block,0) = acc;
    acc = block;
    break;
  case MAKEBLOCK2 :
    tag_t t = read_val(pc++);
    val_t block;
    Alloc_small(block, 2, t);
    Field(block,0) = acc;
    Field(bloc,1) = pop();
    acc = block;
    break;
  case MAKEBLOCK3 :
    tag_t t = read_val(pc++);
    val_t block;
    Alloc_small(block, 3, t);
    Field(block,0) = acc;
    Field(block,1) = pop();
    Field(block,2) = pop();
    acc = block;
    break;
  case GETFIELD0 :
    acc = Field(acc,0);
    break;
  case GETFIELD1 :
    acc = Field(acc,1);
    break;
  case GETFIELD2 :
    acc = Field(acc,2);
    break;
  case GETFIELD3 :
    acc = Field(acc,3);
    break;
  case GETFIELD :
    int n = read_int(pc++);
    acc = Field(acc,n);
    break;
  case GETFLOATFIELD :
    int n = read_int(pc++);
    acc = Field(acc,n);
    /* Double_field */
    break;
  case SETFIELD0 :
    Field(acc,0) = pop();
    acc = Val_unit;
    break;
  case SETFIELD1 :
    Field(acc,1) = pop();
    acc = Val_unit;
    break;
  case SETFIELD2 :
    Field(acc,2) = pop();
    acc = Val_unit;
    break;
  case SETFIELD3 :
    Field(acc,3) = pop();
    acc = Val_unit;
    break;
  case SETFIELD :
    int n = read_int(pc++);
    Field(acc,n) = pop();
    acc = Val_unit;
    break;
  case SETFLOATFIELD :
    int n = read_int(pc++);
    Field(acc,n) = pop();
    /* Double_field ?  */
    acc = Val_unit;
    break;
  case VECTLENGTH :
    acc = Wosize_val(acc);
    break;
  case GETVECTITEM :
    val_t n = pop();
    acc = Field(acc,n);
    break;
  case SETVECTITEM :
    val_t n = pop();
    val_t v = pop();
    Field(acc,Int_val(n)) = v;
    acc = Val_unit;
    break;
  case GETSTRINGCHAR :
    int n = Int_val(pop());
    acc = Val_int(Byte_u(acc, n));
    break;
  case SETSTRINGCHAR :
    int n = Int_val(pop());
    val_t v = pop();
    Byte_u(acc,n);
    acc = Val_unit;
    break;
  case BRANCH :
    int ofs = read_int(pc);
    pc+=ofs;
    break;
  case BRANCHIF :
    int ofs = read_int(pc++);
    if (acc != Val_false){
      /* -1 because pc++ has been done */
      pc += (ofs-1);
    }
    break;
  case BRANCHIFNOT :
    int ofs = read_int(pc++);
    if (acc == Val_false){
      pc+= (ofs-1);
    }
    break;
  case SWITCH :
    int n = read_int(pc++);
    val_t* tab = pc;
    /* (sizeTag << 16) + sizeInt */
    if (Is_int(acc)){
      int idx = Int_val(acc);
      pc += tab[idx];
    }
    else {
      tag_t idx = Tag_val(acc);
      pc += tab[(n & 0xFFFF) + index];
    }
    break;
  case BOOLNOT :
    acc = Val_not(acc);
    break;
  case PUSHTRAP :
    /* TODO */
    break;
  case POPTRAP :
    /* TODO */
    break;
  case RAISE :
    /* TODO */
    break;
  case CHECK_SIGNALS :
    /* TODO */
    break;
  case C_CALL1 :
    int p = read_int(pc++);
    push(env);
    acc = Primitive(p)(acc);
    env = pop();
    break;
  case C_CALL2 :
    int p = read_int(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1]);
    env = pop();
    pop();
    break;
  case C_CALL3 :
    int p = read_int(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1],sp[2]);
    env = pop();
    pop();
    pop();
    break;
  case C_CALL4 :
    int p = read_int(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1],sp[2],sp[3]);
    env = pop();
    pop();
    pop();
    pop();
    break;
  case C_CALL5 :
    int p = read_int(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1],sp[2],sp[3],sp[4]);
    env = pop();
    pop();
    pop();
    pop();
    pop();
    break;
  case C_CALLN :
    int n = read_int(pc++);
    int p = read_int(pc++);
    int i;
    push(env);
    acc = Primitive(p)(sp+1, n);
    env = pop();
    pop_n(n);
    break;
  case CONST0 :
    acc = Val_int(0);
    break;
  default : break;

  }
}
