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

let usage =
  Printf.sprintf "Usage: %s [-device=DEVICE] <circuit.txt>\n%!"
    Sys.argv.(0)

let print_usage () =
  Printf.eprintf "%s" usage;
  exit 1

let file = ref None

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

let () =
  Arg.parse spec (set "file" file) usage;

  try
    let (module M) = get_device () in
    let open Lexer.Lexer(M) in
    let open Parser.Make(M) in
    let open Component.Component(M) in

    let file = get "file" file in
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
      let components = main lex lexbuf in
      at_exit (fun () -> print_endline "STOP");
      Window.init_graphics ();
      List.iter register components;
      Simul.start ();
      Window.main_loop ();
    with
    | Failure msg ->
      eprintf "Invalid circuit: %s\n" msg;
      exit 1;
    | Graphics.Graphic_failure _ -> print_endline "STOP"; exit 0
    | Parsing.Parse_error -> error "syntax error";
    | Lexing_error msg -> error ("lexing error : " ^ msg)
    | End_of_file -> error "unexpected end of file"
  with
  | Sys_error msg ->
    eprintf "Sys error: %s\n" msg;
    exit 1;
  | Failure msg ->
    Printf.eprintf "Error: %s\n%!" msg;
    print_usage ()
