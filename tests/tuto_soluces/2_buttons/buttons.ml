open Avr
    
let r = PIN10
let g = PIN9 
let b = PIN11
let button_A = PIN7 
let button_B = PIN8 

let boot_pins () =
  
  pin_mode r OUTPUT;
  pin_mode g OUTPUT;
  pin_mode b OUTPUT;
  pin_mode button_A INPUT_PULLUP;
  pin_mode button_B INPUT_PULLUP;
  digital_write r HIGH;
  digital_write g HIGH;
  digital_write b HIGH

let _ =
  boot_pins ();
  while true do 
    let a_state = digital_read button_A in 
    let b_state = digital_read button_B in
    digital_write PIN9 a_state;
    digital_write PIN10 b_state;
  done
