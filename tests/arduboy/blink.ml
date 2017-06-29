module Arduboy = struct
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print   : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
  external draw_rect : int -> int -> int -> int -> int -> unit = "ocaml_arduboy_draw_rect"
  external draw_circle : int -> int -> int -> int -> unit = "ocaml_arduboy_draw_circle"
  external draw_line : int -> int -> int -> int -> int -> unit = "ocaml_arduboy_draw_line"
  external draw_pixel : int -> int -> int -> unit = "ocaml_arduboy_draw_pixel"
  external fill_rect : int -> int -> int -> int -> int -> unit = "ocaml_arduboy_fill_rect"
  external fill_circle : int -> int -> int -> int -> unit = "ocaml_arduboy_fill_circle"
end

let rec facto x =
  match x with
  | 0 -> 1
  | _ -> facto (x - 1) * x

(* let facto x = *)
(*   let rec aux x acc = *)
(*     match x with *)
(*     | 0 -> acc *)
(*     | _ -> aux (x-1) (acc*x) *)
(*   in *)
(*   aux x 1 *)


let () =
  Arduboy.init ();
  (* for i = 0 to 4 do *)
  (* (\* Arduboy.print "facto "; *\) *)
  (* (\* Arduboy.print_int i; *\) *)
  (* (\* Arduboy.print " = "; *\) *)
  (*   let x = facto i in *)
  (*   (\* x *\) *)
  (* Arduboy.print_int (x); *)
  (* Arduboy.print " \n"; *)
  (* Arduboy.display (); *)
  (* (\* delay 1000 *\) *)
  (* (\* blink PIN17 100 1000 *\) *)
  (* done; *)
  for i = 0 to 5 do
    Arduboy.draw_circle 64 32 (i*10) 255;
    Arduboy.draw_line 0 (i*10) 128 (i*10) 100;
  done;
  Arduboy.fill_rect 12 12 22 22 100;
  Arduboy.display ();
