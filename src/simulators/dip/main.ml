open Simul

type pin = port * int


module type MICRO = sig

  exception Error

  val name : string

  val pins_total : int

  val num_of_pin : pin -> int

  val pin_of_num : int -> (port * int)

  val name_of_num : int -> string

  val pin_of_an : int -> pin

  val char_of_port : port -> char

  val init_state_of_num : int -> bool

end


module Dip (M:MICRO ) = struct


  exception Error = M.Error

  let pins = Array.make (M.pins_total) ((0,0),false)
  let tris = Array.make (M.pins_total) true
  let mem_tris = Array.make (M.pins_total) false
  let vals = Array.make (M.pins_total) false
  let mem_vals = Array.make (M.pins_total) true

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
    pins.(i) <- ((x1, y1), M.init_state_of_num i);
    let x2 = (50 + M.pins_total / 4 * (pin_width + pin_space) ) in
    let y2 = y1 in
    Graphics.set_color Graphics.yellow;
    Graphics.fill_rect x2 y2 pin_width pin_height;
    Graphics.set_color Graphics.black;
    Graphics.draw_rect x2 y2 pin_width pin_height;
    pins.(M.pins_total-1 - i) <- ((x2, y2), M.init_state_of_num i)


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
   if i >= M.pins_total / 2 then
     (if not isin then r else l) (px + pin_width + pin_space) (py + 6)
   else
     (if not isin then l else r) (px - 10 - pin_space) (py + 6)

  let draw_name i p =
    let ((x,y),_) = p in
    let name = M.name_of_num i in
    if i < M.pins_total / 2 then
      Graphics.moveto (x+pin_width + pin_space + 15) (y)
    else
      Graphics.moveto (x-50) (y);
    Graphics.set_color Graphics.green;
    Graphics.draw_string (Printf.sprintf "%s " name );
    Graphics.set_color Graphics.black;
    try
      let (port, bit) = M.pin_of_num i in
      let c = M.char_of_port port in
      Graphics.set_color Graphics.white;
      if i < M.pins_total / 2 then
        Graphics.moveto (x+pin_width + pin_space) (y)
      else
        Graphics.moveto (x-15) (y);
      Graphics.draw_string (Printf.sprintf "%c%d" c bit);
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

  let change_arrows port value =
    for bit = 0 to 7 do
      try
        let n = M.num_of_pin (port, bit) in
        let ((x,y),_) = pins.(n) in
        pins.(n) <- ((x,y),value land (1 lsl bit) <> 0);
      with M.Error -> ()
    done;
    sync_display ()

   let draw_val pin isone =
     let ((px, py),_) = pins.(pin) in
     Graphics.set_color (if isone then Graphics.red else Graphics.yellow);
     Graphics.fill_rect (px) (py) pin_width pin_height;
     Graphics.set_color Graphics.black;
     Graphics.draw_rect (px) (py) pin_width pin_height

   let draw_vals port value =
     for bit = 0 to 7 do
       try
         let n = M.num_of_pin (port, bit) in
         draw_val n (value land (1 lsl bit) <> 0);
       with Error -> ()
     done;
     sync_display ()

   let draw_analog an value =
     let open Graphics in
     let ((px, py),_) = pins.(M.num_of_pin (M.pin_of_an (int_of_an an))) in
     let red_sz = ((pin_height - 1) * (value - 1) + (0x3FF - 1)) / (0x3FF - 1) in
     set_color red;
     for i = 0 to red_sz - 1 do
       moveto (px) (py+i);
       rlineto pin_width 0;
     done;
     set_color yellow;
     for i = red_sz to 10 do
       moveto (px) (py+i);
       rlineto pin_width 0;
     done;
     set_color black;
     draw_rect px py pin_width pin_height;
     sync_display ()


  let draw_micro () =
    Graphics.open_graph " ";
    let p = pin_width + pin_space in
    let q = pin_height + pin_space in
    Graphics.resize_window (M.pins_total / 4 * p + 100)  (M.pins_total / 2 * q + 100);
    let s = Printf.sprintf "Pin Simulator (%s)" M.name in
    Graphics.set_window_title s;
    (* Graphics.display_mode false; *)
    let grew = Graphics.rgb 200 200 200 in
    Graphics.set_color grew;
    Graphics.fill_rect 0 0 (M.pins_total / 4 * p + 100) (M.pins_total / 2 * q + 100);
    Graphics.set_color Graphics.black;
    Graphics.fill_rect 50 50 (M.pins_total / 4 * p) (M.pins_total / 2 * q);
    for i = 0 to (M.pins_total - 1) / 2 do draw_pin i done;
    Array.iteri (fun i pin -> draw_name i pin) pins;
    (* for i = 0 to M.pins_total - 1 do do_pin pins.(i) done; *)
    draw_arrows ();
    Graphics.synchronize ()

end

(* open Graphics *)


