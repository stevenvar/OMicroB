let microbitConfig: config = {
  typeD = MICROBIT;
  mmcu = "Arm Cortex M0";
  avr = "";
  baud = 115_200;
  clock = 16_000_000;
  folder = "";
  pins_module = "Microbit";
}

(** Choose correct config according to name *)
let get_config name = match name with
  | "microbit" -> microbitConfig
  | _ -> get_config name

(** Get the names of all configs *)
let all_config_names () = [
  "microbit"
]@(all_config_names ())
