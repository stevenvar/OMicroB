module LCD(Simul : Simul.Simul) = struct
  open Simul

  module Types = struct
    type ddram = int array

    type cgram = bool array array array
    type matrix = bool array array

    type mode = Data | Command

    type display = {
      x : int;
      y : int;
      cs : [ `SIMUL ] pin;
      dc : [ `SIMUL ] pin;
      rst : [ `SIMUL ] pin;
      register : register;
      column_nb : int;
      line_nb : int;
      width : int;
      height : int;
      matrix : matrix;
      ddram : ddram;
      mutable mode : mode;
      mutable current_col : int;
      mutable current_page : int;
      mutable min_col : int;
      mutable max_col : int;
      mutable min_page : int;
      mutable max_page : int;
      (* cgram : cgram; *)
      (* mutable ram_addr : int;
       * mutable selected_ram : ram;
       * mutable line_mode : line_mode;
       * mutable cursor_mode : cursor_mode;
       * mutable entry_mode_incr : direction;
       * mutable shift_display : bool;
       * mutable display_mode : display_mode; *)
    }

    type line_mode = One | Two
    type display_mode = On | Off
    type cursor_mode = Show | Hide | Blink
    type bus_mode = Eight | Four
    type direction = Left | Right
    type font = F5x8 | F5x11
    type ram = DDRam | CGRam
  end

  module DDRAM = struct
    open Types

    let size = 128 * 8

    let create () = Array.make size 0

    let fill c display =
      Array.fill display.ddram 0 (Array.length display.ddram) c

    let translate_position col page display =
      page * display.width + col

    let write, set_line, set_column_low, set_column_high =
      let i = ref 0 in
      let write c display =
        (* if c <> 0 then *)
        (* Printf.printf "i = %d , c = %d " !i c; *)
        display.ddram.(!i) <- c;
        incr i;
        i := !i mod size
      and set_line n =
        i := (!i land 0x007F) lor (n lsl 7);
      and set_column_low n =
        i := (!i land 0xFFF0) lor n;
      and set_column_high n =
        i := (!i land 0xFF8F) lor ((n land 0x07) lsl 4) in
      write, set_line, set_column_low, set_column_high

    let to_matrix (display:display) =
      let ddram = display.ddram in
      let matrix = display.matrix in
      for i = 0 to size - 1 do
        let col = i mod 128 in (* 128 is col 0 *)
        let row = (i / 128) * 8 in (* 128 is row 8 *)
        (* Probably shoudn't be hard-coded this way but there's no time ..  *)
        try
          matrix.(col).(row+0) <- ddram.(i) land 0b00000001 = 0b00000001;
          matrix.(col).(row+1) <- ddram.(i) land 0b00000010 = 0b00000010;
          matrix.(col).(row+2) <- ddram.(i) land 0b00000100 = 0b00000100;
          matrix.(col).(row+3) <- ddram.(i) land 0b00001000 = 0b00001000;
          matrix.(col).(row+4) <- ddram.(i) land 0b00010000 = 0b00010000;
          matrix.(col).(row+5) <- ddram.(i) land 0b00100000 = 0b00100000;
          matrix.(col).(row+6) <- ddram.(i) land 0b01000000 = 0b01000000;
          matrix.(col).(row+7) <- ddram.(i) land 0b10000000 = 0b10000000;
        with _ -> failwith "to_matrix"
      done

    let print_ddram display =
      let oc = open_out "ddram.txt" in
      for i = 0 to size - 1 do
        Printf.fprintf oc "%d" display.ddram.(i)
      done;
      close_out oc

    let print_matrix display =
      let oc = open_out "matrix.txt" in
      let char_of_bool = function
        | true  -> '#'
        | false -> '_'
      in
      let matrix = display.matrix in
      for i = 0 to display.height - 1 do
        for j = 0 to display.width - 1 do
          Printf.fprintf oc "%c" (char_of_bool matrix.(j).(i))
        done;
        Printf.fprintf  oc "\n"
      done;
      close_out oc
  end

  module Display = struct
    open Graphics
    open Types

    let create_display x y cs dc rst column_nb line_nb =
      {
        x = x;
        y = y;
        cs = cs;
        dc = dc;
        rst = rst;
        register = spdr;
        column_nb = column_nb;
        line_nb = line_nb;
        width = column_nb;
        height = 8 * line_nb;
        current_col = 0;
        current_page = 0;
        min_page = 0;
        max_page = line_nb-1;
        min_col = 0;
        max_col = column_nb-1;
        matrix = Array.make_matrix column_nb (8*line_nb) false;
        ddram = DDRAM.create ();
        mode = Command
      }

    let sync_display =
      let sync_mutex = Mutex.create () in
      let sync_check = ref false in
      let rec sync_thread () =
        begin
          try
            Thread.delay 0.01;
            Mutex.lock sync_mutex;
            let must_sync = !sync_check in
            sync_check := false;
            Mutex.unlock sync_mutex;
            if must_sync then synchronize ();
          with exn ->
            Printf.eprintf "Unhandled exception %s\n%!" (Printexc.to_string exn)
        end;
        sync_thread ();
      in
      let _ = Thread.create sync_thread () in
      fun () ->
        Mutex.lock sync_mutex;
        sync_check := true;
        Mutex.unlock sync_mutex

    let set_pixel x y display =
      let y = (display.height - 1) - y in (* must invert because of Graphics y positions ... *)
      (* in the physical screen, pixels are white when on *)
      set_color white;
      (* Format.printf "X = %d ; Y = %d \n" (x) (y); *)
      fill_rect (display.x+x*2) (display.y+y*2) 1 1

    let clear_pixel _x _y =
      set_color black; ()

    let show display =
      (* Graphics.clear_graph (); *)
      let matrix = display.matrix in
      let height = display.height in
      let width = display.width in
      set_color black;
      Graphics.fill_rect display.x display.y (width*2) (height*2);
      let disp i j v =
        match v with
        | true -> set_pixel i j display
        | false -> ()
      in
      begin try
          for i = 0 to width - 1 do
            for j = 0 to height - 1 do
              disp i j matrix.(i).(j)
            done
          done;
        with _ -> failwith "show"
      end;
      sync_display ()
  end

  module Proto = struct
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
                DDRAM.to_matrix display;
                (* Ddram.print_matrix display; *)
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
      print (Format.sprintf "write_data_to_ram(%C)" (char_of_int data));
      DDRAM.write data display

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
                  | '\x00' .. '\x0F' -> DDRAM.set_column_low i
                  | '\x10' .. '\x1F' -> DDRAM.set_column_high (i - 0x10)
                  | '\xB0' .. '\xB7' -> DDRAM.set_line (i - 0xB0)
                  | _ -> Printf.eprintf "Warning (LCD): unknown command: 0x%02x\n%!" i
                )
            ) in

      Simul.add_handler (Simul.Clear_pin_handler (display.cs, handler));
      Simul.add_handler (Simul.Set_pin_handler (display.dc, handler));
      Simul.add_handler (Simul.Write_register_handler (display.register, write_handler))
  end
end
