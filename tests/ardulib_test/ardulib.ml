open Avr

let init_rgb r g b =
  digital_write r true;
  digital_write g true;
  digital_write b true


let boot_pins () =
  let cs = PIN12 in
  let dc = PIN4 in
  let rst = PIN6 in
  let pin_left = PINA2 in
  let pin_right = PINA1 in
  let pin_down = PINA3 in
  let pin_up = PINA0 in
  let button_a = PIN7 in
  let button_b = PIN8 in
  let r = PIN9 in
  let g = PIN10 in
  let b = PIN11 in
  pin_mode pin_left INPUT;
  pin_mode pin_right INPUT;
  pin_mode pin_down INPUT;
  pin_mode pin_up INPUT;
  (* pin_mode r OUTPUT; *)
  (* pin_mode g OUTPUT; *)
  (* pin_mode b OUTPUT; *)
  pin_mode button_a INPUT;
  pin_mode button_b INPUT;
  pin_mode cs OUTPUT;
  pin_mode dc OUTPUT;
  pin_mode rst OUTPUT;
  (* init_rgb r g b; *)
  digital_write rst true;
  digital_write rst false;
  digital_write rst true

let () =
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  boot_pins ();
  Oled.boot ~cs:PIN12 ~dc:PIN4 ~rst:PIN6;
  for i = 0 to 10 do
    Oled.draw ~cs:PIN12 ~dc:PIN4 30 i;
    for i = 0 to 100 do () done;
    Oled.clear_zone ~cs:PIN12 ~dc:PIN4 30 i;
  done
