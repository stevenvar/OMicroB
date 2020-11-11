(******************************************************************************)

let default_arm_cxx_options = [ "-mcpu=cortex-m0"; "-mthumb";
                                "-fno-exceptions"; "-fno-unwind-tables";
                                "-fdata-sections"; "-ffunction-sections";
                                "-O"; "-g"; "-Wall"; "-Wl,-Os";
                                "-Wl,--gc-sections" ]

module MicroBitConfig : DEVICECONFIG = struct
  let compile_ml_to_byte ~ppx_options ~mlopts ~cxxopts ~local ~trace ~verbose
      inputs output =
    let libdir = libdir local in
    let vars = [ ("CAMLLIB", libdir) ] in
    let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-custom" ] @ mlopts in
    let cmd = if trace > 0 then cmd @ [ "-ccopt"; "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ List.flatten (List.map (fun cxxopt -> [ "-ccopt"; cxxopt ]) cxxopts) in
    let cmd = cmd @ [ "-I"; Filename.concat libdir "targets/microbit";
                      Filename.concat libdir "targets/microbit/microbit.cma";
                      "-open"; "Microbit" ] in
    let cmd = cmd @ inputs @ [ "-o"; output ] in
    run ~vars ~verbose cmd

  let compile_c_to_hex ~local ~trace:_ ~verbose input output =
    let includedir = includedir local in
    let microbitdir =
      if local then Filename.concat Config.builddir "src/byterun/microbit"
      else Filename.concat Config.includedir "microbit" in

    let arm_o_file = (Filename.remove_extension input)^".arm_o" in
    let arm_elf_file = (Filename.remove_extension input)^".arm_elf" in

    (* Compile a .c into a .arm_o *)
    let conc_microbit s = Filename.concat microbitdir s in
    let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
    let cmd = cmd @ [ "-D__MICROBIT__" ] in
    let cmd = cmd @ [ "-I"; Filename.concat includedir "microbit" ] in
    let cmd = cmd @ [ "-o"; arm_o_file ] @ [ "-c"; input ] in
    run ~verbose cmd;

    (* Compile a .arm_o into a .arm_elf *)
    let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
    let cmd = cmd @ [ "--specs=nosys.specs" ] in
    let cmd = cmd @ [ "-D__MICROBIT__" ] in
    let cmd = cmd @ [ "-T"; conc_microbit "NRF51822.ld" ] in
    let cmd = cmd @ [ conc_microbit "startup.o";
                      arm_o_file;
                      conc_microbit "microbitlib.o" ] in
    (* let cmd = cmd @ [ "-lnosys"; "-lstdc++"; "-lsupc++"; "-lm"; "-lc"; "-lgcc"; "-lstdc++"; "-lsupc++"; "-lm"; "-lc"; "-lgcc" ] in *)
    let cmd = cmd @ [ "-o" ; arm_elf_file ] in
    run ~verbose cmd;

    (* Compile a .arm_elf into a .hex *)
    let cmd = [ Config.arm_objcopy; "-O"; "ihex"; arm_elf_file; output ] in
    run ~verbose cmd

  let flash ~sudo:_ ~verbose:_ hexfile =
    failwith
      (Printf.sprintf
         "To flash a microbit, simply copy %s to your microbit device"
         hexfile)
end

(******************************************************************************)

(** Choose correct config according to name *)
let get_config name = match name with
  | "microbit" -> (module MicroBitConfig : DEVICECONFIG)
  | _ -> get_config name

(** Get the names of all configs *)
let all_config_names () = [
  "microbit"
]@(all_config_names ())


 (* 
 *      *   ) *)

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
