val export : Arch.t -> T.code_ptr array -> T.value -> T.stack -> T.globals -> T.dword * T.dword list * T.dword list * T.dword list
val reverse_stack : int -> T.dword list -> T.dword list
