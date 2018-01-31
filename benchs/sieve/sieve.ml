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
  Avr.(pin_mode PIN9 OUTPUT);
  (* let r = ref (fun x -> 0) in *)
  for x = 0 to 100 do
    do_list (fun n -> ()) (sieve 10);
  done;
