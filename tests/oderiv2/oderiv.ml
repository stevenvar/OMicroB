module Array = struct
  external length : 'a array -> int = "%array_length"
  external get: 'a array -> int -> 'a = "%array_safe_get"
  external set: 'a array -> int -> 'a -> unit = "%array_safe_set"
  external make: int -> 'a -> 'a array = "caml_make_vect"
end;;
module Arduboy = struct
  (* external reset_cursor : unit -> unit = "ocaml_arduboy_reset_cursor" *)
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external clear : unit -> unit = "ocaml_arduboy_clear"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
    external millis  : unit -> int = "ocaml_arduboy_millis"
end

let failwith s = raise(Failure s);;
open Arduboy;;

let rec map f = function [] -> [] | h::t -> (f h)::(map f t);;

type operator = P | M | T | D;;

type dexpr = Numb of int
	| Symbole of string
	| Dexpr of operator * (dexpr list);;

let xx = "x"


let rec derive =
  let deriv_aux a = Dexpr (D,[derive a; a]) in
  function
    Numb _ -> Numb 0
  | Symbole z -> if z = xx then  Numb 1 else Numb 0
  (* | Symbole _ -> Numb 0 *)
  | Dexpr (P, lexpr) -> Dexpr (P, map derive lexpr)
  | Dexpr (M, lexpr) -> Dexpr (M, map derive lexpr)
  | Dexpr (T, lexpr) as a -> Dexpr (T, [a ; Dexpr (P, map deriv_aux lexpr)])
  | Dexpr (D, [a1;a2])
           -> Dexpr (M, [Dexpr (D, [derive a1 ; a2]) ;
			 Dexpr (D, [a1 ; Dexpr (T, [a2;a2;derive a2])])])
  | _ -> failwith "no"
 	    (* FORMULA IS WRONG BUT NEVER USED IN TEST *)


(* let pol = Dexpr (P, [Dexpr (T, [Numb 3; Symbole "x"; Symbole "x"]) ; *)
(*                      Dexpr (T, [Symbole "a"; Symbole "x"; Symbole "x"]) ; *)
(*                      Dexpr (T, [Symbole "b"; Symbole "x"]) ; *)
(*                      Numb 5]);; *)
(* (\* let res = ref pol;; *\) *)

let (@) a b = Dexpr (T, [a;b])
let (+) a b = Dexpr (P, [a;b])
let x = Symbole xx
(* x^2 + x *)
let pol = (x@x) + x

let rec iter f = function
    [] -> ()
  | x :: xs -> (f x) ; iter f xs

let rec print_expr = function
  | Numb x -> print_int x
  | Symbole x -> print_string x
  | Dexpr (P, lexpr) -> print_string "(+"; iter print_expr lexpr; print_string ")"
  | Dexpr (M, lexpr) -> print_string "(-"; iter print_expr lexpr; print_string ")"
  | Dexpr (T, lexpr) -> print_string "(*"; iter print_expr lexpr; print_string ")"
  | Dexpr (D, lexpr) -> print_string "(/"; iter print_expr lexpr; print_string ")"

let res = ref pol

let main() =
  Arduboy.init();
  let x = Arduboy.millis () in
  (* for i = 0 to 999 do *)
  (*   res := derive pol; *)
  (*   res := derive pol; *)
  (*   res := derive pol; *)
  (*   res := derive pol; *)
  (*   res := derive pol *)
  (* done; *)
  res := derive pol;
  print_expr !res;
  let y = Arduboy.millis () in
  Arduboy.print_string("\n");
  Arduboy.print_int (y-x);
  Arduboy.display();;

main();;
