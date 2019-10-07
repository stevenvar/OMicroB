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
;;
