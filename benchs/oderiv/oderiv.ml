(* let failwith s = raise(Failure s);; *)

let rec iter f = function [] -> () | h::t -> (f h); iter f t;;
let rec map f = function [] -> [] | h::t -> (f h)::(map f t);;

type operator = P | M | T | D;;

type dexpr = Numb of int
	| Symbole of string
	| Dexpr of operator * (dexpr list);;

let xx = "x"

let rec derive =
  (* let deriv_aux a = Dexpr (D,[derive a; a]) in *)
  function
    Numb _ -> Numb 0
  | Symbole z -> if z = xx then  Numb 1 else Numb 0
  (* | Symbole _ -> Numb 0 *)
  | Dexpr (P, lexpr) -> Dexpr (P, map derive lexpr)
  | Dexpr (M, lexpr) -> Dexpr (M, map derive lexpr)
  (* | Dexpr (T, lexpr) as a -> Dexpr (T, [a ; Dexpr (P, map deriv_aux lexpr)]) *)
  | Dexpr (T, [a1;a2])
    -> Dexpr (P, [Dexpr(T, [derive a1;a2]);
                  Dexpr(T, [a1; derive a2])])
  | Dexpr (D, [a1;a2])
           -> Dexpr (M, [Dexpr (D, [derive a1 ; a2]) ;
			 Dexpr (D, [a1 ; Dexpr (T, [a2;a2;derive a2])])])
  | _ -> Numb (-1)
 	    (* FORMULA IS WRONG BUT NEVER USED IN TEST *)

(* let rec print = *)
(*   function *)
(*   | Numb x -> Arduboy.print_int x *)
(*   | Symbole z -> Arduboy.print_string z *)
(*   | Dexpr (P,lexpr) -> Arduboy.print_string "(+ "; iter print lexpr; Arduboy.print_string ")" *)
(*   | Dexpr (T,lexpr) -> Arduboy.print_string "(\* "; iter print lexpr; Arduboy.print_string ")" *)
(*   | Dexpr (M,lexpr) -> Arduboy.print_string "(- "; iter print lexpr; Arduboy.print_string ")" *)
(*   | Dexpr (D,lexpr) -> Arduboy.print_string "(/ "; iter print lexpr; Arduboy.print_string ")" *)

(* let pol = Dexpr (P, [Dexpr (T, [Numb 3; Symbole "x"; Symbole "x"]) ; *)
(*                      Dexpr (T, [Symbole "a"; Symbole "x"; Symbole "x"]) ; *)
(*                      Dexpr (T, [Symbole "b"; Symbole "x"]) ; *)
(*                      Numb 5]);; *)
(* (* let res = ref pol;; *) *)

let pol = Dexpr (T,[Symbole xx; Symbole xx])
(* x^2 *)

let rec iter f = function
    [] -> ()
  | x :: xs -> (f x) ; iter f xs

(* (* let rec print_expr = function *) *)
(* (*   | Numb x -> print_int x *) *)
(* (*   | Symbole x -> print_string x *) *)
(* (*   | Dexpr (P, lexpr) -> print_string "(+"; iter print_expr lexpr; print_string ")" *) *)
(* (*   | Dexpr (M, lexpr) -> print_string "(-"; iter print_expr lexpr; print_string ")" *) *)
(* (*   | Dexpr (T, lexpr) -> print_string "(\*"; iter print_expr lexpr; print_string ")" *) *)
(* (*   | Dexpr (D, lexpr) -> print_string "(/"; iter print_expr lexpr; print_string ")" *) *)

(* let res = ref pol *)


let ()  =
  Avr.(pin_mode PIN9 OUTPUT);
  for i = 0 to 100 do
    ignore (derive pol);
  done;
  (* (* print_expr !res; *) *)
  (* let e = Failure "test" in *)
  (* print (derive pol); *)
  (* force_gc (); *)
  (* raise e; *)
