module LCD(Simul : Simul.Simul) = struct
  open Simul

  module Types = struct
    type line_mode = One | Two
    type display_mode = On | Off
    type cursor_mode = Show | Hide | Blink
    type bus_mode = Eight | Four
    type direction = Left | Right
    type font = F5x8 | F5x11
    type ram = DDRam | CGRam

    type ddram = char array
    type cgram = bool array array array
    type matrix = bool array array array array

    type display = {
      x : int;
      y : int;
      e : [ `SIMUL ] pin;
      rs : [ `SIMUL ] pin;
      rw : [ `SIMUL ] pin;
      d4 : [ `SIMUL ] pin;
      d5 : [ `SIMUL ] pin;
      d6 : [ `SIMUL ] pin;
      d7 : [ `SIMUL ] pin;
      column_nb : int;
      line_nb : int;
      width : int;
      height : int;
      matrix : matrix;
      ddram : ddram;
      cgram : cgram;
      mutable ram_addr : int;
      mutable selected_ram : ram;
      mutable line_mode : line_mode;
      mutable cursor_mode : cursor_mode;
      mutable entry_mode_incr : direction;
      mutable shift_display : bool;
      mutable display_mode : display_mode;
      mutable font : font;
      mutable bus_mode : bus_mode;
    }

  end

  module CGROM = struct

    exception Parsing_error of string * int

    let file = Filename.concat Config.libdir "lcd_cgrom.txt"

    let parse () =
      let line_counter = ref 0 in
      let ic = open_in file in
      let input_line () = incr line_counter ; input_line ic in
      let error () = close_in ic ; raise (Parsing_error (file, !line_counter)) in
      let parse_5 () =
        let l = input_line () in
        if String.length l <> 5 then error ();
        Array.init 5 (fun i -> l.[i] = 'X');
      in
      let parse_5x8 () = Array.init 8 (fun _ -> parse_5 ()) in
      let parse_5x11 () = Array.init 11 (fun _ -> parse_5 ()) in
      let parse_sep () =
        let l = input_line () in
        if String.length l <> 32 then error ();
        for i = 0 to 31 do if l.[i] <> '#' then error () done;
      in
      let parse_space () =
        let l = input_line () in
        if String.length l <> 0 then error ();
      in
      let parse_section_5x8 () =
        parse_space ();
        parse_sep ();
        Array.init 16 (fun _ -> parse_space () ; parse_5x8 ())
      in
      let parse_section_5x11 () =
        parse_space ();
        parse_sep ();
        Array.init 16 (fun _ -> parse_space () ; parse_5x11 ())
      in
      let rec fold n f acc =
        if n = 0 then acc else fold (pred n) f (f () :: acc)
      in
      let lmm = fold 2 parse_section_5x11 (fold 14 parse_section_5x8 []) in
      close_in ic;
      Array.concat (List.rev lmm)
  end

  module CGRAM = struct
    open Types

    let create () = Array.init 8 (fun _ -> Array.make_matrix 8 5 false)

    let get_current_line display =
      let ascii_ind = (display.ram_addr lsr 3) land 0b111 in
      let line_ind = (display.ram_addr land 0b111) in
      display.cgram.(ascii_ind).(line_ind)

    let write n display =
      assert (display.selected_ram = CGRam);
      let line = get_current_line display in
      for i = 0 to 4 do
        line.(i) <- n land (1 lsl (4 - i)) <> 0
      done;
      display.ram_addr <- (display.ram_addr + 1) land 63

    let read display =
      assert (display.selected_ram = CGRam);
      let line = get_current_line display in
      let rec f i acc =
        if i = 5 then acc
        else if line.(i) then f (i + 1) (acc lor (1 lsl (5 - i)))
        else f (i + 1) acc
      in f 0 0
  end

  module DDRAM = struct
    open Types

    let cgrom = CGROM.parse ()

    let create () = Array.make 104 ' ';;

    let set_addr addr display =
      let new_addr =
        match display.line_mode with
        | One ->
          begin match addr with
            | -1 -> 79
            | 80 | 128 -> 0
            | _ -> addr
          end
        | Two ->
          begin match addr with
            | -1 -> 103
            | 40 -> 64
            | 104 | 128 -> 0
            | _ -> addr
          end
      in
      assert (new_addr >= 0 && new_addr < 128);
      display.ram_addr <- new_addr

    let incr_addr display = set_addr (display.ram_addr + 1) display

    let decr_addr display = set_addr (display.ram_addr - 1) display

    exception InvalidAddress

    let convert_addr display =
      let addr = display.ram_addr in
      assert (addr >= 0 && addr < 128);
      match display.line_mode with
      | One -> if addr < 80 then addr else raise InvalidAddress
      | Two ->
        if addr < 40 then addr
        else if addr < 64 then addr + 64 - 40
        else if addr < 104 then addr
        else if addr < 112 then addr - 104
        else if addr < 120 then addr - 112
        else addr - 120

    let write c display =
      try display.ddram.(convert_addr display) <- c;
      with InvalidAddress -> ()

    let read display =
      try display.ddram.(convert_addr display);
      with InvalidAddress -> ' '

    let fill c display =
      Array.fill display.ddram 0 (Array.length display.ddram) c

    let rotate_left display =
      let ddram = display.ddram in
      let ddram103 = ddram.(103) in
      for i = 102 downto 0 do
        ddram.(succ i) <- ddram.(i)
      done;
      ddram.(0) <- ddram103

    let rotate_right display =
      let ddram = display.ddram in
      let ddram0 = ddram.(0) in
      for i = 0 to 102 do
        ddram.(i) <- ddram.(succ i)
      done;
      ddram.(103) <- ddram0

    let set_two_line_mode b display =
      display.line_mode <- if b then Two else One

    let get_bitmap ind display =
      if ind < 8 then display.cgram.(ind)
      else cgrom.(ind)

    let to_matrix display =
      let ddram = display.ddram in
      let matrix = display.matrix in
      for i = 0 to 39 do
        matrix.(i).(0) <- get_bitmap (int_of_char ddram.(i)) display;
      done;
      if display.line_mode = Two then
        for i = 0 to 39 do
          matrix.(i).(1) <- get_bitmap (int_of_char ddram.(i + 64)) display;
        done
      else
        for i = 0 to 39 do
          matrix.(i).(1) <- get_bitmap (int_of_char ' ') display;
        done
  end

  module Display = struct
    open Graphics
    open Types

    let create_display x y e rs rw d4 d5 d6 d7 column_nb line_nb =
      let error() = failwith (Format.sprintf "invalid lcd size %dx%d" column_nb line_nb) in
      begin match line_nb with
        | 1 | 2 | 4 -> if column_nb <= 0 || column_nb * line_nb > 80 then error ()
        | _ -> error ()
      end;
      {
        x = x; y = y;
        e = e; rs = rs; rw = rw;
        d4 = d4;
        d5 = d5;
        d6 = d6;
        d7 = d7;
        column_nb = column_nb;
        line_nb = line_nb;
        width = 65 + 23 * column_nb;
        height = 65 + 34 * line_nb;
        matrix = Array.make_matrix 40 2 [|[||]|];
        cgram = CGRAM.create ();
        ddram = DDRAM.create ();
        selected_ram = DDRam;
        ram_addr = 0;
        line_mode = One;
        cursor_mode = Hide;
        entry_mode_incr = Right;
        shift_display = false;
        display_mode = On;
        font = F5x8;
        bus_mode = Eight;
      }

    let sync_display =
      let sync_mutex = Mutex.create () in
      let sync_check = ref false in
      let rec sync_thread () =
        begin try
            Thread.delay 0.1;
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

    let display_border display =
      let x = display.x in
      let y = display.y in
      let width = display.width in
      let height = display.height in
      set_color green;
      fill_rect x y width height;
      set_color black;
      fill_rect (x + 10) (y + 10) (width - 20) (height - 20);
      draw_rect (x-1) (y-1) (width+1) (height+1);
      set_color blue;
      fill_rect (x + 20) (y + 20) (width - 40) (height - 40)

    let display_char x y =
      let disp i j c =
        set_color (if c then white else blue);
        fill_rect (x + 4 * i) (y + 4 * (7 - j)) 2 2;
      in
      Array.iteri (fun j -> Array.iteri (fun i c -> disp i j c))

    let show display =
      let matrix = display.matrix in
      let height = display.height in
      let line_nb = display.line_nb in
      let column_nb = display.column_nb in
      let disp i j c =
        display_char (display.x + 36 + 23 * i) (display.y + height - 65 - 34 * j) c
      in
      display_border display;
      begin match line_nb with
        | 1 ->
          for i = 0 to pred column_nb do
            disp i 0 matrix.(i).(0)
          done
        | 2 ->
          for i = 0 to pred column_nb do
            disp i 0 matrix.(i).(0);
            disp i 1 matrix.(i).(1);
          done
        | 4 ->
          for i = 0 to pred column_nb do
            disp i 0 matrix.(i).(0);
            disp i 1 matrix.(i).(1);
            disp i 2 matrix.(i + 20).(0);
            disp i 3 matrix.(i + 20).(1);
          done
        | _ -> ()
      end;
      sync_display ()
  end

  module Proto = struct
    open Types
    open Format

    let verbose = true
    let print = if verbose then prerr_endline else (fun _ -> ())

    let refresh display =
      if display.display_mode = On then
        let addr = display.ram_addr in
        DDRAM.to_matrix display;
        begin match display.cursor_mode with
          | Hide -> ()
          | Show ->
            begin try
                let i = addr mod 64 in
                let j = addr / 64 in
                let old_m = display.matrix.(i).(j) in
                let m =
                  Array.init 8 (fun i -> Array.init 5 (fun j -> old_m.(i).(j)))
                in
                for j = 0 to 4 do
                  m.(7).(j) <- true;
                done;
                display.matrix.(i).(j) <- m;
              with Invalid_argument _ -> () end
          | Blink ->
            begin try
                let i = addr mod 64 in
                let j = addr / 64 in
                let old_m = display.matrix.(i).(j) in
                let m =
                  Array.init 8 (fun i -> Array.init 5 (fun j -> old_m.(i).(j)))
                in
                for j = 0 to 4 do
                  m.(0).(j) <- true;
                  m.(7).(j) <- true;
                done;
                for i = 1 to 6 do
                  m.(i).(0) <- true;
                  m.(i).(4) <- true;
                done;
                display.matrix.(i).(j) <- m;
              with Invalid_argument _ -> () end
        end;
        Display.show display

    let clear display =
      print "clear()";
      DDRAM.fill ' ' display;
      DDRAM.set_addr 0 display;
      refresh display

    let home display =
      print "home()";
      DDRAM.set_addr 0 display;
      refresh display

    let entry_mode_set id sh display =
      print (sprintf "entry_mode_set( I/D = %b , SH = %b )" id sh);
      display.entry_mode_incr <- if id then Right else Left;
      display.shift_display <- sh

    let display_onoff_control d c b display =
      print (sprintf "display_onoff_control( D = %b , C = %b , B = %b )" d c b);
      display.display_mode <- if d then On else Off;
      display.cursor_mode <- if c then if b then Blink else Show else Hide;
      refresh display

    let cursor_or_display_shift sc rl display =
      print (sprintf "cursor_or_display_shift( S/C = %b , R/L = %b )" sc rl);
      begin match (rl, sc) with
        | (true, false) -> DDRAM.incr_addr display;
        | (false, false) -> DDRAM.decr_addr display;
        | (false, true) -> DDRAM.rotate_left display;
        | (true, true) -> DDRAM.rotate_right display;
      end;
      refresh display

    let function_set dl n f display =
      print (sprintf "function_set( DL = %b , N = %b , F = %b )" dl n f);
      display.bus_mode <- if dl then Eight else Four;
      DDRAM.set_two_line_mode n display;
      display.font <- if f then F5x11 else F5x8

    let set_cgram_address addr display =
      print (sprintf "set_cgram_address(%02x)" addr);
      display.selected_ram <- CGRam;
      display.ram_addr <- addr

    let set_ddram_address addr display =
      print (sprintf "set_ddram_address(%02x)" addr);
      display.selected_ram <- DDRam;
      DDRAM.set_addr addr display;
      refresh display

    let send bus_low bus_register value display =
      Simul.write_register bus_register (
        match display.bus_mode with
        | Eight -> value
        | Four ->
          if bus_low > 0x0F then (bus_low land 0x0F) lor (value land 0xF0)
          else bus_low lor ((value lsl 4) land 0xF0)
      )

    let read_busy_flag_and_address bus_low bus_register display =
      print "read_busy_flag_and_address()";
      send bus_low bus_register (display.ram_addr) display

    let write_data_to_ram data display =
      print (sprintf "write_data_to_ram(%C = %d)" (char_of_int data) data);
      match display.selected_ram with
      | DDRam ->
        DDRAM.write (char_of_int data) display;
        cursor_or_display_shift display.shift_display
          (display.entry_mode_incr = Right) display;
      | CGRam ->
        CGRAM.write data display

    let read_data_from_ram bus_low bus_register display=
      print "read_data_from_ram()";
      match display.selected_ram with
      | DDRam ->
        send bus_low bus_register (int_of_char (DDRAM.read display)) display;
      | CGRam ->
        send bus_low bus_register (CGRAM.read display) display

    let exec_8bit rs rw bus display =
      print (sprintf "exec_8bit: %x" bus);
      (* let bus_register = Simul.REGISTERB in *)
      let bus_bit bit = ((1 lsl bit) land bus) <> 0 in
      match (rs, rw) with
      | (false, _) ->

        if bus = 0 then ()
        else if bus = 1 then clear display
        else if bus = 2 || bus = 3 then home display
        else if bus < 8 then
          entry_mode_set (bus_bit 1) (bus_bit 0) display
        else if bus < 16 then
          display_onoff_control (bus_bit 2) (bus_bit 1) (bus_bit 0) display
        else if bus < 32 then
          (if bus_bit 3 then
             cursor_or_display_shift true (not (bus_bit 2)) display;
           cursor_or_display_shift false (bus_bit 2)) display
        else if bus < 64 then
          function_set (bus_bit 4) (bus_bit 3) (bus_bit 2) display
        else if bus < 128 then
          set_cgram_address (bus land 0b111111) display
        else
          set_ddram_address (bus land 0b1111111) display
      | (true, false) -> write_data_to_ram bus display
      | _ -> ()

    let exec_4bit =
      let mem_bus = ref (-1) in
      fun rs rw bus display ->
        let old_bus = !mem_bus in
        if old_bus = -1 then mem_bus := bus
        else (
          mem_bus := -1;
          let new_bus = ((old_bus lsl 4) lor (bus )) in
          exec_8bit rs rw new_bus
            display;
        )

    let set_pin_handler display =
      let handler () =
        let rs_val = Simul.test_pin display.rs in
        let rw_val = Simul.test_pin display.rw in
        let d4_val = Simul.test_pin display.d4 in
        let d5_val = Simul.test_pin display.d5 in
        let d6_val = Simul.test_pin display.d6 in
        let d7_val = Simul.test_pin display.d7 in
        let d4_val = if d4_val then 0b0001 else 0b0 in
        let d5_val = if d5_val then 0b0010 else 0b0 in
        let d6_val = if d6_val then 0b0100 else 0b0 in
        let d7_val = if d7_val then 0b1000 else 0b0 in
        let bus = d4_val lor d5_val lor d6_val lor d7_val in
        (* match display.bus_mode with *)
        (* | Eight -> exec_8bit rs_val rw_val bus display; *)
        (* | Four -> *)
        exec_4bit rs_val rw_val bus display;
      in Simul.Set_pin_handler (display.e, handler)
  end
end
