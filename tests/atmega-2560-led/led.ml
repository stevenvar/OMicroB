open Avr

let () =
  set_bit DDRB DB7;
  while true do
    set_bit PORTB PB7;
    delay 500;
    clear_bit PORTB PB7;
    delay 500;
  done
