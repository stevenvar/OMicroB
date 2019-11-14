open Pic32

let _ =
  pin_mode PIN78 OUTPUT;
  pin_mode PIN82 OUTPUT;
  while true do 
    digital_write PIN78 HIGH;
    digital_write PIN82 HIGH;
    delay 2500,
    digital_write PIN78 LOW;
    digital_write PIN82 LOW;
    delay 2500;
  done
