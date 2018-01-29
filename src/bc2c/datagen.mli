val split_globals : Arch.t -> T.globals -> OByteLib.Code.t -> T.globals * T.globals * T.instr array
val export : Arch.t -> T.code_ptr array -> T.value -> T.stack -> T.globals -> T.globals -> T.dword * (string * T.dword) list * T.dword * T.dword list * T.dword list * T.dword list * T.dword list * T.dword list
val reverse_stack : int -> T.dword list -> T.dword list
