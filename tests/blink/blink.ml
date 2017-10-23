module Arduboy = struct
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
end

let rec facto x =
  if x = 0 then 1
  else
    facto (x-1) * x

let _ =
    let x = facto 3 in
  Arduboy.init();
    (* Disp.init (); *)
  (* Disp.config (); *)
  (* Disp.print_string "Hello world"; *)
  (* Disp.print_int (facto 3) *)
  (* write_reg TRISB 0x00; *)
  (* print_int 8; *)
  Arduboy.print_int x
  (* write_reg PORTB (facto 3) *)
