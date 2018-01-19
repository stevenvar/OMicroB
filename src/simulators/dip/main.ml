(*************************************************************************)
(*                                                                       *)
(*                                OCaPIC                                 *)
(*                                                                       *)
(*                             Benoit Vaugon                             *)
(*                                                                       *)
(*    This file is distributed under the terms of the CeCILL license.    *)
(*    See file ../../../LICENSE-en.                                      *)
(*                                                                       *)
(*************************************************************************)

open Graphics;;
open Simul;;

exception Error;;

type pin = port * int

let num_of_pin pin =
  match pin with
  | (PORTE, 6) -> 0
  | (PORTB, 0) -> 7
  | (PORTB, 1) -> 8
  | (PORTB, 2) -> 9
  | (PORTB, 3) -> 10
  | (PORTB, 7) -> 11
  | (PORTD, 0) -> 17
  | (PORTD, 1) -> 18
  | (PORTD, 2) -> 19
  | (PORTD, 3) -> 20
  | (PORTD, 5) -> 21
  | (PORTD, 4) -> 24
  | (PORTD, 6) -> 25
  | (PORTD, 7) -> 26
  | (PORTB, 4) -> 27
  | (PORTB, 5) -> 28
  | (PORTB, 6) -> 29
  | (PORTC, 6) -> 30
  | (PORTC, 7) -> 31
  | (PORTE, 2) -> 32
  | (PORTF, 7) -> 35
  | (PORTF, 6) -> 36
  | (PORTF, 5) -> 37
  | (PORTF, 4) -> 38
  | (PORTF, 1) -> 39
  | (PORTF, 0) -> 40
  | _ -> raise Error
;;

let pin_of_num num =
  match num with
    0 -> (PORTE,6)
  | 7 -> (PORTB,0)
  | 8 -> (PORTB,1)
  | 9 -> (PORTB,2)
  | 10 -> (PORTB,3)
  | 11 -> (PORTB, 7) 
  | 17 -> (PORTD, 0) 
  | 18 -> (PORTD, 1) 
  | 19 -> (PORTD, 2) 
  | 20 -> (PORTD, 3) 
  | 21 -> (PORTD, 5)
  | 24 -> (PORTD, 4) 
  | 25 -> (PORTD, 6)
  | 26 -> (PORTD, 7)
  | 27 -> (PORTB, 4) 
  | 28 -> (PORTB, 5) 
  | 29 -> (PORTB, 6) 
  | 30 -> (PORTC, 6) 
  | 31 -> (PORTC, 7) 
  | 32 -> (PORTE, 2)
  | 35 -> (PORTF, 7) 
  | 36 -> (PORTF, 6) 
  | 37 -> (PORTF, 5) 
  | 38 -> (PORTF, 4) 
  | 39 -> (PORTF, 1) 
  | 40 -> (PORTF, 0) 
  | _ -> raise Error
;;

let pin_of_an an = match an with
  | 5 -> (PORTE, 0) |  6 -> (PORTE, 1) |  7 -> (PORTE, 2)
  |  8 -> (PORTB, 2) | 9 -> (PORTB, 3) | 10 -> (PORTB, 1) | 11 -> (PORTB, 4)
  | 12 -> (PORTB, 0) | _ -> raise Error
;;

let pins = Array.make 44 (0, 0);;
let tris = Array.make 44 true;;
let mem_tris = Array.make 44 false;;
let vals = Array.make 44 false;;
let mem_vals = Array.make 44 true;;

let grew = rgb 200 200 200;;
open_graph " 430x430";;
set_window_title "pin simulator";;
display_mode false;;
set_color grew;
fill_rect 0 0 430 430;;
set_color black;;
fill_rect 50 50 320 320;;
for i = 0 to 10 do
  let x1 = (78 + (254 * i) / 10) in
  let x2 = (78 + (254 * i) / 10) in
  let y1 = 38 in
  let y2 = 370 in
  draw_rect x1 y1 12 12;
  draw_rect x2 y2 12 12;
  pins.(i) <- (x1, y1);
  pins.(32-i) <- (x2, y2);
done;;
for i = 0 to 10 do
  let x2 = 38 in
  let x1 = 370 in
  let y1 = (78 + (254 * i) / 10) in
  let y2 = (78 + (254 * i) / 10) in
  draw_rect x1 y1 12 12;
  draw_rect x2 y2 12 12;
  pins.(i+11) <- (x1, y1);
  pins.(43-i) <- (x2, y2);
  
done;;
  (* pins.(39-i) <- (x2, y2); *)
(* done;; *)
set_color (rgb 100 100 100);;
fill_circle 85 85 8;;
(* draw_circle 68 74 4;; *)
(* fill_circle 49 115 8;; *)
set_color white;;
moveto 180 210;
draw_string (Printf.sprintf "ATmega32U4");
for i = 0 to 43 do
  try
    let (x, y) = pins.(i) in
    let (port, bit) = pin_of_num i in
    let c = char_of_port port in
    if i < 11 then moveto (x+1) (y + 16) else
    if i < 22 then moveto (x-17) y else
    if i < 33 then  moveto (x+1) (y - 16) else
      moveto (x+16) (y+1);
     
    draw_string (Printf.sprintf "%c%d" c bit);
  with Error -> ()
done;;

