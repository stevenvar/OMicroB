let _ =
  let r = PIN10 in
  let g = PIN11 in
  let b = PIN9 in
  pin_mode g OUTPUT;
  pin_mode r OUTPUT;
  pin_mode b OUTPUT;
  digital_write g HIGH;
  digital_write r HIGH;
  digital_write b HIGH;
  let l = [3;4] in
  let ll = [1;2;3] in
  if  l < ll then
    digital_write b LOW
  else
    digital_write r LOW
