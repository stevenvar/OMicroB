(** Type of device *)
type device_type = AVR

(** Config for a given avr device *)
type config = {
  typeD: device_type;
  mmcu: string;
  avr: string;
  baud: int;
  clock: int;
  device_def: string;
  pins_module: string;
}

let arduboyConfig: config = {
  typeD = AVR;
  mmcu = "atmega32u4";
  avr = "avr109";
  baud = 115_200;
  clock = 16_000_000;
  device_def = "DEVICE_ARDUBOY";
  pins_module = "ArduboyPins";
}

let arduinoMegaConfig: config = {
  typeD = AVR;
  mmcu = "atmega2560";
  avr = "avrispmkii";
  baud = 115_200;
  clock = 16_000_000;
  device_def = "DEVICE_ARDUINO_MEGA";
  pins_module = "ArduinoMegaPins";
}

let arduinoUnoConfig: config = {
  typeD = AVR;
  mmcu  = "atmega328p";
  avr   = "arduino";
  baud  = 115_200;
  clock = 16_000_000;
  device_def = "DEVICE_ARDUINO_UNO";
  pins_module = "ArduinoUnoPins";
}

(** Choose se correct config according to name *)
let get_config name = match name with
  | "arduboy" -> arduboyConfig
  | "arduino-mega" -> arduinoMegaConfig
  | "arduino-uno" -> arduinoUnoConfig
  | _ -> invalid_arg "choose_config"

(** Get the names of all configs *)
let all_config_names () = [
  "arduboy";
  "arduino-mega";
  "arduino-uno"
]
