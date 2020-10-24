open Circuits

module%component MyLed = MakeLed(struct connectedPin = PIN8 end)
module%component MyClock = MakeClock(struct period = 2000 end)
module%connect Circuit = Connect(MyClock)(MyLed)

let _ =
  MyLed.init ();
  while true do
    Circuit.update ();
    delay 10
  done
