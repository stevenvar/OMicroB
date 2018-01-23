#define OCAML_STACK_WOSIZE               32
#define OCAML_HEAP_WOSIZE                32
#define OCAML_HEAP_INITIAL_WOSIZE        20
#define OCAML_STACK_INITIAL_WOSIZE        4
#define OCAML_GLOBDATA_NUMBER            14
#define OCAML_BYTECODE_BSIZE            490
#define OCAML_PRIMITIVE_NUMBER            3
#define OCAML_VIRTUAL_ARCH               32
#define OCAML_STARTING_OOID               0

#define OCAML_GC_MARK_AND_COMPACT

#include </Users/travail/github/OMicroB/src/byterun/vm/values.h>

#define OCAML_ACC0                        0
#define OCAML_ACC1                        1
#define OCAML_ACC2                        2
#define OCAML_PUSH                        3
#define OCAML_PUSHACC1                    4
#define OCAML_PUSHACC2                    5
#define OCAML_PUSHACC3                    6
#define OCAML_PUSHACC4                    7
#define OCAML_PUSHACC5                    8
#define OCAML_POP                         9
#define OCAML_APPLY1                     10
#define OCAML_APPLY2                     11
#define OCAML_APPTERM2                   12
#define OCAML_RETURN                     13
#define OCAML_RESTART                    14
#define OCAML_GRAB                       15
#define OCAML_PUSHGETGLOBAL_1B           16
#define OCAML_BRANCH_1B                  17
#define OCAML_BRANCH_2B                  18
#define OCAML_BRANCHIF_1B                19
#define OCAML_BRANCHIFNOT_1B             20
#define OCAML_SWITCH_1B                  21
#define OCAML_CHECK_SIGNALS              22
#define OCAML_C_CALL2                    23
#define OCAML_CONST0                     24
#define OCAML_CONST1                     25
#define OCAML_CONST2                     26
#define OCAML_CONST3                     27
#define OCAML_CONSTINT_1B                28
#define OCAML_PUSHCONST0                 29
#define OCAML_PUSHCONSTINT_1B            30
#define OCAML_NEQ                        31
#define OCAML_STOP                       32

value ocaml_heap[OCAML_HEAP_WOSIZE] = {
  /*  0 */  Make_header(1, Closure_tag, Color_white),
  /*  1 */  Val_codeptr(409),
  /*  2 */  Make_header(1, Closure_tag, Color_white),
  /*  3 */  Val_codeptr(269),
  /*  4 */  Make_header(1, Closure_tag, Color_white),
  /*  5 */  Val_codeptr(101),
  /*  6 */  Make_header(1, Closure_tag, Color_white),
  /*  7 */  Val_codeptr(365),
  /*  8 */  Make_header(1, Closure_tag, Color_white),
  /*  9 */  Val_codeptr(213),
  /* 10 */  Make_header(1, Closure_tag, Color_white),
  /* 11 */  Val_codeptr(157),
  /* 12 */  Make_header(1, Closure_tag, Color_white),
  /* 13 */  Val_codeptr(317),
  /* 14 */  Make_header(1, Closure_tag, Color_white),
  /* 15 */  Val_codeptr(50),
  /* 16 */  Make_header(1, Closure_tag, Color_white),
  /* 17 */  Val_codeptr(24),
  /* 18 */  Make_header(1, Closure_tag, Color_white),
  /* 19 */  Val_codeptr(3)
};

value acc = Val_block(&ocaml_heap[1]);

