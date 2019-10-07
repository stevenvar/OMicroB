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

let usage () =
  Printf.eprintf "Usage: %s [COLxLIN] [e=PINXX] [rs=PINXX] [rw=PINXX] [bus=PORTX]\n%!"
    Sys.argv.(0);
  exit 1;
;;

let check_prefix prefix str =
  let plen = String.length prefix in
  if plen > String.length str then false else
    let rec f i =
      if i = plen then true
      else if Char.lowercase_ascii prefix.[i] <> Char.lowercase_ascii str.[i] then false
      else f (succ i)
    in
    f 0
;;

let parse_size str =
  try
    let len = String.length str in
    let x_ind = String.index str 'x' in
    let col = String.sub str 0 x_ind in
    let lin = String.sub str (succ x_ind) (len - x_ind - 1) in
    (int_of_string col, int_of_string lin)
  with Not_found | Invalid_argument _ | Failure _ ->
    failwith "invalid size"
;;

let e = ref None in
let rs = ref None in
let rw = ref None in
let d4 = ref None in
let d5 = ref None in
let d6 = ref None in
let d7 = ref None in
let size = ref None in
let nb_arg = Array.length Sys.argv in
let set n x v =
  match !x with
    | None -> x := Some v
    | Some _ -> failwith (Printf.sprintf "%s already defined" n)
in
let get n x =
  match !x with
    | None -> failwith (Printf.sprintf "%s undefined" n)
    | Some v -> v
in
for i = 1 to nb_arg - 1 do
  let arg = Sys.argv.(i) in
  try
    let len = String.length arg in
    if check_prefix "e=PIN" arg then
      set "e" e (Simul.pin_of_number (String.sub arg 2 (len-2)))
    else if check_prefix "rs=PIN" arg then
      set "rs" rs (Simul.pin_of_number (String.sub arg 3 (len-3)))
    else if check_prefix "rw=PIN" arg then
      set "rw" rw (Simul.pin_of_number (String.sub arg 3 (len-3)))
    else if check_prefix "d4=PIN" arg then
      set "d4" d4 (Simul.pin_of_number (String.sub arg 3 (len-3)))
    else if check_prefix "d5=PIN" arg then
      set "d5" d5 (Simul.pin_of_number (String.sub arg 3 (len-3)))
    else if check_prefix "d6=PIN" arg then
      set "d6" d6 (Simul.pin_of_number (String.sub arg 3 (len-3)))
    else if check_prefix "d7=PIN" arg then
      set "d7" d7 (Simul.pin_of_number (String.sub arg 3 (len-3)))

    else
      set "size" size (parse_size arg);
  with Failure _ ->
    Printf.eprintf "Error: don't know what to do with: '%s'\n%!" arg;
    usage ();
done;
let e = get "e" e in
let rs = get "rs" rs in
let rw = get "rw" rw in
let d4 = get "d4" d4 in
let d5 = get "d5" d5 in
let d6 = get "d6" d6 in
let d7 = get "d7" d7 in
let size = get "size" size in
let column_nb = fst size in
let line_nb = snd size in
try
  let display = Display.create_display 0 0 e rs rw d4 d5 d6 d7 column_nb line_nb in
  Display.init_graphics display;
  Proto.register display;
  Simul.start ();
  Simul.join ();
with Failure msg ->
  Printf.eprintf "Error: %s\n%!" msg;
  usage ();
;;
