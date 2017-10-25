module Arduboy = struct
  (* external reset_cursor : unit -> unit = "ocaml_arduboy_reset_cursor" *)
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external clear : unit -> unit = "ocaml_arduboy_clear"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end;;

let print_newline () =
  Arduboy.print_string "\n";
  Arduboy.display();;

let rec map f l = match l with [] -> [] | h::t -> (f h)::(map f t);;

let rec interval n m =
    if n > m then [] else (n :: interval (succ n) m);;

let rec concmap f = function
    [] -> []
  | x :: l -> f x @ concmap f l;;

let rec list_length = function
    [] -> 0
  | _::l -> 1 + list_length l;;

let rec safe d x = function
    [] -> true
  | q::l -> (not (x = q)) && ((not (x = q+d)) && ((not (x = q-d)) &&
            safe (d+1) x l));;

let ok = function [] -> true | x::l -> safe 1 x l;;

let rec filter p = function
   [] -> []
 | x::l -> if p x then x::filter p l else filter p l;;
let range = interval 1;;

let queens n =
 let qs = range n in
 let testcol = function b -> filter ok (map (fun q -> q::b) qs) in
 let rec gen = function
    0 -> [[]]
  | n -> Arduboy.print_int n;
         print_newline();
         concmap testcol (gen (n - 1)) in
 list_length (gen n);;

  Arduboy.init();;
queens 3 ;;
