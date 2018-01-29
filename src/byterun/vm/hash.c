#include <stdint.h>
#include "values.h"

static uint32_t hash(uint32_t *count, uint32_t *limit, uint32_t h, value v) {
  if (*count <= 1 || *limit == 0) return h;
  (*count) --;
  if (Is_block(v)) {
    tag_t tag = Tag_val(v);
    mlsize_t sz = Wosize_val(v);
    h = h * 223 + Tag_val(v);
    // TODO: manage custom blocks
    if (tag < No_scan_tag) {
      mlsize_t i;
      for (i = 0; i < sz; i ++) {
        h = hash(count, limit, h, Field(v, i));
        if (*count == 0 || *limit == 0) return h;
      }
    } else {
      mlsize_t i;
      for (i = 0; i < sz; i ++) {
        h = h * 223 + Field(v, i);
      }
      if (*limit < sz) *limit = 0;
      else *limit -= sz;
    }
    return h;
  } else {
    (*limit) --;
    return h * 223 + (uint32_t) v;
  }
}

value caml_hash(value ml_count, value ml_limit, value seed, value v) {
  uint32_t count = Int_val(ml_count);
  uint32_t limit = Int_val(ml_limit);
  return Val_int(hash(&count, &limit, Int_val(seed), v) & 0x3FFFFFFF);
}
