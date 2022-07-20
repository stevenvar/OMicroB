let usage =
  Printf.sprintf "Usage: %s [-device=D] [COLxLIN] [-dc=RXX] [-cs=RXX] [-rst=RXX] \n%!"
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
    failwith (Printf.sprintf "invalid size %s" str)


let dc = ref None
let cs = ref None
let rst = ref None
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
    ("-dc", Arg.String (set "dc" dc), "set the dc pin");
    ("-cs", Arg.String (set "cs" cs), "set the cs pin");
    ("-rst", Arg.String (set "rst" rst), "set the rst pin");
  ])

let set_size arg =
  set "size" size (parse_size arg)

let _ =
  Arg.parse spec set_size usage;

  try
    let (module M) = get_device () in
    let open Display.Display(M) in
    let open Proto.Proto(M) in

    let cs = get "cs" cs |> M.pin_of_string in
    let dc = get "dc" dc |> M.pin_of_string in
    let rst = get "rst" rst |> M.pin_of_string in
    let size = get "size" size in
    let column_nb = fst size in
    let line_nb = snd size in
    at_exit (fun () -> print_endline "STOP");
    let display = create_display 0 0 cs dc rst column_nb line_nb in
    init_graphics display;
    register display;
    Simul.start ();
    Simul.join ()
  with Failure msg ->
    Printf.eprintf "Error: %s\n%!" msg;
    print_usage ()
