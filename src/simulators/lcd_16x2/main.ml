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

let usage =
  Printf.sprintf "Usage: %s [-device=DEVICE] [COLxLIN] [-e=PINXX] [-rs=PINXX] [-rw=PINXX] [-d4=PINXX] [-d5=PINXX] [-d6=PINXX] [-d7=PINXX]\n%!"
    Sys.argv.(0)

let print_usage () =
  Printf.eprintf "%s" usage;
  exit 1

let check_prefix prefix str =
  let plen = String.length prefix in
  if plen > String.length str then false else
    let rec f i =
      if i = plen then true
      else if Char.lowercase_ascii prefix.[i] <> Char.lowercase_ascii str.[i] then false
      else f (succ i)
    in
    f 0

let parse_size str =
  try
    let len = String.length str in
    let x_ind = String.index str 'x' in
    let col = String.sub str 0 x_ind in
    let lin = String.sub str (succ x_ind) (len - x_ind - 1) in
    (int_of_string col, int_of_string lin)
  with Not_found | Invalid_argument _ | Failure _ ->
    failwith "invalid size"

let e = ref None
let rs = ref None
let rw = ref None
let d4 = ref None
let d5 = ref None
let d6 = ref None
let d7 = ref None
let size = ref None

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
    ("-e", Arg.String (set "e" e), "set the enable pin");
    ("-rs", Arg.String (set "rs" rs), "set the reset pin");
    ("-rw", Arg.String (set "rw" rw), "set the read/write pin");
    ("-d4", Arg.String (set "d4" d4), "set the data 4 pin");
    ("-d5", Arg.String (set "d5" d5), "set the data 5 pin");
    ("-d6", Arg.String (set "d6" d6), "set the data 6 pin");
    ("-d7", Arg.String (set "d7" d7), "set the data 7 pin");
  ])

let set_size arg =
  set "size" size (parse_size arg)

let _ =
  Arg.parse spec set_size usage;

  try
    let (module M) = get_device () in
    let open Display.Display(M) in
    let open Proto.Proto(M) in

    let e = get "e" e |> M.pin_of_string in
    let rs = get "rs" rs |> M.pin_of_string in
    let rw = get "rw" rw |> M.pin_of_string in
    let d4 = get "d4" d4 |> M.pin_of_string in
    let d5 = get "d5" d5 |> M.pin_of_string in
    let d6 = get "d6" d6 |> M.pin_of_string in
    let d7 = get "d7" d7 |> M.pin_of_string in
    let size = get "size" size in
    let column_nb = fst size in
    let line_nb = snd size in
    let display = create_display 0 0 e rs rw d4 d5 d6 d7 column_nb line_nb in
    init_graphics display;
    register display;
    Simul.start ();
    Simul.join ();
  with Failure msg ->
    Printf.eprintf "Error: %s\n%!" msg;
    print_usage ()
