(** Change the side depending on the side you want to program *)

let%component ButtonA = Circuits.MakeButton(connectedPin = PIN7)
let%component ButtonB = Circuits.MakeButton(connectedPin = PIN6)

let%component Screen = LiquidCrystal.MakeLCD(
    rsPin = PIN9;
    enablePin = PIN8;
    d4Pin = PIN5;
    d5Pin = PIN4;
    d6Pin = PIN3;
    d7Pin = PIN2;
  )

let _ =
  Screen.init (); SPISlave.init ();
  ButtonA.init (); ButtonB.init ();
  let y = ref 32 in
  let lastScore = ref 0 in
  Screen.print_int !lastScore;
  while true do
    let score = int_of_char (SPISlave.transmit (char_of_int !y)) in
    if score > !lastScore then (
        lastScore := score;
        Screen.clear_screen ();
        Screen.print_int !lastScore
      );
    if ButtonA.is_on () then y := max (!y - 4) 5;
    if ButtonB.is_on () then y := min (!y + 4) 58;
    delay 5
  done
