type t = A16 | A32 | A64

val of_int            : int -> t
val to_string         : t -> string
val byte_count        : t -> int
val bit_count         : t -> int
val hd_size_bitcnt    : t -> int

val support_int32     : t -> Int32.t     -> bool
val support_int64     : t -> Int64.t     -> bool
val support_nativeint : t -> Nativeint.t -> bool

val normalize_int     : t -> int -> int
