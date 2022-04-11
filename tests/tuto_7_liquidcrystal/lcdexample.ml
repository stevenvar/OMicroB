type _register = register
type 'a _pin = 'a pin

module LCD = LiquidCrystal.MakeLCD(struct
    type register = _register
    type 'a pin = 'a _pin
    let pin_mode = pin_mode
    let digital_write = digital_write
  end)
open LCD

let () =
  delay 1000;
  (* rs enable d0 d1 d2 d3 *)
  let lcd = create4bitmode PIN11 PIN12 PIN2 PIN3 PIN4 PIN5 in


  (* The function int_of_string is not available in OMicroB, so we'll convert binary to decimal ourselves ! *)
  let smiley =[| (* 00000 *) 0;
                 (* 10001 *) 17;
                 (* 00000 *) 0;
                 (* 00000 *) 0;
                 (* 10001 *) 17;
                 (* 01110 *) 14;
                 (* 00000 *) 0|] in
  createChar lcd 0 smiley;

  lcdBegin lcd 16 2;

  setCursor lcd 2 0;
  print lcd "Hello world!";

  setCursor lcd 0 1;
  write lcd 0;

  setCursor lcd 15 1;
  write lcd 0;
