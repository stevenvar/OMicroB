let _ =
  Screen.print_string "sender";

  while true do
    if ButtonA.is_on () then Radio.send "A";
    if ButtonB.is_on () then Radio.send "B";
    delay 100
  done
