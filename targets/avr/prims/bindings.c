#ifdef __OCAML__
#include <caml/mlvalues.h>
#else
#include "../vm/values.h"
#endif

#include "prims.h"
#include "../stdlib/random.h"
#include "../stdlib/trace.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#if defined(__OCAML__) || defined(__PC__) || defined(__AVR__)

value caml_avr_adc_init(value unit){
  avr_adc_init();
  return Val_unit;
}

value caml_avr_analog_read(value channel){
  return Val_int(avr_analog_read(Int_val(channel)));
}

/******************************************************************************/

value caml_avr_serial_init(value unit) {
  avr_serial_init();
  return Val_unit;
}

value caml_avr_serial_write(value val) {
  avr_serial_write(Int_val(val));
  return Val_unit;
}

value caml_avr_serial_read(value unit) {
  return Val_int(avr_serial_read());
}

#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
