type 'a t = 'a list

let acc stack n =
  let rec loop stack n =
    match stack, n with
    | v :: _, 0 -> v
    | _ :: r, _ -> loop r (n - 1)
    | [], _ -> assert false in
  assert (n >= 0);
  loop stack n

let push stack v =
  v :: stack

let pop stack =
  match stack with
  | v :: r -> (v, r)
  | [] -> assert false

let popn stack n =
  let rec loop stack n =
    match stack, n with
    | _, 0 -> stack
    | _ :: r, _ -> loop r (n - 1)
    | [], _ -> assert false in
  assert (n >= 0);
  loop stack n

let topn stack n =
  let rec loop stack n =
    match stack, n with
    | _, 0 -> []
    | v :: r, _ -> v :: loop r (n - 1)
    | [], _ -> assert false in
  assert (n >= 0);
  loop stack n

let assign stack n v =
  let rec loop stack n v =
    match stack, n with
    | _ :: r, 0 -> v :: r
    | w :: r, _ -> w :: loop r (n - 1) v
    | [], _ -> assert false in
  assert (n >= 0);
  loop stack n v
