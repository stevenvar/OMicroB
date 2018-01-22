/******************************************************************************/

static const val_t out_of_memory_exn_s[] = {
  Make_header(4, String_tag, Color_white),
  Make_string_data('O', 'u', 't', '_'),
  Make_string_data('o', 'f', '_', 'm'),
  Make_string_data('e', 'm', 'o', 'r'),
  Make_string_data('y', '\0', '\0', '\2')
};

static const val_t out_of_memory_exn[] = {
  Make_header(2, Object_tag, Color_white),
  Val_block(&out_of_memory_exn_s[1]),
  Val_int(-1)
};

const val_t ocaml_out_of_memory = Val_block(&out_of_memory_exn[1]);

/******************************************************************************/

static const val_t stack_overflow_exn_s[] = {
  Make_header(4, String_tag, Color_white),
  Make_string_data('S', 't', 'a', 'c'),
  Make_string_data('k', '_', 'o', 'v'),
  Make_string_data('e', 'r', 'f', 'l'),
  Make_string_data('o', 'w', '\0', '\1')
};

static const val_t stack_overflow_exn[] = {
  Make_header(2, Object_tag, Color_white),
  Val_block(&stack_overflow_exn_s[1]),
  Val_int(-9)
};

const val_t ocaml_stack_overflow = Val_block(&stack_overflow_exn[1]);

/******************************************************************************/

static const val_t division_by_zero_exn_s[] = {
  Make_header(5, String_tag, Color_white),
  Make_string_data('D', 'i', 'v', 'i'),
  Make_string_data('s', 'i', 'o', 'n'),
  Make_string_data('_', 'b', 'y', '_'),
  Make_string_data('z', 'e', 'r', 'o'),
  Make_string_data('\0', '\0', '\0', '\3')
};

static const val_t division_by_zero_exn[] = {
  Make_header(2, Object_tag, Color_white),
  Val_block(&division_by_zero_exn_s[1]),
  Val_int(-6)
};

const val_t ocaml_division_by_zero = Val_block(&division_by_zero_exn[1]);

/******************************************************************************/

static const val_t invalid_argument_exn_s[] = {
  Make_header(5, String_tag, Color_white),
  Make_string_data('I', 'n', 'v', 'a'),
  Make_string_data('l', 'i', 'd', '_'),
  Make_string_data('a', 'r', 'g', 'u'),
  Make_string_data('m', 'e', 'n', 't'),
  Make_string_data('\0', '\0', '\0', '\3')
};

static const val_t invalid_argument_exn[] = {
  Make_header(2, Object_tag, Color_white),
  Val_block(&invalid_argument_exn_s[1]),
  Val_int(-4)
};

const val_t ocaml_invalid_argument = Val_block(&invalid_argument_exn[1]);

/******************************************************************************/
