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
open Printf;;

type color = White | Black
type button = Table of int * int | Stack of color * int

let wood = rgb 230 250 100;;
let bakelite = rgb 103 41 11;;

let width = 630;;
let height = 410;;

open_graph (sprintf " %dx%d" width height);;
set_window_title "Goblet";;

set_color wood;;
fill_rect 0 0 width height;;
set_color white;;
fill_rect 20 20 (width - 40) (height - 40);;

let string_of_color = function White -> "White" | Black -> "Black"

let string_of_button b =
  match b with
    | Table (i, j) -> sprintf "Table (%d, %d)" i j
    | Stack (c, j) -> sprintf "Stack (%s, %d)" (string_of_color c) j;
;;

let buttons = ref [];;
let set_button i j b =
  set_color bakelite;
  buttons := (i, j, i+80, j+80, b) :: !buttons;
  fill_rect i j 80 80;
in
for j = 0 to 2 do
  set_button 50 (60 + j * 100) (Stack (White, 2 - j));
  set_button (width - 50 - 80) (60 + j * 100) (Stack (Black, 2 - j));
done;
for i = 0 to 3 do
  for j = 0 to 3 do
    set_button (140 + i * 90) (30 + j * 90) (Table (i, 3 - j));
  done
done;
;;

let ind_of_key key =
  match key with
    | Table (0, 0) -> 0b00100000
    | Table (0, 1) -> 0b01000100
    | Table (0, 2) -> 0b01100000
    | Table (0, 3) -> 0b10001100
    | Table (1, 0) -> 0b10100000
    | Table (1, 1) -> 0b00000100
    | Table (1, 2) -> 0b00100100
    | Table (1, 3) -> 0b00101100
    | Table (2, 0) -> 0b01000000
    | Table (2, 1) -> 0b11000000
    | Table (2, 2) -> 0b01100100
    | Table (2, 3) -> 0b01101100
    | Table (3, 0) -> 0b10000000
    | Table (3, 1) -> 0b10000100
    | Table (3, 2) -> 0b11000100
    | Table (3, 3) -> 0b01101000

    | Stack (Black, 0) -> 0b11100000
    | Stack (Black, 1) -> 0b11100100
    | Stack (Black, 2) -> 0b00001000

    | Stack (White, 0) -> 0b11101000
    | Stack (White, 1) -> 0b00001100
    | Stack (White, 2) -> 0b00101000

    | _ -> invalid_arg "ind_of_key"
;;

let button_pressed x y =
  try
    let test (x0, y0, x1, y1, _) = x > x0 && x < x1 && y > y0 && y < y1 in
    let (_, _, _, _, b) = List.find test !buttons in
    let s1 = sprintf "WD%02X" (ind_of_key b) in
    let s2 = sprintf "WD%02X" 0 in
    [ s1 ; s1 ; s2 ; s2 ]
  with Not_found -> []
;;

let channel = Event.new_channel ()

let task1 () =
  while true do
    let status = wait_next_event [ Button_down ] in
    let cmnds = button_pressed status.mouse_x status.mouse_y in
    List.iter (fun cmnd -> Event.sync (Event.send channel cmnd)) cmnds;
  done;
and task2 () =
  while true do
    match read_line () with
      | "SYNC" ->
        begin match Event.poll (Event.receive channel) with
          | Some cmnd -> printf "%s\nDONE\n%!" cmnd;
          | None -> printf "DONE\n%!";
        end
      | "STOP" -> exit 0
      | _ -> ()
  done
;;

ignore (Thread.create task1 ());
task2 ();
