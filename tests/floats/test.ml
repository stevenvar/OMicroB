open Avr

let prod tbl =
  Array.fold_left ( *. ) 1. tbl

let mktbl =
  let rec loop i acc =
    if i = 0 then acc
    else loop (i - 1) (Array.append [| 1. /. float_of_int i |] acc) in
  fun i -> loop i [||]
  
let () =
  pin_mode PIN9 OUTPUT;
  trace (string_of_float (prod (mktbl 4)))
