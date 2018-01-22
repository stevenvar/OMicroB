#include "values.h"
#include "str.h"

int string_length(value s) {
  mlsize_t temp;
  temp = Bosize_val(s) - 1;
  return temp - StringField(s, temp);
}

value caml_string_length(value s) {
  return Val_int(string_length(s));
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

value caml_bytes_equal(value s1, value s2) {
  return caml_string_equal(s1, s2);
}

value caml_string_notequal(value s1, value s2) {
  return Val_bool(!Bool_val(caml_string_equal(s1, s2)));
}
