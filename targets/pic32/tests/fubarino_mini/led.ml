open Pic32

let _ =
  pin_mode PIN28 OUTPUT;
  pin_mode PIN10 OUTPUT;
  while true do 
    digital_write PIN10 HIGH;
    digital_write PIN28 HIGH;
    delay 1000;
    digital_write PIN10 LOW;
    digital_write PIN28 LOW;
    delay 100;
  done
