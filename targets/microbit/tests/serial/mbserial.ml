let _ =
  Serial.init ();
  while(true) do
    Serial.write ((string_of_int (millis ()))^"\n");
    Screen.print_string (Serial.read ()); (* Weirdly this takes ~1s *)
    delay 200;
  done
