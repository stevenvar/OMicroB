open Pic32

let _ =
  pin_mode PIN1 OUTPUT;
  while true do
    digital_write PIN1 HIGH;
    (* delay 1000;
    digital_write PIN1 LOW;
    delay 1000; *)
  done