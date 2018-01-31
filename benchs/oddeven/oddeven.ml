let rec odd x = 
  if x = 0 then false
  else
    even (x-1)
and even x =
  if x = 0 then true 
  else 
    odd (x-1)

let () =
  Avr.(pin_mode PIN9 OUTPUT);
  for i = 0 to 100 do 
    ignore (odd i);
  done;
