(* https://github.com/lancaster-university/microbit-samples/blob/master/source/examples/accelerometer/main.cpp *)
open Screen

let pixel_of_g g =
  if g < -750 then 0
  else if g < -250 then 1
  else if g < 250 then 2
  else if g < 750 then 3
  else 4

let _ =
  Radio.init ();
  while true do
    let x = pixel_of_g (Accelerometer.x ())
    and y = pixel_of_g (Accelerometer.y ()) in

    Radio.send ((string_of_int x)^":"^(string_of_int y));

    try
      let s = String.split_on_char ':' (Radio.recv ()) in
      let x = int_of_string (List.nth s 0) and y = int_of_string (List.nth s 1) in

      clear_screen ();
      set_pixel x y true
    with _ -> ();
    delay 10;
  done
