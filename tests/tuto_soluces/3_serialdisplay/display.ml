open Avr
    
let cs = PIN12
let dc = PIN4
let rst = PIN6
  
let () =
  pin_mode SS OUTPUT;
  pin_mode SCK OUTPUT;
  pin_mode MOSI OUTPUT;
  pin_mode cs OUTPUT;
  pin_mode dc OUTPUT;
  pin_mode rst OUTPUT;
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  Oled.boot ~cs:cs ~dc:dc ~rst:rst;
  while true do
    Oled.draw 23 10 true;
    Oled.draw 11 11 true;
    Oled.display ()
  done;


