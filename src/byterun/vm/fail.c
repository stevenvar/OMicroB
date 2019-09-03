#include <setjmp.h>
#include <string.h>

#include "values.h"
#include "gc.h"
#include "fail.h"

/******************************************************************************/

jmp_buf caml_exception_jmp_buf;

void caml_raise(value v) {
  acc = v;
  longjmp(caml_exception_jmp_buf, 1);
}

/******************************************************************************/

void caml_raise_out_of_memory(void) {
  caml_raise(OCAML_Out_of_memory);
}

void caml_raise_stack_overflow(void) {
  caml_raise(OCAML_Stack_overflow);
}

void caml_raise_division_by_zero(void) {
  caml_raise(OCAML_Division_by_zero);
}

/******************************************************************************/

static void caml_raise_exception_with_string(value exn, char const *msg) {
  mlsize_t msg_len = strlen(msg);
  value block;
  mlsize_t str_wosize = Wsize_bsize(msg_len) + 1;
  mlsize_t str_bosize = Bsize_wsize(str_wosize);
  OCamlAlloc(block, str_wosize + 3, String_tag);
  if (block == 0) {
    caml_raise_out_of_memory();
  } else {
    Ram_hd_val(block) = Make_header(str_wosize, String_tag, Color_white);
    Ram_field(block, str_wosize - 1) = 0;
    memcpy(Ram_string_val(block), msg, msg_len);
    Ram_string_val(block)[str_bosize - 1] = str_bosize - msg_len - 1;
    Ram_field(block, str_wosize) = Make_header(2, 0, Color_white);
    Ram_field(block, str_wosize + 1) = exn;
    Ram_field(block, str_wosize + 2) = block;
    caml_raise(Val_dynamic_block(&Ram_field(block, str_wosize + 1)));
  }
}

void caml_raise_invalid_argument(char const *msg) {
  caml_raise_exception_with_string(OCAML_Invalid_argument, msg);
}

void caml_raise_failure(char const *msg) {
  caml_raise_exception_with_string(OCAML_Failure, msg);
}

/******************************************************************************/

void caml_raise_index_out_of_bounds(void) {
  caml_raise_invalid_argument("index out of bounds");
}

/******************************************************************************/
