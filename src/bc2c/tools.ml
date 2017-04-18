(******************************************************************************)

let fail fmt = Printf.ksprintf failwith fmt

(******************************************************************************)

let with_ic path f =
  let ic = open_in path in
  match f ic with
  | res -> close_in ic; res
  | exception exn -> (try close_in ic with _ -> ()); raise exn

let with_oc path f =
  let oc = open_out path in
  match f oc with
  | res -> close_out oc; res
  | exception exn -> (try close_out oc with _ -> ()); raise exn

(******************************************************************************)

let is_prefix ~prefix str =
  let str_len = String.length str in
  let prefix_len = String.length prefix in
  if str_len < prefix_len then false
  else String.sub str 0 prefix_len = prefix

let is_suffix ~suffix str =
  let str_len = String.length str in
  let suffix_len = String.length suffix in
  if str_len < suffix_len then false
  else String.sub str (str_len - suffix_len) suffix_len = suffix

(******************************************************************************)
