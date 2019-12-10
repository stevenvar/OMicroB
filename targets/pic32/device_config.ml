let fubarinoMiniConfig: config = {
  typeD = PIC32;
  mmcu = "32MX250F128D";
  avr = "";
  baud = 115_200;
  clock = 48_000_000;
  folder = "fubarino_mini";
  pins_module = "FubarinoMiniPins";
  (* linker_scripts = ["chipKIT-application-32MX250F128.ld"; "chipKIT-application-COMMON.ld"] *)
  (* linker_scripts = [ "procdefs_250F128D.ld"; "elf32pic32mx.x" ]*)
  (* linker_scripts = [ "elf32pic32mx.ld" ] *)
  linker_scripts = [ "p32MX250F128D.ld"] 
}

let lchipConfig: config = {
  typeD = PIC32;
  mmcu = "32MX795F512L";
  avr = "";
  baud = 115_200;
  clock = 48_000_000;
  folder = "lchip";
  pins_module = "LchipPins";
  linker_scripts = ["32MX795F512L-lchip.ld"]
}

[@@@warning "-32"]
let defConfig = fubarinoMiniConfig

let get_config name = match name with
  | "fubarino-mini" -> fubarinoMiniConfig
  | "lchip" -> lchipConfig
  | _ -> get_config name

let all_config_names () = [
  "fubarino-mini";
  "lchip"
]@(all_config_names ())
