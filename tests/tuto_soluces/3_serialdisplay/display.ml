open Avr

let cs = PIN12
let dc = PIN4
let rst = PIN6
let button_smile = PIN7
let button_frown = PIN8

type emotion = Smile | Frown | Nothing

let smile () =
    Oled.draw 39 24 true;
    Oled.draw 38 23 true;
    Oled.draw 37 22 true;
    Oled.draw 61 24 true;
    Oled.draw 62 23 true;
    Oled.draw 63 22 true

let frown () =
  Oled.draw 39 25 true;
  Oled.draw 38 26 true;
  Oled.draw 37 27 true;
  Oled.draw 61 25 true;
  Oled.draw 62 26 true;
  Oled.draw 63 27 true


let cur_emotion = ref Nothing

let boot () =
  pin_mode SS OUTPUT;
  pin_mode SCK OUTPUT;
  pin_mode MOSI OUTPUT;
  pin_mode cs OUTPUT;
  pin_mode dc OUTPUT;
  pin_mode rst OUTPUT;
  pin_mode button_smile INPUT_PULLUP;
  pin_mode button_frown INPUT_PULLUP;
  Spi.begin_spi ~ss:SS ~sck:SCK ~mosi:MOSI;
  Oled.boot ~cs:cs ~dc:dc ~rst:rst

let () =
  boot ();

  while true do
    if digital_read button_smile = LOW then (
      Oled.clear ();
      cur_emotion := Smile;
    );
    if digital_read button_frown = LOW
    then
      (
        Oled.clear ();
        cur_emotion := Frown;
      );

    Oled.draw 40 10 true;
    Oled.draw 40 11 true;
    Oled.draw 60 10 true;
    Oled.draw 60 11 true;

    for i = 0 to 20 do
      Oled.draw (i+40) 25 true
    done;

    begin
    match !cur_emotion with
    | Smile -> smile ()
    | Frown -> frown ()
    | Nothing -> ()
  end
    ;
    Oled.display ();
  done;
