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


#define Alloc_small(a,b,c) (a)

val_t atom0_header;
val_t atom0;


static code_t pc;
static val_t acc;
/* extern val_t *stack_end; */
/* extern val_t env; */
val_t* stack_end;
val_t env;
static val_t *sp;
static val_t *trapSp;
static val_t *global_data;
static int extra_args;

static int cpt;

/* static inst myArray[8] = { CONSTINT, 0x00, 0x00, 0x00, 0x03, PUSH, CONST2, STOP}; */
static inst myArray[100] = { CONST1, PUSH, CONST2, PUSH, CONST3, PUSH, STOP};

static val_t fakeStack[1000];

void print_stack(){
  val_t i;
  printf("STACK = [%d; %d] \n", stack_end, sp);
  for (i = 0; i <= (stack_end-sp) ; i++ ){
    printf(">[%d] = %d \n",i, Int_val(sp[i]));
  }
}

opcode_t read_inst (code_t pc){
  return pgm_read_byte_near(pc);
}

opcode_t read_byte (code_t pc){
  return read_inst(pc);
}

val_t read_val (code_t pc){
  val_t v = 0;
  int i;
  for (i = 0; i < 4; i++){
    v = (v << 8) | read_inst(pc++);
  }
  return v;
}

code_t read_ptr (code_t pc){
  return read_val(pc);
}

uint16_t read_global_index(code_t pc){
 val_t v = 0;
  int i;
  for (i = 0; i < 2; i++){
    v = (v << 8) | read_inst(pc++);
  }
  return v;
}

int32_t read_int (code_t pc){
  return read_val(pc);
}



val_t peek (int n){
  return sp[(val_t) n+1];
}

void push (val_t x){
  *sp = x;
  sp--;
}

val_t pop (){
  return *(++sp);
}

void pop_n (int n){
  sp += n;
}


