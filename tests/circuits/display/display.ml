(* Print some stuff on a screen *)

(* Use the microbit internal screen *)
(* module MyDisp = MicroBit.Screen *)

(* Use an external, LiquidCrystal type screen *)
let%component MyDisp = LiquidCrystal.MakeLCD(
    rsPin = PIN12;
    enablePin = PIN11;
    d4Pin = PIN5;
    d5Pin = PIN4;
    d6Pin = PIN3;
    d7Pin = PIN2;
)

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
  MyDisp.print_image smiley;
