let get_config name = match name with
  | "arduino-uno" -> (module ArduinoUnoPins : MCUSimul)
  | "arduino-mega" -> (module ArduinoMegaPins : MCUSimul)
  | "arduboy" -> (module ArduboyPins : MCUSimul)
  | _ -> get_config name

let all_config_names () = [
  "arduino-uno";
  "arduino-mega";
  "arduboy";
]@(all_config_names ())
