(* Print some stuff on a screen *)

(* Use the microbit internal screen *)
(* module MyDisp = MicroBit.Screen *)

(* Use an external, LiquidCrystal type screen *)
module MyDisp = LiquidCrystal.MakeLCD(struct
    include Connection
    let rsPin = PIN12
    let enablePin = PIN11
    let d4Pin = PIN5
    let d5Pin = PIN4
    let d6Pin = PIN3
    let d7Pin = PIN2
  end)

let smiley = [[LOW;HIGH;LOW;HIGH;LOW];
              [LOW;HIGH;LOW;HIGH;LOW];
              [LOW;LOW;LOW;LOW;LOW];
              [HIGH;LOW;LOW;LOW;HIGH];
              [LOW;HIGH;HIGH;HIGH;LOW]]

let _ =
  MyDisp.init ();
  MyDisp.print_string "OMicroB ";
  MyDisp.print_int 42; MyDisp.print_newline ();
  MyDisp.print_string "Yay ! ";
  MyDisp.print_image smiley
