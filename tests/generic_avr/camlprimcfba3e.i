# 1 "/tmp/camlprimcfba3e.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "/tmp/camlprimcfba3e.c"
# 11 "/tmp/camlprimcfba3e.c"
typedef long value;

extern value caml_abs_float();
extern value caml_acos_float();
extern value caml_add_debug_info();
extern value caml_add_float();
extern value caml_alloc_dummy();
extern value caml_alloc_dummy_float();
extern value caml_alloc_dummy_function();
extern value caml_array_append();
extern value caml_array_blit();
extern value caml_array_concat();
extern value caml_array_get();
extern value caml_array_get_addr();
extern value caml_array_get_float();
extern value caml_array_set();
extern value caml_array_set_addr();
extern value caml_array_set_float();
extern value caml_array_sub();
extern value caml_array_unsafe_get();
extern value caml_array_unsafe_get_float();
extern value caml_array_unsafe_set();
extern value caml_array_unsafe_set_addr();
extern value caml_array_unsafe_set_float();
extern value caml_asin_float();
extern value caml_atan2_float();
extern value caml_atan_float();
extern value caml_ba_blit();
extern value caml_ba_change_layout();
extern value caml_ba_create();
extern value caml_ba_dim();
extern value caml_ba_dim_1();
extern value caml_ba_dim_2();
extern value caml_ba_dim_3();
extern value caml_ba_fill();
extern value caml_ba_get_1();
extern value caml_ba_get_2();
extern value caml_ba_get_3();
extern value caml_ba_get_generic();
extern value caml_ba_kind();
extern value caml_ba_layout();
extern value caml_ba_num_dims();
extern value caml_ba_reshape();
extern value caml_ba_set_1();
extern value caml_ba_set_2();
extern value caml_ba_set_3();
extern value caml_ba_set_generic();
extern value caml_ba_slice();
extern value caml_ba_sub();
extern value caml_ba_uint8_get16();
extern value caml_ba_uint8_get32();
extern value caml_ba_uint8_get64();
extern value caml_ba_uint8_set16();
extern value caml_ba_uint8_set32();
extern value caml_ba_uint8_set64();
extern value caml_backtrace_status();
extern value caml_blit_bytes();
extern value caml_blit_string();
extern value caml_bswap16();
extern value caml_bytes_compare();
extern value caml_bytes_equal();
extern value caml_bytes_get();
extern value caml_bytes_get16();
extern value caml_bytes_get32();
extern value caml_bytes_get64();
extern value caml_bytes_greaterequal();
extern value caml_bytes_greaterthan();
extern value caml_bytes_lessequal();
extern value caml_bytes_lessthan();
extern value caml_bytes_notequal();
extern value caml_bytes_of_string();
extern value caml_bytes_set();
extern value caml_bytes_set16();
extern value caml_bytes_set32();
extern value caml_bytes_set64();
extern value caml_ceil_float();
extern value caml_channel_descriptor();
extern value caml_classify_float();
extern value caml_compare();
extern value caml_convert_raw_backtrace();
extern value caml_convert_raw_backtrace_slot();
extern value caml_copysign_float();
extern value caml_cos_float();
extern value caml_cosh_float();
extern value caml_create_bytes();
extern value caml_create_string();
extern value caml_div_float();
extern value caml_dynlink_add_primitive();
extern value caml_dynlink_close_lib();
extern value caml_dynlink_get_current_libs();
extern value caml_dynlink_lookup_symbol();
extern value caml_dynlink_open_lib();
extern value caml_ensure_stack_capacity();
extern value caml_ephe_blit_data();
extern value caml_ephe_blit_key();
extern value caml_ephe_check_data();
extern value caml_ephe_check_key();
extern value caml_ephe_create();
extern value caml_ephe_get_data();
extern value caml_ephe_get_data_copy();
extern value caml_ephe_get_key();
extern value caml_ephe_get_key_copy();
extern value caml_ephe_set_data();
extern value caml_ephe_set_key();
extern value caml_ephe_unset_data();
extern value caml_ephe_unset_key();
extern value caml_eq_float();
extern value caml_equal();
extern value caml_exp_float();
extern value caml_expm1_float();
extern value caml_fill_bytes();
extern value caml_fill_string();
extern value caml_final_register();
extern value caml_final_register_called_without_value();
extern value caml_final_release();
extern value caml_float_compare();
extern value caml_float_of_int();
extern value caml_float_of_string();
extern value caml_floatarray_create();
extern value caml_floatarray_get();
extern value caml_floatarray_set();
extern value caml_floatarray_unsafe_get();
extern value caml_floatarray_unsafe_set();
extern value caml_floor_float();
extern value caml_fmod_float();
extern value caml_format_float();
extern value caml_format_int();
extern value caml_fresh_oo_id();
extern value caml_frexp_float();
extern value caml_gc_compaction();
extern value caml_gc_counters();
extern value caml_gc_full_major();
extern value caml_gc_get();
extern value caml_gc_huge_fallback_count();
extern value caml_gc_major();
extern value caml_gc_major_slice();
extern value caml_gc_minor();
extern value caml_gc_minor_words();
extern value caml_gc_quick_stat();
extern value caml_gc_set();
extern value caml_gc_stat();
extern value caml_ge_float();
extern value caml_get_current_callstack();
extern value caml_get_current_environment();
extern value caml_get_exception_backtrace();
extern value caml_get_exception_raw_backtrace();
extern value caml_get_global_data();
extern value caml_get_major_bucket();
extern value caml_get_major_credit();
extern value caml_get_minor_free();
extern value caml_get_public_method();
extern value caml_get_section_table();
extern value caml_greaterequal();
extern value caml_greaterthan();
extern value caml_gt_float();
extern value caml_hash();
extern value caml_hash_univ_param();
extern value caml_hexstring_of_float();
extern value caml_hypot_float();
extern value caml_input_value();
extern value caml_input_value_from_bytes();
extern value caml_input_value_from_string();
extern value caml_input_value_to_outside_heap();
extern value caml_install_signal_handler();
extern value caml_int32_add();
extern value caml_int32_and();
extern value caml_int32_bits_of_float();
extern value caml_int32_bswap();
extern value caml_int32_compare();
extern value caml_int32_div();
extern value caml_int32_float_of_bits();
extern value caml_int32_format();
extern value caml_int32_mod();
extern value caml_int32_mul();
extern value caml_int32_neg();
extern value caml_int32_of_float();
extern value caml_int32_of_int();
extern value caml_int32_of_string();
extern value caml_int32_or();
extern value caml_int32_shift_left();
extern value caml_int32_shift_right();
extern value caml_int32_shift_right_unsigned();
extern value caml_int32_sub();
extern value caml_int32_to_float();
extern value caml_int32_to_int();
extern value caml_int32_xor();
extern value caml_int64_add();
extern value caml_int64_and();
extern value caml_int64_bits_of_float();
extern value caml_int64_bswap();
extern value caml_int64_compare();
extern value caml_int64_div();
extern value caml_int64_float_of_bits();
extern value caml_int64_format();
extern value caml_int64_mod();
extern value caml_int64_mul();
extern value caml_int64_neg();
extern value caml_int64_of_float();
extern value caml_int64_of_int();
extern value caml_int64_of_int32();
extern value caml_int64_of_nativeint();
extern value caml_int64_of_string();
extern value caml_int64_or();
extern value caml_int64_shift_left();
extern value caml_int64_shift_right();
extern value caml_int64_shift_right_unsigned();
extern value caml_int64_sub();
extern value caml_int64_to_float();
extern value caml_int64_to_int();
extern value caml_int64_to_int32();
extern value caml_int64_to_nativeint();
extern value caml_int64_xor();
extern value caml_int_as_pointer();
extern value caml_int_compare();
extern value caml_int_of_float();
extern value caml_int_of_string();
extern value caml_invoke_traced_function();
extern value caml_lazy_follow_forward();
extern value caml_lazy_make_forward();
extern value caml_ldexp_float();
extern value caml_le_float();
extern value caml_lessequal();
extern value caml_lessthan();
extern value caml_lex_engine();
extern value caml_log10_float();
extern value caml_log1p_float();
extern value caml_log_float();
extern value caml_lt_float();
extern value caml_make_array();
extern value caml_make_float_vect();
extern value caml_make_vect();
extern value caml_marshal_data_size();
extern value caml_md5_chan();
extern value caml_md5_string();
extern value caml_ml_bytes_length();
extern value caml_ml_channel_size();
extern value caml_ml_channel_size_64();
extern value caml_ml_close_channel();
extern value caml_ml_enable_runtime_warnings();
extern value caml_ml_flush();
extern value caml_ml_flush_partial();
extern value caml_ml_input();
extern value caml_ml_input_char();
extern value caml_ml_input_int();
extern value caml_ml_input_scan_line();
extern value caml_ml_open_descriptor_in();
extern value caml_ml_open_descriptor_out();
extern value caml_ml_out_channels_list();
extern value caml_ml_output();
extern value caml_ml_output_bytes();
extern value caml_ml_output_char();
extern value caml_ml_output_int();
extern value caml_ml_output_partial();
extern value caml_ml_pos_in();
extern value caml_ml_pos_in_64();
extern value caml_ml_pos_out();
extern value caml_ml_pos_out_64();
extern value caml_ml_runtime_warnings_enabled();
extern value caml_ml_seek_in();
extern value caml_ml_seek_in_64();
extern value caml_ml_seek_out();
extern value caml_ml_seek_out_64();
extern value caml_ml_set_binary_mode();
extern value caml_ml_set_channel_name();
extern value caml_ml_string_length();
extern value caml_modf_float();
extern value caml_mul_float();
extern value caml_nativeint_add();
extern value caml_nativeint_and();
extern value caml_nativeint_bswap();
extern value caml_nativeint_compare();
extern value caml_nativeint_div();
extern value caml_nativeint_format();
extern value caml_nativeint_mod();
extern value caml_nativeint_mul();
extern value caml_nativeint_neg();
extern value caml_nativeint_of_float();
extern value caml_nativeint_of_int();
extern value caml_nativeint_of_int32();
extern value caml_nativeint_of_string();
extern value caml_nativeint_or();
extern value caml_nativeint_shift_left();
extern value caml_nativeint_shift_right();
extern value caml_nativeint_shift_right_unsigned();
extern value caml_nativeint_sub();
extern value caml_nativeint_to_float();
extern value caml_nativeint_to_int();
extern value caml_nativeint_to_int32();
extern value caml_nativeint_xor();
extern value caml_neg_float();
extern value caml_neq_float();
extern value caml_new_lex_engine();
extern value caml_notequal();
extern value caml_obj_add_offset();
extern value caml_obj_block();
extern value caml_obj_dup();
extern value caml_obj_is_block();
extern value caml_obj_reachable_words();
extern value caml_obj_set_tag();
extern value caml_obj_tag();
extern value caml_obj_truncate();
extern value caml_output_value();
extern value caml_output_value_to_buffer();
extern value caml_output_value_to_bytes();
extern value caml_output_value_to_string();
extern value caml_parse_engine();
extern value caml_power_float();
extern value caml_raw_backtrace_length();
extern value caml_raw_backtrace_next_slot();
extern value caml_raw_backtrace_slot();
extern value caml_realloc_global();
extern value caml_record_backtrace();
extern value caml_register_channel_for_spacetime();
extern value caml_register_code_fragment();
extern value caml_register_named_value();
extern value caml_reify_bytecode();
extern value caml_remove_debug_info();
extern value caml_reset_afl_instrumentation();
extern value caml_restore_raw_backtrace();
extern value caml_runtime_parameters();
extern value caml_runtime_variant();
extern value caml_set_oo_id();
extern value caml_set_parser_trace();
extern value caml_setup_afl();
extern value caml_sin_float();
extern value caml_sinh_float();
extern value caml_spacetime_enabled();
extern value caml_spacetime_only_works_for_native_code();
extern value caml_sqrt_float();
extern value caml_static_alloc();
extern value caml_static_free();
extern value caml_static_release_bytecode();
extern value caml_static_resize();
extern value caml_string_compare();
extern value caml_string_equal();
extern value caml_string_get();
extern value caml_string_get16();
extern value caml_string_get32();
extern value caml_string_get64();
extern value caml_string_greaterequal();
extern value caml_string_greaterthan();
extern value caml_string_lessequal();
extern value caml_string_lessthan();
extern value caml_string_notequal();
extern value caml_string_of_bytes();
extern value caml_string_set();
extern value caml_sub_float();
extern value caml_sys_chdir();
extern value caml_sys_close();
extern value caml_sys_const_backend_type();
extern value caml_sys_const_big_endian();
extern value caml_sys_const_int_size();
extern value caml_sys_const_max_wosize();
extern value caml_sys_const_ostype_cygwin();
extern value caml_sys_const_ostype_unix();
extern value caml_sys_const_ostype_win32();
extern value caml_sys_const_word_size();
extern value caml_sys_exit();
extern value caml_sys_file_exists();
extern value caml_sys_get_argv();
extern value caml_sys_get_config();
extern value caml_sys_getcwd();
extern value caml_sys_getenv();
extern value caml_sys_is_directory();
extern value caml_sys_isatty();
extern value caml_sys_open();
extern value caml_sys_random_seed();
extern value caml_sys_read_directory();
extern value caml_sys_remove();
extern value caml_sys_rename();
extern value caml_sys_system_command();
extern value caml_sys_time();
extern value caml_sys_time_include_children();
extern value caml_sys_unsafe_getenv();
extern value caml_tan_float();
extern value caml_tanh_float();
extern value caml_terminfo_rows();
extern value caml_update_dummy();
extern value caml_weak_blit();
extern value caml_weak_check();
extern value caml_weak_create();
extern value caml_weak_get();
extern value caml_weak_get_copy();
extern value caml_weak_set();
extern value caml_string_of_int();
extern value caml_string_of_float();
extern value caml_unsafe_string_of_bytes();
extern value caml_unsafe_bytes_of_string();
extern value caml_avr_delay();
extern value caml_avr_millis();
extern value caml_avr_serial_init();
extern value caml_avr_serial_read();
extern value caml_avr_serial_write();
extern value caml_avr_write_register();
extern value caml_avr_read_register();
extern value caml_avr_set_bit();
extern value caml_avr_clear_bit();
extern value caml_avr_read_bit();
typedef value (*primitive)();
primitive caml_builtin_cprim[] = {
  caml_abs_float,
  caml_acos_float,
  caml_add_debug_info,
  caml_add_float,
  caml_alloc_dummy,
  caml_alloc_dummy_float,
  caml_alloc_dummy_function,
  caml_array_append,
  caml_array_blit,
  caml_array_concat,
  caml_array_get,
  caml_array_get_addr,
  caml_array_get_float,
  caml_array_set,
  caml_array_set_addr,
  caml_array_set_float,
  caml_array_sub,
  caml_array_unsafe_get,
  caml_array_unsafe_get_float,
  caml_array_unsafe_set,
  caml_array_unsafe_set_addr,
  caml_array_unsafe_set_float,
  caml_asin_float,
  caml_atan2_float,
  caml_atan_float,
  caml_ba_blit,
  caml_ba_change_layout,
  caml_ba_create,
  caml_ba_dim,
  caml_ba_dim_1,
  caml_ba_dim_2,
  caml_ba_dim_3,
  caml_ba_fill,
  caml_ba_get_1,
  caml_ba_get_2,
  caml_ba_get_3,
  caml_ba_get_generic,
  caml_ba_kind,
  caml_ba_layout,
  caml_ba_num_dims,
  caml_ba_reshape,
  caml_ba_set_1,
  caml_ba_set_2,
  caml_ba_set_3,
  caml_ba_set_generic,
  caml_ba_slice,
  caml_ba_sub,
  caml_ba_uint8_get16,
  caml_ba_uint8_get32,
  caml_ba_uint8_get64,
  caml_ba_uint8_set16,
  caml_ba_uint8_set32,
  caml_ba_uint8_set64,
  caml_backtrace_status,
  caml_blit_bytes,
  caml_blit_string,
  caml_bswap16,
  caml_bytes_compare,
  caml_bytes_equal,
  caml_bytes_get,
  caml_bytes_get16,
  caml_bytes_get32,
  caml_bytes_get64,
  caml_bytes_greaterequal,
  caml_bytes_greaterthan,
  caml_bytes_lessequal,
  caml_bytes_lessthan,
  caml_bytes_notequal,
  caml_bytes_of_string,
  caml_bytes_set,
  caml_bytes_set16,
  caml_bytes_set32,
  caml_bytes_set64,
  caml_ceil_float,
  caml_channel_descriptor,
  caml_classify_float,
  caml_compare,
  caml_convert_raw_backtrace,
  caml_convert_raw_backtrace_slot,
  caml_copysign_float,
  caml_cos_float,
  caml_cosh_float,
  caml_create_bytes,
  caml_create_string,
  caml_div_float,
  caml_dynlink_add_primitive,
  caml_dynlink_close_lib,
  caml_dynlink_get_current_libs,
  caml_dynlink_lookup_symbol,
  caml_dynlink_open_lib,
  caml_ensure_stack_capacity,
  caml_ephe_blit_data,
  caml_ephe_blit_key,
  caml_ephe_check_data,
  caml_ephe_check_key,
  caml_ephe_create,
  caml_ephe_get_data,
  caml_ephe_get_data_copy,
  caml_ephe_get_key,
  caml_ephe_get_key_copy,
  caml_ephe_set_data,
  caml_ephe_set_key,
  caml_ephe_unset_data,
  caml_ephe_unset_key,
  caml_eq_float,
  caml_equal,
  caml_exp_float,
  caml_expm1_float,
  caml_fill_bytes,
  caml_fill_string,
  caml_final_register,
  caml_final_register_called_without_value,
  caml_final_release,
  caml_float_compare,
  caml_float_of_int,
  caml_float_of_string,
  caml_floatarray_create,
  caml_floatarray_get,
  caml_floatarray_set,
  caml_floatarray_unsafe_get,
  caml_floatarray_unsafe_set,
  caml_floor_float,
  caml_fmod_float,
  caml_format_float,
  caml_format_int,
  caml_fresh_oo_id,
  caml_frexp_float,
  caml_gc_compaction,
  caml_gc_counters,
  caml_gc_full_major,
  caml_gc_get,
  caml_gc_huge_fallback_count,
  caml_gc_major,
  caml_gc_major_slice,
  caml_gc_minor,
  caml_gc_minor_words,
  caml_gc_quick_stat,
  caml_gc_set,
  caml_gc_stat,
  caml_ge_float,
  caml_get_current_callstack,
  caml_get_current_environment,
  caml_get_exception_backtrace,
  caml_get_exception_raw_backtrace,
  caml_get_global_data,
  caml_get_major_bucket,
  caml_get_major_credit,
  caml_get_minor_free,
  caml_get_public_method,
  caml_get_section_table,
  caml_greaterequal,
  caml_greaterthan,
  caml_gt_float,
  caml_hash,
  caml_hash_univ_param,
  caml_hexstring_of_float,
  caml_hypot_float,
  caml_input_value,
  caml_input_value_from_bytes,
  caml_input_value_from_string,
  caml_input_value_to_outside_heap,
  caml_install_signal_handler,
  caml_int32_add,
  caml_int32_and,
  caml_int32_bits_of_float,
  caml_int32_bswap,
  caml_int32_compare,
  caml_int32_div,
  caml_int32_float_of_bits,
  caml_int32_format,
  caml_int32_mod,
  caml_int32_mul,
  caml_int32_neg,
  caml_int32_of_float,
  caml_int32_of_int,
  caml_int32_of_string,
  caml_int32_or,
  caml_int32_shift_left,
  caml_int32_shift_right,
  caml_int32_shift_right_unsigned,
  caml_int32_sub,
  caml_int32_to_float,
  caml_int32_to_int,
  caml_int32_xor,
  caml_int64_add,
  caml_int64_and,
  caml_int64_bits_of_float,
  caml_int64_bswap,
  caml_int64_compare,
  caml_int64_div,
  caml_int64_float_of_bits,
  caml_int64_format,
  caml_int64_mod,
  caml_int64_mul,
  caml_int64_neg,
  caml_int64_of_float,
  caml_int64_of_int,
  caml_int64_of_int32,
  caml_int64_of_nativeint,
  caml_int64_of_string,
  caml_int64_or,
  caml_int64_shift_left,
  caml_int64_shift_right,
  caml_int64_shift_right_unsigned,
  caml_int64_sub,
  caml_int64_to_float,
  caml_int64_to_int,
  caml_int64_to_int32,
  caml_int64_to_nativeint,
  caml_int64_xor,
  caml_int_as_pointer,
  caml_int_compare,
  caml_int_of_float,
  caml_int_of_string,
  caml_invoke_traced_function,
  caml_lazy_follow_forward,
  caml_lazy_make_forward,
  caml_ldexp_float,
  caml_le_float,
  caml_lessequal,
  caml_lessthan,
  caml_lex_engine,
  caml_log10_float,
  caml_log1p_float,
  caml_log_float,
  caml_lt_float,
  caml_make_array,
  caml_make_float_vect,
  caml_make_vect,
  caml_marshal_data_size,
  caml_md5_chan,
  caml_md5_string,
  caml_ml_bytes_length,
  caml_ml_channel_size,
  caml_ml_channel_size_64,
  caml_ml_close_channel,
  caml_ml_enable_runtime_warnings,
  caml_ml_flush,
  caml_ml_flush_partial,
  caml_ml_input,
  caml_ml_input_char,
  caml_ml_input_int,
  caml_ml_input_scan_line,
  caml_ml_open_descriptor_in,
  caml_ml_open_descriptor_out,
  caml_ml_out_channels_list,
  caml_ml_output,
  caml_ml_output_bytes,
  caml_ml_output_char,
  caml_ml_output_int,
  caml_ml_output_partial,
  caml_ml_pos_in,
  caml_ml_pos_in_64,
  caml_ml_pos_out,
  caml_ml_pos_out_64,
  caml_ml_runtime_warnings_enabled,
  caml_ml_seek_in,
  caml_ml_seek_in_64,
  caml_ml_seek_out,
  caml_ml_seek_out_64,
  caml_ml_set_binary_mode,
  caml_ml_set_channel_name,
  caml_ml_string_length,
  caml_modf_float,
  caml_mul_float,
  caml_nativeint_add,
  caml_nativeint_and,
  caml_nativeint_bswap,
  caml_nativeint_compare,
  caml_nativeint_div,
  caml_nativeint_format,
  caml_nativeint_mod,
  caml_nativeint_mul,
  caml_nativeint_neg,
  caml_nativeint_of_float,
  caml_nativeint_of_int,
  caml_nativeint_of_int32,
  caml_nativeint_of_string,
  caml_nativeint_or,
  caml_nativeint_shift_left,
  caml_nativeint_shift_right,
  caml_nativeint_shift_right_unsigned,
  caml_nativeint_sub,
  caml_nativeint_to_float,
  caml_nativeint_to_int,
  caml_nativeint_to_int32,
  caml_nativeint_xor,
  caml_neg_float,
  caml_neq_float,
  caml_new_lex_engine,
  caml_notequal,
  caml_obj_add_offset,
  caml_obj_block,
  caml_obj_dup,
  caml_obj_is_block,
  caml_obj_reachable_words,
  caml_obj_set_tag,
  caml_obj_tag,
  caml_obj_truncate,
  caml_output_value,
  caml_output_value_to_buffer,
  caml_output_value_to_bytes,
  caml_output_value_to_string,
  caml_parse_engine,
  caml_power_float,
  caml_raw_backtrace_length,
  caml_raw_backtrace_next_slot,
  caml_raw_backtrace_slot,
  caml_realloc_global,
  caml_record_backtrace,
  caml_register_channel_for_spacetime,
  caml_register_code_fragment,
  caml_register_named_value,
  caml_reify_bytecode,
  caml_remove_debug_info,
  caml_reset_afl_instrumentation,
  caml_restore_raw_backtrace,
  caml_runtime_parameters,
  caml_runtime_variant,
  caml_set_oo_id,
  caml_set_parser_trace,
  caml_setup_afl,
  caml_sin_float,
  caml_sinh_float,
  caml_spacetime_enabled,
  caml_spacetime_only_works_for_native_code,
  caml_sqrt_float,
  caml_static_alloc,
  caml_static_free,
  caml_static_release_bytecode,
  caml_static_resize,
  caml_string_compare,
  caml_string_equal,
  caml_string_get,
  caml_string_get16,
  caml_string_get32,
  caml_string_get64,
  caml_string_greaterequal,
  caml_string_greaterthan,
  caml_string_lessequal,
  caml_string_lessthan,
  caml_string_notequal,
  caml_string_of_bytes,
  caml_string_set,
  caml_sub_float,
  caml_sys_chdir,
  caml_sys_close,
  caml_sys_const_backend_type,
  caml_sys_const_big_endian,
  caml_sys_const_int_size,
  caml_sys_const_max_wosize,
  caml_sys_const_ostype_cygwin,
  caml_sys_const_ostype_unix,
  caml_sys_const_ostype_win32,
  caml_sys_const_word_size,
  caml_sys_exit,
  caml_sys_file_exists,
  caml_sys_get_argv,
  caml_sys_get_config,
  caml_sys_getcwd,
  caml_sys_getenv,
  caml_sys_is_directory,
  caml_sys_isatty,
  caml_sys_open,
  caml_sys_random_seed,
  caml_sys_read_directory,
  caml_sys_remove,
  caml_sys_rename,
  caml_sys_system_command,
  caml_sys_time,
  caml_sys_time_include_children,
  caml_sys_unsafe_getenv,
  caml_tan_float,
  caml_tanh_float,
  caml_terminfo_rows,
  caml_update_dummy,
  caml_weak_blit,
  caml_weak_check,
  caml_weak_create,
  caml_weak_get,
  caml_weak_get_copy,
  caml_weak_set,
  caml_string_of_int,
  caml_string_of_float,
  caml_unsafe_string_of_bytes,
  caml_unsafe_bytes_of_string,
  caml_avr_delay,
  caml_avr_millis,
  caml_avr_serial_init,
  caml_avr_serial_read,
  caml_avr_serial_write,
  caml_avr_write_register,
  caml_avr_read_register,
  caml_avr_set_bit,
  caml_avr_clear_bit,
  caml_avr_read_bit,
  (primitive) 0 };
