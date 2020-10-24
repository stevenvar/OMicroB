module%component MyLed = Circuits.MakeLed(struct let connectedPin = PIN8 end)

module%component MyButton = Circuits.MakeButton(struct let connectedPin = PIN9 end)

let _ =
  MyLed.init ();
  while true do
    if(MyButton.is_on ()) then MyLed.on ()
    else MyLed.off ();
    delay 10;
  done
