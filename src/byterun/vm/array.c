#include "debug.h"
#include "gc.h"

value caml_make_vect(value len, value init) {
  value res;
  mlsize_t size, i;
  size = Int_val(len);
  if (size == 0) {
    res = OCAML_atom0;
  } else {
    OCamlAlloc(res, size, 0);
    for (i = 0; i < size; i ++) {
      Ram_field(res, i) = init;
    }
  }
  return res;
}

value caml_make_array(value init) {
  return init;
}

value caml_array_get_addr(value array, value index) {
  mlsize_t idx = Int_val(index);
  assert(Is_block(array));
  if (idx >= Wosize_val(array)) caml_raise_index_out_of_bounds();
  return Field(array, idx);
}

value caml_array_set_addr(value array, value index, value newval) {
  mlsize_t idx = Int_val(index);
  assert(Is_block(array));
  assert(Is_in_ram(array));
  if (idx >= Wosize_val(array)) caml_raise_index_out_of_bounds();
  Ram_field(array, idx) = newval;
  return Val_unit;
}

value caml_array_unsafe_get(value array, value index) {
  assert(Is_block(array));
  return Field(array, Int_val(index));
}

value caml_array_unsafe_set(value array, value index, value val) {
  assert(Is_block(array));
  assert(Is_in_ram(array));
  Ram_field(array, Int_val(index)) = val;
  return Val_unit;
}

value caml_array_get(value array, value index) {
  return caml_array_get_addr(array, index); // OK since floats are not boxed
}

value caml_array_set(value array, value index, value val) {
  return caml_array_set_addr(array, index, val); // OK since floats are not boxed
}

value caml_floatarray_set(value array, value index, value val) {
  return caml_array_set_addr(array, index, val); // OK since floats are not boxed
}

value caml_floatarray_get(value array, value index) {
  return caml_array_get_addr(array, index); // OK since floats are not boxed
}


value caml_array_sub(value array, value ml_ofs, value ml_len) {
  mlsize_t ofs = Int_val(ml_ofs);
  mlsize_t len = Int_val(ml_len);
  value result;
  mlsize_t i;
  OCamlAlloc(result, len, 0);
  for (i = 0; i < len; i ++) {
    Ram_field(result, i) = Field(array, i + ofs);
  }
  return result;
}

value caml_array_append(value tbl1, value tbl2) {
  mlsize_t sz1 = Wosize_val(tbl1);
  mlsize_t sz2 = Wosize_val(tbl2);
  value result;
  mlsize_t i;
  OCamlAlloc(result, sz1 + sz2, 0);
  for (i = 0; i < sz1; i ++) {
    Ram_field(result, i) = Field(tbl1, i);
  }
  for (i = 0; i < sz2; i ++) {
    Ram_field(result, i + sz1) = Field(tbl2, i);
  }
  return result;
}

value caml_array_blit(value tbl1, value ml_ofs1, value tbl2, value ml_ofs2, value ml_n) {
  value i, n = Int_val(ml_n), ofs1 = Int_val(ml_ofs1), ofs2 = Int_val(ml_ofs2);
  for (i = 0; i < n; i ++) {
    Ram_field(tbl2, ofs2 + i) = Field(tbl1, ofs1 + i);
  }
  return Val_unit;
}


/* These functions are untested and buggy  */

/* static const mlsize_t mlsize_t_max = -1; */

/* value caml_array_gather(mlsize_t num_arrays, */
/*                                value arrays[/\*num_arrays*\/], */
/*                                mlsize_t offsets[/\*num_arrays*\/], */
/*                                mlsize_t lengths[/\*num_arrays*\/]) */
/* { */
/*   /\* CAMLparamN(arrays, num_arrays); *\/ */
/*   /\* TODO : fix  *\/ */
/*   value res;                    /\* no need to register it as a root *\/ */
/*   mlsize_t i, size, count, pos; */
/*   value * src; */

/*   /\* Determine total size and whether result array is an array of floats *\/ */
/*   size = 0; */
/*   for (i = 0; i < num_arrays; i++) { */
/*     if (mlsize_t_max - lengths[i] < size) caml_raise_invalid_argument("Array.concat"); */
/*     size += lengths[i]; */
/*   } */
/*   if (size == 0) { */
/*     /\* If total size = 0, just return empty array *\/ */
/*     res = OCAML_atom0; */
/*   } */
/*   else if (size < Max_wosize) { */
/*     res = caml_alloc_small(size, 0); */
/*     for (i = 0, pos = 0; i < num_arrays; i++) { */
/*       memcpy(&Field(res, pos), */
/*              &Field(arrays[i], offsets[i]), */
/*              lengths[i] * sizeof(value)); */
/*       pos += lengths[i]; */
/*     } */
/*     CAMLassert(pos == size); */
/*   } */
/*   else { */
/*     /\* Array of values, too big. *\/ */
/*     caml_raise_invalid_argument("Array.concat"); */
/*   } */
/*   return res; */
/* } */


/* value caml_array_concat(value al) */
/* { */
/* /\* TODO : check *\/ */
/* #define STATIC_SIZE 16 */
/*   value static_arrays[STATIC_SIZE], * arrays; */
/*   mlsize_t static_offsets[STATIC_SIZE], * offsets; */
/*   mlsize_t static_lengths[STATIC_SIZE], * lengths; */
/*   mlsize_t n, i; */
/*   value l, res; */

/*   /\* Length of list = number of arrays *\/ */
/*   for (n = 0, l = al; l != Val_int(0); l = Field(l, 1)) n++; */
/*   /\* Allocate extra storage if too many arrays *\/ */
/*   if (n <= STATIC_SIZE) { */
/*     arrays = static_arrays; */
/*     offsets = static_offsets; */
/*     lengths = static_lengths; */
/*   } else { */
/*     /\* TODO : code *\/ */
/*     /\* arrays = caml_stat_alloc(n * sizeof(value)); *\/ */
/*     /\* offsets = caml_stat_alloc_noexc(n * sizeof(mlsize_t)); *\/ */
/*     /\* if (offsets == NULL) { *\/ */
/*     /\*   caml_stat_free(arrays); *\/ */
/*     /\*   caml_raise_out_of_memory(); *\/ */
/*     /\* } *\/ */
/*     /\* lengths = caml_stat_alloc_noexc(n * sizeof(value)); *\/ */
/*     /\* if (lengths == NULL) { *\/ */
/*     /\*   caml_stat_free(offsets); *\/ */
/*     /\*   caml_stat_free(arrays); *\/ */
/*     /\*   caml_raise_out_of_memory(); *\/ */
/*     /\* } *\/ */
/*   } */
/*   /\* Build the parameters to caml_array_gather *\/ */
/*   for (i = 0, l = al; l != Val_int(0); l = Field(l, 1), i++) { */
/*     arrays[i] = Field(l, 0); */
/*     offsets[i] = 0; */
/*     lengths[i] = caml_array_length(Field(l, 0)); */
/*   } */
/*   /\* Do the concatenation *\/ */
/*   res = caml_array_gather(n, arrays, offsets, lengths); */
/*   /\* Free the extra storage if needed *\/ */
/*   /\* if (n > STATIC_SIZE) { *\/ */
/*   /\*   caml_stat_free(arrays); *\/ */
/*   /\*   caml_stat_free(offsets); *\/ */
/*   /\*   caml_stat_free(lengths); *\/ */
/*   /\* } *\/ */
/*   return res; */
/* } */
