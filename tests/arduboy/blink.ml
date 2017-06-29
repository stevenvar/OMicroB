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

type 'a ref = { mutable contents : 'a }

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
  (* for i = 0 to 5 do *)
  (*   Arduboy.draw_circle 64 32 (i*10) 255; *)
  (*   Arduboy.draw_line 0 (i*10) 128 (i*10) 100; *)
  (* done; *)
  let x = { contents = 0} in
  let y = { contents = 0} in
  while true do
    Arduboy.clear ();
    if Arduboy.is_pressed Arduboy.LEFT then
        x.contents <- x.contents - 1;
    if Arduboy.is_pressed Arduboy.RIGHT then
      x.contents <- x.contents + 1;
    if Arduboy.is_pressed Arduboy.UP then
      y.contents <- y.contents - 1;
    if Arduboy.is_pressed Arduboy.DOWN then
      y.contents <- y.contents + 1;
    Arduboy.draw_circle x.contents y.contents 10 255;
    if Arduboy.is_pressed Arduboy.A then
      Arduboy.fill_rect 0 0 22 22 100;
    if Arduboy.is_pressed Arduboy.B then
      Arduboy.fill_rect 0 10 22 22 100;
    Arduboy.display ();
  done
