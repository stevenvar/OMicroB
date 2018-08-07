open Avr

let cs = PIN12
let dc = PIN4
let rst = PIN6

let boot_pins () =
  pin_mode cs OUTPUT;
  pin_mode dc OUTPUT;
  pin_mode rst OUTPUT

let init () =
  boot_pins ()
