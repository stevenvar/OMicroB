let _ =
  Serial.init ();
  pin_mode PIN0 INPUT;
  pin_mode PIN1 OUTPUT;
  while true do
    let v = analog_read PIN0 in
    analog_write PIN1 v;
    delay 100
  done
