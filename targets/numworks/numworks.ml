(* Timing *)

external delay: int -> unit = "caml_delay" [@@noalloc]
external millis : unit -> int = "caml_millis" [@@noalloc]

(* Printing *)

external print_string : string -> unit = "caml_numworks_print_string" [@@noalloc]
