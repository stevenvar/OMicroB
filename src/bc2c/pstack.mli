type 'a t = 'a list

val acc    : 'a t -> int -> 'a
val push   : 'a t -> 'a -> 'a t
val pop    : 'a t -> 'a * 'a t
val popn   : 'a t -> int -> 'a t
val topn   : 'a t -> int -> 'a t
val assign : 'a t -> int -> 'a -> 'a t
