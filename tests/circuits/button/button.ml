let%component MyLed = Circuits.MakeLed(connectedPin = PIN8)

let%component MyButton = Circuits.MakeButton(connectedPin = PIN9)

let _ =
  MyLed.init ();
  while true do
    if(MyButton.is_on ()) then MyLed.on ()
    else MyLed.off ();
    delay 10;
  done
