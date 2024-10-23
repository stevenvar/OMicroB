(******************************************************************************)

let default_arm_cxx_options = [ "-std=c99" ]
                              @ (String.split_on_char ' ' Config.eadk_cflags)
                              @ [ "-Os"; "-Wall"; "-ggdb"]
(* TODO ld_flags *)

module NumworksConfig : DEVICECONFIG = struct
  let compile_ml_to_byte ~ppx_options ~mlopts ~cxxopts ~local ~trace ~verbose
        inputs output =
  let libdir = libdir local in
  let vars = [ ("CAMLLIB", libdir) ] in
  let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-custom" ] @ mlopts in
  let cmd = if trace > 0 then cmd @ [ "-ccopt"; "-DDEBUG=" ^ string_of_int trace ] else cmd in
  let cmd = cmd @ List.flatten (List.map (fun cxxopt -> [ "-ccopt"; cxxopt ]) cxxopts) in
  let cmd = cmd @ [ "-I"; Filename.concat libdir "targets/numworks";
                    Filename.concat libdir "targets/numworks/numworks.cma";
                    "-open"; "Numworks" ] in
  let cmd = cmd @ inputs @ [ "-o"; output ] in
  run ~vars ~verbose cmd


let compile_c_to_hex ~local ~trace:_ ~verbose input output =
  let includedir = includedir local in
  let numworksdir =
    if local then Filename.concat Config.builddir "src/byterun/numworks"
    else Filename.concat Config.includedir "numworks" in

  let arm_o_file = (Filename.remove_extension input)^".arm_o" in
  let arm_elf_file = (Filename.remove_extension input)^".arm_elf" in
  (* let arm_map_file = (Filename.remove_extension input)^".map" in *)

  (* Compile a .c into a .arm_o *)

  let conc_numworks s = Filename.concat numworksdir s in
  let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
  let cmd = cmd @ [ "-D__NUMWORKS__" ] in
  let cmd = cmd @ [ "-I"; Filename.concat includedir "numworks" ] in
  let cmd = cmd @ [ "-o"; arm_o_file ] @ [ "-c"; input ] in
  Printf.printf "################## Compile a .c into a .arm_o\n";
  run ~verbose cmd;
  Printf.printf "################## Compiled a .c into a .arm_o\n";

  (* Compile a .arm_o into a .arm_elf *)
  let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
  let cmd = cmd @ [ "-Wl,--relocatable" ] in
  let cmd = cmd @ [ "-nostartfiles" ] in
  let cmd = cmd @ [ "--specs=nosys.specs" ] in
  let cmd = cmd @ [ "-fdata-sections"; "-ffunction-sections" ] in
  let cmd = cmd @ [ "-Wl,-e,main"; "-Wl,-u,eadk_app_name"; "-Wl,-u,eadk_app_icon"; "-Wl,-u,eadk_api_level" ] in
  let cmd = cmd @ [ "-Wl,--gc-sections" ] in
  let cmd = cmd @ [ "-D__NUMWORKS__" ] in
  let cmd = cmd @ [ arm_o_file;
                    conc_numworks "startup.o";
                    conc_numworks "icon.o" ] in
  let cmd = cmd @ [ "-lm" ] in
  let cmd = cmd @ [ "-o" ; arm_elf_file ] in
  List.iter (Printf.printf "%s ") cmd;
  run ~verbose cmd;
  Printf.printf "################## Compiled a .arm_o into a .arm_elf\n";

  (* Compile a .arm_elf into a .hex *)
  let cmd = [ "cp"; arm_elf_file; output ] in
  run ~verbose cmd

  let simul_flag = "__SIMUL_NUMWORKS__"

  let flash ~sudo:_ ~verbose:_ _hexfile =
    failwith "TODO"
end

(******************************************************************************)

(** Choose correct config according to name *)
let get_config name = match name with
  | "numworks" -> (module NumworksConfig : DEVICECONFIG)
  | _ -> get_config name

(** Get the names of all configs *)
let all_config_names () = [ "numworks" ]@(all_config_names ())

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
