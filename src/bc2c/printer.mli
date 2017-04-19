val print_codegen_word_array : out_channel -> string -> string -> string -> Codegen.word list -> unit
val print_datagen_word_array : out_channel -> string -> string -> string -> Datagen.word list -> unit
val print_opcodes : out_channel -> Opcode.t list -> unit
val print_prim : out_channel -> OByteLib.Prim.t -> unit
