open Circuits

module%component MyLed = MakeLed(struct let connectedPin = PIN8 end)
module%component MyClock = MakeClock(struct let period = 2000 end)
module Circuit = Connect(MyClock)(MyLed)

let _ =
  MyLed.init ();
  while true do
    Circuit.update ();
    delay 10
  done
