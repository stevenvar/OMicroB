type 'a t = 'a list ref

let acc stack i =
  let rec loop stack i =
    match i, stack with
    | _, [] -> assert false
    | 0, v :: _ -> v
    | _, _ :: r -> loop r (i - 1) in
  assert (i >= 0);
  loop !stack i

let push stack v =
  stack := v :: !stack

let pop stack =
  match !stack with
  | [] -> assert false
  | v :: rest -> stack := rest; v

let popn stack n =
  let rec loop stack n =
    match n, stack with
    | 0, _ -> stack
    | _, _ :: rest -> loop rest (n - 1)
    | _, [] -> assert false in
  assert (n >= 0);
  stack := loop !stack n

let assign stack i v =
  let rec loop stack i v =
    match i, stack with
    | 0, _ :: rest -> v :: rest
    | _, t :: rest -> t :: loop rest (i - 1) v
    | _, [] -> assert false in
  assert (i >= 0);
  stack := loop !stack i v
