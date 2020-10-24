open Circuits

module%comp MyGreenLed = MakeLed(struct let connectedPin = PIN9 end)
module%comp MyRedLed = MakeLed(struct let connectedPin = PIN8 end)
module%comp MyBlueLed = MakeLed(struct let connectedPin = PIN7 end)

module%comp MyButton1 = MakeButton(struct let connectedPin = PIN10 end)
module%comp MyButton2 = MakeButton(struct let connectedPin = PIN11 end)

module MyOr = Or(MyButton1)(MyButton2)
module MyNot = Not(MyOr)

module%multiact MyMultiAct = MultiAct(MyRedLed)(MyGreenLed)(MyBlueLed)

module MyConnect = Connect(MyOr)(MyMultiAct)

let _ =
  MyGreenLed.init (); MyRedLed.init (); MyBlueLed.init ();
  MyButton1.init (); MyButton2.init ();
  while true do
    MyConnect.update ();
    delay 10
  done
