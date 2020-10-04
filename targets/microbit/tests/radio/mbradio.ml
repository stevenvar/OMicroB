let _ =
  Radio.init ();
  while true do
    if ButtonA.is_on () then Radio.send "a" else Radio.send "noA";
    if ButtonB.is_on () then Radio.send "b" else Radio.send "noB";

    let c = Radio.recv () in
    trace c;
    if c = "a" then Screen.set_pixel 0 2 true;
    if c = "noA" then Screen.set_pixel 0 2 false;
    if c = "b" then Screen.set_pixel 4 2 true;
    if c = "noB" then Screen.set_pixel 4 2 false;

    delay 10
  done