(* let pins = Array.make 44 (0, 0);;
 * let tris = Array.make 44 true;;
 * let mem_tris = Array.make 44 false;;
 * let vals = Array.make 44 false;;
 * let mem_vals = Array.make 44 true;;
 *
 * let grew = rgb 200 200 200;;
 * open_graph " 740x420";;
 * set_window_title "pin simulator";;
 * display_mode false;;
 * set_color grew;
 * fill_rect 0 0 770 420;;
 * set_color black;;
 * fill_rect 50 50 630 320;;
 * for i = 0 to 10 do
 *   let x1 = (100 + (508 * i) / 10) in
 *   let x2 = (100 + (508 * i) / 10) in
 *   let y1 = 38 in
 *   let y2 = 370 in
 *   draw_rect x1 y1 12 12;
 *   draw_rect x2 y2 12 12;
 *   pins.(i) <- (x1, y1);
 *   pins.(32-i) <- (x2, y2);
 * done;;
 * for i = 0 to 10 do
 *   let x2 = 38 in
 *   let x1 = 680 in
 *   let y1 = (100 + (220 * i) / 10) in
 *   let y2 = (100 + (220 * i) / 10) in
 *   draw_rect x1 y1 12 12;
 *   draw_rect x2 y2 12 12;
 *   pins.(i+11) <- (x1, y1);
 *   pins.(43-i) <- (x2, y2);
 *
 * done;;
 *   (* pins.(39-i) <- (x2, y2); *)
 * (* done;; *)
 * set_color (rgb 100 100 100);;
 * fill_circle 65 65 8;;
 * (* draw_circle 68 74 4;; *)
 * (* fill_circle 49 115 8;; *)
 * set_color white;;
 * moveto 330 200;
 * draw_string (Printf.sprintf "ATmega32U4");
 * for i = 0 to 43 do
 *   (try
 *     let (x, y) = pins.(i) in
 *     let (port, bit) = pin_of_num i in
 *     let c = char_of_port port in
 *     if i < 11 then moveto (x+1) (y + 16) else
 *     if i < 22 then moveto (x-17) y else
 *     if i < 33 then  moveto (x+1) (y - 16) else
 *       moveto (x+16) (y+1);
 *     draw_string (Printf.sprintf "%c%d" c bit);
 *   with Error -> ());
 *     try
 *       let (x, y) = pins.(i) in
 *       let name = name_of_num i in
 *       set_color green;
 *     if i < 11 then moveto (x-1) (y + 32) else
 *     if i < 22 then moveto (x-62) y else
 *     if i < 33 then  moveto (x-1) (y - 32) else
 *       moveto (x+32) (y+1);
 *       draw_string (Printf.sprintf "%s" name);
 *       set_color white;
 *     with Error -> () ;
 * done;; *)

