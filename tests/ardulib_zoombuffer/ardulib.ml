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
  (* let snake = Array.make 100 (10,10)  in *)
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  boot_pins ();
  Oled.boot ~cs:PIN12 ~dc:PIN4 ~rst:PIN6;

     (* let x,y = snake.(i) in *)
     (* Oled.draw x y true *)
   (* done; *)
  (* pin_mode PIN9 OUTPUT; *)

  (* for i = 0 to 10 do  *)
  (* Oled.draw 30 i ON; *)
  (* Oled.draw 0 0 true; *)
  (* Oled.draw 2 0 true; *)
  (* Oled.draw 4 0 true; *)
  (* Oled.draw 6 0 true; *)
  (* Oled.draw 8 0 true; *)
  (* Oled.draw 0 2 true; *)
  (* Oled.draw 8 2 true; *)
  (* Oled.draw 8 4 true; *)
  (* Oled.draw 8 6 true; *)
  (* Oled.draw 8 8 true; *)
  (* for i = 0 to 63 do *)
    (* Oled.draw i 0 true; *)
    (* Oled.draw i 31 true *)
  (* done; *)
  (* for i = 0 to 31 do *)
    (* Oled.draw 0 i true; *)
    (* Oled.draw 63 i true; *)
  (* done; *)

  (* for i = 0 to 20 do *)
    (* Oled.draw i i true; *)
  (* done; *)
  let buttonA = PIN7 in
  let buttonB = PIN8 in
  (* Oled.display(); *)
  Oled.draw 10 10 true;
  Oled.draw 50 10 true;
  Oled.draw 10 20 true;
  Oled.draw 11 21 true;
  Oled.draw 12 22 true;
  Oled.draw 13 23 true;
  Oled.draw 47 23 true;
  Oled.draw 48 22 true;
  Oled.draw 49 21 true;
  Oled.draw 50 20 true;
  for i = 0 to 33 do
    Oled.draw (13+i) 23 true;
  done;
  Oled.display ();
  while true do
    let valA = digital_read buttonA in
    digital_write PIN9 (not (digital_read buttonA));
    digital_write PIN10 (not (digital_read buttonB));
  done
    (* for i = 0 to 100 do () done; *)
    (* Oled.clear_zone ~cs:PIN12 ~dc:PIN4 30 i; *)
  (* done *)
