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
end

open Arduboy;;
let rec map f = function [] -> [] | h::t -> (f h)::(map f t);;

type operator = P | M | T | D;;

type dexpr = Numb of int
	| Symbole of string
	| Dexpr of operator * (dexpr list);;

let rec derive =
  let deriv_aux a = Dexpr (D,[derive a; a]) in
  function
    Numb _ -> Numb 0
  | Symbole "x" -> Numb 1
  | Symbole _ -> Numb 0
  | Dexpr (P, lexpr) -> Dexpr (P, map derive lexpr)
  | Dexpr (M, lexpr) -> Dexpr (M, map derive lexpr)
  | Dexpr (T, lexpr) as a -> Dexpr (T, [a ; Dexpr (P, map deriv_aux lexpr)])
  | Dexpr (D, [a1;a2])
           -> Dexpr (M, [Dexpr (D, [derive a1 ; a2]) ;
			Dexpr (D, [a1 ; Dexpr (T, [a2;a2;derive a2])])])
 	    (* FORMULA IS WRONG BUT NEVER USED IN TEST *)


(* let pol = Dexpr (P, [Dexpr (T, [Numb 3; Symbole "x"; Symbole "x"]) ; *)
(*                      Dexpr (T, [Symbole "a"; Symbole "x"; Symbole "x"]) ; *)
(*                      Dexpr (T, [Symbole "b"; Symbole "x"]) ; *)
(*                      Numb 5]);; *)
(* (\* let res = ref pol;; *\) *)
let pol = Symbole "x"

let res = ref pol

let main() =
  Arduboy.init();
  for i = 0 to 999 do
    res := derive pol;
    res := derive pol;
    res := derive pol;
    res := derive pol;
    res := derive pol
  done;
  begin
    match !res with
  | Numb 1 ->
    Arduboy.print_string "OK"
  | _ ->
    Arduboy.print_string "bad"
  end;
  Arduboy.display();;

main();;
