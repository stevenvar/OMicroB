type t

val create   : unit -> t
val push     : t -> T.dword -> unit
val push_ref : t -> T.dword ref
val pointer  : t -> int
val contents : t -> T.dword list
