open Avr

let _ =
  Serial.init ();
  adc_init ();
  while true do
    let x = Avr.analog_read PINA0 in
    Serial.write_string "LIGHT IS ";
    Serial.write_int x;
    Serial.write '\n';
    delay 1000;
  done
