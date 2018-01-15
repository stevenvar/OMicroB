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
    | (PORTA, 0) ->  1 | (PORTA, 1) ->  2 | (PORTA, 2) ->  3 | (PORTA, 3) ->  4 | (PORTA, 4) ->  5
    | (PORTA, 5) ->  6 | (PORTA, 6) -> 13 | (PORTA, 7) -> 12 | (PORTB, 0) -> 32 | (PORTB, 1) -> 33
    | (PORTB, 2) -> 34 | (PORTB, 3) -> 35 | (PORTB, 4) -> 36 | (PORTB, 5) -> 37 | (PORTB, 6) -> 38
    | (PORTB, 7) -> 39 | (PORTC, 0) -> 14 | (PORTC, 1) -> 15 | (PORTC, 2) -> 16 | (PORTC, 3) -> 17
    | (PORTC, 4) -> 22 | (PORTC, 5) -> 23 | (PORTC, 6) -> 24 | (PORTC, 7) -> 25 | (PORTD, 0) -> 18
    | (PORTD, 1) -> 19 | (PORTD, 2) -> 20 | (PORTD, 3) -> 21 | (PORTD, 4) -> 26 | (PORTD, 5) -> 27
    | (PORTD, 6) -> 28 | (PORTD, 7) -> 29 | (PORTE, 0) ->  7 | (PORTE, 1) ->  8 | (PORTE, 2) ->  9
    | (PORTE, 3) ->  0 | _ -> raise Error
;;

let pin_of_num num =
  match num with
    |  1 -> (PORTA, 0) |  2 -> (PORTA, 1) |  3 -> (PORTA, 2) |  4 -> (PORTA, 3) |  5 -> (PORTA, 4)
    |  6 -> (PORTA, 5) | 13 -> (PORTA, 6) | 12 -> (PORTA, 7) | 32 -> (PORTB, 0) | 33 -> (PORTB, 1)
    | 34 -> (PORTB, 2) | 35 -> (PORTB, 3) | 36 -> (PORTB, 4) | 37 -> (PORTB, 5) | 38 -> (PORTB, 6)
    | 39 -> (PORTB, 7) | 14 -> (PORTC, 0) | 15 -> (PORTC, 1) | 16 -> (PORTC, 2) | 17 -> (PORTC, 3)
    | 22 -> (PORTC, 4) | 23 -> (PORTC, 5) | 24 -> (PORTC, 6) | 25 -> (PORTC, 7) | 18 -> (PORTD, 0)
    | 19 -> (PORTD, 1) | 20 -> (PORTD, 2) | 21 -> (PORTD, 3) | 26 -> (PORTD, 4) | 27 -> (PORTD, 5)
    | 28 -> (PORTD, 6) | 29 -> (PORTD, 7) |  7 -> (PORTE, 0) |  8 -> (PORTE, 1) |  9 -> (PORTE, 2)
    |  0 -> (PORTE, 3) | _ -> raise Error
;;

let pin_of_an an = match an with
  |  0 -> (PORTA, 0) | 1 -> (PORTA, 1) |  2 -> (PORTA, 2) |  3 -> (PORTA, 3)
  |  4 -> (PORTA, 5) | 5 -> (PORTE, 0) |  6 -> (PORTE, 1) |  7 -> (PORTE, 2)
  |  8 -> (PORTB, 2) | 9 -> (PORTB, 3) | 10 -> (PORTB, 1) | 11 -> (PORTB, 4)
  | 12 -> (PORTB, 0) | _ -> raise Error
;;

let pins = Array.make 40 (0, 0);;
let tris = Array.make 40 true;;
let mem_tris = Array.make 40 false;;
let vals = Array.make 40 false;;
let mem_vals = Array.make 40 true;;

let grew = rgb 200 200 200;;
open_graph " 620x620";;
set_window_title "DIP40 simulator";;
display_mode false;;
set_color grew;
fill_rect 0 0 620 620;;
set_color black;;
fill_rect 50 50 520 520;;
for i = 0 to 19 do
  let x1 = (62 + (254 * i) / 10) in
  let x2 = (62 + (254 * i) / 10) in
  let y1 = 38 in
  let y2 = 560 in
  draw_rect x1 y1 12 12;
  draw_rect x2 y2 12 12;
  pins.(i) <- (x1, y1);
  pins.(39-i) <- (x2, y2);
done;;
set_color (rgb 100 100 100);;
fill_circle 68 74 4;;
draw_circle 68 74 4;;
fill_circle 49 115 8;;
set_color grew;;
fill_rect 40 105 9 20;;
set_color white;;
for i = 0 to 39 do
  try
    let (x, y) = pins.(i) in
    let (port, bit) = pin_of_num i in
    let c = char_of_port port in
    if i < 20 then moveto (x+1) (y + 16) else moveto (x+1) (y - 16);
    draw_string (Printf.sprintf "%c%d" c bit);
  with Error -> ()
done;;
let draw_plus pin d =
  let (x, y) = pins.(pin) in
  draw_poly_line [| (x+3, y+6+d) ; (x+9, y+6+d) |];
  draw_poly_line [| (x+6, y+3+d) ; (x+6, y+9+d) |];
and draw_minus pin d =
  let (x, y) = pins.(pin) in
  draw_poly_line [| (x+3, y+6+d) ; (x+9, y+6+d) |];
in
draw_plus 10 (16);
draw_minus 11 (16);
draw_plus 31 (-16);
draw_minus 30 (-16);
;;

let draw_arrow pin isin =
  let (px, py) = pins.(pin) in
  let t x y =
    draw_poly_line [| (x, y) ; (x, y+10) |];
    draw_poly_line [| (x-3, y+7) ; (x, y+10) ; (x+3, y+7) |];
  in
  let b x y =
    draw_poly_line [| (x, y) ; (x, y+10) |];
    draw_poly_line [| (x-3, y+3) ; (x, y) ; (x+3, y+3) |];
  in
  set_color grew;
  if pin < 20 then
    fill_rect px (py - 14) 9 12
  else
    fill_rect px (py + 14) 9 12;
  set_color black;
  if pin < 20 then
    (if isin then t else b) (px + 6) (py - 13)
  else
    (if isin then b else t) (px + 6) (py + 15)
;;

let draw_val pin isone =
  let (px, py) = pins.(pin) in
  set_color (if isone then red else white);
  fill_rect (px+1) (py+1) 10 10;
;;

for i = 0 to 39 do
  match i with
    | 10 | 11 | 30 | 31 -> ()
    | _ -> draw_arrow i true ; draw_val i false ;
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
