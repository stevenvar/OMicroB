#include <stdint.h>
#include <avr/pgmspace.h>
#include "inst.h"
#include "values.h"

/* Registers for the abstract machine:
   pc          the code pointer
   sp          the stack pointer (grows downward)
   accu        the accumulator
   env         heap-allocated environment
   caml_trapsp pointer to the current trap frame
   extra_args  number of extra arguments provided by the caller
*/

#define Trap_link(tp) (((val_t **)(tp))[1])
#define Trap_pc(tp) (((code_t *)(tp))[0])

static code_t pc;
static val_t acc;
extern val_t *stack_end;
extern val_t env;
static val_t *sp;
static val_t *trapSp;
static val_t *global_data;
static int extra_args;

opcode_t read_inst (code_t pc){
  return pgm_read_byte_near(pc);
}

val_t read_val (code_t pc){
  return read_inst(pc);
}

int read_int (code_t pc){
  return (int)read_val(pc);
}

val_t peek (int n){
  return sp[(val_t) n];
}

val_t push (val_t x){
  *(sp--) = x;
}

val_t pop (){
  return *(sp++);
}

val_t pop_n (int n){
  sp += (val_t) n;
  return *(sp);
}


val_t interp_inst (){
  opcode_t curr_inst = read_inst(pc++);
  int n, nargs, slotsize,i,f,v,o,p;
  int ofs;
  val_t arg, arg1,arg2,arg3, *new_sp, r, block, val, *tab,x,y;
  tag_t t;
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
    n = read_int(pc++);
    acc = peek(n);
    break;
  case PUSH :
    /* fallthrough */
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
    n = read_int(pc++);
    push(acc);
    acc = peek(n+1);
    break;
  case POP :
    sp += read_val(pc++);
    break;
  case ASSIGN :
    n = read_int(pc++);
    sp[n] = acc;
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
    read_int(pc++);
    push(Val_int(extra_args));
    push(env);
    /* Something's not right here : an AVR pointer is 16bits
     while a val_t can be 32 bits */
    push(pc + ofs);
    break;
  case APPLY :
    extra_args = read_val(pc++) - 1;
    pc = Code_val(acc);
    env = acc;
    break;
  case APPLY1 :
    arg1 = pop();
    push(Val_int(extra_args));
    push(env);
    push(Val_int(pc));
    push(arg1);
    pc = Code_val(acc);
    env = acc;
    extra_args = 0;
    break;
  case APPLY2 :
    arg1 = pop();
    arg2 = pop();
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
    arg1 = pop();
    arg2 = pop();
    arg3 = pop();
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
      nargs = read_val(pc++);
      slotsize = read_val(pc++);
      // TODO Check
      /* Slide the nargs bottom words of the current frame to the top
         of the frame, and discard the remainder of the frame */
      val_t * newsp = sp + slotsize - nargs;
      for (i = nargs - 1; i >= 0; i--) {
	newsp[i] = sp[i];
      }
      sp = newsp;
      pc = Code_val(acc);
      env = acc;
      extra_args += nargs - 1;
    break;
  case APPTERM1 :
    arg = peek(0);
    r = pop_n(read_val(pc++)-1);
    push(arg);
    pc = Code_val(acc);
    env = acc;
    break;
  case APPTERM2 :
    arg1 = peek(0);
    arg2 = peek(1);
    r = pop_n(read_val(pc++)-2);
    push(arg1);
    push(arg2);
    pc = Code_val(acc);
    env = acc;
    break;
  case APPTERM3 :
    arg1 = peek(0);
    arg2 = peek(1);
    arg3 = peek(2);
    r = pop_n(read_val(pc++)-3);
    push(arg1);
    push(arg2);
    push(arg3);
    pc = Code_val(acc);
    env = acc;
    break;
  case RETURN :
    r = pop_n(read_val(pc++));
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
    nargs =  Wosize_val(env) - 2;
    for (i = nargs - 1 ; i < 2; i--){
      push(Field(env,i));
    }
    env = Field(env,1);
    extra_args += nargs;
    break;
  case GRAB :
    n = read_int(pc++);
    if (extra_args >= n){
      extra_args -= n;
    }
    else {
      Alloc_small(acc, extra_args + 3, Closure_tag);
      Code_val(acc) = pc - 3;
      Field(acc,1) = env;
      for (i = 0 ; i < n; i++) {
	Field(env,i+1) = pop();
      }
      pc = pop();
      env = pop();
      extra_args = pop();
    }
    break;
  case CLOSURE :
    n = read_int(pc++);
    ofs = read_int(pc++);
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
    f = read_int(pc++);
    v = read_int(pc++);
    o = read_int(pc++);
    if (v > 0){
      push(acc);
    }
    Alloc_small(acc, 2*f - 1 + v, Closure_tag);
    Field(acc,0) = pc+o;
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
    n = read_int(pc++);
    acc = env + n * sizeof(val_t);
    break;
  case PUSHGETGLOBAL :
    push(acc);
    /* fallthrough */
  case GETGLOBAL :
    n = read_int(pc++);
    acc = Field(global_data,n);
    break;
  case PUSHGETGLOBALFIELD :
    push(acc);
    /* fallthrough */
  case GETGLOBALFIELD :
    n = read_int(pc++);
    p = read_int(pc++);
    acc = Field(Field(global_data,n),p);
    break;
  case SETGLOBAL :
    n = read_int(pc++);
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
    n = read_int(pc++);
    acc = Atom(n);
    break;
  case MAKEBLOCK :
    n =read_int(pc++);
    t = read_val(pc++);
    Alloc_small(block, n, t);
    Field(block,0) = acc;
    acc = block;
    break;
  case MAKEBLOCK1 :
    t = read_val(pc++);
    Alloc_small(block, 1, t);
    Field(block,0) = acc;
    acc = block;
    break;
  case MAKEBLOCK2 :
    t = read_val(pc++);
    Alloc_small(block, 2, t);
    Field(block,0) = acc;
    Field(block,1) = pop();
    acc = block;
    break;
  case MAKEBLOCK3 :
    t = read_val(pc++);
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
    n = read_int(pc++);
    acc = Field(acc,n);
    break;
  case GETFLOATFIELD :
    n = read_int(pc++);
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
    n = read_int(pc++);
    Field(acc,n) = pop();
    acc = Val_unit;
    break;
  case SETFLOATFIELD :
    n = read_int(pc++);
    Field(acc,n) = pop();
    /* Double_field ?  */
    acc = Val_unit;
    break;
  case VECTLENGTH :
    acc = Wosize_val(acc);
    break;
  case GETVECTITEM :
    n = pop();
    acc = Field(acc,n);
    break;
  case SETVECTITEM :
    n = pop();
    val = pop();
    Field(acc,Int_val(n)) = val;
    acc = Val_unit;
    break;
  case GETSTRINGCHAR :
    n = Int_val(pop());
    acc = Val_int(Byte_u(acc, n));
    break;
  case SETSTRINGCHAR :
    n = Int_val(pop());
    val = pop();
    Byte_u(acc,n) = v;
    acc = Val_unit;
    break;
  case BRANCH :
    ofs = read_int(pc);
    pc+=ofs;
    break;
  case BRANCHIF :
    ofs = read_int(pc++);
    if (acc != Val_false){
      /* -1 because pc++ has been done */
      pc += (ofs-1);
    }
    break;
  case BRANCHIFNOT :
    ofs = read_int(pc++);
    if (acc == Val_false){
      pc+= (ofs-1);
    }
    break;
  case SWITCH :
    n = read_int(pc++);
    tab = pc;
    /* (sizeTag << 16) + sizeInt */
    if (Is_int(acc)){
      int idx = Int_val(acc);
      pc += tab[idx];
    }
    else {
      int idx = Tag_val(acc);
      pc += tab[(n & 0xFFFF) + idx];
    }
    break;
  case BOOLNOT :
    acc = Val_not(acc);
    break;
  case PUSHTRAP :
    ofs = read_val(pc++);
    push(Val_int(extra_args));
    push((val_t)trapSp);
    push((val_t)(pc+ofs));
    trapSp = sp;
    break;
  case POPTRAP :
    pop();
    trapSp = pop();
    pop();
    pop();
    break;
  case RAISE :
    /* : If no stack frame is defined,
       stops the execution print- ing the exception. TODO */
    if (*trapSp == Val_unit){
      return Val_unit;
    }
    sp = trapSp;
    pc = pop();
    trapSp = pop();
    env = pop();
    extra_args = pop();
    break;
  case CHECK_SIGNALS :
    /* TODO */
    break;
  case C_CALL1 :
    p = read_int(pc++);
    push(env);
    /* acc = Primitive(p)(acc); */
    env = pop();
    break;
  case C_CALL2 :
    p = read_int(pc++);
    push(env);
    /* acc = Primitive(p)(acc,sp[1]); */
    env = pop();
    pop();
    break;
  case C_CALL3 :
    p = read_int(pc++);
    push(env);
    /* acc = Primitive(p)(acc,sp[1],sp[2]); */
    env = pop();
    pop();
    pop();
    break;
  case C_CALL4 :
    p = read_int(pc++);
    push(env);
    /* acc = Primitive(p)(acc,sp[1],sp[2],sp[3]); */
    env = pop();
    pop();
    pop();
    pop();
    break;
  case C_CALL5 :
    p = read_int(pc++);
    push(env);
    /* acc = Primitive(p)(acc,sp[1],sp[2],sp[3],sp[4]); */
    env = pop();
    pop();
    pop();
    pop();
    pop();
    break;
  case C_CALLN :
    n = read_int(pc++);
    p = read_int(pc++);
    i;
    push(env);
    /* acc = Primitive(p)(sp+1, n); */
    env = pop();
    pop_n(n);
    break;
  case PUSHCONST0 :
    push(acc);
    /* fallthrough */
  case CONST0 :
    acc = Val_int(0);
    break;
  case PUSHCONST1 :
    push(acc);
    /* fallthrough */
  case CONST1 :
    acc = Val_int(1);
    break;
  case PUSHCONST2 :
    push(acc);
    /* fallthrough */
  case CONST2 :
    acc = Val_int(2);
    break;
  case PUSHCONST3 :
    push(acc);
    /* fallthrough */
  case CONST3 :
    acc = Val_int(3);
    break;
  case PUSHCONSTINT :
    push(acc);
    /* fallthrough */
  case CONSTINT :
    n = read_int(pc++);
    acc = Val_int(n);
    break;
  case NEGINT :
    acc = NegInt(acc);
    /* TODO MACRO */
    break;
  case ADDINT :
    /* acc = AddInt(acc,pop()); */
    acc = Val_int((Int_val(acc) + Int_val(op())));
    /* TODO MACRO */
    break;
  case SUBINT :
    /* acc = SubInt(acc,pop()); */
    acc = Val_int((Int_val(acc) - Int_val(op())));
    /* TODO MACRO */
    break;
  case MULINT :
    /* acc = MulInt(acc,pop()); */
    acc = Val_int((Int_val(acc) * Int_val(op())));
    /* TODO MACRO */
    break;
  case DIVINT :
    /* acc = DivInt(acc,pop()); */
    acc = Val_int((Int_val(acc) / Int_val(op())));
    /* TODO MACRO */
    break;
  case MODINT :
    /* acc = ModInt(acc,pop()); */
    acc = Val_int((Int_val(acc) % Int_val(op())));
    /* TODO MACRO */
    break;
  case ANDINT :
    /* acc = AndInt(acc,pop()); */
    acc = Val_int((Int_val(acc) & Int_val(op())));
    /* TODO MACRO */
    break;
  case ORINT :
    /* acc = OrInt(acc,pop()); */
    acc = Val_int((Int_val(acc) | Int_val(op())));
    /* TODO MACRO */
    break;
  case XORINT :
    /* acc = XorInt(acc,pop()); */
    acc = Val_int((Int_val(acc) ^ Int_val(op())));
    /* TODO MACRO */
    break;
  case LSLINT :
    /* acc = LslInt(acc,pop()); */
    /* TODO MACRO */
    break;
 case LSRINT :
    /* acc = LsrInt(acc,pop()); */
    /* TODO MACRO */
    break;
  case ASRINT :
    /* acc = AsrInt(acc,pop()); */
    /* TODO MACRO */
    break;
  case EQ :
    acc = (acc == pop()) ? Val_int(1) : Val_int(0);
    break;
  case NEQ :
    acc = (acc == pop()) ? Val_int(0) : Val_int(1);
    break;
  case LTINT :
    acc = (acc < pop()) ? Val_int(0) : Val_int(1);
    break;
  case LEINT :
    acc = (acc <= pop()) ? Val_int(0) : Val_int(1);
    break;
  case GTINT :
    acc = (acc > pop()) ? Val_int(0) : Val_int(1);
    break;
  case GEINT :
    acc = (acc >= pop()) ? Val_int(0) : Val_int(1);
    break;
  case OFFSETINT :
    ofs = read_int(pc++);
    acc += Val_int(ofs);
    break;
  case OFFSETREF :
    ofs = read_int(pc++);
    Field(acc,0) += Val_int(ofs);
    acc = Val_unit;
    break;
  case ISINT :
    acc = Is_int(acc) ? Val_int(1) : Val_int(0);
    break;
  case GETMETHOD :
    x = peek(0);
    y = Field(x,0);
    acc = Field(y,Int_val(acc));
    break;
  case BEQ :
    val = read_val(pc++);
    ofs = read_int(pc);
    if (val == acc){
      pc += ofs - 1;
    }
    else {
      pc++;
    }
    break;
  case BNEQ :
    val = read_val(pc++);
    ofs = read_int(pc);
    if (val != acc){
      pc += ofs - 1;
    }
    else {
      pc++;
    }
    break;
  case BLTINT :
    val = read_val(pc++);
    ofs = read_int(pc);
    if (val < acc){
      pc += ofs -1;
    }
    break;
  /* case BLEINT : break; */
  /* case BGTINT : break; */
  /* case BGEINT : break; */
  /* case ULTINT : break; */
  /* case UGEINT : break; */
  /* case BULTINT : break; */
  /* case BUGEINT : break; */
  /* case GETPUBMET : break; */
  /* case GETDYNMET : break; */
  case STOP :
    return acc;
    break;
  /* case EVENT : break; */
  /* case BREAK : break; */
  default : break;
  }
  return Val_unit;
}


void interp(){
  sp = stack_end;
  *trapSp = Val_unit;
  env = Val_unit;
  for(;;){
    interp_inst();
  }
}
