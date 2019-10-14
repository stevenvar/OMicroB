type 'a _register = 'a register
type ('a, 'b, 'c, 'd)_pin = ('a, 'b, 'c, 'd) pin

module LCD = LiquidCrystal.MakeLCD(struct
    type 'a register = 'a _register
    type ('a, 'b, 'c, 'd) pin = ('a, 'b, 'c, 'd) _pin
    let pin_mode = pin_mode
    let digital_write = digital_write
  end)
open LCD

let () =
  delay 1000;
  let lcd = create4bitmode PIN11 PIN12 PIN9 PIN8 PIN7 PIN6 in


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
