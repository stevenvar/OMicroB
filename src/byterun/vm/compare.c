/* Structural comparison */

#include <stdint.h>

#include "values.h"
#include "debug.h"
#include "fail.h"
#include "str.h"
#include "int32.h"
#include "int64.h"

/******************************************************************************/

static int8_t compare_customs(uint8_t flag, value v1, value v2) {
  if (flag == INT32_CUSTOM_FLAG) {
    return int32_compare(v1, v2);
  } else if (flag == INT64_CUSTOM_FLAG) {
    return int64_compare(v1, v2);
  } else {
    caml_raise_invalid_argument("compare: unknown custom blocks");
    return 0;
  }
}

/******************************************************************************/

static int8_t compare_val(value v1, value v2) {
  if (v1 == v2) {
    return 0;
  }

  if (Is_block(v1)) {
    if (Is_block(v2)) {
      tag_t t1 = Tag_val(v1);
      tag_t t2 = Tag_val(v2);
      if (t1 < t2) return -1;
      if (t1 > t2) return 1;

      switch(t1) {
      case String_tag:
        return string_compare(v1, v2);
        
      case Abstract_tag:
        caml_raise_invalid_argument("compare: abstract value");
        
      case Closure_tag:
      case Infix_tag:
        caml_raise_invalid_argument("compare: functional value");
        
      case Object_tag:
        return Oid_val(v1) - Oid_val(v2);
        
      case Custom_tag: {
        unsigned char flag1 = Field(v1, 0);
        unsigned char flag2 = Field(v2, 0);
        if (flag1 < flag2) return -1;
        if (flag1 > flag2) return 1;
        return compare_customs(flag1, v1, v2);
      }
        
      default: {
        mlsize_t sz1 = Wosize_val(v1);
        mlsize_t sz2 = Wosize_val(v2);
        mlsize_t i;
        int res;
        if (sz1 < sz2) return -1;
        if (sz1 > sz2) return 1;
        if (sz1 == 0) return 0;
        for (i = 0; i < sz1 - 1; i ++) {
          res = compare_val(Field(v1, i), Field(v2, i));
          if (res != 0) return res;
        }
        return compare_val(Field(v1, sz1 - 1), Field(v2, sz2 - 1));
      }
      }
    } else {
      if (Tag_val(v1) == Custom_tag) return compare_customs(Field(v1, 0), v1, v2);
      return 1;
    }
  } else if (Is_block(v2)) {
    if (Tag_val(v2) == Custom_tag) return compare_customs(Field(v2, 0), v1, v2);
    return -1;
  } else if (v1 == Val_nan) {
    return -1;
  } else if (v2 == Val_nan) {
    return 1;
  } else {
    return v1 < v2 ? -1 : 1;
  }
}

/******************************************************************************/

value caml_equal(value v1, value v2) {
  int res = compare_val(v1, v2);
  return Val_int(res == 0);
}

value caml_notequal(value v1, value v2) {
  int res = compare_val(v1, v2);
  return Val_int(res != 0);
}

value caml_lessthan(value v1, value v2) {
  int res = compare_val(v1, v2);
  return Val_int(res < 0);
}

value caml_lessequal(value v1, value v2) {
  int res = compare_val(v1, v2);
  return Val_int(res <= 0);
}

value caml_greaterthan(value v1, value v2) {
  int res = compare_val(v1, v2);
  return Val_int(res > 0);
}

value caml_greaterequal(value v1, value v2) {
  int res = compare_val(v1, v2);
  return Val_int(res >= 0);
}

value caml_compare(value v1, value v2) {
  return Val_int(compare_val(v1, v2));
}

/******************************************************************************/
