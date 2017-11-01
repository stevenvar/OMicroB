module Arduboy = struct
  external millis : unit -> int = "ocaml_arduboy_millis"
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_float : float -> unit = "ocaml_arduboy_print_float"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end;;

let integrale f a b n =
  let h = (b -. a) /. n in
  let rec integ x =
    if  x >=  b then 0.0 else (f x) +. integ (x +. h) in
  integ  a *. h


let poly x = x *. x

let repeat n =
  for i = 0 to (n-1) do
    integrale poly 0.0 1.0 10.;
    (* force_gc(); *)
  done;
  integrale poly 0.0 1.0 10.

let _ =
  Arduboy.init();
  (* Arduboy.print_float (repeat 10); *)
  (* let x = Arduboy.millis () in *)
  (* integrale poly 0.0 1.0 10.; *)
  (* force_gc(); *)
  (* Arduboy.print_float 4.5; *)
  Arduboy.print_float (repeat 3);

  (* let y = Arduboy.millis () - x in *)
  (* Arduboy.print_int y; *)
  (* Arduboy.print_float (integrale poly 0.0 1.0 10.); *)
  (* let y = fact_floats 4. in *)
  (* Arduboy.print_float (y); *)
  Arduboy.display();
