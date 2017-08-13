type 'a t = 'a list ref

val acc    : 'a t -> int -> 'a
val push   : 'a t -> 'a -> unit
val pop    : 'a t -> 'a
val popn   : 'a t -> int -> unit
val assign : 'a t -> int -> 'a -> unit
