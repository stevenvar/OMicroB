open Avr
let cs = PIN12
let dc = PIN4
let rst = PIN6
let button_left = PINA2
let button_right = PINA1
(* let button_down = PINA3 *)
(* let button_up = PINA0 *)
let button_a = PIN7
let button_b = PIN8
let g = PIN9
let r = PIN10
let b = PIN11


let init_rgb r g b =
  digital_write r HIGH;
  digital_write g HIGH;
  digital_write b HIGH

let boot_pins () =
  pin_mode button_left INPUT_PULLUP;
  pin_mode button_right INPUT_PULLUP;
  (* pin_mode button_down INPUT_PULLUP; *)
  (* pin_mode button_up INPUT_PULLUP; *)
  pin_mode r OUTPUT;
  pin_mode g OUTPUT;
  pin_mode b OUTPUT;
  pin_mode button_a INPUT_PULLUP;
  pin_mode button_b INPUT_PULLUP;
  pin_mode cs OUTPUT;
  pin_mode dc OUTPUT;
  pin_mode rst OUTPUT;
  init_rgb r g b


let init () =
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  boot_pins ();
  Oled.boot ~cs:cs ~dc:dc ~rst:rst
