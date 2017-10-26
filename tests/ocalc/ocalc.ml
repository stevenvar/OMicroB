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

type touche = Plus | Moins | Fois | Par | Egal | Chiffre of int
            | MemoireIn | MemoireOut | Clear | Off

exception Touche_non_valide
let traduction = function
    "+" -> Plus
  | "-" -> Moins
  | "*" -> Fois
  | "/" -> Par
  | "=" -> Egal
  | "C" | "c" -> Clear
  | "M" -> MemoireIn
  | "m" -> MemoireOut
  | c -> let n = (Char.code c) - (Char.code "0")
    in if n>=0 && n<=9 then Chiffre n else raise Touche_non_valide

type etat = {
 mutable dce : int;     (* dernier calcul effectue       *)
 mutable dta : bool;    (* vrai si touche = chiffre      *)
 mutable doe : touche;  (* derniere operation effectuee  *)
 mutable vaf : int;     (* valeur affichee               *)
 mutable mem : int      (* memoire de la calculette      *)
}

let transition et tou = match tou with
    Clear -> et.vaf <- 0
  | Chiffre n  ->
      begin
        et.vaf <- ( if et.dta then et.vaf*10+n else n );
        et.dta <- true
      end
  | MemoireIn ->
      begin
        et.dta <- false ;
        et.mem <- et.vaf
      end
  | MemoireOut ->
      begin
        et.dta <- false ;
        et.vaf <- et.mem
      end
  |  _  ->
      begin
         let dce = match et.doe with
                     Plus  -> et.dce + et.vaf
                    | Moins -> et.dce - et.vaf
                    | Fois  -> et.dce * et.vaf
                    | Par   -> et.dce / et.vaf
                    | Egal  -> et.vaf
                    | _ -> failwith "transition: filtre impossible"
       	in
          et.dce <- dce ;
          et.dta <- false ;
          et.doe <- tou ;
          et.vaf <- et.dce
      end
(* __________________________________________________________________ *)

exception Fin

let _  =
  Arduboy.init();
  Arduboy.display()

(* let squel f_init f_end f_key f_mouse f_except = *)
(*   f_init(); *)
(*   try *)
(*     while true do *)
(*       try *)
(*         let s = Graphics.wait_next_event *)
(*                  [Graphics.Button_down; Graphics.Key_pressed] in *)
(*           if s.Graphics.keypressed *)
(*             then f_key s.Graphics.key *)
(*           else if s.Graphics.button *)
(*                 then f_mouse s.Graphics.mouse_x s.Graphics.mouse_y *)
(*       with Fin -> raise Fin *)
(*         |   e  -> f_except e *)
(*     done *)
(*   with Fin  -> f_end() *)
(* ;; *)
