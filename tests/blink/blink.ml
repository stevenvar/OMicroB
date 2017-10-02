
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

let make_pair x = (1,x)
let fst k (x,y) = x

let _ =
  digital_write PIN13 true;
  let f x = x + 5 in
  for i = 1 to 100 do
    make_pair 1909
  done
    (*   digital_write PIN13 true; *)
  (*   f (fst p ) *)
  (* done *)
