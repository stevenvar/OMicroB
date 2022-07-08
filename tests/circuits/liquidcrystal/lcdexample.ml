module%comp LCD = Circuits.MakeLCD(struct
    let rsPin = PIN11
    let enablePin = PIN12
    let d4Pin = PIN2
    let d5Pin = PIN3
    let d6Pin = PIN4
    let d7Pin = PIN5
  end)

let () =
  (* The function int_of_string is not available in OMicroB, so we'll convert binary to decimal ourselves ! *)
  let f = false and t = true in
  let smiley = [[t;f;f;f;t];
                [f;f;f;f;f];
                [f;f;f;f;f];
                [t;f;f;f;t];
                [f;t;t;t;f];
                [f;f;f;f;f]] in
  LCD.init ();
  LCD.print_string "Hello world! ";
  LCD.print_image smiley