let draw_plus pin dv dh =
  let (x, y) = pins.(pin) in
  draw_poly_line [| (x+3+dh, y+6+dv) ; (x+9+dh, y+6+dv) |];
  draw_poly_line [| (x+6+dh, y+3+dv) ; (x+6+dh, y+9+dv) |];
and draw_minus pin dv dh =
  let (x, y) = pins.(pin) in
  draw_poly_line [| (x+3+dh, y+6+dv) ; (x+9+dh, y+6+dv) |];
in
draw_plus 1 (16) 0;
draw_minus 4 (16) 0;
draw_plus 13 0 (-16);
draw_minus 14 0 (-16);
draw_plus 33 0 16;
draw_minus 34 0 16;
draw_plus 23 (-16) 0;
draw_minus 22 (-16) 0;
draw_minus 42 0 16;
draw_plus 43 0 16;
;;

let draw_arrow pin isin =
  let (px, py) = pins.(pin) in
  let r x y =
    draw_poly_line [| (x, y) ; (x+10, y) |];
    draw_poly_line [| (x+7, y-3) ; (x+10, y) ; (x+7, y+3) |];
  in
  let l x y =
    draw_poly_line [| (x, y) ; (x+10, y) |];
    draw_poly_line [| (x+3, y+3) ; (x, y) ; (x+3, y-3) |];
  in
  let t x y =
    draw_poly_line [| (x, y) ; (x, y+10) |];
    draw_poly_line [| (x-3, y+7) ; (x, y+10) ; (x+3, y+7) |];
  in
  let b x y =
    draw_poly_line [| (x, y) ; (x, y+10) |];
    draw_poly_line [| (x-3, y+3) ; (x, y) ; (x+3, y+3) |];
  in
  set_color grew;
  if pin < 11 then
    fill_rect px (py - 14) 9 12
  else if pin < 22 then
    fill_rect (px + 14) py 9 12
  else if pin < 33 then
    fill_rect px (py + 14) 9 12
  else
    fill_rect (px - 14) py 9 12;
  set_color black;
  if pin < 11 then
    (if not isin then t else b) (px + 6) (py - 13)
  else if pin < 22 then
    (if not isin then l else r) (px + 15) (py + 6)
  else if pin < 33 then
    (if not isin then b else t) (px + 6) (py + 16) 
  else
    (if not isin then r else l) (px - 15) (py + 6)
;;

let draw_val pin isone =
  let (px, py) = pins.(pin) in
  set_color (if isone then red else white);
  fill_rect (px+1) (py+1) 10 10;
;;

for i = 0 to 43 do
  match i with
    | 1 | 2 | 3 | 4 | 5 | 6 | 13 | 14| 33 | 34 | 23 | 22 | 41 |  42 | 43 -> ()
    | _ -> draw_arrow i false ; draw_val i false ;
done;;

let sync_display =
  let sync_mutex = Mutex.create () in
  let sync_check = ref true in
  let rec sync_thread () =
    begin try
            Mutex.lock sync_mutex;
            let must_sync = !sync_check in
            sync_check := false;
            Mutex.unlock sync_mutex;
            if must_sync then synchronize ();
            Thread.delay 0.1;
      with _ -> () end;
    sync_thread ();
  in
  let _ = Thread.create sync_thread () in
  fun () ->
    Mutex.lock sync_mutex;
    sync_check := true;
    Mutex.unlock sync_mutex;
;;

sync_display ();;

let draw_vals port value =
  for bit = 0 to 7 do
    try
      let n = num_of_pin (port, bit) in
      draw_val n (value land (1 lsl bit) <> 0);
    with Error -> ()
  done;
  sync_display ();
;;

let draw_arrows port value =
  for bit = 0 to 7 do
    try
      let n = num_of_pin (port, bit) in
      draw_arrow n (value land (1 lsl bit) <> 0);
    with Error -> ()
  done;
  sync_display ();
;;

let draw_analog_config analog_nb =
  for an = 0 to 12 do
    let pin = num_of_pin (pin_of_an an) in
    let (px, py) = pins.(pin) in
    let px = px + 4 and py = if pin < 20 then py - 27 else py + 27 in
    if an < analog_nb then (
      set_color black;
      moveto px py;
      draw_string "A";
    ) else (
      set_color grew;
      fill_rect px py 6 10;
    )
  done;
  sync_display ();
;;

let draw_analog an value =
  let (px, py) = pins.(num_of_pin (pin_of_an (int_of_an an))) in
  let red_sz = ((11 - 1) * (value - 1) + (0x3FF - 1)) / (0x3FF - 1) in
  set_color red;
  for i = 0 to red_sz - 1 do
    moveto (px+1) (py+1+i);
    rlineto 10 0;
  done;
  set_color white;
  for i = red_sz to 10 do
    moveto (px+1) (py+1+i);
    rlineto 10 0;
  done;
  sync_display ();
;;

while true do
  try
    let line = read_line () in
    try
      match input_of_string line with
      | IWrite (port, value) -> draw_vals port value;
      | ITris (port, value) -> draw_arrows port value;
      | IWriteAnalog (an, value) -> draw_analog an value;
      | IConfigAnalog cnt -> draw_analog_config cnt;
      | ISync -> print_endline (string_of_output ODone)
      | IStop -> exit 0
    with Error -> Printf.eprintf "Invalid command: %s\n%!" line
  with Graphic_failure _ -> exit 0
done
