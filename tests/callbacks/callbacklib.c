#ifdef __OCAML__
#include <caml/mlvalues.h>
#else
#include "../../src/byterun/vm/values.h"
#endif

#include "../../src/byterun/vm/callback.h"

// These bindings would be contained inside bindings.c
value callback_test_1(value v) {
  caml_callback(v, Val_int(41));
  return Val_unit;
}

value callback_test_2(value v) {
  caml_callback2(v, Val_int(61), Val_int(20));
  return Val_unit;
}

value callback_test_3(value v) {
  caml_callback3(v, Val_int(25), Val_int(25), Val_int(9));
  return Val_unit;
}

value callback_test_6(value v) {
  value args[6];
  args[0] = Val_int(31); args[1] = Val_int(14); args[2] = Val_int(17);
  args[3] = Val_int(5); args[4] = Val_int(22); args[5] = Val_int(10);
  caml_callbackN(v, 6, args);
  return Val_unit;
}
