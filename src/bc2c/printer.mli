val string_of_dword : T.dword -> string
val print_codegen_word_array : out_channel -> string -> string -> string -> T.cword list -> unit
val print_datagen_word_array : out_channel -> string -> string -> string -> T.dword list -> unit
val print_opcodes : out_channel -> Opcode.t list -> unit
val print_prim : out_channel -> OByteLib.Prim.t -> unit
