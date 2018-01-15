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
  Printf.eprintf "Usage: %s [COLxLIN] [e=RXX] [rs=RXX] [rw=RXX] [bus=PORTX]\n%!"
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
let bus = ref None in
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
    if check_prefix "e=r" arg && len = 5 then
      set "e" e (Simul.pin_of_string (String.sub arg 2 3))
    else if check_prefix "rs=r" arg && len = 6 then
      set "rs" rs (Simul.pin_of_string (String.sub arg 3 3))
    else if check_prefix "rw=r" arg && len = 6 then
      set "rw" rw (Simul.pin_of_string (String.sub arg 3 3))
    else if check_prefix "bus=port" arg && len = 9 then
      set "bus" bus (Simul.port_of_char arg.[8])
    else
      set "size" size (parse_size arg);
  with Failure _ ->
    Printf.eprintf "Error: don't know what to do with: '%s'\n%!" arg;
    usage ();
done;
let e = get "e" e in
let rs = get "rs" rs in
let rw = get "rw" rw in
let bus = get "bus" bus in
let size = get "size" size in
let column_nb = fst size in
let line_nb = snd size in
try
  let display = Display.create_display 0 0 e rs rw bus column_nb line_nb in
  Display.init_graphics display;
  Proto.register display;
  Simul.start ();
  Simul.join ();
with Failure msg ->
  Printf.eprintf "Error: %s\n%!" msg;
  usage ();
;;