(* let draw_plus pin dv dh =
 *   let (x, y) = pins.(pin) in
 *   draw_poly_line [| (x+3+dh, y+6+dv) ; (x+9+dh, y+6+dv) |];
 *   draw_poly_line [| (x+6+dh, y+3+dv) ; (x+6+dh, y+9+dv) |];
 * and draw_minus pin dv dh =
 *   let (x, y) = pins.(pin) in
 *   draw_poly_line [| (x+3+dh, y+6+dv) ; (x+9+dh, y+6+dv) |];
 * in
 * draw_plus 1 (16) 0;
 * draw_minus 4 (16) 0;
 * draw_plus 13 0 (-16);
 * draw_minus 14 0 (-16);
 * draw_plus 33 0 16;
 * draw_minus 34 0 16;
 * draw_plus 23 (-16) 0;
 * draw_minus 22 (-16) 0;
 * draw_minus 42 0 16;
 * draw_plus 43 0 16;
 * ;;
 *
 * let draw_arrow pin isin =
 *   let (px, py) = pins.(pin) in
 *   let r x y =
 *     draw_poly_line [| (x, y) ; (x+10, y) |];
 *     draw_poly_line [| (x+7, y-3) ; (x+10, y) ; (x+7, y+3) |];
 *   in
 *   let l x y =
 *     draw_poly_line [| (x, y) ; (x+10, y) |];
 *     draw_poly_line [| (x+3, y+3) ; (x, y) ; (x+3, y-3) |];
 *   in
 *   let t x y =
 *     draw_poly_line [| (x, y) ; (x, y+10) |];
 *     draw_poly_line [| (x-3, y+7) ; (x, y+10) ; (x+3, y+7) |];
 *   in
 *   let b x y =
 *     draw_poly_line [| (x, y) ; (x, y+10) |];
 *     draw_poly_line [| (x-3, y+3) ; (x, y) ; (x+3, y+3) |];
 *   in
 *   set_color grew;
 *   if pin < 11 then
 *     fill_rect px (py - 14) 9 12
 *   else if pin < 22 then
 *     fill_rect (px + 14) py 9 12
 *   else if pin < 33 then
 *     fill_rect px (py + 14) 9 12
 *   else
 *     fill_rect (px - 14) py 9 12;
 *   set_color black;
 *   if pin < 11 then
 *     (if not isin then t else b) (px + 6) (py - 13)
 *   else if pin < 22 then
 *     (if not isin then l else r) (px + 15) (py + 6)
 *   Else if pin < 33 then
 *     (if not isin then b else t) (px + 6) (py + 16)
 *   else
 *     (if not isin then r else l) (px - 15) (py + 6)
 * ;;
 *
 * let draw_val pin isone =
 *   let (px, py) = pins.(pin) in
 *   set_color (if isone then red else white);
 *   fill_rect (px+1) (py+1) 10 10;
 * ;;
 *
 * for i = 0 to 43 do
 *   match i with
 *     | 1 | 2 | 3 | 4 | 5 | 6 | 13 | 14| 33 | 34 | 23 | 22 | 41 |  42 | 43 -> ()
 *     | _ -> draw_arrow i false ; draw_val i false ;
 * done;;
 *
 * let sync_display =
 *   let sync_mutex = Mutex.create () in
 *   let sync_check = ref true in
 *   let rec sync_thread () =
 *     begin try
 *             Mutex.lock sync_mutex;
 *             let must_sync = !sync_check in
 *             sync_check := false;
 *             Mutex.unlock sync_mutex;
 *             if must_sync then synchronize ();
 *             Thread.delay 0.1;
 *       with _ -> () end;
 *     sync_thread ();
 *   in
 *   let _ = Thread.create sync_thread () in
 *   fun () ->
 *     Mutex.lock sync_mutex;
 *     sync_check := true;
 *     Mutex.unlock sync_mutex;
 * ;;
 *
 * sync_display ();;
 *
 * let draw_vals port value =
 *   for bit = 0 to 7 do
 *     try
 *       let n = num_of_pin (port, bit) in
 *       draw_val n (value land (1 lsl bit) <> 0);
 *     with Error -> ()
 *   done;
 *   sync_display ();
 * ;;
 *
 * let draw_arrows port value =
 *   for bit = 0 to 7 do
 *     try
 *       let n = num_of_pin (port, bit) in
 *       draw_arrow n (value land (1 lsl bit) <> 0);
 *     with Error -> ()
 *   done;
 *   sync_display ();
 * ;;
 *
 * let draw_analog_config analog_nb =
 *   for an = 0 to 12 do
 *     let pin = num_of_pin (pin_of_an an) in
 *     let (px, py) = pins.(pin) in
 *     let px = px + 4 and py = if pin < 20 then py - 27 else py + 27 in
 *     if an < analog_nb then (
 *       set_color black;
 *       moveto px py;
 *       draw_string "A";
 *     ) else (
 *       set_color grew;
 *       fill_rect px py 6 10;
 *     )
 *   done;
 *   sync_display ();
 * ;;
 *
 * let draw_analog an value =
 *   let (px, py) = pins.(num_of_pin (pin_of_an (int_of_an an))) in
 *   let red_sz = ((11 - 1) * (value - 1) + (0x3FF - 1)) / (0x3FF - 1) in
 *   set_color red;
 *   for i = 0 to red_sz - 1 do
 *     moveto (px+1) (py+1+i);
 *     rlineto 10 0;
 *   done;
 *   set_color white;
 *   for i = red_sz to 10 do
 *     moveto (px+1) (py+1+i);
 *     rlineto 10 0;
 *   done;
 *   sync_display ();
 * ;;
 *
 * while true do
 *   try
 *     let line = read_line () in
 *     try
 *       match input_of_string line with
 *       | IWrite (port, value) -> draw_vals port value;
 *       | ITris (port, value) -> draw_arrows port value;
 *       | IWriteAnalog (an, value) -> draw_analog an value;
 *       | IConfigAnalog cnt -> draw_analog_config cnt;
 *       | ISync -> print_endline (string_of_output ODone)
 *       | IStop -> exit 0
 *     with Error -> Printf.eprintf "Invalid command: %s\n%!" line
 *   with Graphic_failure _ -> Printf.eprintf "Graphical failure"; exit 0
 * done *)



module DipMicro = Dip(Atmega2560)

let _ =
  DipMicro.draw_micro ();
  while true do

      let line = read_line () in
      try
        match input_of_string line with
        | IWrite (port, value) ->
          DipMicro.draw_vals port value;
        | ITris (port, value) ->
          DipMicro.change_arrows port value
        | IWriteAnalog (an, value) ->
          DipMicro.draw_analog an value;
        | IConfigAnalog _cnt -> ()
          (* draw_analog_config cnt; *)
        | ISync -> print_endline (string_of_output ODone)
        | IStop -> exit 0
      with DipMicro.Error -> Printf.eprintf "Invalid command: %s\n%!" line

  done
