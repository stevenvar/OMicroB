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

open Types

let cgrom = Cgrom.parse ()

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
  display.ram_addr <- new_addr;
;;

let incr_addr display = set_addr (display.ram_addr + 1) display;;

let decr_addr display = set_addr (display.ram_addr - 1) display;;

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
;;

let write c display =
  try display.ddram.(convert_addr display) <- c;
  with InvalidAddress -> ();
;;

let read display =
  try display.ddram.(convert_addr display);
  with InvalidAddress -> ' ';
;;

let fill c display =
  Array.fill display.ddram 0 (Array.length display.ddram) c;
;;

let rotate_left display =
  let ddram = display.ddram in
  let ddram103 = ddram.(103) in
  for i = 102 downto 0 do
    ddram.(succ i) <- ddram.(i);
  done;
  ddram.(0) <- ddram103;
;;

let rotate_right display =
  let ddram = display.ddram in
  let ddram0 = ddram.(0) in
  for i = 0 to 102 do
    ddram.(i) <- ddram.(succ i);
  done;
  ddram.(103) <- ddram0;
;;

let set_two_line_mode b display =
  display.line_mode <- if b then Two else One;
;;

let get_bitmap ind display =
  if ind < 8 then display.cgram.(ind)
  else cgrom.(ind)
;;

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
;;