value ocaml_stack[OCAML_STACK_WOSIZE] = {
  /*  0 */  Val_int(0),
  /*  1 */  Val_int(0),
  /*  2 */  Val_int(0),
  /*  3 */  Val_int(0),
  /*  4 */  Val_int(0),
  /*  5 */  Val_int(0),
  /*  6 */  Val_int(0),
  /*  7 */  Val_int(0),
  /*  8 */  Val_int(0),
  /*  9 */  Val_int(0),
  /* 10 */  Val_int(0),
  /* 11 */  Val_int(0),
  /* 12 */  Val_int(0),
  /* 13 */  Val_int(0),
  /* 14 */  Val_int(0),
  /* 15 */  Val_int(0),
  /* 16 */  Val_int(0),
  /* 17 */  Val_int(0),
  /* 18 */  Val_int(0),
  /* 19 */  Val_int(0),
  /* 20 */  Val_int(0),
  /* 21 */  Val_int(0),
  /* 22 */  Val_int(0),
  /* 23 */  Val_int(0),
  /* 24 */  Val_int(0),
  /* 25 */  Val_int(0),
  /* 26 */  Val_int(0),
  /* 27 */  Val_int(0),
  /* 28 */  Val_int(0),
  /* 29 */  Val_block(&ocaml_heap[1]),
  /* 30 */  Val_int(8),
  /* 31 */  Val_int(7)
};

value ocaml_global_data[OCAML_GLOBDATA_NUMBER] = {
  /*  0 */  Val_block(&ocaml_heap[3]),
  /*  1 */  Val_block(&ocaml_heap[5]),
  /*  2 */  Val_block(&ocaml_heap[7]),
  /*  3 */  Val_block(&ocaml_heap[9]),
  /*  4 */  Val_block(&ocaml_heap[11]),
  /*  5 */  Val_block(&ocaml_heap[13]),
  /*  6 */  Val_int(10),
  /*  7 */  Val_block(&ocaml_heap[15]),
  /*  8 */  Val_int(9),
  /*  9 */  Val_int(11),
  /* 10 */  Val_int(7),
  /* 11 */  Val_int(8),
  /* 12 */  Val_block(&ocaml_heap[17]),
  /* 13 */  Val_block(&ocaml_heap[19])
};

