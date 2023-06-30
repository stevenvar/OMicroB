let millis () = int_of_float (Unix.gettimeofday () *. 1000.)

module Serial = struct
  let write_string = print_endline
  let write_int = print_int
end

(* module Time = struct *)
(*   let print_time (millis : int) = *)
(*     print_int millis (\* TODO *\) *)
(* end *)
