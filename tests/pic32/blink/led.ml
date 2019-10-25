open Pic32

let _ =
  pin_mode PIN78 OUTPUT;
  pin_mode PIN82 OUTPUT;
  digital_write PIN78 HIGH;
  digital_write PIN82 HIGH;