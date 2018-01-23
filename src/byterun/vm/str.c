#include <string.h>
#include "values.h"
#include "str.h"

int string_length(value s) {
  mlsize_t temp;
  temp = Bosize_val(s) - 1;
  return temp - StringField(s, temp);
}

value caml_create_bytes(value ml_len) {
  value res;
  mlsize_t str_len = Long_val(ml_len);
  mlsize_t blk_wlen = Wsize_bsize(str_len) + 1;
  mlsize_t blk_blen = Bsize_wsize(blk_wlen);
  OCamlAlloc(res, blk_wlen, String_tag);
  Field(res, blk_wlen - 1) = 0;
  String_val(res)[blk_blen - 1] = blk_blen - str_len - 1;
  return res;
}

value caml_ml_string_length(value s) {
  return Val_int(string_length(s));
}

value caml_ml_bytes_length(value b) {
  return caml_ml_string_length(b);
}

value caml_blit_string(value ml_s, value ml_sofs, value ml_b, value ml_bofs, value ml_len) {
  char *s = String_val(ml_s);
  mlsize_t sofs = Long_val(ml_sofs);
  char *b = String_val(ml_b);
  mlsize_t bofs = Long_val(ml_bofs);
  mlsize_t len = Long_val(ml_len);
  s += sofs;
  b += bofs;
  while (len > 0) {
    *b = *s;
    b ++;
    s ++;
    len --;
  }
  return Val_unit;
}

value caml_blit_bytes(value ml_s, value ml_sofs, value ml_b, value ml_bofs, value ml_len) {
  return caml_blit_string(ml_s, ml_sofs, ml_b, ml_bofs, ml_len);
}

value caml_fill_bytes(value ml_b, value ml_ofs, value ml_len, value ml_c) {
  char *b = String_val(ml_b);
  mlsize_t ofs = Long_val(ml_ofs);
  mlsize_t len = Long_val(ml_len);
  char c = (char) Long_val(ml_c);
  b += ofs;
  while (len > 0) {
    *b = c;
    b ++;
    len --;
  }
  return Val_unit;
}

value caml_string_equal(value s1, value s2) {
  mlsize_t sz1, sz2;
  value *p1, *p2;
  if (s1 == s2) return Val_true;
  sz1 = Wosize_val(s1);
  sz2 = Wosize_val(s2);
  if (sz1 != sz2) return Val_false;
  p1 = &Field(s1, 0);
  p2 = &Field(s2, 0);
  while (sz1 > 0) {
    if (*p1 != *p2) {
      return Val_false;
    }
    sz1 --;
    p1 ++;
    p2 ++;
  }
  return Val_true;
}

value caml_string_compare(value s1, value s2) {
  mlsize_t sz1, sz2;
  int c;
  if (s1 == s2) return Val_int(0);
  sz1 = Bosize_val(s1);
  sz2 = Bosize_val(s2);
  c = memcmp(String_val(s1), String_val(s2), sz1 < sz2 ? sz1 : sz2);
  if (c != 0) return Val_int(c < 0 ? -1 : 1);
  return sz1 < sz2 ? -1 : 1;
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
