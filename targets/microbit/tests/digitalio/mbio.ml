open Screen

let _ =
  pin_mode PIN0 INPUT;
  pin_mode PIN1 OUTPUT;

  while true do
    digital_write PIN1
      (if ((millis () mod 1000) < 500) then HIGH else LOW);
    let l = digital_read PIN0 in
    set_pixel 2 2 (match l with HIGH -> true | _ -> false);
    delay 100
  done
