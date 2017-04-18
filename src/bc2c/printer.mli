val print_c_array : out_channel -> string -> string -> string -> int list -> unit
val print_opgen : out_channel -> (Opcode.t * int) list -> unit
val print_prim : out_channel -> OByteLib.Prim.t -> unit
