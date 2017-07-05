module Arduboy = struct
  type button = A | B | UP | DOWN | LEFT | RIGHT
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print   : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
  external clear : unit -> unit = "ocaml_arduboy_clear"
  external draw_rect : int -> int -> int -> int -> int -> unit = "ocaml_arduboy_draw_rect"
  external draw_circle : int -> int -> int -> int -> unit = "ocaml_arduboy_draw_circle"
  external draw_line : int -> int -> int -> int -> int -> unit = "ocaml_arduboy_draw_line"
  external draw_pixel : int -> int -> int -> unit = "ocaml_arduboy_draw_pixel"
  external fill_rect : int -> int -> int -> int -> int -> unit = "ocaml_arduboy_fill_rect"
  external fill_circle : int -> int -> int -> int -> unit = "ocaml_arduboy_fill_circle"
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

(* let rec facto x = *)
(*   match x with *)
(*   | 0 -> 1 *)
(*   | _ -> facto (x - 1) * x *)

let facto x =
  let rec aux x cpt =
    match x with
    | 0 -> 1
    | _ -> aux (x-1) (x*cpt)
  in
  aux x 1


let () =
  Arduboy.init ();
  Arduboy.print_int (facto 5) ;
  Arduboy.display ()
  (* Arduboy.print "facto 6"; *)
  (* Arduboy.print " = "; *)
  (* Arduboy.display (); *)
  (* let x = facto 6 in *)
  (* Arduboy.print_int (x); *)
  (* Arduboy.print " \n"; *)
  (* Arduboy.display (); *)
