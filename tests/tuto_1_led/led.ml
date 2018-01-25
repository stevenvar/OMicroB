open Avr

let _ =
(*   R (red) connectée à PIN10 (alias PORTB[6])
 * G (green) connectée à PIN11 (alias PORTB[7]) B (blue) connecté à PIN9 (alias PORTB[5]) *)
  (* pin_mode PIN9 OUTPUT; *)
  (* pin_mode PIN10 OUTPUT; *)
  (* pin_mode PIN11 OUTPUT; *)
  (* digital_write PIN9 LOW; *)
  (* digital_write PIN10 HIGH; *)
  (* digital_write PIN11 HIGH *)
  let r = PIN10 in
  let g = PIN11 in
  let b = PIN9 in
  write_register DDRB 0b11100000;
  write_register PORTB 0b11000000
  
