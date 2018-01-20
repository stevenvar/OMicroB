
open Printf
open Types

let verbose = false
let print = if verbose then prerr_endline else (fun _ -> ())

let refresh display =
  (* if display.display_mode = On then *)
    (* let addr = display.ram_addr in *)
    Ddram.to_matrix display;
    (* begin match display.cursor_mode with
     *   | Hide -> ()
     *   | Show ->
     *     begin try
     *             let i = addr mod 64 in
     *             let j = addr / 64 in
     *             let old_m = display.matrix.(i).(j) in
     *             let m =
     *               Array.init 8 (fun i -> Array.init 5 (fun j -> old_m.(i).(j)))
     *             in
     *             for j = 0 to 4 do
     *               m.(7).(j) <- true;
     *             done;
     *             display.matrix.(i).(j) <- m;
     *       with Invalid_argument _ -> () end
     *   | Blink ->
     *     begin try
     *       let i = addr mod 64 in
     *       let j = addr / 64 in
     *       let old_m = display.matrix.(i).(j) in
     *       let m =
     *         Array.init 8 (fun i -> Array.init 5 (fun j -> old_m.(i).(j)))
     *       in
     *       for j = 0 to 4 do
     *         m.(0).(j) <- true;
     *         m.(7).(j) <- true;
     *       done;
     *       for i = 1 to 6 do
     *         m.(i).(0) <- true;
     *         m.(i).(4) <- true;
     *       done;
     *       display.matrix.(i).(j) <- m;
     *     with Invalid_argument _ -> () end
     * end; *)
    Display.show display;
;;

let clear display =
  print "clear()";
  Ddram.fill 0 display;
  (* Ddram.set_addr 0 display; *)
  refresh display;
;;

let home display =
  print "home()";
  (* Ddram.set_addr 0 display; *)
  refresh display;
;;

(* let entry_mode_set id sh display =
 *   print (sprintf "entry_mode_set( I/D = %b , SH = %b )" id sh);
 *   display.entry_mode_incr <- if id then Right else Left;
 *   display.shift_display <- sh;
 * ;; *)

(* let display_onoff_control d c b display =
 *   print (sprintf "display_onoff_control( D = %b , C = %b , B = %b )" d c b);
 *   display.display_mode <- if d then On else Off;
 *   display.cursor_mode <- if c then if b then Blink else Show else Hide;
 *   refresh display;
 * ;; *)

(* let cursor_or_display_shift sc rl display =
 *   print (sprintf "cursor_or_display_shift( S/C = %b , R/L = %b )" sc rl);
 *   begin match (rl, sc) with
 *     | (true, false) -> Ddram.incr_addr display;
 *     | (false, false) -> Ddram.decr_addr display;
 *     | (false, true) -> Ddram.rotate_left display;
 *     | (true, true) -> Ddram.rotate_right display;
 *   end;
 *   refresh display;
 * ;; *)

(* let function_set dl n f display =
 *   print (sprintf "function_set( DL = %b , N = %b , F = %b )" dl n f);
 *   display.bus_mode <- if dl then Eight else Four;
 *   Ddram.set_two_line_mode n display;
 *   display.font <- if f then F5x11 else F5x8;
 * ;; *)

(* let set_cgram_address addr display =
 *   print (sprintf "set_cgram_address(%02x)" addr);
 *   display.selected_ram <- CGRam;
 *   display.ram_addr <- addr;
 * ;; *)

(* let set_ddram_address addr display =
 *   print (sprintf "set_ddram_address(%02x)" addr);
 *   display.selected_ram <- DDRam;
 *   Ddram.set_addr addr display;
 *   refresh display;
 * ;; *)

(* let send bus_low bus_port value display =
 *   Simul.write_port bus_port (
 *     match display.bus_mode with
 *       | Eight -> value
 *       | Four ->
 *         if bus_low > 0x0F then (bus_low land 0x0F) lor (value land 0xF0)
 *         else bus_low lor ((value lsl 4) land 0xF0)
 *   )
 * ;; *)

