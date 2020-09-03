module I2C = I2C(struct let address = 0x3C end)
module Scr = Ssd1306.MakeSSD1306(I2C)

type coord = (int * int)
type side = Left | Right

let scoreL = ref 0 and scoreR = ref 0

let%component LeftLed = Circuits.MakeLed(connectedPin = PIN1)
let%component RightLed = Circuits.MakeLed(connectedPin = PIN2)
let%component SPIMaster = MakeSPIMaster(slavePin = PIN0)

(** Draw or undraw one of the paddles *)
let draw_paddle side y show =
  let x = (match side with Left -> 0 | Right -> 126) in
  for i = y-5 to y+5 do
    Scr.set_pixel x i show; Scr.set_pixel (x+1) i show
  done

(** Draw or undraw the ball *)
let draw_ball (x, y) show =
  for i = x-1 to x+1 do
    for j = y-1 to y+1 do
      try
        Scr.set_pixel i j show
      with _ -> ()
    done
  done

(** Draw everything *)
let draw_all bCoord ly ry =
  draw_ball bCoord true;
  draw_paddle Left ly true; draw_paddle Right ry true

(** Update the ball position (including earning a point if relevant) *)
let update_ball_coord (x, y) (sx, sy) ly ry =
  let (nx, ny) = (x + sx, y + sy) in
  if nx <= 3 then (
    if ny <= ly + 6 && ny >= ly - 6 then ((nx, ny), (-sx, sy))
    else (
      LeftLed.on ();
      scoreR := !scoreR + 1; Radio.send ("sr"^(string_of_int !scoreR));
      delay 500;
      LeftLed.off ();
      ((64, 32), (3, -3))
    )
  )
  else if nx >= 125 then (
    if ny <= ry + 6 && ny >= ry - 6 then ((nx, ny), (-sx, sy))
    else (
      RightLed.on ();
      scoreL := !scoreL + 1; Radio.send ("sl"^(string_of_int !scoreL));
      delay 500;
      RightLed.off ();
      ((64, 32), (-3, 3))
    )
  ) else
  if(ny >= 60 || ny <= 3) then ((nx, ny), (sx, -sy))
  else ((nx, ny), (sx, sy))


let _ =
  Scr.init (); Radio.init (); SPIMaster.init ();
  let bCoord = ref (64, 32) and bSpeed = ref (3, -3) in
  let leftY = ref 32 and rightY = ref 32 in
  draw_all !bCoord !leftY !rightY;
  while true do
    (* Receive new position of paddles *)
    draw_paddle Left !leftY false;
    draw_paddle Right !rightY false;
    let s = int_of_char (SPIMaster.transmit (char_of_int !scoreL)) in
    if(s <> 0) then leftY := 58 - (min 58 (max 5 s));
    let s = Radio.recv () in
    if(String.length s = 1) then (
        rightY := min 58 (max 5 (int_of_char (String.get s 0)));
    );
    draw_paddle Left !leftY true;
    draw_paddle Right !rightY true;

    (* Update ball position *)
    draw_ball !bCoord false;
    let (nCoord, nSpeed) = update_ball_coord !bCoord !bSpeed !leftY !rightY in
    bSpeed := nSpeed; bCoord := nCoord;
    draw_ball !bCoord true;
    delay 5
  done
