#ifndef OCAML_VIRTUAL_ARCH
#define OCAML_VIRTUAL_ARCH 64
#endif

#include "values.h"

/******************************************************************************/

#ifndef __AVR__

#define OUTPUT 0
#define HIGH 1
#define LOW 0

#include <stdio.h>
#include <time.h>

void pinMode(int pin, int mode) {
  printf("pinMode(%d, %d)\n", pin, mode);
}

void digitalWrite(int pin, int val) {
  printf("digitalWrite(%d, %d)\n", pin, val);
}

void delay(int millis) {
  struct timespec req, rem;
  req.tv_sec = (millis / 1000);
  req.tv_nsec = (millis - (req.tv_sec)) * 1000000;
  printf("delay(%d)\n", millis);
  nanosleep(&req, &rem);
}

#endif

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
extern void *caml_fresh_oo_id;
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
extern void *caml_make_vect;
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
extern void *caml_array_get_addr;
extern void *caml_array_set_addr;
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
extern void *caml_obj_dup;
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

val_t led_blink(val_t unit) {
  int led = 13;
  pinMode(led, OUTPUT);
  while (1) {
    digitalWrite(led, HIGH);
    delay(1000);
    digitalWrite(led, LOW);
    delay(1000);
  }
  return Val_unit;
}
 
/******************************************************************************/
