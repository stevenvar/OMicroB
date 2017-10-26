module Arduboy = struct
  type button = A | B | UP | DOWN | LEFT | RIGHT
  external millis : unit -> int = "ocaml_arduino_millis"
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print   : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
  external clear : unit -> unit = "ocaml_arduboy_clear"
  external pressed : int -> bool = "ocaml_arduboy_pressed"

  let is_pressed b =
    match b with
    | UP -> pressed 7
    | DOWN -> pressed 4
    | LEFT -> pressed 5
    | RIGHT -> pressed 6
    | A -> pressed 3
    | B -> pressed 2
end


let _ = ()
  (* Arduboy.print_int 1; *)
  (* Arduboy.display(); *)
