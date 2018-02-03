
open Printf
open Types

type multi_cmd =
  | SetDisplayClockDivisor
  | EnableChargePump
  | SetContrast
  | SetPreCharge

let verbose = false
let print = if verbose then prerr_endline else (fun _ -> ())

let refresh display =
  let mutex = Mutex.create () in
  let flag = ref true in
  let _thread =
    Thread.create (fun () ->
      while true do
        Mutex.lock mutex;
        let b = !flag in
        if b then flag := false;
        Mutex.unlock mutex;
        if b then (
          Ddram.to_matrix display;
          Display.show display
        );
        Thread.delay 0.01;
      done;
    ) ()  in
  fun () ->
    Mutex.lock mutex;
    flag := true;
    Mutex.unlock mutex

let write_data_to_ram data display =
  print (sprintf "write_data_to_ram(%C)" (char_of_int data));
  Ddram.write data display

let exec cs dc _rst display =
  (* if rst then clear display; *)
  match (cs,dc) with
  |  (false,false) ->
    (* Printf.printf "command mode\n"; *)
    display.mode <- Command
  | (false,true) ->
    (* Printf.printf "data mode\n"; *)
    display.mode <- Data
  | _ -> ()

let register display =
  let refresh = refresh display in
  
  let handler () =
    let cs_val = Simul.test_pin display.cs in
    let dc_val = Simul.test_pin display.dc in
    let rst_val = Simul.test_pin display.rst in
    exec cs_val dc_val rst_val display in
  
  let set_display_clock_divisor _ = () in (* TODO *)
  let enable_charge_pump _ = () in (* TODO *)
  let set_contrast _ = () in (* TODO *)
  let set_precharge _ = () in (* TODO *)
  let set_segment_remap () = () in (* TODO *)
  let set_com_output_scan_direction () = () in (* TODO *)
  let display_on () = () in (* TODO *)
  let set_horizontal_mode () = () in (* TODO *)

  let write_handler =
    let multi_cmd = ref None in
    let cpt = ref 0 in
    fun i ->
      match display.mode with
      | Data -> (
        write_data_to_ram i display;
        refresh ();
        incr cpt;
        cpt := !cpt mod 1024
      )
      | Command -> (
        match !multi_cmd with
        | Some SetDisplayClockDivisor -> multi_cmd := None; set_display_clock_divisor i
        | Some EnableChargePump       -> multi_cmd := None; enable_charge_pump i
        | Some SetContrast            -> multi_cmd := None; set_contrast i
        | Some SetPreCharge           -> multi_cmd := None; set_precharge i
        | None -> (
          match char_of_int i with
          | '\xD5' -> multi_cmd := Some SetDisplayClockDivisor
          | '\x8D' -> multi_cmd := Some EnableChargePump
          | '\xA1' -> set_segment_remap ()
          | '\xC8' -> set_com_output_scan_direction ()
          | '\x81' -> multi_cmd := Some SetContrast
          | '\xD9' -> multi_cmd := Some SetPreCharge
          | '\xAF' -> display_on ()
          | '\x20' -> set_horizontal_mode ()
          | '\x00' .. '\x0F' -> Ddram.set_column_low i
          | '\x10' .. '\x1F' -> Ddram.set_column_high (i - 0x10)
          | '\xB0' .. '\xB7' -> Ddram.set_line (i - 0xB0)
          | _ -> Printf.eprintf "Warning (LCD): unknown command: 0x%02x\n%!" i
        )
      ) in

  Simul.add_handler (Simul.Clear_pin_handler (display.cs, handler));
  Simul.add_handler (Simul.Set_pin_handler (display.dc, handler));
  Simul.add_handler (Simul.Write_port_handler (display.port, write_handler))
