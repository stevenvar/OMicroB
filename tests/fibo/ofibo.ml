
module Arduboy = struct
  (* external reset_cursor : unit -> unit = "ocaml_arduboy_reset_cursor" *)
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external clear : unit -> unit = "ocaml_arduboy_clear"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
  external millis : unit  -> int = "ocaml_arduboy_millis"
end

let rec fibo x =
  if x <= 1 then 1
  else fibo (x-1) + fibo (x -2)

let _ =
  Arduboy.init ();
  let x = Arduboy.millis () in
  for i = 0 to 10 do
    (* Arduboy.print_int(facto i); *)
    for i = 0 to 10 do
      fibo i;
    done;
  done;
  let y = Arduboy.millis () in
  Arduboy.print_string "\n";
  Arduboy.print_int (y-x);

  Arduboy.display()