val_t interp_inst (){
  opcode_t curr_inst = read_inst(pc++);
  printf("%d\n",curr_inst);
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
  case ACC : {
    uint8_t n = read_byte(pc++);
    acc = peek(n);
    break;
  }
  case PUSH :
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
  case PUSHACC : {
    uint8_t n = read_byte(pc++);
    push(acc);
    acc = peek(n);
    break;
  }
  case POP :
    pop_n(read_byte(pc++));
    break;
  case ASSIGN : {
    uint8_t n = read_byte(pc++);
    sp[n] = acc;
    acc = Val_unit;
    break;
  }
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
    acc = Field(env, read_byte(pc++));
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
    acc = Field(env,read_byte(pc++));
    break;
  case PUSH_RETADDR : {
    code_t ofs = read_ptr(pc++);
    push(Val_int(extra_args));
    push(env);
    push(pc + ofs);
    break;
  }
  case APPLY :
    extra_args = read_byte(pc++) - 1;
    pc = Code_val(acc);
    env = acc;
    break;
  case APPLY1 : {
    val_t arg1 = pop();
    push(Val_int(extra_args));
    push(env);
    push(pc);
    push(arg1);
    pc = Code_val(acc);
    env = acc;
    extra_args = 0;
    break;
  }
  case APPLY2 : {
    val_t arg1 = pop();
    val_t arg2 = pop();
    push(Val_int(extra_args));
    push(env);
    push(pc);
    push(arg1);
    push(arg2);
    pc = Code_val(acc);
    env = acc;
    extra_args = 1;
    break;
  }
  case APPLY3 : {
    val_t arg1 = pop();
    val_t arg2 = pop();
    val_t arg3 = pop();
    push(Val_int(extra_args));
    push(env);
    push(pc);
    push(arg1);
    push(arg2);
    push(arg3);
    pc = Code_val(acc);
    env = acc;
    extra_args = 2;
    break;
  }
  case APPTERM : {
    uint8_t nargs = read_byte(pc++);
    uint8_t slotsize = read_byte(pc++);
    val_t * newsp = sp + slotsize - nargs;
    for (i = nargs ; i > 0; i--) {
      newsp[i] = sp[i];
    }
    sp = newsp;
    pc = Code_val(acc);
    env = acc;
    extra_args += nargs - 1;
    break;
  }
  case APPTERM1 : {
    val_t arg = peek(0);
    pop_n(read_byte(pc++)-1);
    push(arg);
    pc = Code_val(acc);
    env = acc;
    break;
  }
  case APPTERM2 : {
    val_t arg1 = peek(0);
    val_t arg2 = peek(1);
    pop_n(read_byte(pc++)-2);
    push(arg1);
    push(arg2);
    pc = Code_val(acc);
    env = acc;
    extra_args++;
    break;
  }
  case APPTERM3 : {
    val_t arg1 = peek(0);
    val_t arg2 = peek(1);
    val_t arg3 = peek(2);
    pop_n(read_byte(pc++)-3);
    push(arg1);
    push(arg2);
    push(arg3);
    pc = Code_val(acc);
    env = acc;
    extra_args+=2;
    break;
  }
  case RETURN :
    pop_n(read_byte(pc++));
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
  case RESTART : {
    uint8_t nargs = Wosize_val(env) - 2;
    uint8_t i;
    sp -= nargs;
    for (i = 1; i <= nargs; i++) sp[i] = Field(env, i + 1);
    env = Field(env,1);
    extra_args += nargs;
    break;
  }
  case GRAB : {
    uint8_t n = read_byte(pc++);
    uint8_t i;
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
  }
  case CLOSURE : {
    uint8_t n = read_byte(pc++);
    uint8_t ofs = read_byte(pc++);
    uint8_t i;
    if (n != 0){
      push(acc);
    }
    Alloc_small(acc, n+1, Closure_tag);
    Code_val(acc) = pc + ofs;
    for (i = 0; i < n; i++){
      Field(acc, i+1) = pop();
    }
    break;
  }
  case CLOSUREREC : {
    uint8_t f = read_byte(pc++);
    uint8_t v = read_byte(pc++);
    code_t ofs = read_ptr(pc++);
    if (v > 0){
      push(acc);
    }
    Alloc_small(acc, 2*f - 1 + v, Closure_tag);
    Field(acc,0) = pc+ofs;
    for(i = 1; i < f; i++){
      Field(acc,2*i-1) = Make_header(2*i, Infix_tag);
      Field(acc,2*i) = pc+read_ptr(pc);
      pc++;
    }
    for (; i< 2*f -1 + v ; i++){
      Field(acc,i+2*f-1) = pop();
    }
    break;
  }
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
    n = read_byte(pc++);
    acc = env + n * sizeof(val_t);
    break;
  case PUSHGETGLOBAL :
    push(acc);
    /* fallthrough */
  case GETGLOBAL : {
    uint16_t n = read_global_index(pc++);
    acc = global_data[n];
    break;
  }
  case PUSHGETGLOBALFIELD :
    push(acc);
    /* fallthrough */
  case GETGLOBALFIELD : {
    uint16_t n = read_global_index(pc++);
    p = read_byte(pc++);
    acc = Field(global_data[n],p);
    break;
  }
  case SETGLOBAL : {
    uint16_t n = read_global_index(pc++);
    global_data[n] = acc;
    acc = Val_unit;
    break;
  }
  case PUSHATOM0 :
    push(acc);
    /* fallthrough */
  case ATOM0 :
    acc = atom0;
    break;
  case MAKEBLOCK : {
    uint8_t n = read_byte(pc++);
    tag_t t = read_byte(pc++);
    Alloc_small(block, n, t);
    Field(block,0) = acc;
    for (i = 1; i < n; i++) Field(block, i) = pop();
    acc = block;
    break;
  }
  case MAKEBLOCK1 : {
    tag_t t = read_byte(pc++);
    Alloc_small(block, 1, t);
    Field(block,0) = acc;
    acc = block;
    break;
  }
  case MAKEBLOCK2 : {
    tag_t t = read_byte(pc++);
    Alloc_small(block, 2, t);
    Field(block,0) = acc;
    Field(block,1) = pop();
    acc = block;
    break;
  }
  case MAKEBLOCK3 : {
    tag_t t = read_byte(pc++);
    Alloc_small(block, 3, t);
    Field(block,0) = acc;
    Field(block,1) = pop();
    Field(block,2) = pop();
    acc = block;
    break;
  }
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
  case GETFIELD : {
    uint8_t n = read_byte(pc++);
    acc = Field(acc,n);
    break;
  }
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
  case SETFIELD : {
    uint8_t n = read_byte(pc++);
    Field(acc,n) = pop();
    acc = Val_unit;
    break;
  }
  case VECTLENGTH :
    acc = Wosize_val(acc);
    break;
  case GETVECTITEM : {
    uint8_t n = pop();
    acc = Field(acc,n);
    break;
  }
  case SETVECTITEM : {
    val_t n = pop();
    val_t val = pop();
    Field(acc,Int_val(n)) = val;
    acc = Val_unit;
    break;
  }
  case GETSTRINGCHAR : {
    val_t n = pop();
    acc = Val_int(Byte_u(acc, Int_val(n)));
    break;
  }
  case SETSTRINGCHAR : {
    val_t n = pop();
    val_t val = pop();
    Byte_u(acc,Int_val(n)) = v;
    acc = Val_unit;
    break;
  }
  case BRANCH : {
    code_t ofs = read_ptr(pc);
    pc+=ofs;
    break;
  }
  case BRANCHIF : {
    code_t ofs = read_ptr(pc++);
    if (acc != Val_false){
      /* -1 because pc++ has been done */
      pc += (ofs-1);
    }
    break;
  }
  case BRANCHIFNOT : {
    code_t ofs = read_ptr(pc++);
    if (acc == Val_false){
      pc+= (ofs-1);
    }
    break;
  }
  case SWITCH : {
    uint8_t n = read_byte(pc++);
    uint8_t t = read_byte(pc++);
    /* tab = pc; */
    /* (sizeTag << 16) + sizeInt */
    if (Is_int(acc)){
      code_t idx = Int_val(acc);
      pc += read_byte(pc+idx);
    }
    else {
      tag_t idx = Tag_val(acc);
      pc += tab[(n & 0xFFFF) + idx];
    }
    break;
  }
  case BOOLNOT :
    acc = Val_not(acc);
    break;
  case PUSHTRAP : {
    code_t ofs = read_ptr(pc++);
    push(Val_int(extra_args));
    push(trapSp);
    push(pc+ofs);
    trapSp = sp;
    break;
  }
  case POPTRAP :
    pop();
    trapSp = pop();
    pop();
    pop();
    break;
  case RAISE :
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
  case C_CALL1 : {
    uint8_t p = read_byte(pc++);
    push(env);
    acc = Primitive(p)(acc);
    env = pop();
    break;
  }
  case C_CALL2 : {
    uint8_t p = read_byte(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1]);
    env = pop();
    pop();
    break;
  }
  case C_CALL3 : {
    uint8_t p =read_byte(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1],sp[2]);
    env = pop();
    pop();
    pop();
    break;
  }
  case C_CALL4 : {
    uint8_t p =read_byte(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1],sp[2],sp[3]);
    env = pop();
    pop();
    pop();
    pop();
    break;
  }
  case C_CALL5 : {
    uint8_t p =read_byte(pc++);
    push(env);
    acc = Primitive(p)(acc,sp[1],sp[2],sp[3],sp[4]);
    env = pop();
    pop();
    pop();
    pop();
    pop();
    break;
  }
  case C_CALLN : {
    n = read_int(pc++);
    uint8_t p = read_byte(pc++);
    i;
    push(env);
    acc = Primitive(p)(sp+1, n);
    env = pop();
    pop_n(n);
    break;
  }
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
    goto CONSTINT;
    /* fallthrough */
  case CONSTINT :
    acc = Val_int(read_val(pc++));
    break;
  case NEGINT :
    /* acc = NegInt(acc); */
    acc = Val_int (-Int_val (acc));
    /* TODO MACRO */
    break;
  case ADDINT :
    /* acc = AddInt(acc,pop()); */
    acc = Val_int((Int_val(acc) + Int_val(pop())));
    /* TODO MACRO */
    break;
  case SUBINT :
    /* acc = SubInt(acc,pop()); */
    acc = Val_int((Int_val(acc) - Int_val(pop())));
    /* TODO MACRO */
    break;
  case MULINT :
    /* acc = MulInt(acc,pop()); */
    acc = Val_int((Int_val(acc) * Int_val(pop())));
    /* TODO MACRO */
    break;
  case DIVINT : {
    int32_t divisor = Int_val(pop());
    if (divisor == 0){
      caml_raise_zero_divide();
    }
    acc = Val_int(Int_val(acc) / divisor);
    break;
  }
  case MODINT : {
    int32_t divisor = Int_val(pop());
    if (divisor == 0){
      caml_raise_zero_divide();
    }
    acc = Val_int(Int_val(acc) % divisor);
    /* TODO MACRO */
    break;
  }
  case ANDINT :
    /* acc = AndInt(acc,pop()); */
    acc = Val_int((Int_val(acc) & Int_val(pop())));
    /* TODO MACRO */
    break;
  case ORINT :
    /* acc = OrInt(acc,pop()); */
    acc = Val_int((Int_val(acc) | Int_val(pop())));
    /* TODO MACRO */
    break;
  case XORINT :
    /* acc = XorInt(acc,pop()); */
    acc = Val_int(Int_val(acc) ^ Int_val(pop()));
    /* TODO MACRO */
    break;
  case LSLINT :
    acc = Val_int(Int_val(acc) << Int_val(pop()));
    /* acc = LslInt(acc,pop()); */
    /* TODO MACRO */
    break;
 case LSRINT :
   acc = Val_int((uval_t)(Int_val(acc)) >> Int_val(pop()));
    /* acc = LsrInt(acc,pop()); */
    /* TODO MACRO */
    break;
  case ASRINT :
    acc = Val_int(Int_val(acc) >> Int_val(pop()));
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
  case ULTINT :
    acc = ((uval_t)acc < (uval_t)pop()) ? Val_int(0) : Val_int(1);
    break;
  case UGEINT :
    acc = ((uval_t)acc >= (uval_t)pop()) ? Val_int(0) : Val_int(1);
    break;
  case OFFSETINT : {
    int32_t ofs = read_int(pc++);
    acc = Val_int(Int_val(acc) + ofs);
    break;
  }
  case OFFSETREF : {
    int32_t ofs = read_int(pc++);
    Field(acc,0) = Val_int (Int_val(Field(acc,0)) + ofs);
    acc = Val_unit;
    break;
  }
  case ISINT :
    acc = Is_int(acc) ? Val_int(1) : Val_int(0);
    break;
  case GETMETHOD : {
    val_t x = peek(0);
    val_t y = Field(x,0);
    acc = Field(y,Int_val(acc));
    break;
  }
  case BEQ : {
    val_t val = read_val(pc++);
    code_t ofs = read_ptr(pc);
    if (val == acc){
      pc += ofs - 1;
    }
    else {
      pc++;
    }
    break;
  }
  case BNEQ : {
    val_t val = read_val(pc++);
    code_t ofs = read_ptr(pc);
    if (val != acc){
      pc += ofs - 1;
    }
    else {
      pc++;
    }
    break;
  }
  case BLTINT : {
    val_t val = read_val(pc++);
    code_t ofs = read_ptr(pc);
    if (val < acc){
      pc += ofs -1;
    }
    else{
      pc++;
    }
    break;
  }
    case BLEINT : {
      val_t val = read_val(pc++);
      code_t ofs = read_ptr(pc);
      if (val <= acc){
	pc += ofs -1;
      }
      else{
	pc++;
      }
      break;
    }
  case BGTINT : {
    val_t val = read_val(pc++);
    code_t ofs = read_ptr(pc);
    if (val > acc){
      pc += ofs -1;
    }
    else{
      pc++;
    }
    break;
  }
  case BGEINT : {
    val_t val = read_val(pc++);
    code_t ofs = read_ptr(pc);
    if (val >= acc){
      pc += ofs -1;
    }
    else{
      pc++;
    }
    break;
  }

  case BULTINT : {
    uval_t val = read_val(pc++);
    code_t ofs = read_ptr(pc);
    if (val < (uval_t)acc){
      pc += ofs -1;
    }
    else{
      pc++;
    }
    break;
  }
  case BUGEINT : {
    uval_t val = read_val(pc++);
    code_t ofs = read_ptr(pc);
    if (val >= (uval_t)acc){
      pc += ofs -1;
    }
    else{
      pc++;
    }
    break;
  }
  case GETPUBMET : {
    int32_t tag = read_int(pc++);
    push(acc);
    acc = Val_int(tag);
    /* fallthrough */
  }
  case GETDYNMET : {
    val_t meths = Field(peek(0),0);
    int li = 3, hi = Field(meths,0), mi;
    while (li < hi){
      mi = ((li+hi) >> 1) | 1;
      if (acc < Field (meths,mi)){
	hi = mi-2;
      }
      else {
	li = mi;
      }
    }
    acc = Field(meths,li-1);
  }
    break;
  case STOP :
    return acc;
    break;
  case EVENT : break;
  case BREAK : break;
  default : break;
  }
  return Val_unit;
}


void interp(){
  atom0_header = Make_header(0,0);
  atom0 = Val_block(&atom0_header+1);
  stack_end = fakeStack + sizeof(val_t) * 1000;
  sp = stack_end;
  trapSp = Val_unit;
  env = Val_unit;
  cpt = 0;
  pc = 0;
  for(int i = 0; i < 10; i++){
    print_stack();
    interp_inst();
  }
}

int main(int argc, char** argv){
  interp();
  return 0;
}