PROGMEM opcode_t const ocaml_bytecode[OCAML_BYTECODE_BSIZE] = {
  /*   0 */  OCAML_BRANCH_2B, 1, 202,
  /*   3 */  OCAML_ACC0,
  /*   4 */  OCAML_PUSHGETGLOBAL_1B, 0,
  /*   6 */  OCAML_APPLY1,
  /*   7 */  OCAML_PUSHACC1,
  /*   8 */  OCAML_PUSHGETGLOBAL_1B, 1,
  /*  10 */  OCAML_APPLY1,
  /*  11 */  OCAML_PUSH,
  /*  12 */  OCAML_PUSHACC2,
  /*  13 */  OCAML_C_CALL2, 0,
  /*  15 */  OCAML_PUSH,
  /*  16 */  OCAML_PUSHCONST0,
  /*  17 */  OCAML_NEQ,
  /*  18 */  OCAML_BRANCHIFNOT_1B, 3,
  /*  20 */  OCAML_CONST1,
  /*  21 */  OCAML_RETURN, 4,
  /*  23 */  OCAML_RESTART,
  /*  24 */  OCAML_GRAB, 1,
  /*  26 */  OCAML_ACC0,
  /*  27 */  OCAML_PUSHGETGLOBAL_1B, 2,
  /*  29 */  OCAML_APPLY1,
  /*  30 */  OCAML_PUSHACC1,
  /*  31 */  OCAML_PUSHGETGLOBAL_1B, 3,
  /*  33 */  OCAML_APPLY1,
  /*  34 */  OCAML_PUSHACC3,
  /*  35 */  OCAML_BRANCHIFNOT_1B, 8,
  /*  37 */  OCAML_ACC0,
  /*  38 */  OCAML_PUSHACC2,
  /*  39 */  OCAML_C_CALL2, 1,
  /*  41 */  OCAML_RETURN, 4,
  /*  43 */  OCAML_ACC0,
  /*  44 */  OCAML_PUSHACC2,
  /*  45 */  OCAML_C_CALL2, 2,
  /*  47 */  OCAML_RETURN, 4,
  /*  49 */  OCAML_RESTART,
  /*  50 */  OCAML_GRAB, 1,
  /*  52 */  OCAML_ACC0,
  /*  53 */  OCAML_PUSHGETGLOBAL_1B, 2,
  /*  55 */  OCAML_APPLY1,
  /*  56 */  OCAML_PUSHACC1,
  /*  57 */  OCAML_PUSHGETGLOBAL_1B, 3,
  /*  59 */  OCAML_APPLY1,
  /*  60 */  OCAML_PUSHACC2,
  /*  61 */  OCAML_PUSHGETGLOBAL_1B, 4,
  /*  63 */  OCAML_APPLY1,
  /*  64 */  OCAML_PUSHACC3,
  /*  65 */  OCAML_PUSHGETGLOBAL_1B, 5,
  /*  67 */  OCAML_APPLY1,
  /*  68 */  OCAML_PUSHACC5,
  /*  69 */  OCAML_SWITCH_1B, 3, 0, 6, 16, 22,
  /*  75 */  OCAML_ACC1,
  /*  76 */  OCAML_PUSHACC1,
  /*  77 */  OCAML_C_CALL2, 2,
  /*  79 */  OCAML_ACC2,
  /*  80 */  OCAML_PUSHACC4,
  /*  81 */  OCAML_C_CALL2, 2,
  /*  83 */  OCAML_RETURN, 6,
  /*  85 */  OCAML_ACC1,
  /*  86 */  OCAML_PUSHACC1,
  /*  87 */  OCAML_C_CALL2, 1,
  /*  89 */  OCAML_RETURN, 6,
  /*  91 */  OCAML_ACC1,
  /*  92 */  OCAML_PUSHACC1,
  /*  93 */  OCAML_C_CALL2, 2,
  /*  95 */  OCAML_ACC2,
  /*  96 */  OCAML_PUSHACC4,
  /*  97 */  OCAML_C_CALL2, 1,
  /*  99 */  OCAML_RETURN, 6,
  /* 101 */  OCAML_ACC0,
  /* 102 */  OCAML_SWITCH_1B, 24, 0, 27, 30, 33, 36, 39, 43, 47, 43, 39, 51, 43, 47, 43, 47, 30, 33, 27, 36, 47, 43, 51, 39, 33, 36,
  /* 129 */  OCAML_CONST2,
  /* 130 */  OCAML_RETURN, 1,
  /* 132 */  OCAML_CONST3,
  /* 133 */  OCAML_RETURN, 1,
  /* 135 */  OCAML_CONST1,
  /* 136 */  OCAML_RETURN, 1,
  /* 138 */  OCAML_CONST0,
  /* 139 */  OCAML_RETURN, 1,
  /* 141 */  OCAML_CONSTINT_1B, 4,
  /* 143 */  OCAML_RETURN, 1,
  /* 145 */  OCAML_CONSTINT_1B, 6,
  /* 147 */  OCAML_RETURN, 1,
  /* 149 */  OCAML_CONSTINT_1B, 7,
  /* 151 */  OCAML_RETURN, 1,
  /* 153 */  OCAML_CONSTINT_1B, 5,
  /* 155 */  OCAML_RETURN, 1,
  /* 157 */  OCAML_ACC0,
  /* 158 */  OCAML_SWITCH_1B, 24, 0, 27, 30, 33, 36, 39, 43, 47, 43, 39, 51, 43, 47, 43, 47, 30, 33, 27, 36, 47, 43, 51, 39, 33, 36,
  /* 185 */  OCAML_CONST2,
  /* 186 */  OCAML_RETURN, 1,
  /* 188 */  OCAML_CONST3,
  /* 189 */  OCAML_RETURN, 1,
  /* 191 */  OCAML_CONST1,
  /* 192 */  OCAML_RETURN, 1,
  /* 194 */  OCAML_CONST0,
  /* 195 */  OCAML_RETURN, 1,
  /* 197 */  OCAML_CONSTINT_1B, 4,
  /* 199 */  OCAML_RETURN, 1,
  /* 201 */  OCAML_CONSTINT_1B, 6,
  /* 203 */  OCAML_RETURN, 1,
  /* 205 */  OCAML_CONSTINT_1B, 7,
  /* 207 */  OCAML_RETURN, 1,
  /* 209 */  OCAML_CONSTINT_1B, 5,
  /* 211 */  OCAML_RETURN, 1,
  /* 213 */  OCAML_ACC0,
  /* 214 */  OCAML_SWITCH_1B, 24, 0, 27, 30, 33, 36, 39, 43, 47, 43, 39, 51, 43, 47, 43, 47, 30, 33, 27, 36, 47, 43, 51, 39, 33, 36,
  /* 241 */  OCAML_CONST2,
  /* 242 */  OCAML_RETURN, 1,
  /* 244 */  OCAML_CONST3,
  /* 245 */  OCAML_RETURN, 1,
  /* 247 */  OCAML_CONST1,
  /* 248 */  OCAML_RETURN, 1,
  /* 250 */  OCAML_CONST0,
  /* 251 */  OCAML_RETURN, 1,
  /* 253 */  OCAML_CONSTINT_1B, 4,
  /* 255 */  OCAML_RETURN, 1,
  /* 257 */  OCAML_CONSTINT_1B, 6,
  /* 259 */  OCAML_RETURN, 1,
  /* 261 */  OCAML_CONSTINT_1B, 7,
  /* 263 */  OCAML_RETURN, 1,
  /* 265 */  OCAML_CONSTINT_1B, 5,
  /* 267 */  OCAML_RETURN, 1,
  /* 269 */  OCAML_ACC0,
  /* 270 */  OCAML_SWITCH_1B, 24, 0, 31, 31, 31, 31, 31, 35, 31, 27, 39, 39, 39, 39, 31, 35, 39, 39, 39, 39, 43, 43, 43, 43, 43, 43,
  /* 297 */  OCAML_CONSTINT_1B, 13,
  /* 299 */  OCAML_RETURN, 1,
  /* 301 */  OCAML_CONSTINT_1B, 12,
  /* 303 */  OCAML_RETURN, 1,
  /* 305 */  OCAML_CONSTINT_1B, 11,
  /* 307 */  OCAML_RETURN, 1,
  /* 309 */  OCAML_CONSTINT_1B, 10,
  /* 311 */  OCAML_RETURN, 1,
  /* 313 */  OCAML_CONSTINT_1B, 14,
  /* 315 */  OCAML_RETURN, 1,
  /* 317 */  OCAML_ACC0,
  /* 318 */  OCAML_SWITCH_1B, 24, 0, 31, 31, 31, 31, 31, 35, 31, 27, 39, 39, 39, 39, 31, 35, 39, 39, 39, 39, 43, 43, 43, 43, 43, 43,
  /* 345 */  OCAML_CONSTINT_1B, 8,
  /* 347 */  OCAML_RETURN, 1,
  /* 349 */  OCAML_CONSTINT_1B, 7,
  /* 351 */  OCAML_RETURN, 1,
  /* 353 */  OCAML_CONSTINT_1B, 6,
  /* 355 */  OCAML_RETURN, 1,
  /* 357 */  OCAML_CONSTINT_1B, 5,
  /* 359 */  OCAML_RETURN, 1,
  /* 361 */  OCAML_CONSTINT_1B, 9,
  /* 363 */  OCAML_RETURN, 1,
  /* 365 */  OCAML_ACC0,
  /* 366 */  OCAML_SWITCH_1B, 24, 0, 30, 30, 30, 30, 30, 33, 30, 27, 36, 36, 36, 36, 30, 33, 36, 36, 36, 36, 39, 39, 39, 39, 39, 39,
  /* 393 */  OCAML_CONST3,
  /* 394 */  OCAML_RETURN, 1,
  /* 396 */  OCAML_CONST2,
  /* 397 */  OCAML_RETURN, 1,
  /* 399 */  OCAML_CONST1,
  /* 400 */  OCAML_RETURN, 1,
  /* 402 */  OCAML_CONST0,
  /* 403 */  OCAML_RETURN, 1,
  /* 405 */  OCAML_CONSTINT_1B, 4,
  /* 407 */  OCAML_RETURN, 1,
  /* 409 */  OCAML_CONST1,
  /* 410 */  OCAML_PUSHGETGLOBAL_1B, 6,
  /* 412 */  OCAML_PUSHGETGLOBAL_1B, 7,
  /* 414 */  OCAML_APPLY2,
  /* 415 */  OCAML_CONST1,
  /* 416 */  OCAML_PUSHGETGLOBAL_1B, 8,
  /* 418 */  OCAML_PUSHGETGLOBAL_1B, 7,
  /* 420 */  OCAML_APPLY2,
  /* 421 */  OCAML_CONST1,
  /* 422 */  OCAML_PUSHGETGLOBAL_1B, 9,
  /* 424 */  OCAML_PUSHGETGLOBAL_1B, 7,
  /* 426 */  OCAML_APPLY2,
  /* 427 */  OCAML_CONST2,
  /* 428 */  OCAML_PUSHGETGLOBAL_1B, 10,
  /* 430 */  OCAML_PUSHGETGLOBAL_1B, 7,
  /* 432 */  OCAML_APPLY2,
  /* 433 */  OCAML_CONST2,
  /* 434 */  OCAML_PUSHGETGLOBAL_1B, 11,
  /* 436 */  OCAML_PUSHGETGLOBAL_1B, 7,
  /* 438 */  OCAML_APPLY2,
  /* 439 */  OCAML_CONST1,
  /* 440 */  OCAML_PUSHGETGLOBAL_1B, 6,
  /* 442 */  OCAML_PUSHGETGLOBAL_1B, 12,
  /* 444 */  OCAML_APPLY2,
  /* 445 */  OCAML_CONST1,
  /* 446 */  OCAML_PUSHGETGLOBAL_1B, 8,
  /* 448 */  OCAML_PUSHGETGLOBAL_1B, 12,
  /* 450 */  OCAML_APPLY2,
  /* 451 */  OCAML_CONST1,
  /* 452 */  OCAML_PUSHGETGLOBAL_1B, 9,
  /* 454 */  OCAML_PUSHGETGLOBAL_1B, 12,
  /* 456 */  OCAML_APPTERM2, 3,
  /* 458 */  OCAML_APPLY1,
  /* 459 */  OCAML_BRANCH_1B, 25,
  /* 461 */  OCAML_CHECK_SIGNALS,
  /* 462 */  OCAML_ACC2,
  /* 463 */  OCAML_PUSHGETGLOBAL_1B, 13,
  /* 465 */  OCAML_APPLY1,
  /* 466 */  OCAML_PUSHACC2,
  /* 467 */  OCAML_PUSHGETGLOBAL_1B, 13,
  /* 469 */  OCAML_APPLY1,
  /* 470 */  OCAML_PUSHACC1,
  /* 471 */  OCAML_PUSHCONSTINT_1B, 9,
  /* 473 */  OCAML_PUSHGETGLOBAL_1B, 12,
  /* 475 */  OCAML_APPLY2,
  /* 476 */  OCAML_ACC0,
  /* 477 */  OCAML_PUSHCONSTINT_1B, 10,
  /* 479 */  OCAML_PUSHGETGLOBAL_1B, 12,
  /* 481 */  OCAML_APPLY2,
  /* 482 */  OCAML_POP, 2,
  /* 484 */  OCAML_CONST1,
  /* 485 */  OCAML_BRANCHIF_1B, (opcode_t) -24,
  /* 487 */  OCAML_POP, 3,
  /* 489 */  OCAML_STOP
};

#include </Users/travail/github/OMicroB/src/byterun/vm/runtime.c>

PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {
  /*  0 */  (void *) &caml_avr_read_bit,
  /*  1 */  (void *) &caml_avr_set_bit,
  /*  2 */  (void *) &caml_avr_clear_bit,
};
