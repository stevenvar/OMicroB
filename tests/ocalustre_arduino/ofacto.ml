
module Arduino = struct
  external serial_begin : int -> unit = "ocaml_arduino_serial_begin"
  external millis : unit -> int = "ocaml_arduino_millis"
end;;


type ('a,'b) count_state =
  {
  mutable count_pre_c: 'a ;
  mutable count_out_c: 'b }

let count_init init =
  let c = init  in
  let pre_c = c + 1  in { count_pre_c = pre_c; count_out_c = c }

let count_step state init =
  let c = state.count_pre_c  in
  let pre_c = c + 1  in
  state.count_out_c <- c; state.count_pre_c <- pre_c; ()

let _ =
  Arduino.serial_begin 57600;
  let x = Arduino.millis () in
  let counter_state = count_init 0 in
   for i = 0 to 99 do
    count_step counter_state 0;
    (* Arduboy.print_int counter_state.count_out_c; *)
  done;
  let y = Arduino.millis () in
  (* print_string "\n"; *)
  print_int (y-x);
  print_string "finish"