const char * caml_names_of_builtin_cprim[] = {
  "caml_abs_float",
  "caml_acos_float",
  "caml_add_debug_info",
  "caml_add_float",
  "caml_alloc_dummy",
  "caml_alloc_dummy_float",
  "caml_alloc_dummy_function",
  "caml_array_append",
  "caml_array_blit",
  "caml_array_concat",
  "caml_array_get",
  "caml_array_get_addr",
  "caml_array_get_float",
  "caml_array_set",
  "caml_array_set_addr",
  "caml_array_set_float",
  "caml_array_sub",
  "caml_array_unsafe_get",
  "caml_array_unsafe_get_float",
  "caml_array_unsafe_set",
  "caml_array_unsafe_set_addr",
  "caml_array_unsafe_set_float",
  "caml_asin_float",
  "caml_atan2_float",
  "caml_atan_float",
  "caml_ba_blit",
  "caml_ba_change_layout",
  "caml_ba_create",
  "caml_ba_dim",
  "caml_ba_dim_1",
  "caml_ba_dim_2",
  "caml_ba_dim_3",
  "caml_ba_fill",
  "caml_ba_get_1",
  "caml_ba_get_2",
  "caml_ba_get_3",
  "caml_ba_get_generic",
  "caml_ba_kind",
  "caml_ba_layout",
  "caml_ba_num_dims",
  "caml_ba_reshape",
  "caml_ba_set_1",
  "caml_ba_set_2",
  "caml_ba_set_3",
  "caml_ba_set_generic",
  "caml_ba_slice",
  "caml_ba_sub",
  "caml_ba_uint8_get16",
  "caml_ba_uint8_get32",
  "caml_ba_uint8_get64",
  "caml_ba_uint8_set16",
  "caml_ba_uint8_set32",
  "caml_ba_uint8_set64",
  "caml_backtrace_status",
  "caml_blit_bytes",
  "caml_blit_string",
  "caml_bswap16",
  "caml_bytes_compare",
  "caml_bytes_equal",
  "caml_bytes_get",
  "caml_bytes_get16",
  "caml_bytes_get32",
  "caml_bytes_get64",
  "caml_bytes_greaterequal",
  "caml_bytes_greaterthan",
  "caml_bytes_lessequal",
  "caml_bytes_lessthan",
  "caml_bytes_notequal",
  "caml_bytes_of_string",
  "caml_bytes_set",
  "caml_bytes_set16",
  "caml_bytes_set32",
  "caml_bytes_set64",
  "caml_ceil_float",
  "caml_channel_descriptor",
  "caml_classify_float",
  "caml_compare",
  "caml_convert_raw_backtrace",
  "caml_convert_raw_backtrace_slot",
  "caml_copysign_float",
  "caml_cos_float",
  "caml_cosh_float",
  "caml_create_bytes",
  "caml_create_string",
  "caml_div_float",
  "caml_dynlink_add_primitive",
  "caml_dynlink_close_lib",
  "caml_dynlink_get_current_libs",
  "caml_dynlink_lookup_symbol",
  "caml_dynlink_open_lib",
  "caml_ensure_stack_capacity",
  "caml_ephe_blit_data",
  "caml_ephe_blit_key",
  "caml_ephe_check_data",
  "caml_ephe_check_key",
  "caml_ephe_create",
  "caml_ephe_get_data",
  "caml_ephe_get_data_copy",
  "caml_ephe_get_key",
  "caml_ephe_get_key_copy",
  "caml_ephe_set_data",
  "caml_ephe_set_key",
  "caml_ephe_unset_data",
  "caml_ephe_unset_key",
  "caml_eq_float",
  "caml_equal",
  "caml_exp_float",
  "caml_expm1_float",
  "caml_fill_bytes",
  "caml_fill_string",
  "caml_final_register",
  "caml_final_register_called_without_value",
  "caml_final_release",
  "caml_float_compare",
  "caml_float_of_int",
  "caml_float_of_string",
  "caml_floatarray_create",
  "caml_floatarray_get",
  "caml_floatarray_set",
  "caml_floatarray_unsafe_get",
  "caml_floatarray_unsafe_set",
  "caml_floor_float",
  "caml_fmod_float",
  "caml_format_float",
  "caml_format_int",
  "caml_fresh_oo_id",
  "caml_frexp_float",
  "caml_gc_compaction",
  "caml_gc_counters",
  "caml_gc_full_major",
  "caml_gc_get",
  "caml_gc_huge_fallback_count",
  "caml_gc_major",
  "caml_gc_major_slice",
  "caml_gc_minor",
  "caml_gc_minor_words",
  "caml_gc_quick_stat",
  "caml_gc_set",
  "caml_gc_stat",
  "caml_ge_float",
  "caml_get_current_callstack",
  "caml_get_current_environment",
  "caml_get_exception_backtrace",
  "caml_get_exception_raw_backtrace",
  "caml_get_global_data",
  "caml_get_major_bucket",
  "caml_get_major_credit",
  "caml_get_minor_free",
  "caml_get_public_method",
  "caml_get_section_table",
  "caml_greaterequal",
  "caml_greaterthan",
  "caml_gt_float",
  "caml_hash",
  "caml_hash_univ_param",
  "caml_hexstring_of_float",
  "caml_hypot_float",
  "caml_input_value",
  "caml_input_value_from_bytes",
  "caml_input_value_from_string",
  "caml_input_value_to_outside_heap",
  "caml_install_signal_handler",
  "caml_int32_add",
  "caml_int32_and",
  "caml_int32_bits_of_float",
  "caml_int32_bswap",
  "caml_int32_compare",
  "caml_int32_div",
  "caml_int32_float_of_bits",
  "caml_int32_format",
  "caml_int32_mod",
  "caml_int32_mul",
  "caml_int32_neg",
  "caml_int32_of_float",
  "caml_int32_of_int",
  "caml_int32_of_string",
  "caml_int32_or",
  "caml_int32_shift_left",
  "caml_int32_shift_right",
  "caml_int32_shift_right_unsigned",
  "caml_int32_sub",
  "caml_int32_to_float",
  "caml_int32_to_int",
  "caml_int32_xor",
  "caml_int64_add",
  "caml_int64_and",
  "caml_int64_bits_of_float",
  "caml_int64_bswap",
  "caml_int64_compare",
  "caml_int64_div",
  "caml_int64_float_of_bits",
  "caml_int64_format",
  "caml_int64_mod",
  "caml_int64_mul",
  "caml_int64_neg",
  "caml_int64_of_float",
  "caml_int64_of_int",
  "caml_int64_of_int32",
  "caml_int64_of_nativeint",
  "caml_int64_of_string",
  "caml_int64_or",
  "caml_int64_shift_left",
  "caml_int64_shift_right",
  "caml_int64_shift_right_unsigned",
  "caml_int64_sub",
  "caml_int64_to_float",
  "caml_int64_to_int",
  "caml_int64_to_int32",
  "caml_int64_to_nativeint",
  "caml_int64_xor",
  "caml_int_as_pointer",
  "caml_int_compare",
  "caml_int_of_float",
  "caml_int_of_string",
  "caml_invoke_traced_function",
  "caml_lazy_follow_forward",
  "caml_lazy_make_forward",
  "caml_ldexp_float",
  "caml_le_float",
  "caml_lessequal",
  "caml_lessthan",
  "caml_lex_engine",
  "caml_log10_float",
  "caml_log1p_float",
  "caml_log_float",
  "caml_lt_float",
  "caml_make_array",
  "caml_make_float_vect",
  "caml_make_vect",
  "caml_marshal_data_size",
  "caml_md5_chan",
  "caml_md5_string",
  "caml_ml_bytes_length",
  "caml_ml_channel_size",
  "caml_ml_channel_size_64",
  "caml_ml_close_channel",
  "caml_ml_enable_runtime_warnings",
  "caml_ml_flush",
  "caml_ml_flush_partial",
  "caml_ml_input",
  "caml_ml_input_char",
  "caml_ml_input_int",
  "caml_ml_input_scan_line",
  "caml_ml_open_descriptor_in",
  "caml_ml_open_descriptor_out",
  "caml_ml_out_channels_list",
  "caml_ml_output",
  "caml_ml_output_bytes",
  "caml_ml_output_char",
  "caml_ml_output_int",
  "caml_ml_output_partial",
  "caml_ml_pos_in",
  "caml_ml_pos_in_64",
  "caml_ml_pos_out",
  "caml_ml_pos_out_64",
  "caml_ml_runtime_warnings_enabled",
  "caml_ml_seek_in",
  "caml_ml_seek_in_64",
  "caml_ml_seek_out",
  "caml_ml_seek_out_64",
  "caml_ml_set_binary_mode",
  "caml_ml_set_channel_name",
  "caml_ml_string_length",
  "caml_modf_float",
  "caml_mul_float",
  "caml_nativeint_add",
  "caml_nativeint_and",
  "caml_nativeint_bswap",
  "caml_nativeint_compare",
  "caml_nativeint_div",
  "caml_nativeint_format",
  "caml_nativeint_mod",
  "caml_nativeint_mul",
  "caml_nativeint_neg",
  "caml_nativeint_of_float",
  "caml_nativeint_of_int",
  "caml_nativeint_of_int32",
  "caml_nativeint_of_string",
  "caml_nativeint_or",
  "caml_nativeint_shift_left",
  "caml_nativeint_shift_right",
  "caml_nativeint_shift_right_unsigned",
  "caml_nativeint_sub",
  "caml_nativeint_to_float",
  "caml_nativeint_to_int",
  "caml_nativeint_to_int32",
  "caml_nativeint_xor",
  "caml_neg_float",
  "caml_neq_float",
  "caml_new_lex_engine",
  "caml_notequal",
  "caml_obj_add_offset",
  "caml_obj_block",
  "caml_obj_dup",
  "caml_obj_is_block",
  "caml_obj_reachable_words",
  "caml_obj_set_tag",
  "caml_obj_tag",
  "caml_obj_truncate",
  "caml_output_value",
  "caml_output_value_to_buffer",
  "caml_output_value_to_bytes",
  "caml_output_value_to_string",
  "caml_parse_engine",
  "caml_power_float",
  "caml_raw_backtrace_length",
  "caml_raw_backtrace_next_slot",
  "caml_raw_backtrace_slot",
  "caml_realloc_global",
  "caml_record_backtrace",
  "caml_register_channel_for_spacetime",
  "caml_register_code_fragment",
  "caml_register_named_value",
  "caml_reify_bytecode",
  "caml_remove_debug_info",
  "caml_reset_afl_instrumentation",
  "caml_restore_raw_backtrace",
  "caml_runtime_parameters",
  "caml_runtime_variant",
  "caml_set_oo_id",
  "caml_set_parser_trace",
  "caml_setup_afl",
  "caml_sin_float",
  "caml_sinh_float",
  "caml_spacetime_enabled",
  "caml_spacetime_only_works_for_native_code",
  "caml_sqrt_float",
  "caml_static_alloc",
  "caml_static_free",
  "caml_static_release_bytecode",
  "caml_static_resize",
  "caml_string_compare",
  "caml_string_equal",
  "caml_string_get",
  "caml_string_get16",
  "caml_string_get32",
  "caml_string_get64",
  "caml_string_greaterequal",
  "caml_string_greaterthan",
  "caml_string_lessequal",
  "caml_string_lessthan",
  "caml_string_notequal",
  "caml_string_of_bytes",
  "caml_string_set",
  "caml_sub_float",
  "caml_sys_chdir",
  "caml_sys_close",
  "caml_sys_const_backend_type",
  "caml_sys_const_big_endian",
  "caml_sys_const_int_size",
  "caml_sys_const_max_wosize",
  "caml_sys_const_ostype_cygwin",
  "caml_sys_const_ostype_unix",
  "caml_sys_const_ostype_win32",
  "caml_sys_const_word_size",
  "caml_sys_exit",
  "caml_sys_file_exists",
  "caml_sys_get_argv",
  "caml_sys_get_config",
  "caml_sys_getcwd",
  "caml_sys_getenv",
  "caml_sys_is_directory",
  "caml_sys_isatty",
  "caml_sys_open",
  "caml_sys_random_seed",
  "caml_sys_read_directory",
  "caml_sys_remove",
  "caml_sys_rename",
  "caml_sys_system_command",
  "caml_sys_time",
  "caml_sys_time_include_children",
  "caml_sys_unsafe_getenv",
  "caml_tan_float",
  "caml_tanh_float",
  "caml_terminfo_rows",
  "caml_update_dummy",
  "caml_weak_blit",
  "caml_weak_check",
  "caml_weak_create",
  "caml_weak_get",
  "caml_weak_get_copy",
  "caml_weak_set",
  "caml_string_of_int",
  "caml_string_of_float",
  "caml_unsafe_string_of_bytes",
  "caml_unsafe_bytes_of_string",
  "caml_avr_delay",
  "caml_avr_millis",
  "caml_avr_serial_init",
  "caml_avr_serial_read",
  "caml_avr_serial_write",
  "caml_avr_write_register",
  "caml_avr_read_register",
  "caml_avr_set_bit",
  "caml_avr_clear_bit",
  "caml_avr_read_bit",
  (char *) 0 };
