open Avr

let _ =
  let s = PIN7 in
  let r = PIN8 in
  let g = PIN9 in
  pin_mode s INPUT;
  pin_mode g OUTPUT;
  pin_mode r OUTPUT;
  digital_write g LOW;
  digital_write r LOW;
  while true do
    (match digital_read s with
     | LOW -> digital_write g LOW; digital_write r HIGH
     | HIGH -> digital_write g HIGH; digital_write r LOW);
    delay 100
  done;
  if 3 < 2 then
    digital_write g HIGH
  else
    digital_write r HIGH
