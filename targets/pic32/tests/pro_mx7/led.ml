open Pic32

let _ =
  pin_mode PIN96 OUTPUT;
  pin_mode PIN97 OUTPUT;
  pin_mode PIN1 OUTPUT;
  pin_mode PIN95 OUTPUT;
  while true do 
    digital_write PIN96 HIGH;
    digital_write PIN97 HIGH;
    digital_write PIN95 HIGH;
    digital_write PIN1 HIGH;
    delay 2000;
    digital_write PIN96 LOW;
    digital_write PIN97 LOW;
    digital_write PIN95 LOW;
    digital_write PIN1 LOW;
    delay 2000;
  done
