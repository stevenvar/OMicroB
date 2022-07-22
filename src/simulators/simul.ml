
(* Tools *)

let int_of_hex1 c =
  match c with
  | '0' .. '9' -> int_of_char c - int_of_char '0'
  | 'a' .. 'f' -> int_of_char c - int_of_char 'a' + 10
  | 'A' .. 'F' -> int_of_char c - int_of_char 'A' + 10
  | _ -> invalid_arg "Simul.int_of_hex1"
let int_of_hex2 c1 c0 =
  (int_of_hex1 c1 lsl 4) lor int_of_hex1 c0
;;

let int_of_hex3 c2 c1 c0 =
  (int_of_hex1 c2 lsl 8) lor (int_of_hex1 c1 lsl 4) lor int_of_hex1 c0
;;

(***)

module type MCUSimul = sig
  type 'a pin
  type register
  type bit
  type analog_channel

  val pin_of_string : string -> [ `SIMUL ] pin
  val analog_pin_of_string : string -> [ `AREAD | `SIMUL ] pin
  val name_of_pin : [ `SIMUL ] pin -> string
  val nb_pins : int

  val num_of_pin : [ `SIMUL ] pin -> int
  val pin_of_num : int -> [ `SIMUL ] pin option

  val spdr : register

  val register_of_char : char -> register
  val char_of_register : register -> char
  val register_of_index : int -> register
  val index_of_register : register -> int
  val nb_registers : int

  val index_of_bit : bit -> int
  val bit_of_index : int -> bit

  val register_of_pin : [ `SIMUL ] pin -> register
  val bit_of_pin : [ `SIMUL ] pin -> bit

  val pin_of_register_bit : register -> bit -> [ `SIMUL ] pin

  val analog_of_pin : [ `SIMUL | `AREAD ] pin -> analog_channel
  val pin_of_analog : analog_channel -> [< `SIMUL | `AREAD ] pin
  val int_of_analog : analog_channel -> int
  val analog_of_int : int -> analog_channel
end

module Simul(M : MCUSimul) = struct
  open M

  let string_of_analog an =
    name_of_pin (pin_of_analog an)

  let analog_of_string str =
    analog_of_pin (analog_pin_of_string str)

  (***)

  type input =
    | IWrite of register * int
    | ITris of register * int
    | IWriteAnalog of analog_channel * int
    | IConfigAnalog of int | ISync | IStop

  let input_of_string s =
    let error e = invalid_arg (Printf.sprintf "Simul.input_of_string : %s, %s" s (Printexc.to_string e)) in
    match s with
    | "SYNC" -> ISync
    | "STOP" -> IStop
    | _ ->
      try
        match s.[0] with
        | 'W' ->
          assert (String.length s = 4);
          IWrite  (register_of_index @@ (fun x -> int_of_char x - 1) @@ s.[1], int_of_hex2 s.[2] s.[3])
        | 'T' ->
          assert (String.length s = 4);
          ITris   (register_of_index @@ (fun x -> int_of_char x - 1) @@ s.[1], int_of_hex2 s.[2] s.[3])
        | 'Z' ->
          assert (String.length s = 5);
          IWriteAnalog (analog_of_int @@ (fun x -> int_of_char x - 1) @@ s.[1], int_of_hex3 s.[2] s.[3] s.[4])
        | 'C' ->
          assert (String.length s = 2);
          IConfigAnalog (int_of_hex1 s.[1])
        | _ -> error (Failure "First character")
      with e -> error e

  (***)

  type output =
    | OSet of [ `SIMUL ] pin
    | OClear of [ `SIMUL ] pin
    | OWrite of register * int
    | OWriteAnalog of analog_channel * int
    | ODone
    | OStop

  let index_of_pin p = index_of_bit @@ bit_of_pin @@ p

  let string_of_output output =
    match output with
    | OSet pin ->
      Printf.sprintf "S%c%d" (char_of_int (index_of_register (register_of_pin pin) + 1))
        (index_of_pin pin)
    | OClear pin ->
      Printf.sprintf "C%c%d" (char_of_int (index_of_register (register_of_pin pin) + 1))
        (index_of_pin pin)
    | OWrite (register, value) ->
      if value < 0 || value > 0xFF
      then failwith (Printf.sprintf "value %d of OWrite is out of range [ 0x0; 0xFF ]" value);
      Printf.sprintf "W%c%02X" (char_of_int (index_of_register register + 1)) value
    | OWriteAnalog (an, value) ->
      if value < 0 || value > 0x3FF
      then failwith (Printf.sprintf "value %d of OWriteAnalog is out of range [ 0x0; 0x3FF ]" value);
      Printf.sprintf "Z%c%03X" (char_of_int @@ (fun x -> int_of_analog x + 1) an) value
    | ODone -> "DONE"
    | OStop -> "STOP"
  ;;

  (***)

  let channel = Event.new_channel ();;

  let rec send_loop () =
    begin try
        let output = (Event.sync (Event.receive channel)) in
        print_string (string_of_output output);
        print_char '\n';
        flush stdout;
      with exn ->
        Printf.eprintf "Unhandled exception %s\n%!" (Printexc.to_string exn)
    end;
    send_loop ();
  in
  ignore (Thread.create send_loop ());
  ;;

  let send output = Event.sync (Event.send channel output);;

  (***)

  type handler =
    | Exit_handler of (unit -> unit)
    | Write_handler of (register -> int -> unit)
    | Write_register_handler of register * (int -> unit)
    | Tris_handler of (register -> int -> unit)
    | Tris_register_handler of register * (int -> unit)
    | Set_handler of ([ `SIMUL ] pin -> unit)
    | Clear_handler of ([ `SIMUL ] pin -> unit)
    | Change_handler of ([ `SIMUL ] pin -> bool -> unit)
    | Set_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Clear_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Change_pin_handler of [ `SIMUL ] pin * (bool -> unit)
    | Setin_handler of ([ `SIMUL ] pin -> unit)
    | Setout_handler of ([ `SIMUL ] pin -> unit)
    | Setstate_handler of ([ `SIMUL ] pin -> bool -> unit)
    | Setin_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Setout_pin_handler of [ `SIMUL ] pin * (unit -> unit)
    | Setstate_pin_handler of [ `SIMUL ] pin * (bool -> unit)
    | Write_analog_handler of (analog_channel -> int -> unit)
    | Write_an_analog_handler of analog_channel * (int -> unit)
    | Config_analogs_handler of (int -> unit)

  let handlers_mutex = Mutex.create ();;
  let handlers = ref [];;

  let add_handler handler =
    Mutex.lock handlers_mutex;
    handlers := handler :: !handlers;
    Mutex.unlock handlers_mutex;
  ;;

  let remove_handler handler =
    Mutex.lock handlers_mutex;
    handlers := List.filter ((!=) handler) !handlers;
    Mutex.unlock handlers_mutex;

  ;;

  (***)

  let registers = Array.make nb_registers 0;;
  let triss = Array.make nb_registers 0xFF;;
  let analogs = Array.make 13 0;;
  let analog_cnt = ref 0;;

  let scall1 f arg =
    try Printexc.print f arg with _ -> ();
  ;;

  let scall2 f arg1 arg2 =
    try Printexc.print (Printexc.print f arg1) arg2 with _ -> ();
  ;;

  let pin_of_register_index register bit =
    pin_of_register_bit register (bit_of_index bit)

  let exec input =
    match input with
    | IWrite (register, new_value) ->
      (* let s = Printf.sprintf "register %s = %d" (string_of_register register) new_value in *)
      (* if true then failwith s; *)
      assert (new_value >= 0 && new_value <= 255);
      let index = index_of_register register in
      let old_value = registers.(index) in
      let lxor_values = old_value lxor new_value in
      let set_pins = ref [] in
      let clear_pins = ref [] in
      let () =
        for i = 0 to 7 do
          let mask = 1 lsl i in
          if lxor_values land mask <> 0 then
            if old_value land mask <> 0 then
              clear_pins := pin_of_register_index register i :: !clear_pins
            else
              set_pins := pin_of_register_index register i :: !set_pins
        done;
      in
      let set_pins = !set_pins in
      let clear_pins = !clear_pins in
      let call h =
        match h with
        | Write_handler f -> scall2 f register new_value;
        | Write_register_handler (p, f) -> if p = register then scall1 f new_value;
        | Set_handler f -> List.iter (scall1 f) set_pins;
        | Clear_handler f -> List.iter (scall1 f) clear_pins;
        | Change_handler f ->
          List.iter (fun p -> scall2 f p true) set_pins;
          List.iter (fun p -> scall2 f p false) clear_pins;
        | Set_pin_handler (p, f) ->
          List.iter (fun q -> if p = q then scall1 f ()) set_pins;
        | Clear_pin_handler (p, f) ->
          List.iter (fun q -> if p = q then scall1 f ()) clear_pins;
        | Change_pin_handler (p, f) ->
          List.iter (fun q -> if p = q then scall1 f true) set_pins;
          List.iter (fun q -> if p = q then scall1 f false) clear_pins;
        | _ -> ()
      in
      registers.(index) <- new_value;
      List.iter call !handlers;
      true
    | ITris (register, new_value) ->
      assert (new_value >= 0 && new_value <= 0xFF);
      let index = index_of_register register in
      let old_value = registers.(index) in
      let lxor_values = old_value lxor new_value in
      let new_in_pins = ref [] in
      let new_out_pins = ref [] in
      let () =
        for i = 0 to 7 do
          let mask = 1 lsl i in
          if lxor_values land mask <> 0 then
            if old_value land mask <> 0 then
              new_out_pins := pin_of_register_index register i :: !new_out_pins
            else
              new_in_pins := pin_of_register_index register i :: !new_in_pins
        done;
      in
      let new_in_pins = !new_in_pins in
      let new_out_pins = !new_out_pins in
      let call h =
        match h with
        | Tris_handler f -> scall2 f register new_value;
        | Tris_register_handler (p, f) -> if p = register then scall1 f new_value;
        | Setin_handler f -> List.iter (scall1 f) new_in_pins;
        | Setout_handler f -> List.iter (scall1 f) new_out_pins;
        | Setstate_handler f ->
          List.iter (fun p -> scall2 f p true) new_in_pins;
          List.iter (fun p -> scall2 f p false) new_out_pins;
        | Setin_pin_handler (p, f) ->
          List.iter (fun q -> if p = q then scall1 f ()) new_in_pins;
        | Setout_pin_handler (p, f) ->
          List.iter (fun q -> if p = q then scall1 f ()) new_out_pins;
        | Setstate_pin_handler (p, f) ->
          List.iter (fun q -> if p = q then scall1 f true) new_in_pins;
          List.iter (fun q -> if p = q then scall1 f false) new_out_pins;
        | _ -> ()
      in
      triss.(index) <- new_value;
      List.iter call !handlers;
      true
    | IWriteAnalog (an, value) ->
      assert (value >= 0 && value <= 0x3FF);
      analogs.(int_of_analog an) <- value;
      List.iter (fun handler -> match handler with
          | Write_analog_handler f -> f an value
          | Write_an_analog_handler (an', f) when an' = an -> f value
          | _ -> ()
        ) !handlers;
      true
    | IConfigAnalog cnt ->
      assert (cnt >= 0 && cnt <= 13);
      analog_cnt := cnt;
      List.iter (fun handler -> match handler with
          | Config_analogs_handler f -> f cnt
          | _ -> ()
        ) !handlers;
      true
    | ISync -> send ODone; true
    | IStop ->
      let call h = match h with Exit_handler f -> scall1 f () | _ -> () in
      List.iter call !handlers;
      false
  ;;

  (***)

  let (start, join) =
    let rec receive_loop () =
      let s = read_line () in
      match
        try Some (input_of_string s)
        with Invalid_argument _ ->
          Printf.eprintf "Invalid instruction: `%s'\n%!" s;
          None
      with
      | Some input -> if exec input then receive_loop ();
      | None -> receive_loop ();
    in
    let loop_thread_mutex = Mutex.create () in
    let loop_thread = ref None in
    let start () =
      Mutex.lock loop_thread_mutex;
      match !loop_thread with
      | Some _ ->
        Mutex.unlock loop_thread_mutex;
        failwith "invalid call to Simul.start, simulator already running";
      | None ->
        loop_thread := Some (Thread.create receive_loop ());
        Mutex.unlock loop_thread_mutex;
    and join () =
      Mutex.lock loop_thread_mutex;
      match !loop_thread with
      | None ->
        Mutex.unlock loop_thread_mutex;
        failwith "invalid call to Simul.join, simulator is not running";
      | Some th ->
        Mutex.unlock loop_thread_mutex;
        Thread.join th;
    in
    (start, join)
  ;;

  (***)

  let write_register register value =
    send (OWrite (register, value mod 256));;

  let set_pin pin = send (OSet pin);;

  let clear_pin pin = send (OClear pin);;

  let change_pin pin b = send (if b then OSet pin else OClear pin);;

  let write_analog an value = send (OWriteAnalog (an, value));;

  let read_register register = registers.(index_of_register register);;

  let read_tris register = triss.(index_of_register register);;

  let test_pin pin =
    try
      let value = registers.(index_of_register (register_of_pin pin)) in
      let mask = 1 lsl (index_of_pin pin) in
      (value land mask) <> 0
    with _ -> invalid_arg "test_pin"
  ;;

  let state_pin pin =
    try
      let value = triss.(index_of_register (register_of_pin pin)) in
      let mask = 1 lsl (index_of_pin pin) in
      (value land mask) <> 0
    with _ -> invalid_arg "state_pin"
  ;;

  let analog_input_count () =
    !analog_cnt
  ;;

end
