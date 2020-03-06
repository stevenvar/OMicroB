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


value caml_init_system() {
  init_system();
  return Val_unit;
}

value caml_init_interrupts(value mode) {
  init_interrupts(Int_val(mode));
  return Val_unit;
}


value caml_enable_int_adc() {
  enable_int_adc();
  return Val_unit;
}

value caml_disable_int_adc() {
  disable_int_adc();
  return Val_unit;
}

value caml_wait_int_flag_ad1() {
  wait_int_flag_ad1();
  return Val_unit;
}

value caml_read_adc10(value index) {
  return Val_int(read_adc10(Int_val(index)));
}



/**********************************************************************/
/**********************************************************************/
/************************ For timer module ***************************/


value caml_enable_int_timer(value reg) {
  enable_int_timer(Int_val(reg));
  return Val_unit;
}

value caml_disable_int_timer(value reg) {
  disable_int_timer(Int_val(reg));
  return Val_unit;
}

value caml_set_priority_int_timer(value reg, value val) {
  set_priority_int_timer(Int_val(reg), Int_val(val));
  return Val_unit;
}

value caml_set_subpriority_int_timer(value reg, value val) {
  set_subpriority_int_timer(Int_val(reg), Int_val(val));
  return Val_unit;
}

value caml_configure_int_timer(value reg, value val1, value val2) {
  configure_int_timer(Int_val(reg), Int_val(val1), Int_val(val2));
  return Val_unit;
}




/**********************************************************************/
/**********************************************************************/
/************************ For UART module ***************************/



/**********************************************************************/
value caml_enable_tx_int_ec_uart(value uart) {
  enable_tx_int_ec_uart(Int_val(uart));
  return Val_unit;
}

value caml_disable_tx_int_ec_uart(value uart) {
  disable_tx_int_ec_uart(Int_val(uart));
  return Val_unit;
}

value caml_enable_rx_int_ec_uart(value uart) {
  enable_rx_int_ec_uart(Int_val(uart));
  return Val_unit;
}


value caml_disable_rx_int_ec_uart(value uart) {
  disable_rx_int_ec_uart(Int_val(uart));
  return Val_unit;
}


value caml_enable_err_int_ec_uart(value uart) {
  enable_err_int_ec_uart(Int_val(uart));
  return Val_unit;
}


value caml_disable_err_int_ec_uart(value uart) {
  disable_err_int_ec_uart(Int_val(uart));
  return Val_unit;
}


value caml_enable_tx_int_fs_uart(value uart) {
  enable_tx_int_fs_uart(Int_val(uart));
  return Val_unit;
}

value caml_disable_tx_int_fs_uart(value uart) {
  disable_tx_int_fs_uart(Int_val(uart));
  return Val_unit;
}


value caml_enable_rx_int_fs_uart(value uart) {
  enable_rx_int_fs_uart(Int_val(uart));
  return Val_unit;
}

value caml_disable_rx_int_fs_uart(value uart) {
  disable_rx_int_fs_uart(Int_val(uart));
  return Val_unit;
}


value caml_enable_err_int_fs_uart(value uart) {
  enable_err_int_fs_uart(Int_val(uart));
  return Val_unit;
}


value caml_disable_err_int_fs_uart(value uart) {
  disable_err_int_fs_uart(Int_val(uart));
  return Val_unit;
}


/**********************************************************************/

value caml_set_priority_int_uart(value reg, value val) {
  set_priority_int_uart(Int_val(reg), Int_val(val));
  return Val_unit;
}

value caml_set_subpriority_int_uart(value reg, value val) {
  set_subpriority_int_uart(Int_val(reg), Int_val(val));
  return Val_unit;
}
