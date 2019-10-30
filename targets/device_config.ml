(** Available devices *)
type device_type = NONE | AVR | PIC32

(** Config for a given device *)
type config = {
  typeD: device_type;
  mmcu: string;
  avr: string;
  baud: int;
  clock: int;
  folder: string;
  pins_module: string;
  linker_scripts: string list;
}

[@@@warning "-32"]
let defConfig = {
  typeD = NONE;
  mmcu = "";
  avr = "";
  baud = 0;
  clock = 0;
  folder = "";
  pins_module = "";
  linker_scripts = [];
}

let get_config _ = invalid_arg "choose_config"

let all_config_names () = []
