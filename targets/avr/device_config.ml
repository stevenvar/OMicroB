module type AVRCONFIG = sig
  val mmcu : string
  val avr : string
  val baud : int
  val clock : int
  val folder : string
  val pins_module : string
end

module ArduboyConfig : AVRCONFIG = struct
  let mmcu = "atmega32u4"
  let avr = "avr109"
  let baud = 115_200
  let clock = 16_000_000
  let folder = "arduboy"
  let pins_module = "ArduboyPins"
end

module ArduinoUnoConfig : AVRCONFIG = struct
  let mmcu = "atmega328p"
  let avr = "arduino"
  let baud = 115_200
  let clock = 16_000_000
  let folder = "arduino_uno"
  let pins_module = "ArduinoUnoPins"
end

module ArduinoMegaConfig : AVRCONFIG = struct
  let mmcu = "atmega2560"
  let avr = "avrispmkii"
  let baud = 115_200
  let clock = 16_000_000
  let folder = "arduino_mega_2560"
  let pins_module = "ArduinoMegaPins"
end

let default_avr_cxx_options = [ "-g"; "-fno-exceptions"; "-Wall"; "-std=c++11"; "-O2"; "-Wnarrowing"; "-Wl,-Os"; "-fdata-sections"; "-ffunction-sections"; "-Wl,-gc-sections" ]

module AvrConfig(A : AVRCONFIG) : DEVICECONFIG = struct
  let compile_ml_to_byte ~ppx_options ~mlopts ~cxxopts ~trace ~verbose
      inputs output =
    let vars = [ ("CAMLLIB", libdir) ] in
    let cmd = [ ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-custom" ] @ mlopts in
    let cmd = if trace > 0 then cmd @ [ "-ccopt"; "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ List.flatten (List.map (fun cxxopt -> [ "-ccopt"; cxxopt ]) cxxopts) in
    let cmd = cmd @
        [ "-I"; Filename.concat libdir "targets/avr" ;
          Filename.concat libdir "targets/avr/avr.cma";
          "-I"; Filename.concat libdir
            (Filename.concat "targets/avr" A.folder);
          Filename.concat libdir
            (Filename.concat "targets/avr"
               (Filename.concat A.folder
                  ((String.uncapitalize_ascii A.pins_module)^".cmo")));
          "-open"; Printf.sprintf "Avr";
          "-open"; Printf.sprintf "%s" A.pins_module ] in
    let cmd = cmd @ inputs @ [ "-o"; output ] in
    run ~vars ~verbose cmd

  let compile_c_to_hex ~trace ~verbose input output =
    let avr_file = (Filename.remove_extension input)^".avr" in
    (* Compile .c to .avr *)
    let avrcxxopts = [] (* TEMP *) in
    let cmd = [ avr_cxx ] @ default_avr_cxx_options @ avrcxxopts in
    let cmd = if List.exists (fun avrcxxopt -> starts_with avrcxxopt ~sub:"-mmcu=") avrcxxopts then cmd else cmd @ [ "-mmcu=" ^ A.mmcu ] in
    let cmd = if List.exists (fun avrcxxopt -> starts_with avrcxxopt ~sub:"-DF_CPU=") avrcxxopts then cmd else cmd @ [ "-DF_CPU=" ^ string_of_int A.clock ] in
    let cmd = if trace > 0 then cmd @ [ "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ [ "-I"; Filename.concat includedir "avr" ] in
    let cmd = cmd @ [ "-I"; Filename.concat includedir (Filename.concat "avr" A.folder) ] in
    let cmd = cmd @ [ input; "-o"; avr_file ] in
    run ~verbose cmd;

    (* Compile .avr to .hex *)
    let avrobjcopts = [] (* TEMP *) in
    let cmd = [ avr_objcopy; "-O"; "ihex"; "-R"; ".eeprom" ] @
              avrobjcopts @ [ avr_file; output ] in
    run ~verbose cmd


  let flash ~sudo ~verbose path =
    let avrdudeopts = [] in (* TEMP *)
    let cmd = if sudo then [ "sudo" ] else [] in
    let cmd = cmd @ [ avrdude ] in
    let cmd = if List.mem "-c" avrdudeopts then cmd else cmd @ [ "-c"; A.avr ] in
    let cmd = if List.mem "-P" avrdudeopts then cmd
      else cmd @ [ "-P"; tty ~ttyopts:avrdudeopts () ] in
    let cmd = if List.mem "-p" avrdudeopts then cmd else cmd @ [ "-p"; A.mmcu ] in
    let cmd = if List.mem "-b" avrdudeopts then cmd else cmd @ [ "-b"; string_of_int A.baud ] in
    let cmd = cmd @ avrdudeopts @ [ "-v"; "-D"; "-U"; "flash:w:" ^ path ^ ":i" ] in
    run ~verbose cmd
end

(** Choose the correct config according to name *)
let get_config name = match name with
  | "arduboy" -> (module AvrConfig(ArduboyConfig) : DEVICECONFIG)
  | "arduino-mega" -> (module AvrConfig(ArduinoMegaConfig) : DEVICECONFIG)
  | "arduino-uno" -> (module AvrConfig(ArduinoUnoConfig) : DEVICECONFIG)
  | _ -> get_config name

(** Get the names of all configs *)
let all_config_names () = [
  "arduboy";
  "arduino-mega";
  "arduino-uno"
]@(all_config_names ())
