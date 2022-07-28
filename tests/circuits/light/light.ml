module%comp MyLightSensor = Circuits.MakeAnalogSensor(struct let connectedPin = PINA0 end)

let _ =
  Serial.init ();
  MyLightSensor.init ();
  while true do
    Serial.write_string (string_of_int (MyLightSensor.level()));
    Serial.write '\n';
    delay 200
  done
