
type reg = DDRB | PORTB | SPCR
type port_bits = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7 | MSTR | SPE

module Avr = struct
  external write_register : reg -> int -> unit = "ocaml_avr_write_register"
  external set_bit : reg -> port_bits -> unit = "ocaml_avr_set_bit"
end

let begin_spi ~ss ~sck ~mosi =
  digital_write ss true;
  pin_mode ss OUTPUT;
  Avr.set_bit SPCR MSTR;
  Avr.set_bit SPCR SPE;
  pin_mode sck OUTPUT;
  pin_mode mosi OUTPUT

let _ =
  pin_mode PIN9 OUTPUT;
  pin_mode PIN10 OUTPUT;
  pin_mode PIN11 OUTPUT
  (* Avr.write_register DDRB 0xFF; (\* output *\) *)
  (* Avr.write_register PORTB 0x00; (\* off *\) *)
  (* Avr.set_bit PORTB PB5; (\* LED OFF *\) *)
  (* Avr.set_bit PORTB PB6; (\* LED OFF *\) *)
  (* Avr.set_bit PORTB PB7; (\* LED OFF *\) *)
