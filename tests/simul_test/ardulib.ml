open Avr

let () =
  Oled.boot ~cs:PIN12 ~dc:PIN4 ~rst:PIN6;
  ()
