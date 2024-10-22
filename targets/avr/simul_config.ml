let get_config name = match name with
  | "arduino-uno" -> (module ArduinoUnoPins : Simul.MCUSimul)
  | "arduino-mega" -> (module ArduinoMegaPins : Simul.MCUSimul)
  | "arduboy" -> (module ArduboyPins : Simul.MCUSimul)
  | _ -> get_config name

let all_config_names () = [
  "arduino-uno";
  "arduino-mega";
  "arduboy";
]@(all_config_names ())
