

let begin_spi ~ss ~sck ~mosi =
  Avr.digital_write ss true;
  Avr.pin_mode ss OUTPUT;
  Avr.set_bit SPCR MSTR;
  Avr.set_bit SPCR SPE;
  Avr.pin_mode sck OUTPUT;
  Avr.pin_mode mosi OUTPUT

    
let _ =
  begin_spi ~ss:PIN17 ~sck:PIN15 ~mosi:PIN16;
  (* Avr.write_register DDRB 0xFF; (\* output *\) *)
  (* Avr.port_mode PORTB OUTPUT; *)
  (* pin_mode PIN9 OUTPUT; *)
  (* pin_mode PIN10 OUTPUT; *)
  (* pin_mode PIN11 OUTPUT; *)
  (* Avr.write_register DDRB 0xFF; (\* output *\) *)
  (* Avr.write_register PORTB 0x00; (\* off *\) *)
  (* let r = PB6 in
   * let g = PB7 in
   * let b = PB5 in
   * offled g;
   * offled r *)
