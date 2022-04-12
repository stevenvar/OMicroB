(* let%node light_switch (l) ~return:(on,lout) =
 *   trigger = 200;
 *   on = (l > trigger);
 *   lout = l *)

let _ =
  Serial.init ();
  while true do
    let x = analog_read PINA0 in
    Serial.write_string "LIGHT IS ";
    Serial.write_int x;
    Serial.write '\n';
    Avr.delay 2000;
  done
