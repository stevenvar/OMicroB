open Screen

let _ =
  print_string "OMicroB!";
  print_int 42;

  print_image [[false;true;false;true;false];
               [false;true;false;true;false];
               [false;false;false;false;false];
               [false;false;false;false;false];
               [true;true;true;true;true]];
  while(true) do
    if(ButtonA.is_on ())
    then (set_pixel 0 3 true; set_pixel 0 4 false)
    else (set_pixel 0 3 false; set_pixel 0 4 true);
    if(ButtonB.is_on ())
    then (set_pixel 4 3 true; set_pixel 4 4 false)
    else (set_pixel 4 3 false; set_pixel 4 4 true)
  done
