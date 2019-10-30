
let arduinoMegaConfig: config = {
  typeD = AVR;
  mmcu = "atmega2560";
  avr = "avrispmkii";
  baud = 115_200;
  clock = 16_000_000;
  folder = "arduino_mega_2560";
  pins_module = "ArduinoMegaPins";
  linker_scripts = [];
}

let arduboyConfig: config = {
  typeD = AVR;
  mmcu = "atmega32u4";
  avr = "avr109";
  baud = 115_200;
  clock = 16_000_000;
  folder = "arduboy";
  pins_module = "ArduboyPins";
  linker_scripts = [];
}

let arduinoUnoConfig: config = {
  typeD = AVR;
  mmcu  = "atmega328p";
  avr   = "arduino";
  baud  = 115_200;
  clock = 16_000_000;
  folder = "arduino_uno";
  pins_module = "ArduinoUnoPins";
  linker_scripts = [];
}

[@@@warning "-32"]
let defConfig = arduboyConfig

(** Choose se correct config according to name *)
let get_config name = match name with
  | "arduboy" -> arduboyConfig
  | "arduino-mega" -> arduinoMegaConfig
  | "arduino-uno" -> arduinoUnoConfig
  | _ -> get_config name

(** Get the names of all configs *)
let all_config_names () = [
  "arduboy";
  "arduino-mega";
  "arduino-uno"
]@(all_config_names ())
