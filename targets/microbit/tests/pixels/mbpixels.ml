open Screen

let rec iter x y level =
  if y = 5 then ()
  else if x = 5 then iter 0 (y + 1) level
  else (
    set_pixel x y level;
    delay 100;
    iter (x + 1) y level
  )

let _ =
  iter 0 0 true;
  iter 0 0 false
