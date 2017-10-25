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

(* let succ x = x + 1;; *)
(* (\* Eratosthene's sieve *\) *)

(* (\* interval min max = [min; min+1; ...; max-1; max] *\) *)

(* let rec interval min max = *)
(*   if min > max then [] else min :: interval (succ min) max *)
(* ;; *)

(* (\* filter p L returns the list of the elements in list L *)
(*    that satisfy predicate p *\) *)

(* let rec filter p l = match l with *)
(*     []   -> [] *)
(*   | (a::r) -> if p a then a :: filter p r else filter p r *)
(* ;; *)

(* (\* Application: removing all numbers multiple of n from a list of integers *\) *)

(* let remove_multiples_of n = *)
(*   filter (fun m -> if (m mod n) = 0 then false else true) *)
(* ;; *)

(* (\* The sieve itself *\) *)

(* let sieve max = *)
(*   let rec filter_again = function *)
(*      [] -> [] *)
(*   | n::r as l -> *)
(*       if n*n > max then l else n :: filter_again (remove_multiples_of n r) *)
(*   in *)
(*     filter_again (interval 2 max) *)
(* ;; *)

(* let rec do_list f l = match l with *)
(*        []   -> () *)
(*   |  (a::q) -> f a; do_list f q *)
(* ;; *)
(* let rec f x = *)
(*   if x = 1 then 1 *)
(*   else if x mod 2 = 0 then f(x/2) *)
(* 	   else f(3*x+1) *)
(* 	   ;; *)


(* class cell a = *)
(*   object *)
(*     val mutable v = (a : bool) *)
(*     method isAlive = v *)
(*   end ;; *)


(* 4.2 *)

class virtual absWorld n m  =
  object(self)
    val mutable tcell = Array.create_matrix n m (new cell false)
    val maxx = n
    val maxy = m
    val mutable gen = 0
    method private dessine(c) =
     if c#isAlive then print_string "*"
     else print_string "."
    method display() =
      for i = 0 to (maxx-1) do
        for j=0 to (maxy -1) do
          print_string " " ;
          self#dessine(tcell.(i).(j))
        done ;
        print_newline()
      done
    method getCell(i,j) = tcell.(i).(j)
    method setCell(i,j,c) = tcell.(i).(j) <- c
    method getCells = tcell
  end ;;


(* 4.3 *)

class world n m =
  object(self)
    inherit absWorld n m
    method neighbors(x,y) =
      let r = ref 0 in
      for i=x-1 to x+1 do
        let k = (i+maxx) mod maxx in
        for j=y-1 to y+1 do
          let l = (j + maxy) mod maxy in
            if tcell.(k).(l)#isAlive then incr r
        done
      done;
      if tcell.(x).(y)#isAlive then decr r ;
      !r

    method nextGen() =
      let w2 = new world maxx maxy in
      for i=0 to maxx-1 do
        for j=0 to maxy -1 do
          let n = self#neighbors(i,j) in
          if tcell.(i).(j)#isAlive
          then (if (n = 2) || (n = 3) then w2#setCell(i,j,new cell true))
          else (if n = 3 then w2#setCell(i,j,new cell true))
        done
      done ;
      tcell <- w2#getCells ;
      gen <- gen + 1
  end ;;


(* 4.4 *)

exception Fin;;

let main () =

  let a = 10 and b = 12 in
  let w = new world a b in
  w#setCell(4,4,new cell true) ;
  w#setCell(4,5,new cell true) ;
  w#setCell(4,6,new cell true) ;
  try
    while true do
      w#display() ;
      if ((read_line()) = "F") then raise Fin else w#nextGen()
    done
  with Fin -> () ;;

Arduboy.init();;
main () ;;




(* let _ = *)

(* (\* do_list (fun n -> print_int n; print_string " ") (sieve 15); *\) *)
(*   for i = 1 to 10 do f (23529) done;   (\* 2 820 000 appels *\) *)
(*   if (f 23529) = 1 then print_string "OK" else print_string "PB"; *)
(*   print_string "\n"; *)
(*   Arduboy.display();; *)
