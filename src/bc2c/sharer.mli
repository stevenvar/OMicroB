type 'a t

val create : unit -> 'a t

val find_int32       : 'a t -> int32 -> 'a
val find_int64       : 'a t -> int64 -> 'a
val find_nativeint   : 'a t -> nativeint -> 'a
val find_float_array : 'a t -> T.mutability -> float array -> 'a
val find_bytes       : 'a t -> T.mutability -> bytes -> 'a
val find_block       : 'a t -> T.mutability -> int -> T.value array -> 'a
val find_closure     : 'a t -> T.code_ptr array -> T.value array -> 'a

val put_int32        : 'a t -> int32 -> 'a -> unit
val put_int64        : 'a t -> int64 -> 'a -> unit
val put_nativeint    : 'a t -> nativeint -> 'a -> unit
val put_float_array  : 'a t -> T.mutability -> float array -> 'a -> unit
val put_bytes        : 'a t -> T.mutability -> bytes -> 'a -> unit
val put_block        : 'a t -> T.mutability -> int -> T.value array -> 'a -> unit
val put_closure      : 'a t -> T.code_ptr array -> T.value array -> 'a -> unit
