val fail : ('a, unit, string, 'b) format4 -> 'a

val with_ic : string -> (in_channel -> 'a) -> 'a
val with_oc : string -> (out_channel -> 'a) -> 'a

val is_prefix : prefix:string -> string -> bool
val is_suffix : suffix:string -> string -> bool
