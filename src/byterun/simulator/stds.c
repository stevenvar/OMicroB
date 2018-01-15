/*************************************************************************/
/*                                                                       */
/*                                OCaPIC                                 */
/*                                                                       */
/*                             Benoit Vaugon                             */
/*                                                                       */
/*    This file is distributed under the terms of the CeCILL license.    */
/*    See file ../../LICENSE-en.                                         */
/*                                                                       */
/*************************************************************************/

#include <time.h>
#include <caml/fail.h>
#include <caml/memory.h>

/* Gc */

CAMLprim value caml_gc_stat(value v);
CAMLprim value caml_gc_full_major(value v);
CAMLprim value caml_gc_minor(value v);

value caml_gc_run(value unit){
  CAMLparam1(unit);
  caml_gc_minor(Val_unit);
  CAMLreturn(Val_unit);
}

value caml_heap_size(value unit){
  return Val_long(0x7 * 256);
}

value caml_stack_size(value unit){
  return Val_long(0xF57 - 0xE00);
}

value caml_gc_compaction(value unit);

value caml_heap_occupation(value unit){
  CAMLparam0();
  CAMLlocal1(stat);
  caml_gc_compaction(unit);
  stat = caml_gc_stat(unit);
  CAMLreturn(Val_long(2 * Long_val(Field(stat, 7))));
}

value caml_stack_occupation(value unit){
  return Val_long(42);
}

value caml_running_number(value unit){
  CAMLparam0();
  CAMLlocal1(stat);
  caml_gc_full_major(Val_unit);
  stat = caml_gc_stat(Val_unit);
  CAMLreturn(Field(stat, 3)); /* minor_collection */
}

/* Random */

value caml_random_bits(value unit){
  return Val_long(random() % 16384);
}

value caml_random_bool(value unit){
  return Val_long(random() % 2 != 0);
}

value caml_random_round(value unit){
  srandom(time(NULL));
  return Val_unit;
}

/* Interrupt */

value caml_set_interruption_handler(value unit){
  return Val_unit;
}

/* Tool */

value caml_raise_ios_failure(value unit){
  caml_failwith("int_of_string");
}

/* Sleep */

value caml_sleep_millis(value time){
  int nb = Long_val(time);
  if(nb <= 0) return Val_unit;
  struct timespec t;
  t.tv_sec  = nb / 1000;
  t.tv_nsec = (nb % 1000) * 1000000;
  nanosleep(&t, NULL);
  return Val_unit;
}
