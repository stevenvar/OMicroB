#include "values.h"
#include "gc.h"
#include <string.h>

/******************************************************************************/

void *int32_custom_operations;
void *int64_custom_operations;
void *nativeint_custom_operations;

/******************************************************************************/

extern void *caml_ml_input;
extern void *caml_ml_flush;
extern void *caml_ml_output_char;
extern void *caml_ml_output_int;
extern void *caml_ml_seek_out;
extern void *caml_ml_pos_out;
extern void *caml_ml_input_int;
extern void *caml_input_value;
extern void *caml_ml_seek_in;
extern void *caml_ml_pos_in;
extern void *caml_ml_channel_size;
extern void *caml_ml_close_channel;
extern void *caml_sys_exit;
extern void *caml_ml_string_length;
extern void *caml_blit_bytes;
extern void *caml_ml_input_scan_line;
extern void *caml_create_bytes;
extern void *caml_ml_input_char;
extern void *caml_sys_open;
extern void *caml_ml_open_descriptor_in;
extern void *caml_ml_set_channel_name;
extern void *caml_output_value;
extern void *caml_ml_output;
extern void *caml_ml_output_bytes;
extern void *caml_ml_out_channels_list;
extern void *caml_ml_open_descriptor_out;
extern void *caml_format_float;
extern void *caml_string_get;
extern void *caml_format_int;
extern void *caml_string_notequal;
extern void *caml_blit_string;
extern void *caml_greaterequal;
extern void *caml_lessequal;
extern void *caml_register_named_value;
/* extern void *caml_fresh_oo_id; */
extern void *caml_compare;
extern void *caml_ml_bytes_length;
extern void *caml_fill_bytes;
extern void *caml_string_equal;
extern void *caml_string_compare;
extern void *caml_sys_get_argv;
extern void *caml_sys_get_config;
extern void *caml_sys_const_backend_type;
extern void *caml_sys_const_big_endian;
extern void *caml_sys_const_word_size;
extern void *caml_sys_const_int_size;
extern void *caml_sys_const_ostype_unix;
extern void *caml_sys_const_ostype_win32;
extern void *caml_sys_const_ostype_cygwin;
extern void *caml_sys_const_max_wosize;
extern void *caml_output_value_to_buffer;
extern void *caml_array_unsafe_get;
extern void *caml_array_unsafe_set;
/* extern void *caml_make_vect; */
extern void *caml_array_blit;
extern void *caml_array_sub;
extern void *caml_array_append;
extern void *caml_int32_format;
extern void *caml_int32_add;
extern void *caml_int64_format;
extern void *caml_int64_add;
extern void *caml_nativeint_format;
extern void *caml_nativeint_add;
extern void *caml_bytes_get;
/* extern void *caml_array_get_addr; */
/* extern void *caml_array_set_addr; */
extern void *caml_new_lex_engine;
extern void *caml_lex_engine;
extern void *caml_notequal;
extern void *caml_array_get;
extern void *caml_parse_engine;
extern void *caml_obj_tag;
extern void *caml_obj_set_tag;
extern void *caml_int_of_string;
extern void *caml_hexstring_of_float;
extern void *caml_classify_float;
extern void *caml_lt_float;
extern void *caml_bytes_set;
extern void *caml_equal;
extern void *caml_float_of_string;
extern void *caml_get_exception_raw_backtrace;
extern void *caml_convert_raw_backtrace;
extern void *caml_obj_block;
extern void *caml_md5_chan;
extern void *caml_md5_string;
extern void *caml_int32_of_int;
extern void *caml_int32_shift_left;
extern void *caml_int32_or;
extern void *caml_int32_mod;
extern void *caml_int32_sub;
extern void *caml_greaterthan;
extern void *caml_int64_of_int;
extern void *caml_int64_shift_left;
extern void *caml_int64_or;
extern void *caml_int64_mod;
extern void *caml_int64_sub;
extern void *caml_mul_float;
extern void *caml_float_of_int;
extern void *caml_div_float;
extern void *caml_add_float;
extern void *caml_int64_of_nativeint;
extern void *caml_int64_to_nativeint;
extern void *caml_nativeint_to_int32;
extern void *caml_nativeint_of_int32;
extern void *caml_sys_random_seed;
extern void *caml_hash;
extern void *caml_hash_univ_param;
extern void *caml_sys_getenv;
extern void *caml_weak_create;
extern void *caml_weak_set;
extern void *caml_weak_get;
extern void *caml_lessthan;
extern void *caml_ensure_stack_capacity;
extern void *caml_int64_of_string;
extern void *caml_int32_of_string;
extern void *caml_nativeint_of_string;
extern void *caml_sys_close;
extern void *caml_sys_isatty;
extern void *caml_nativeint_neg;
extern void *caml_int64_neg;
extern void *caml_int32_neg;
extern void *caml_sys_file_exists;
extern void *caml_sys_remove;
extern void *caml_eq_float;
extern void *caml_int_of_float;
extern void *caml_sub_float;
extern void *caml_sys_time;
extern void *caml_float_compare;
extern void *caml_sys_system_command;
extern void *caml_terminfo_setup;
extern void *caml_sys_getcwd;
extern void *caml_terminfo_backup;
extern void *caml_terminfo_standout;
extern void *caml_terminfo_resume;
/* extern void *caml_obj_dup; */
extern void *caml_string_lessthan;
extern void *caml_int_compare;
extern void *caml_array_set;
extern void *caml_ge_float;
extern void *caml_dynlink_get_current_libs;
extern void *caml_dynlink_add_primitive;
extern void *caml_dynlink_lookup_symbol;
extern void *caml_dynlink_close_lib;
extern void *caml_dynlink_open_lib;
extern void *caml_get_global_data;
extern void *caml_get_section_table;
extern void *caml_realloc_global;
extern void *caml_output_value_to_string;
extern void *caml_static_alloc;
extern void *caml_register_code_fragment;
extern void *caml_add_debug_info;
extern void *caml_reify_bytecode;

