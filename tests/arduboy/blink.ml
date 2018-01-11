module Arduboy = struct
  external millis : unit -> int = "ocaml_arduboy_millis"
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end;;


let _ =
  Arduboy.init();
  Arduboy.print_int 1;
  Arduboy.display()
