(* let%component MyRGBLed = Circuits.MakeRGBLed(
 *     redPin = PIN0;
 *     greenPin = PIN1;
 *     bluePin = PIN2) *) (* Pins for microbit*)

module%comp MyRGBLed = Circuits.MakeRGBLed(struct
    redPin = PIN3;
    greenPin = PIN5;
    bluePin = PIN11;
  end) (* Pins for arduino uno *)

let rgb_of_hsv (h, s, v) =
  let c = v *. s in let m = v -. c in
  let x = c *. (1. -. abs_float ((mod_float (h/.60.) 2.) -. 1.)) in
  let (r', g', b') =
    if h < 60. then (c, x, 0.)
    else if h < 120. then (x, c, 0.)
    else if h < 180. then (0., c, x)
    else if h < 240. then (0., x, c)
    else if h < 300. then (x, 0., c)
    else (c, 0., x) in
  (int_of_float ((r'+.m)*.255.), int_of_float ((g'+.m)*.255.), int_of_float ((b'+.m)*.255.))

let _ =
  MyRGBLed.init ();
  while(true) do
    for h = 0 to 360 do
      let (rv, gv, bv) = rgb_of_hsv ((float_of_int h), 1., 1.) in
      MyRGBLed.set_color rv gv bv;
      delay 10
    done
  done
