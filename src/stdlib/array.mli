external length : 'a array -> int = "%array_length"
external get : 'a array -> int -> 'a = "%array_safe_get"
external set : 'a array -> int -> 'a -> unit = "%array_safe_set"
external unsafe_get : 'a array -> int -> 'a = "%array_unsafe_get"
external unsafe_set : 'a array -> int -> 'a -> unit = "%array_unsafe_set"
external make : int -> 'a -> 'a array = "caml_make_vect"
val make_matrix : int -> int -> 'a -> 'a array array
val init : int -> (int -> 'a) -> 'a array
val iter : ('a -> 'b) -> 'a array -> unit
val iteri : (int -> 'a -> 'b) -> 'a array -> unit
