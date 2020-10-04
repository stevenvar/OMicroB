(** Change the side depending on the side you want to program *)

type side = Left | Right

let _ =
  Radio.init ();
  let y = ref 32 in
  while true do
    let s = Radio.recv () in
    if(String.length s > 2 && String.sub s 0 2 = "sr") then
      Screen.print_int (int_of_string (String.sub s 2 ((String.length s) - 2)));
    if ButtonA.is_on () then (y := min (!y + 1) 58;
                              Radio.send (String.make 1 (char_of_int (!y))));
    if ButtonB.is_on () then (y := max (!y - 1) 5;
                              Radio.send (String.make 1 (char_of_int (!y))));
    delay 10
  done
