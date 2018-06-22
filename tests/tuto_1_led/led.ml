open Avr

let l = ref [ 1; 2; 3; 4 ]
let m = Array.make_matrix 10 10 1
let _ =
  write_register DDRB 0b1111111;
  (* write_register PORTB (Array.length m); *)
  for i = 0 to 9 do
    m.(0).(i) <- 2
  done;
  l := 8::!l;
  write_register PORTB (m.(0).(1))
