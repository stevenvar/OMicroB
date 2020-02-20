open Pic32

let _ =
  let r = PIN78 in
  let p = PIN82 in
  pin_mode r OUTPUT;
  pin_mode p OUTPUT;
  while true do
  digital_write r HIGH;
  digital_write p HIGH;
  delay 4000; 
  digital_write r LOW;
  digital_write p LOW;
  delay 4000;
 done
