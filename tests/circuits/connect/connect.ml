open Circuits

let%component MyGreenLed = MakeLed(connectedPin = PIN9)
let%component MyRedLed = MakeLed(connectedPin = PIN8)
let%component MyBlueLed = MakeLed(connectedPin = PIN7)

let%component MyButton1 = MakeButton(connectedPin = PIN10)
let%component MyButton2 = MakeButton(connectedPin = PIN11)

let%gate MyOr = Or(MyButton1;MyButton2)
let%gate MyNot = Not(MyOr)

let%multiact MyMultiAct = MultiAct(MyRedLed;MyGreenLed;MyBlueLed)

let%connect MyConnect = Connect(MyOr;MyMultiAct)

let _ =
  MyGreenLed.init (); MyRedLed.init (); MyBlueLed.init ();
  MyButton1.init (); MyButton2.init ();
  while true do
    MyConnect.update ();
    delay 10
  done
