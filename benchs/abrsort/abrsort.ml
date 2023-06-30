type 'a tree = Empty | Node of 'a * 'a tree * 'a tree

let init n f =
  let rec aux n acc =
    if n = 0 then acc
    else
      aux (n-1) ((f n)::acc)
  in
  aux n []

let rec fold_left f accu l =
  match l with
    [] -> accu
  | a::l -> fold_left f (f accu a) l

let rec add a t =
  match t with
    | Empty -> Node (a,Empty, Empty)
    | Node (x,l,r) -> if a < x then Node(x,add a l,r) else Node(x,l,add a r)

let rec to_list t =
  match t with
    | Empty -> []
    | Node (x,l,r) -> List.rev_append (to_list l) (x :: to_list r)

let tree_sort l =
  let t = fold_left (fun acc x -> add x acc) Empty l in
  to_list t

let _ =
  let start = millis () in
  for i = 1 to 10000 do
    let l = init 100 (fun x -> Random.int x) in
    ignore (tree_sort l)
  done;
  let stop = millis () in
  Serial.write_string (string_of_int (stop-start))
