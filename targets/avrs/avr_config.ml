(** Config for a given avr device *)
type config = {
  mmcu: string;
  avr: string;
  baud: int;
  clock: int;
  device_def: string;
  folder: string;
}

let arduboyConfig: config = {
  mmcu = "atmega32u4";
  avr = "avr109";
  baud = 115_200;
  clock = 16_000_000;
  device_def = "DEVICE_ARDUBOY";
  folder = "arduboy";
}

let arduinoMegaConfig: config = {
  mmcu = "atmega2560";
  avr = "avrispmkii";
  baud = 115_200;
  clock = 16_000_000;
  device_def = "DEVICE_ARDUINO_MEGA";
  folder = "arduino_mega_2560";
}

let arduinoUnoConfig: config = {
  mmcu  = "atmega328p";
  avr   = "arduino";
  baud  = 115_200;
  clock = 16_000_000;
  device_def = "DEVICE_ARDUINO_UNO";
  folder = "arduino_uno";
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
