
let blink () =
  pin_mode PIN13 OUTPUT;
  for i = 1 to 1000 do
    digital_write PIN13 true;
    delay 100;
    digital_write PIN13 false;
    delay 100;
  done

let _ =
  (* let x = millis () in *)
  blink ();
  (* let y = millis () - x in *)
  (* () *)