void *caml_builtin_cprim;
void *caml_names_of_builtin_cprim;

/******************************************************************************/
extern val_t ocaml_heap[];


static val_t oo_last_id = Val_int(0);


val_t caml_fresh_oo_id (val_t v) {
  v = oo_last_id;
  oo_last_id += 2;
  return v;
}


val_t caml_obj_dup(val_t arg)
{
  /* CAMLparam1 (arg); */
  /* CAMLlocal1 (res); */
  val_t res;
  mlsize_t sz, i;
  tag_t tg;

  sz = Wosize_val(arg);
  if (sz == 0) 
    return arg;
  tg = Tag_val(arg);
  if (tg >= No_scan_tag) {
    Alloc_small(res,sz,tg);
/* not sure ..  */
    memcpy((char *)res, (char *)arg, sz * sizeof(val_t));
  } else {
    Alloc_small(res,sz,tg);
    for (i = 0; i < sz; i++) 
      Field(res, i) = Field(arg, i);
  }
  return res;
}

#define Long_val Int_val
/* #define Modify(fp,val) caml_modify((fp), (val)) */
val_t caml_make_vect(val_t len, val_t init)
{
  /* CAMLparam2 (len, init); */
  /* CAMLlocal1 (res); */
  val_t res;
  mlsize_t size, i;

  size = Long_val(len);
  if (size == 0) {
    res = Val_unit; 
/* Atom(0); */
  } else {
      Alloc_small(res,size, 0);
      for (i = 0; i < size; i++) 
        Field(res, i) =  init;
      /* res = caml_check_urgent_gc (res); */
    
  }
  /* CAMLreturn (res); */
  return res;
}

val_t caml_array_get_addr(val_t array, val_t index)
{
  val_t idx = Int_val(index);
  /* if (idx < 0 || idx >= Wosize_val(array)) caml_array_bound_error(); */
  return Field(array, idx);
}

val_t caml_array_set_addr(val_t array, val_t index, val_t newval)
{
  val_t idx = Int_val(index);
  /* if (idx < 0 || idx >= Wosize_val(array)) caml_array_bound_error(); */
  Field(array, idx) =  newval;
  return Val_unit;
}
