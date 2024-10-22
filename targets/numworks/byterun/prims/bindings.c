/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __OCAML__
#include <caml/alloc.h>
#endif

#if defined(__OCAML__) || defined(__PC__) || defined(__NUMWORKS__)

#include "prims.h"

value caml_numworks_print_string(value s) {
  #ifdef __OCAML__
  microbit_print_string(String_val(s));
  #else
  int n = caml_string_length(s); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(s, i);
  buf[n] = '\0';
  printf("%s", buf);
  #endif
  return Val_unit;
}

#endif
