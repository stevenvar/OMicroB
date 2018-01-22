/* Structural comparison */

#include "values.h"
#include "fail.h"
#include "str.h"

/******************************************************************************/

#define LESS -1
#define EQUAL 0
#define GREATER 1

#define COMPARE_STACK_INIT_SIZE 8

/******************************************************************************/

static int compare_val(val_t v1, val_t v2) {
  if (v1 == v2) {
    return 0;
  }

  if(Is_int(v1)) {
    if (Is_int(v2)) {
      return Int_val(v1) - Int_val(v2);
    } else {
      return -1;
    }
  }
  
  if (Is_int(v2)) {
    return 1;
  }
  
  tag_t t1 = Tag_val(v1);
  tag_t t2 = Tag_val(v2);
  if (t1 != t2) return t1 - t2;

  switch(t1) {

  case String_tag: {
    mlsize_t len1, len2, len;
    unsigned char * p1, * p2;
    len1 = string_length(v1);
    len2 = string_length(v2);
    p1 = (unsigned char *) String_val(v1);
    p2 = (unsigned char *) String_val(v2);
    len = (len1 <= len2 ? len1 : len2);
    while (len > 0) {
      if (*p1 != *p2) {
        return *p1 - *p2;
      }
      len--;
      p1 ++;
      p2 ++;
    }
    return len1 - len2;
  }

  case Abstract_tag:
    caml_raise_invalid_argument("compare: abstract value");

  case Closure_tag:

  case Infix_tag:
    caml_raise_invalid_argument("compare: functional value");

  case Object_tag:
    return (Oid_val(v1) - Oid_val(v2));

  case Custom_tag:
    caml_raise_invalid_argument("compare: custom value");
    /* return Custom_ops_val(v1)->compare(v1, v2); */

  default: {
    mlsize_t sz1 = Wosize_val(v1);
    mlsize_t sz2 = Wosize_val(v2);
    val_t * p1, * p2;
    int res;
    if (sz1 != sz2) return sz1 - sz2;
    if (sz1 == 0) return 0;
    for(p1 = &Field(v1, 0), p2 = &Field(v2, 0);
        sz1 > 1;
        sz1 --, p1 ++, p2 ++) {
      res = compare_val(*p1, *p2);
      if (res != 0) return res;
    }
    v1 = *p1;
    v2 = *p2;
    return compare_val(v1,v2);
  }
  }
}

/******************************************************************************/

val_t caml_equal(val_t v1, val_t v2)
{
  int res = compare_val(v1, v2);
  return Val_int(res == 0);
}

val_t caml_notequal(val_t v1, val_t v2)
{
  int res = compare_val(v1, v2);
  return Val_int(res != 0);
}

val_t caml_lessthan(val_t v1,val_t v2)
{
  int res = compare_val(v1, v2);
  return Val_int(res < 0);
}

val_t caml_lessequal(val_t v1,val_t v2)
{
  int res = compare_val(v1, v2);
  return Val_int(res <= 0);
}

val_t caml_greaterthan(val_t v1,val_t v2)
{
  int res = compare_val(v1, v2);
  return Val_int(res > 0);
}

val_t caml_greaterequal(val_t v1,val_t v2)
{
  int res = compare_val(v1, v2);
  return Val_int(res >= 0);
}

val_t caml_compare(val_t v1, val_t v2)
{
  int res = compare_val(v1, v2);
  if (res < 0)
    return Val_int(LESS);
  else if (res > 0)
    return Val_int(GREATER);
  else
    return Val_int(EQUAL);
}

/******************************************************************************/
