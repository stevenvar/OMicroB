let _ =
  Screen.print_string "receiver";

  while true do
    let s = Radio.recv () in
    Screen.print_string s
  done
