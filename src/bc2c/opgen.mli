type t

val create : unit -> t
val generate : t -> Opcode.t -> int
val sort : t -> [ `SORTED | `ALREADY_SORTED ]
val export : t -> (Opcode.t * int) list
