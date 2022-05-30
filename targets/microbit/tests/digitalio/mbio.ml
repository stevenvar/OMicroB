open Screen

let _ =
  let pinin = PIN6 and pinout = PIN13 in
  pin_mode pinin INPUT;
  pin_mode pinout OUTPUT;

  while true do
    digital_write pinout
      (if ((millis () mod 1000) < 500) then HIGH else LOW);
    let l = digital_read pinin in
    set_pixel 2 2 (match l with HIGH -> true | LOW -> false);
    delay 100
  done
