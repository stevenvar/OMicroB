open Avr

let _ =
  pin_mode PIN11 OUTPUT;
  pin_mode PIN10 OUTPUT;
  pin_mode PIN9 OUTPUT;
  digital_write PIN11 HIGH;
  digital_write PIN10 HIGH;
  digital_write PIN9 LOW