(* let read_busy_flag_and_address bus_low bus_port display =
 *   print "read_busy_flag_and_address()";
 *   send bus_low bus_port (display.ram_addr) display;
 * ;; *)

let write_data_to_ram data display =
  print (sprintf "write_data_to_ram(%C)" (char_of_int data));
  (* match display.selected_ram with *)
    (* | DDRam -> *)
  Ddram.write data display;
      (* cursor_or_display_shift display.shift_display *)
        (* (display.entry_mode_incr = Right) display; *)
    (* | CGRam -> *)
      (* Cgram.write data display; *)
;;

(* let read_data_from_ram bus_low bus_port display=
 *   print "read_data_from_ram()";
 *   match display.selected_ram with
 *     | DDRam ->
 *       send bus_low bus_port (int_of_char (Ddram.read display)) display;
 *     | CGRam ->
 *       send bus_low bus_port (Cgram.read display) display;
 * ;; *)

let exec cs dc _rst display =
  (* if rst then clear display; *)
  match (cs,dc) with
    (false,false) -> display.mode <- Command

  | (false,true) -> display.mode <- Data
  | _ -> ()

(* let exec_8bit rs rw bus bus_port display =
 *   let bus_bit bit = ((1 lsl bit) land bus) <> 0 in
 *   match (rs, rw) with
 *     | (false, false) ->
 *       if bus = 0 then ()
 *       else if bus = 1 then clear display
 *       else if bus = 2 || bus = 3 then home display
 *       else if bus < 8 then
 *         entry_mode_set (bus_bit 1) (bus_bit 0) display
 *       else if bus < 16 then
 *         display_onoff_control (bus_bit 2) (bus_bit 1) (bus_bit 0) display
 *       else if bus < 32 then
 *         (if bus_bit 3 then
 *             cursor_or_display_shift true (not (bus_bit 2)) display;
 *          cursor_or_display_shift false (bus_bit 2)) display
 *       else if bus < 64 then
 *         function_set (bus_bit 4) (bus_bit 3) (bus_bit 2) display
 *       else if bus < 128 then
 *         set_cgram_address (bus land 0b111111) display
 *       else
 *         set_ddram_address (bus land 0b1111111) display
 *     | (false, true) -> read_busy_flag_and_address bus bus_port display
 *     | (true, false) -> write_data_to_ram bus display
 *     | (true, true) -> read_data_from_ram bus bus_port display
 * ;; *)

(* let exec_4bit =
 *   let mem_bus = ref (-1) in
 *   let old_rw = ref false in
 *   fun rs rw bus bus_port display ->
 *     if !old_rw <> rw then ( old_rw := rw ; mem_bus := -1 );
 *     if rw then (
 *       if !mem_bus = -1 then (
 *         mem_bus := 0;
 *         exec_8bit rs rw ((bus land 0x0F) lor 0xF0) bus_port display;
 *       ) else (
 *         mem_bus := -1;
 *         exec_8bit rs rw (bus land 0x0F) bus_port display;
 *       )
 *     ) else (
 *       let old_bus = !mem_bus in
 *       if old_bus = -1 then mem_bus := bus
 *       else (
 *         mem_bus := -1;
 *         exec_8bit rs rw ((old_bus land 0xF0) lor (bus lsr 4))
 *           bus_port display;
 *       )
 *     )
 * ;; *)


let register display =
  let handler () =
    let cs_val = Simul.test_pin display.cs in
    let dc_val = Simul.test_pin display.dc in
    let rst_val = Simul.test_pin display.rst in
    exec cs_val dc_val rst_val display
    (* match display.bus_mode with *)
      (* | Eight -> exec_8bit rs_val rw_val bus_val display.bus display; *)
      (* | Four -> exec_4bit rs_val rw_val bus_val display.bus display; *)
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
  in
  Simul.add_handler (Simul.Clear_pin_handler (display.cs, handler));
  Simul.add_handler (Simul.Set_pin_handler (display.dc, handler));
  Simul.add_handler (Simul.Write_port_handler (display.port, write_handler))
