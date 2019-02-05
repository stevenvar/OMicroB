let _ =
  Avr.Serial.init ();
  while true do
    let n = Avr.Serial.read () in
    Avr.Serial.write n;
  done
