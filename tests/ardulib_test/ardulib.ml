open Avr

let _ = 
  write_register PORTB 0xFF

let rec map f l =
  match l with
  | [] -> []
  | h::t -> (f h)::(map f t)


let _ =
  let l = [ 1 ; 2 ; 3 ; 4 ] in
  map (fun x -> x + 1) l 
