(* module Arduboy = struct *)
(*   external millis : unit -> int = "ocaml_arduboy_millis" *)
(*   external init    : unit   -> unit = "ocaml_arduboy_init" *)
(*   external print_int : int -> unit = "ocaml_arduboy_print_int" *)
(*   external print_string : string -> unit = "ocaml_arduboy_print" *)
(*   external print_float : float -> unit = "ocaml_arduboy_print_float" *)
(*   external display : unit   -> unit = "ocaml_arduboy_display" *)
(* end;; *)

module Arduino = struct
  external serial_begin : int -> unit = "ocaml_arduino_serial_begin"
  external millis : unit -> int = "ocaml_arduino_millis"
end;;

(* let succ x = x + 1 *)
(* Eratosthene's sieve *)

(* interval min max = [min; min+1; ...; max-1; max] *)

let rec interval min max =
  if min > max then [] else min :: interval (min + 1) max

(* filter p L returns the list of the elements in list L
   that satisfy predicate p *)

let rec filter p l = match l with
    []   -> []
  | (a::r) -> if p a then a :: filter p r else filter p r

(* Application: removing all numbers multiple of n from a list of integers *)

let remove_multiples_of n =
  filter (fun m -> if (m mod n) = 0 then false else true)

(* The sieve itself *)

let sieve max =
  let rec filter_again = function
     [] -> []
  | n::r as l ->
      if n*n > max then l else n :: filter_again (remove_multiples_of n r)
  in
    filter_again (interval 2 max)

let rec do_list f l = match l with
       []   -> ()
  |  (a::q) -> f a; do_list f q



let _ =
  (* let r = ref (fun x -> 0) in *)
  Arduino.serial_begin 115200;
  let x = Arduino.millis () in
  (* let (z,k) = !r in *)
  for x = 0 to 100 do
    do_list (fun n -> ()) (sieve 10);
  done;
  for x = 0 to 100 do
    print_int x;
  done;
    print_int (Arduino.millis () -x);
  for x = 0 to 10 do
    print_int x;
  done;
