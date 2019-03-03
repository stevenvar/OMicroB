open Circuits

module MyLed = MakeLed(struct include Connection let connectedPin = PIN8 end)

let _ =
  MyLed.init ();
  while true do
    MyLed.on ();
    delay 1000;
    MyLed.off ();
    delay 1000
  done
