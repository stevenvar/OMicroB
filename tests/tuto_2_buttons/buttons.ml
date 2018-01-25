open Avr

let r = PIN10
let g = PIN9 
let b = PIN11
let button_A = PIN7
let button_B = PIN8 

let _ =
  pin_mode r OUTPUT;
  pin_mode g OUTPUT;
  pin_mode b OUTPUT;
  digital_write r HIGH; (* éteint *)
  digital_write g HIGH; (* éteint *)
  digital_write b HIGH; (* éteint *)
  pin_mode button_A INPUT_PULLUP;
  pin_mode button_B INPUT_PULLUP;
    while true do 
      let val_a = digital_read button_A in
      let val_b = digital_read button_B in
      digital_write b (val_a);
      digital_write r (val_b)
    done
