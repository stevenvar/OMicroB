
open Printf
open Types

let verbose = false
let print = if verbose then prerr_endline else (fun _ -> ())

let refresh display =
    Ddram.to_matrix display;
    Display.show display

let clear display =
  print "clear()";
  Ddram.fill 0 display;
  (* Ddram.set_addr 0 display; *)
  refresh display

let home display =
  print "home()";
  (* Ddram.set_addr 0 display; *)
  refresh display


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
  let handler () =
    let cs_val = Simul.test_pin display.cs in
    let dc_val = Simul.test_pin display.dc in
    let rst_val = Simul.test_pin display.rst in
    exec cs_val dc_val rst_val display
  in
  let write_handler =
    let cpt = ref 0 in
    fun i ->
    (* Printf.printf "cpt = %d New val = %d\n" !cpt i; *)
    match display.mode with
    | Data -> write_data_to_ram i display;
      if !cpt = 1023 then (refresh display);
      incr cpt;
      cpt := !cpt mod 1024
    | Command -> ()
      (* if i = 0x22 then Printf.printf "Set page address ...\n" *)
      (* else if i = 0x21 then Printf.printf "Set column address ...\n" *)
  in
  Simul.add_handler (Simul.Clear_pin_handler (display.cs, handler));
  Simul.add_handler (Simul.Set_pin_handler (display.dc, handler));
  Simul.add_handler (Simul.Write_port_handler (display.port, write_handler))
