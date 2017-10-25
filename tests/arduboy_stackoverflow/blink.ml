module Arduboy = struct
  external millis : unit -> int = "ocaml_arduino_millis"
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print   : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
  external clear : unit -> unit = "ocaml_arduboy_clear"
end

let rec fact x =
  match x with
  | 0 -> 1
  | _ -> fact (x - 1) * x


let () =
  Arduboy.init ();
  let t = Arduboy.millis () in
  for i = 0 to 9 do
    let _ = fact i in ()
  done;
  Arduboy.print_int (Arduboy.millis () -t);
  Arduboy.display ();
