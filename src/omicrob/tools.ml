(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Tools *)

let split str c =
  let rec loop acc i j =
    if i < 0 then
      String.sub str (i + 1) (j - i) :: acc
    else if str.[i] = c then
      loop ((String.sub str (i + 1) (j - i)) :: acc) (i - 1) (i - 1)
    else
      loop acc (i - 1) j in
  let len = String.length str in
  if len = 0 then []
  else loop [] (len - 1) (len - 1)

let starts_with str ~sub =
  let str_len = String.length str in
  let sub_len = String.length sub in
  str_len >= sub_len && String.sub str 0 sub_len = sub

let is_substring str ~sub =
  let str_len = String.length str in
  let sub_len = String.length sub in
  try
    for i = 0 to str_len - sub_len do
      if String.sub str i sub_len = sub then raise Exit;
    done;
    false
  with Exit ->
    true

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Command run tools *)

let is_str_need_quote str =
  try
    String.iter (fun c ->
      match c with
      | 'a' .. 'z' | 'A' .. 'Z' | '0' .. '9' | '_' | '-' | '+' | '.' | '/' | '@' | '=' | ',' -> ()
      | _ -> raise Exit
    ) str;
    false
  with Exit ->
    true

let quote_if_needed str =
  if is_str_need_quote str then Filename.quote str
  else str

let run ?(verbose=false) ?(just_print=false) ?(vars=[]) strs =
  let buf = Buffer.create 16 in
  let is_first = ref true in
  List.iter (fun (name, value) ->
    if !is_first then is_first := false else Buffer.add_char buf ' ';
    Buffer.add_string buf (quote_if_needed name);
    Buffer.add_char buf '=';
    Buffer.add_string buf (quote_if_needed value);
  ) vars;
  List.iter (fun str ->
    if !is_first then is_first := false else Buffer.add_char buf ' ';
    Buffer.add_string buf (quote_if_needed str);
  ) strs;
  let cmd = Buffer.contents buf in
  if verbose then Printf.eprintf "+ %s\n%!" cmd;
  if not just_print then (
    match Sys.command cmd with
    | 0 -> ()
    | errcode -> exit errcode
  )

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* TTY tools *)

let tty ?ttyopts:(ttyopts=[]) () =
  let rec find_in_options options =
    match options with
    | "-P" :: tty :: _ -> Some tty
    | _ :: rest -> find_in_options rest
    | [] -> None in
  match find_in_options ttyopts with
  | Some tty -> tty
  | None ->
    let dev_paths =
      try Sys.readdir "/dev"
      with _ -> Printf.eprintf "Error: fail to open /dev.\n%!"; exit 1 in
    let available_ttys = ref [] in
    Array.iter (fun dev_path ->
        if is_substring dev_path ~sub:"tty.usbmodem"
        || is_substring dev_path ~sub:"USB"
        || is_substring dev_path ~sub:"ACM"
        then (
          available_ttys := Filename.concat "/dev" dev_path :: !available_ttys;
        )
      ) dev_paths;
    match !available_ttys with
    | [] ->
      Printf.eprintf "Error: no available tty found to flash the micro-controller.\n";
      Printf.eprintf "> Please connect the micro-controller if not already connected.\n";
      Printf.eprintf "> Please reset the micro-controller if not ready to receive a new program.\n";
      Printf.eprintf "> Otherwise, please specify a tty with option -avrdudeopts -P,/dev/ttyXXX.\n";
      exit 1;
    | _ :: _ :: _ as lst ->
      Printf.eprintf "Error: multiple available tty found to flash the micro-controller:\n";
      List.iter (Printf.eprintf "  * %s\n") lst;
      Printf.eprintf "> Please specify a tty with option -avrdudeopts -P,/dev/ttyXXX.\n";
      exit 1;
    | [ tty ] -> tty

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
(* Config *)

let libdir local =
  if local then Filename.concat Config.builddir "lib"
  else Config.libdir

let includedir local =
  if local then Filename.concat Config.builddir "src/byterun"
  else Config.includedir

let libexecdir local =
  if local then Filename.concat Config.builddir "bin"
  else Config.libexecdir
