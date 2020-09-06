/**************************************************************************/
/*                                                                        */
/*                                 OMicroB                                */
/*                                                                        */
/*                          Callback functionalities                      */
/*                     Basile Pesin, Sorbonne University                  */
/*                                                                        */
/**************************************************************************/

#include "callback.h"

value caml_callback(value closure, value arg) {
  value res = caml_callback_exn(closure, arg);
  if (Is_exception_result(res)) caml_raise(Extract_exception(res));
  return res;
}

value caml_callback2(value closure, value arg1, value arg2) {
  value args[2]; args[0] = arg1; args[1] = arg2;
  value res = caml_callbackN_exn(closure, 2, args);
  if (Is_exception_result(res)) caml_raise(Extract_exception(res));
  return res;
}

value caml_callback3(value closure, value arg1, value arg2, value arg3) {
  value args[3]; args[0] = arg1; args[1] = arg2; args[2] = arg3;
  value res = caml_callbackN_exn(closure, 3, args);
  if (Is_exception_result(res)) caml_raise(Extract_exception(res));
  return res;
}

value caml_callbackN(value closure, int narg, value args[]) {
  value res = caml_callbackN_exn(closure, narg, args);
  if (Is_exception_result(res)) caml_raise(Extract_exception(res));
  return res;
}

value caml_callback_exn(value closure, value arg) {
  push(Val_int(0)); // extra-args
  push(env); // env
  push(Val_codeptr(pc)); // return address
  push(arg); // arg

  acc = closure;

  // APPLY 1
  pc = Codeptr_val(Field(acc, 0));
  env = acc;
  extra_args = 0;

  return Val_unit;
}

value caml_callbackN_exn(value closure, int narg, value args[]) {
  push(Val_int(0)); // extra-args
  push(env); // env
  push(Val_codeptr(pc)); // return address
  int i;
  for(i = narg-1; i >= 0; i--) push(args[i]);

  acc = closure;

  // APPLY narg
  pc = Codeptr_val(Field(acc, 0));
  env = acc;
  extra_args = (narg-1);

  return Val_unit;
}

/**************************************************************************/
/* Interrupt handling                                                     */

void declare_waiting_for_interrupt() {
  waiting_for_interrupt = true;
}

void set_interrupt_callback(value closure) {
  interrupt_callback = closure;
}
