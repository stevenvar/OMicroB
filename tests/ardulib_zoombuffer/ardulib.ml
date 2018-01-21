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
  let g = PIN9 in
  let r = PIN10 in
  let b = PIN11 in
  pin_mode pin_left INPUT_PULLUP;
  pin_mode pin_right INPUT_PULLUP;
  pin_mode pin_down INPUT_PULLUP;
  pin_mode pin_up INPUT_PULLUP;
  pin_mode r OUTPUT;
  pin_mode g OUTPUT;
  pin_mode b OUTPUT;
  pin_mode button_a INPUT_PULLUP;
  pin_mode button_b INPUT_PULLUP;
  pin_mode cs OUTPUT;
  pin_mode dc OUTPUT;
  pin_mode rst OUTPUT;
  init_rgb r g b;
  digital_write rst true;
  digital_write rst false;
  digital_write rst true

let sleep x =
  for i = 0 to x do
    for _j = 0 to x do 
      ();
    done
  done



let () =
  let bidule = ref (0,0) in
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  boot_pins ();
  Oled.boot ~cs:PIN12 ~dc:PIN4 ~rst:PIN6;
  let buttonA = PIN7 in
  let buttonB = PIN8 in
  let buttonUp = PINA0 in
  digital_write PIN9 false;
  for i = 0 to 1000 do
    (* let (i,j) = !bidule in *)
    (* let new_i = (i+1) mod 64 in *)
    (* let new_j = if new_i = 0 then (j+1 mod 32) else j in *)
    (* bidule := (new_i,new_j); *)
    Oled.draw i 0 true;
    (* Oled.draw new_i new_j true; *)
    Oled.display ();
  done;
  while true do
    digital_write PIN9 (digital_read buttonA);
    digital_write PIN10 (digital_read buttonB);
    digital_write PIN11 (digital_read buttonUp);
  done
