let%component MyLightSensor = Circuits.MakeAnalogSensor(connectedPin = PINA0)

let _ =
  Serial.init ();
  MyLightSensor.init ();
  while true do
    Serial.write (string_of_int (MyLightSensor.level()));
    Serial.write "\n";
    delay 200
  done
