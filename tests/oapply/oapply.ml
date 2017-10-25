
module Arduboy = struct
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external clear : unit -> unit = "ocaml_arduboy_clear"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end;;
  Arduboy.init();;
let succ x = x + 1
let double = fun f x -> f (f x)

(* let quad x  = double double  x *)
(* let oct x = quad quad x *)



(* let rec repeat n = *)
(*   if n <= 0 then 0 else (repeat (n-1); double oct succ 1) *)

(* let add_x x = (fun y -> y + x)  *)

(* let add_12 = add_x 12 *)

let _ =

  (* Arduboy.print_int (repeat 1); *)
  Arduboy.print_int (double double succ 1);
  (* Arduboy.print_int (add_12 8); *)
  Arduboy.display();
  
