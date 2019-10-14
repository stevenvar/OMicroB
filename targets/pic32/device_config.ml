let fubarinoMiniConfig: config = {
  typeD = PIC32;
  mmcu = "PIC32MX250F128D";
  avr = "";
  baud = 115_200;
  clock = 48_000_000;
  folder = "fubarino_mini"
  pins_module = "FubarinoMiniPins";
}

let lchipConfig: config = {
  typeD = PIC32;
  mmcu = "PIC32MX795F512L";
  avr = "";
  baud = 115_200;
  clock = 0;
  folder = "lchip";
  pins_module = "LchipPins";
}

[@@@warning "-32"]
let defConfig = fubarinoMiniConfig

let get_config name = match name with
  | "fubarino-mini" -> fubarinoMiniConfig
  | "lchip" -> lchipConfig
  | -> get_config name

let all_config_names () = [
  "fubarino-mini";
  "lchip"
]@(all_config_names ())
