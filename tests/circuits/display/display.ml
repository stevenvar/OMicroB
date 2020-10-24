(* Print some stuff on a screen *)

(* Use an external, LiquidCrystal type screen *)
module%comp MyDisp = Circuits.MakeLCD(struct
    let rsPin = PIN12
    let enablePin = PIN11
    let d4Pin = PIN5
    let d5Pin = PIN4
    let d6Pin = PIN3
    let d7Pin = PIN2
end)

let smiley = [[false;true;false;true;false];
              [false;true;false;true;false];
              [false;false;false;false;false];
              [true;false;false;false;true];
              [false;true;true;true;false]]

let _ =
  MyDisp.init ();
  MyDisp.print_string "OMicroB ";
  MyDisp.print_int 42; MyDisp.print_newline ();
  MyDisp.print_string "Yay ! ";
  MyDisp.print_image smiley;
