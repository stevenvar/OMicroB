
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

let fst (x,y) = x

let rec facto x =
  if x = 0 then 1
  else x * facto (x-1)
let _ =
  digital_write PIN13 true;
  (* let f x = x + 5 in *)
  let x = (facto 5,42) in
  let y = (facto 5,32) in
  y
    (*   digital_write PIN13 true; *)
  (*   f (fst p ) *)
  (* done *)
