open Pic32

let _ =
  init ();
  schedule_task ();
  pin_mode A1 OUTPUT;
  while true do
    digital_write A1 HIGH;
    delay 1000;
    digital_write A1 LOW;
    delay 1000;
  done
