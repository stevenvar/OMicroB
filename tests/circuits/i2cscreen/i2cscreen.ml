(* Inspired by https://github.com/adafruit/Adafruit_SSD1306
   and https://github.com/Afantor/Microbit_SSD1306_OLED *)

open Circuits

module I2C = I2C(struct let address = 0x3C end)
module Screen = Ssd1306.MakeSSD1306(I2C)
open Screen

let _ =
  init ();
  set_pixel 0 0 true; set_pixel 0 1 true; set_pixel 1 0 true;
  set_pixel 127 0 true; set_pixel 126 0 true; set_pixel 127 1 true;
  set_pixel 0 63 true; set_pixel 0 62 true; set_pixel 1 63 true;
  set_pixel 127 63 true; set_pixel 126 63 true; set_pixel 127 62 true
