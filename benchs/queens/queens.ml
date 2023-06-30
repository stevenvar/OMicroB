let rec interval n m =
    if n > m then [] else n :: interval (n+1) m

let rec concmap f l =
  match l with
  | [] -> []
  | x :: l -> f x @ concmap f l

let rec safe d x l =
  match l with
  | [] -> true
  | q::l -> (not (x = q)) && ((not (x = q+d)) && ((not (x = q-d)) && safe (d+1) x l))

let ok l =
  match l with
  | [] -> true
  | x::l -> safe 1 x l

let rec filter p l  =
  match l with
  | [] -> []
  | x::l -> if p x then x::List.filter p l else filter p l

let range = interval 1

let queens n =
  let qs = range n in
  let testcol b = List.filter ok (List.map (fun q -> q::b) qs) in
  let rec gen = function
    | 0 -> [[]]
    | n -> concmap testcol (gen (n - 1)) in
  List.length (gen n)

let () =
  let start = millis () in
  for _i = 1 to 10000 do
    for j = 0 to 6 do
      ignore(queens j)
    done
  done;
  let stop = millis () in
  Serial.write_string (string_of_int (stop-start))
