open Circuits

let%component MyLed = MakeLed(connectedPin = PIN8)
let%component MyClock = MakeClock(period = 2000)
let%connect Circuit = Connect(MyClock;MyLed)

let _ =
  MyLed.init ();
  while true do
    Circuit.update ();
    delay 10
  done
