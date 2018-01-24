open Avr

let _ =
  write_register DDRB 0xFF;
  set_bit PORTB PB5.
(* TODO *)
