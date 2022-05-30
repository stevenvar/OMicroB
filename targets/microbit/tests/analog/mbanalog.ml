let _ =
  Serial.init ();
  pin_mode PIN0 INPUT;
  while true do
    Serial.write (string_of_int (analog_read PIN0));
    Serial.write "\n";
    delay 100
  done
