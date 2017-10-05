
(* let fst t (x,y) = x *)

(* let blink pin small_time long_time = *)

(*   pin_mode pin OUTPUT; *)
(*   for i = 1 to 100 do *)
(*     let g = fst 8 in *)
(*     for _j = 1 to i do *)
(*       digital_write pin true; *)
(*       delay (small_time + g (1,2) ); *)
(*       digital_write pin false; *)
(*       delay small_time; *)
(*     done; *)
(*     delay long_time; *)
(*   done *)

(* let () = *)
(*   blink PIN13 100 1000 *)

type 'a ref = { mutable contents : 'a } 

let ref x = { contents= x }

let (:=) a b =
  a.contents <- b

external (!) : 'a ref -> 'a =  "%field0"

let incr x = x := !x+1

let cpt =
  let cpt = ref 0 in
  fun () ->
    incr cpt;
    !cpt

let u = 42

let make_pair x = (x,x+u)
let fst (x,y) = x

let _ =
  digital_write PIN13 true;
  for i = 0 to 1000 do
    let v =  make_pair i in
    delay 500
  done
