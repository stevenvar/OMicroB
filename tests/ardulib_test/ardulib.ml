
(* let _ = Avr.set_bit SPCR SPE *)

let moins a b c =
  Avr.write_register PORTD 99;
  a - b - c

let begin_spi ~ss ~sck ~mosi =
  (* digital_write ss High; *)
  Avr.pin_mode ss OUTPUT;
  Avr.set_bit SPCR MSTR;
  Avr.set_bit SPCR SPE;
  Avr.pin_mode sck OUTPUT;
  Avr.pin_mode mosi OUTPUT


let () =
  let x = moins 3 2 1 in
  (* Avr.write_register PORTD x; *)
  Spi.begin_spi ~ss:PIN17 ~sck:PIN15 ~mosi:PIN16;
  (*Oled.boot();*)
  (* Avr.write_register DDRB 0xFF; (\* output *\) *)
  (* Avr.pin_mode PIN9 OUTPUT; *)
  (* Avr.pin_mode PIN10 OUTPUT; *)
  (* Avr.pin_mode PIN11 OUTPUT; *)
  (* Avr.digital_write PIN9 true; *)
  (* Avr.digital_write PIN10 true; *)
  (* Avr.write_register DDRB 0xFF; (\* output *\) *)
  (* Avr.write_register PORTB 0x00; (\* off *\) *)
  (* let r = PB6 in
   * let g = PB7 in
   * let b = PB5 in
   * offled g;
   * offled r *)
