(* Hashtbl using physical equality to compare keys instead of structural equality. *)

type ('k, 'v) t

val create : unit -> ('k, 'v) t
val put    : ('k, 'v) t -> 'k -> 'v -> unit
val mem    : ('k, 'v) t -> 'k -> bool
val del    : ('k, 'v) t -> 'k -> unit
val find   : ('k, 'v) t -> 'k -> 'v
