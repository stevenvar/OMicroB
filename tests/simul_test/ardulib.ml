open Avr

let () =
  (* pin_mode PIN8 OUTPUT; *)
  (* write_register DDRB 0xFF; *)
  (* write_register PORTB 0xAB; *)
  pin_mode PIN7 OUTPUT;
  digital_write PIN7 true
  (* digital_write PIN8 true *)

  (* set_bit PORTB PB3; *)
  (* if (read_bit PORTB PB3) then *)
  (* set_bit PORTB PB4; *)
  (* clear_bit PORTB PB3; *)

  (* clear_bit PORTB PB3; *)
