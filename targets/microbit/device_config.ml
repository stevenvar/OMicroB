let armcxxopts       = ref []
let armobjcopts      = ref []

let arch_args =
  arch_args@[
    ("-armcxxopt", Arg.String (fun opt -> armcxxopts := opt :: !armcxxopts),
     "<option> Pass the given option to the ARM C++ compiler");
    ("-armcxxopts", Arg.String (fun opts -> armcxxopts := List.rev (split opts ',') @ !armcxxopts),
     "<opt1,opt2,...> Pass the given options to the ARM C++ compiler");
    ("-armobjcopt", Arg.String (fun opt -> armobjcopts := opt :: !armobjcopts),
     "<option> Pass the given option to the ARM objcopy tool");
    ("-armobjcopts", Arg.String (fun opts -> armobjcopts := List.rev (split opts ',') @ !armobjcopts),
     "<opt1,opt2,...> Pass the given options to the ARM objcopy tool");
    ("-arm-c++", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.arm_cxx; exit 0),
       " Print location of ARM C++ compiler and exit");
    ("-arm-objcopy", Arg.Unit (fun () -> Printf.printf "%s\n%!" Config.arm_objcopy; exit 0),
     " Print location of arm-objcopy and exit");
  ]

(******************************************************************************)

module MicroBitConfig : DEVICECONFIG = struct

  let rec interpose s l = match l with
    | [] -> []
    | t::q -> [s; t]@(interpose s q)

  let rec interleave l1 l2 = match (l1, l2) with
    | [],[] -> []
    | [],_ -> invalid_arg "interleave"
    | _,[] -> invalid_arg "interleave"
    | t1::q1, t2::q2 -> [t1; t2]@(interleave q1 q2)

  let default_arm_cxx_options =
    [ "-g"; "-fno-exceptions"; "-fno-unwind-tables"; "-Wall"; "-Wno-array-bounds";
      "-std=c++11"; "-O2"; "-Wnarrowing"; "-Wl,-Os"; "-fdata-sections";
      "-ffunction-sections"; "-Wl,-gc-sections"; "-mcpu=cortex-m0"; "-mthumb" ]

  let compile_ml_to_byte ~ppx_options ~mlopts ~cxxopts ~local ~trace ~verbose
      inputs output =
    let libdir = libdir local in
    let vars = [ ("CAMLLIB", libdir) ] in
    let cmd = [ Config.ocamlc ] @ default_ocamlc_options @ ppx_options @ [ "-custom" ] @ mlopts in
    let cmd = if trace > 0 then cmd @ [ "-ccopt"; "-DDEBUG=" ^ string_of_int trace ] else cmd in
    let cmd = cmd @ List.flatten (List.map (fun cxxopt -> [ "-ccopt"; cxxopt ]) cxxopts) in
    let cmd = cmd @ [ "-I"; Filename.concat libdir "targets/microbit" ;
                      Filename.concat libdir "targets/microbit/microbit.cma";
                      "-open"; Printf.sprintf "Microbit" ] in
    let cmd = cmd @ inputs @ [ "-o"; output ] in
    run ~vars ~verbose cmd

  let compile_c_to_hex ~local ~trace:_ ~verbose input output =

    let microbitdir =
      if local then Filename.concat Config.builddir "src/byterun/microbit"
      else Filename.concat Config.includedir "microbit" in

    let conc_microbit s = Filename.concat microbitdir s in

    let arm_o_path = (Filename.remove_extension input)^".arm_o" in
    let arm_elf_path = (Filename.remove_extension input)^".arm_elf" in
    let hex_path = (Filename.remove_extension input)^".hex" in

    (* Compile .c to .arm_elf *)

    let to_include = [
        "";
        "mbed-classic/api"; "mbed-classic/hal"; "mbed-classic/cmsis";
        "nrf51-sdk/source/ble/ble_radio_notification"; "nrf51-sdk/source/ble/ble_services/ble_dfu";
        "nrf51-sdk/source/ble/common"; "nrf51-sdk/source/ble/device_manager";
        "nrf51-sdk/source/ble/device_manager/config"; "nrf51-sdk/source/ble/peer_manager";
        "nrf51-sdk/source/device"; "nrf51-sdk/source/drivers_nrf/ble_flash";
        "nrf51-sdk/source/drivers_nrf/delay"; "nrf51-sdk/source/drivers_nrf/hal";
        "nrf51-sdk/source/drivers_nrf/pstorage"; "nrf51-sdk/source/drivers_nrf/pstorage/config";
        "nrf51-sdk/source/libraries/bootloader_dfu"; "nrf51-sdk/source/libraries/bootloader_dfu/hci_transport";
        "nrf51-sdk/source/libraries/crc16"; "nrf51-sdk/source/libraries/experimental_section_vars";
        "nrf51-sdk/source/libraries/fds"; "nrf51-sdk/source/libraries/fstorage";
        "nrf51-sdk/source/libraries/hci"; "nrf51-sdk/source/libraries/scheduler";
        "nrf51-sdk/source/libraries/timer"; "nrf51-sdk/source/libraries/util";
        "nrf51-sdk/source/softdevice/common/softdevice_handler"; "nrf51-sdk/source/softdevice/s130/headers";
        "ble"; "ble/ble"; "ble/ble/services";
        "ble-nrf51822/source"; "ble-nrf51822/source/common";
        "ble-nrf51822/source/btle"; "ble-nrf51822/source/btle/custom";
        "microbit-dal/inc/core"; "microbit-dal/inc/types"; "microbit-dal/inc/drivers";
        "microbit-dal/inc/bluetooth"; "microbit-dal/inc/platform";
        "microbit/inc" ] in

    let cmd = [ Config.arm_cxx ] @ default_arm_cxx_options in
    let cmd = cmd @ [ "-D__MBED__"; "-DNDEBUG" ; "-DTOOLCHAIN_GCC"; "-DTOOLCHAIN_ARM_GCC"; "-DMBED_OPERATORS";
                      "-DNRF51"; "-DTARGET_NORDIC"; "-DTARGET_M0"; "-DMCU_NORDIC_16K";
                      "-DTARGET_NRF51_MICROBIT"; "-DTARGET_MCU_NORDIC_16K"; "-DTARGET_MCU_NRF51_16K_S110";
                      "-DTARGET_NRF_LFCLK_RC"; "-D__CORTEX_M0"; "-DARM_MATH_CM0" ] in
    let cmd = cmd @ (interpose "-I" (List.map conc_microbit to_include)) in
    let cmd = cmd @ [ "-o"; arm_o_path ] @ [ "-c"; input ] in
    run ~verbose cmd;

    let to_link = [ "microbit"; "microbit-dal"; "ble-nrf51822"; "ble"; "nrf51-sdk"; "mbed-classic" ] in
    let link_folders = List.map (fun s -> "-L"^(conc_microbit s)) to_link
    and link_libs = List.map (fun s -> "-l"^s) to_link in

    let cmd = [ Config.arm_cxx;
                arm_o_path;
                conc_microbit "microbitlib.o";
                "-o"; arm_elf_path ] @ default_arm_cxx_options in
    let cmd = cmd @ [ "-D__MBED__" ] in
    let cmd = cmd @ [ "-Wl,-wrap,main" ] in
    let cmd = cmd @ [ "-T"; conc_microbit "mbed-classic/cmsis/NRF51822.ld" ] in
    let cmd = cmd @ [ "-Wl,--start-group" ] in
    let cmd = cmd @ (interleave link_folders link_libs) in
    let cmd = cmd @ [ "-lnosys"; "-lstdc++"; "-lsupc++"; "-lm"; "-lc"; "-lgcc"; "-lstdc++"; "-lsupc++"; "-lm"; "-lc"; "-lgcc" ] in
    let cmd = cmd @ [ "-Wl,--end-group"; "--specs=nano.specs" ] in
    run ~verbose cmd;

    (* Compile .arm_elf to .hex *)
    let cmd = [ Config.arm_objcopy; "-O"; "ihex"; arm_elf_path; hex_path ] in
    run ~verbose cmd;

    (* Add the bootloader **)
    let cmd = [ "srec_cat"; Filename.concat microbitdir "BLE_BOOTLOADER_RESERVED.hex" ] in
    let cmd = cmd @ [ "-intel"; Filename.concat microbitdir "mbed-classic/hal/Lib/s110_nrf51822_8_0_0/s110_nrf51822_8.0.0_softdevice.hex" ] in
    let cmd = cmd @ [ "-intel"; hex_path ] in
    let cmd = cmd @ [ "-intel"; "-o"; output; "-intel"; "--line-length=44" ] in
    run ~verbose cmd


  let flash ~sudo:_ ~verbose:_ path =
    failwith
      (Printf.sprintf
         "To flash a microbit, simply copy %s to your microbit device"
         path)
end

(******************************************************************************)

(** Choose the correct config according to name *)
let get_config name = match name with
  | "microbit" -> (module MicroBitConfig : DEVICECONFIG)
  | _ -> get_config name

let all_config_names () = [
  "microbit"
]@(all_config_names ())

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
