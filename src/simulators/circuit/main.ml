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

open Printf;;
open Lexing;;

let file =
  if Array.length Sys.argv <> 2 then (
    eprintf "Usage: %s <circuit.txt>\n" Sys.argv.(0);
    exit 1;
  );
  Sys.argv.(1)
;;

try
  let ic = open_in file in
  let lexbuf = from_channel ic in
  let error msg =
    let start = lexbuf.lex_start_p in
    let curr = lexbuf.lex_curr_p in
    let first_char = start.pos_cnum - start.pos_bol in
    let last_char = curr.pos_cnum - start.pos_bol in
    let msg =
      if first_char + 1 < last_char then
        sprintf "File \"%s\", line %d, characters %d-%d:\nError: %s."
          file start.pos_lnum first_char last_char msg
      else
        sprintf "File \"%s\", line %d, character %d:\nError: %s."
          file start.pos_lnum first_char msg;
    in
    close_in ic;
    eprintf "%s\n" msg;
    exit 1;
  in
  try
    let components = Parser.main Lexer.lex lexbuf in
    at_exit (fun () -> print_endline "STOP");
    Window.init_graphics ();
    List.iter Component.register components;
    Simul.start ();
    Window.main_loop ();
  with
    | Failure msg ->
      eprintf "Invalid circuit: %s\n" msg;
      exit 1;
    | Graphics.Graphic_failure _ -> print_endline "STOP"; exit 0
    | Parsing.Parse_error -> error "syntax error";
    | Lexer.Lexing_error msg -> error ("lexing error : " ^ msg)
    | End_of_file -> error "unexpected end of file"
with
  | Sys_error msg ->
    eprintf "Sys error: %s\n" msg;
    exit 1;
;;
