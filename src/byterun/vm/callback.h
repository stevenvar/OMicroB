/**************************************************************************/
/*                                                                        */
/*                                 OMicroB                                */
/*                                                                        */
/*                          Callback functionalities                      */
/*                     Basile Pesin, Sorbonne University                  */
/*                                                                        */
/**************************************************************************/

#ifndef CAML_CALLBACK_H
#define CAML_CALLBACK_H

// A tester
#define Is_exception_result(v) (((v) & 3) == 2)
#define Extract_exception(v) ((v) & ~3)

value caml_callback(value closure, value arg);
value caml_callback2(value closure, value arg1, value arg2);
value caml_callback3(value closure, value arg1, value arg2, value arg3);
value caml_callbackN(value closure, int narg, value args[]);

value caml_callback_exn(value closure, value arg);
value caml_callbackN_exn(value closure, int narg, value args[]);

#endif
