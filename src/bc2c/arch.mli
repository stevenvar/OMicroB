type t = A16 | A32 | A64

val of_int     : int -> t
val to_string  : t -> string
val byte_count : t -> int
