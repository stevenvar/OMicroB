module Dip (M: Simul.MCUSimul) = struct
  exception Error

  let num_of_pin : type a. a M.pin -> int = Obj.magic (* I know *)
  let pin_of_num : int -> [ `DWRITE ] M.pin = Obj.magic

  let pins = Array.make (M.nb_pins) ((0,0),false)
  let tris = Array.make (M.nb_pins) true
  let mem_tris = Array.make (M.nb_pins) false
  let vals = Array.make (M.nb_pins) false
  let mem_vals = Array.make (M.nb_pins) true

  let pin_width = 10
  let pin_height = 10
  let pin_space = 3

  let do_pin _p = ()

  let draw_pin i =
    let y1 = (50 + (i*(pin_height+pin_space))) in
    let x1 = 50-pin_width in
    Graphics.set_color Graphics.yellow;
    Graphics.fill_rect x1 y1 pin_width pin_height;
    Graphics.set_color Graphics.black;
    Graphics.draw_rect x1 y1 pin_width pin_height;
    pins.(i) <- ((x1, y1), false);
    let x2 = (50 + M.nb_pins / 4 * (pin_width + pin_space) ) in
    let y2 = y1 in
    Graphics.set_color Graphics.yellow;
    Graphics.fill_rect x2 y2 pin_width pin_height;
    Graphics.set_color Graphics.black;
    Graphics.draw_rect x2 y2 pin_width pin_height;
    pins.(M.nb_pins-1 - i) <- ((x2, y2), false)


  let draw_arrow i pin =
    let ((px, py), isin) = pin in
   let r x y =
     Graphics.draw_poly_line [| (x, y) ; (x+10, y) |];
     Graphics.draw_poly_line [| (x+7, y-3) ; (x+10, y) ; (x+7, y+3) |];
   in
   let l x y =
     Graphics.draw_poly_line [| (x, y) ; (x+10, y) |];
     Graphics.draw_poly_line [| (x+3, y+3) ; (x, y) ; (x+3, y-3) |];
   in
   if i >= M.nb_pins / 2 then
     (if not isin then r else l) (px + pin_width + pin_space) (py + 6)
   else
     (if not isin then l else r) (px - 10 - pin_space) (py + 6)

  let draw_name i p =
    let ((x,y),_) = p in
    let name = M.name_of_pin i in
    if (num_of_pin i) < M.nb_pins / 2 then
      Graphics.moveto (x+pin_width + pin_space + 20) (y)
    else
      Graphics.moveto (x-(String.length name)*6-25) (y);
    Graphics.set_color Graphics.green;
    Graphics.draw_string (Printf.sprintf "%s " name );
    Graphics.set_color Graphics.black;
    try
      let register = M.register_of_pin i and bit = M.bit_of_pin i in
      let c = M.char_of_register register in
      Graphics.set_color Graphics.white;
      if (num_of_pin i) < M.nb_pins / 2 then
        Graphics.moveto (x+pin_width + pin_space) (y)
      else
        Graphics.moveto (x-15) (y);
      Graphics.draw_string (Printf.sprintf "%c%d" c (M.index_of_bit bit));
      Graphics.set_color Graphics.black
    with _ -> ()

  let sync_display =
    let sync_mutex = Mutex.create () in
    let sync_check = ref true in
    let rec sync_thread () =
      begin try
          Mutex.lock sync_mutex;
          let must_sync = !sync_check in
          sync_check := false;
          Mutex.unlock sync_mutex;
          if must_sync then Graphics.synchronize ();
          Thread.delay 0.1;
        with _ -> () end;
      sync_thread ();
    in
    let _ = Thread.create sync_thread () in
    fun () ->
      Mutex.lock sync_mutex;
      sync_check := true;
      Mutex.unlock sync_mutex

  let draw_arrows () =
    Array.iteri (fun i pin -> draw_arrow i pin ) pins

  let change_arrows register value =
    for bit = 0 to 7 do
      try
        let n = num_of_pin (M.pin_of_register_bit register (M.bit_of_index bit)) in
        let ((x,y),_) = pins.(n) in
        pins.(n) <- ((x,y),value land (1 lsl bit) <> 0);
      with _ -> ()
    done;
    sync_display ()

   let draw_val pin isone =
     let ((px, py),_) = pins.(pin) in
     Graphics.set_color (if isone then Graphics.red else Graphics.yellow);
     Graphics.fill_rect (px) (py) pin_width pin_height;
     Graphics.set_color Graphics.black;
     Graphics.draw_rect (px) (py) pin_width pin_height

   let draw_vals register value =
     for bit = 0 to 7 do
       try
         let n = num_of_pin (M.pin_of_register_bit register (M.bit_of_index bit)) in
         draw_val n (value land (1 lsl bit) <> 0);
       with _ -> ()
     done;
     sync_display ()

   let draw_analog _an _value = () (* TODO *)
   (*   let open Graphics in *)
   (*   let ((px, py),_) = pins.(num_of_pin (M.pin_of_an (int_of_an an))) in *)
   (*   let red_sz = ((pin_height - 1) * (value - 1) + (0x3FF - 1)) / (0x3FF - 1) in *)
   (*   set_color red; *)
   (*   for i = 0 to red_sz - 1 do *)
   (*     moveto (px) (py+i); *)
   (*     rlineto pin_width 0; *)
   (*   done; *)
   (*   set_color yellow; *)
   (*   for i = red_sz to 10 do *)
   (*     moveto (px) (py+i); *)
   (*     rlineto pin_width 0; *)
   (*   done; *)
   (*   set_color black; *)
   (*   draw_rect px py pin_width pin_height; *)
   (*   sync_display () *)


  let draw_micro () =
    Graphics.open_graph " ";
    let p = pin_width + pin_space in
    let q = pin_height + pin_space in
    Graphics.resize_window (M.nb_pins / 4 * p + 100)  (M.nb_pins / 2 * q + 100);
    let s = Printf.sprintf "Pin Simulator" in
    Graphics.set_window_title s;
    (* Graphics.display_mode false; *)
    let grew = Graphics.rgb 200 200 200 in
    Graphics.set_color grew;
    Graphics.fill_rect 0 0 (M.nb_pins / 4 * p + 100) (M.nb_pins / 2 * q + 100);
    Graphics.set_color Graphics.black;
    Graphics.fill_rect 50 50 (M.nb_pins / 4 * p) (M.nb_pins / 2 * q);
    for i = 0 to (M.nb_pins - 1) / 2 do draw_pin i done;
    Array.iteri (fun i pin -> draw_name (pin_of_num i) pin) pins;
    (* for i = 0 to M.nb_pins - 1 do do_pin pins.(i) done; *)
    draw_arrows ();
    Graphics.synchronize ()

end

let usage =
  Printf.sprintf "Usage: %s [-device=DEVICE] <circuit.txt>\n%!"
    Sys.argv.(0)

let print_usage () =
  Printf.eprintf "%s" usage;
  exit 1

let set n x v =
  match !x with
    | None -> x := Some v
    | Some _ -> failwith (Printf.sprintf "%s already defined" n)

let get n x =
  match !x with
    | None -> failwith (Printf.sprintf "%s undefined" n)
    | Some v -> v

let device = ref None

let get_device () : (module Simul.MCUSimul) =
  (get "device" device) |> Simul_config.get_config

let spec = Arg.align ([
    ("-device", Arg.String (set "device" device), "set the used device");
  ])

let _ =
  Arg.parse spec (fun _ -> ()) usage;

  try
    let (module M) = get_device () in
    let open Simul.Simul(M) in
    let open Dip(M) in

    draw_micro ();
    while true do

      let line = read_line () in
      try
        match input_of_string line with
        | IWrite (register, value) ->
          draw_vals register value;
        | ITris (register, value) ->
          change_arrows register value
        | IWriteAnalog (an, value) ->
          draw_analog an value;
        | IConfigAnalog _cnt -> ()
        (* draw_analog_config cnt; *)
        | ISync -> print_endline (string_of_output ODone)
        | IStop -> exit 0
      with Error -> Printf.eprintf "Invalid command: %s\n%!" line
    done
  with Failure msg ->
    Printf.eprintf "Error: %s\n%!" msg;
    print_usage ()
