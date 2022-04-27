(* https://github.com/lancaster-university/microbit-samples/blob/master/source/examples/accelerometer/main.cpp *)
open Screen

let pixel_of_g g =
  if g < -20 then 0
  else if g < -10 then 1
  else if g < 10 then 2
  else if g < 20 then 3
  else 4

let _ =
  while true do
    let x = pixel_of_g (Accelerometer.x ())
    and y = pixel_of_g (- (Accelerometer.y ())) in

    clear_screen ();
    set_pixel x y true;
    delay 10;
  done
