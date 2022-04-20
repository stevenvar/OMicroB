#include <string.h>
#include <stdio.h>
#include <inttypes.h>
#include "values.h"
#include "str.h"

mlsize_t caml_string_length(value s) {
  mlsize_t temp;
  temp = Bosize_val(s) - 1;
  return temp - String_field(s, temp);
}

value create_bytes(mlsize_t str_len) {
  value res;
  mlsize_t blk_wlen = Wsize_bsize(str_len) + 1;
  mlsize_t blk_blen = Bsize_wsize(blk_wlen);
  OCamlAlloc(res, blk_wlen, String_tag);
  Ram_field(res, blk_wlen - 1) = 0;
  Ram_string_field(res, blk_blen - 1) = blk_blen - str_len - 1;
  return res;
}

value copy_bytes(const char *str) {
  mlsize_t str_len = strlen(str);
  value res = create_bytes(str_len);
  memcpy(Ram_string_val(res), str, str_len);
  return res;
}

value caml_create_bytes(value ml_len) {
  return create_bytes(Int_val(ml_len));
}

value caml_ml_string_length(value s) {
  return Val_int(caml_string_length(s));
}

value caml_ml_bytes_length(value b) {
  return caml_ml_string_length(b);
}

value caml_blit_string(value ml_s, value ml_sofs, value ml_b, value ml_bofs, value ml_len) {
  mlsize_t sofs = Int_val(ml_sofs);
  mlsize_t bofs = Int_val(ml_bofs);
  mlsize_t len = Int_val(ml_len);
  mlsize_t i;
  assert(Is_block(ml_b));
  assert(Is_in_ram(ml_b));
  for (i = 0; i < len; i ++) {
    Ram_string_field(ml_b, bofs + i) = String_field(ml_s, sofs + i);
  }
  return Val_unit;
}

value caml_blit_bytes(value ml_s, value ml_sofs, value ml_b, value ml_bofs, value ml_len) {
  return caml_blit_string(ml_s, ml_sofs, ml_b, ml_bofs, ml_len);
}

value caml_fill_bytes(value ml_b, value ml_ofs, value ml_len, value ml_c) {
  mlsize_t ofs = Int_val(ml_ofs);
  mlsize_t len = Int_val(ml_len);
  uint8_t c = (uint8_t) Int_val(ml_c);
  mlsize_t i;
  assert(Is_block(ml_b));
  assert(Is_in_ram(ml_b));
  for (i = 0; i < len; i ++) {
    Ram_string_field(ml_b, ofs + i) = c;
  }
  return Val_unit;
}

value caml_string_equal(value s1, value s2) {
  mlsize_t sz1, sz2, i;
  if (s1 == s2) return Val_true;
  sz1 = Wosize_val(s1);
  sz2 = Wosize_val(s2);
  if (sz1 != sz2) return Val_false;
  for (i = 0; i < sz1; i ++) {
    value v1 = Field(s1, i);
    value v2 = Field(s2, i);
    if (v1 != v2) return Val_false;
  }
  return Val_true;
}

int string_compare(value s1, value s2) {
  mlsize_t sz1, sz2, sz, i;
  if (s1 == s2) return 0;
  sz1 = Bosize_val(s1);
  sz2 = Bosize_val(s2);
  sz = sz1 < sz2 ? sz1 : sz2;
  for (i = 0; i < sz; i ++) {
    char c1 = String_field(s1, i);
    char c2 = String_field(s2, i);
    if (c1 < c2) return -1;
    if (c1 > c2) return 1;
  }
  if (sz1 == sz2) return 0;
  return sz1 < sz2 ? -1 : 1;
}

value caml_string_compare(value s1, value s2) {
  return Val_int(string_compare(s1, s2));
}

value caml_bytes_compare(value b1, value b2) {
  return caml_string_compare(b1, b2);
}

value caml_bytes_equal(value s1, value s2) {
  return caml_string_equal(s1, s2);
}

value caml_string_notequal(value s1, value s2) {
  return Val_bool(!Bool_val(caml_string_equal(s1, s2)));
}

value caml_string_get(value s, value i) {
  mlsize_t idx = Int_val(i);
  mlsize_t len = caml_string_length(s);
  if (idx >= len) caml_raise_index_out_of_bounds();
  return Val_int(String_field(s, idx));
}

value caml_bytes_get(value b, value i) {
  return caml_string_get(b, i);
}

value caml_bytes_set(value b, value i, value c) {
  assert(Is_block(b));
  assert(Is_in_ram(b));
  mlsize_t idx = Int_val(i);
  mlsize_t len = caml_string_length(b);
  if (idx >= len) caml_raise_index_out_of_bounds();
  Ram_string_field(b, idx) = Int_val(c);
  return Val_unit;
}

value caml_string_of_int(value v) {
  char buf[13];
#if OCAML_VIRTUAL_ARCH == 16
  snprintf(buf, sizeof(buf), "%" PRId16, Int_val(v));
#elif OCAML_VIRTUAL_ARCH == 32
  snprintf(buf, sizeof(buf), "%" PRId32, Int_val(v));
#elif OCAML_VIRTUAL_ARCH == 64
  format_long(buf, sizeof(buf), v);
#endif
  return copy_bytes(buf);
}

value caml_string_of_float(value v) {
  char buf[13];
  snprintf(buf, sizeof(buf), "%.3lg", (double) Float_val(v));
  return copy_bytes(buf);
}

value caml_string_of_bytes(value v){
  return v;
}

value caml_bytes_of_string(value v){
  return v;
}
