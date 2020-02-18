open Config
open Tools

(** Available architectures *)
type device_type = NONE | AVR | PIC32

(** Signatures for a device's configuration *)
module type DEVICECONFIG = sig
  (** Compile a .ml to a .byte *)
  val compile_ml_to_byte : ppx_options:string list -> mlopts:string list ->
    cxxopts:string list -> trace:int -> verbose:bool -> string list -> string -> unit

  (** Compile a .c to a .hex *)
  val compile_c_to_hex : trace:int -> verbose:bool -> string -> string -> unit

  (** Flash an executable file *)
  val flash : sudo:bool -> verbose:bool -> string -> unit
end

let default_ocamlc_options = [ "-g"; "-w"; "A"; "-safe-string"; "-strict-sequence"; "-strict-formats"; "-ccopt"; "-D__OCAML__" ]

(** Default config, when no device is selected *)
module DefaultConfig : DEVICECONFIG = struct
  let compile_ml_to_byte ~ppx_options ~mlopts ~cxxopts ~trace ~verbose
      inputs output =
    let vars = [ ("CAMLLIB", libdir) ] in
    let cmd = [ ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-custom" ] @ mlopts in
    let cmd = if trace > 0 then cmd @ [ "-ccopt"; "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ List.flatten (List.map (fun cxxopt -> [ "-ccopt"; cxxopt ]) cxxopts) in
    let cmd = cmd @ inputs @ [ "-o"; output ] in
    run ~vars ~verbose cmd

  let compile_c_to_hex ~trace:_ ~verbose:_ _ _ =
    failwith "The default config doesn't support flashing"

  let flash ~sudo:_ ~verbose:_ _ =
    failwith "The default config doesn't support flashing"
end

let get_config _ = invalid_arg "choose_config"

let all_config_names () = []
