value caml_sys_const_big_endian(value unit) {
  return Val_false;
}

value caml_sys_const_word_size(value unit) {
  return Val_int(sizeof(value) << 3);
}

value caml_sys_const_int_size(value unit) {
  return Val_int((sizeof(value) << 3) - 1);
}

value caml_sys_const_max_wosize(value unit) {
  return Val_int(((uvalue) 1 << Hd_size_bitcnt) - 1);
}
