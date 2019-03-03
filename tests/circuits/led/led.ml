let%connection MyLed = Circuits.MakeLed(connectedPin = PIN8)

let _ =
  MyLed.init ();
  while true do
    MyLed.on ();
    delay 1000;
    MyLed.off ();
    delay 1000
  done
