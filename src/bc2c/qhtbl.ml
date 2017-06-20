let initial_size = 16 (* Must be a power of 2. *)

type ('k, 'v) t = {
  mutable tbl : (int * ('k * 'v) list ref) list array;
  mutable cnt : int; (* Number of different hashs, not of different keys as usual. *)
}

let create () = {
  tbl = Array.make initial_size [];
  cnt = 0;
}

let grow qhtbl =
  let old_tbl = qhtbl.tbl in
  let old_size = Array.length old_tbl in
  let new_size = old_size * 2 in
  let new_mask = new_size - 1 in
  let new_tbl = Array.make new_size [] in
  Array.iter (fun lst ->
    List.iter (fun ((h, _) as hrl) ->
      let i = h land new_mask in
      new_tbl.(i) <- hrl :: new_tbl.(i);
    ) lst;
  ) old_tbl;
  qhtbl.tbl <- new_tbl

let put qhtbl k v =
  let size = Array.length qhtbl.tbl in
  let mask = size - 1 in
  let h = Hashtbl.hash k in
  let i = h land mask in
  let lst = qhtbl.tbl.(i) in
  try
    let rl = List.assq h lst in
    assert (not (List.mem_assq k !rl));
    rl := (k, v) :: !rl;
  with Not_found ->
    qhtbl.tbl.(i) <- (h, ref [ (k, v) ]) :: lst;
    qhtbl.cnt <- qhtbl.cnt + 1;
    if qhtbl.cnt lsl 1 > size then grow qhtbl

let find qhtbl k =
  let size = Array.length qhtbl.tbl in
  let mask = size - 1 in
  let h = Hashtbl.hash k in
  let i = h land mask in
  let lst = qhtbl.tbl.(i) in
  let rl = List.assq h lst in
  List.assq k !rl

let mem qhtbl k =
  try ignore (find qhtbl k); true
  with Not_found -> false

let del qhtbl k =
  let size = Array.length qhtbl.tbl in
  let mask = size - 1 in
  let h = Hashtbl.hash k in
  let i = h land mask in
  let lst = qhtbl.tbl.(i) in
  try
    let rl = List.assq h lst in
    rl := List.remove_assq k !rl;
    if !rl = [] then (
      qhtbl.tbl.(i) <- List.remove_assq h lst;
      qhtbl.cnt <- qhtbl.cnt - 1;
    )
  with Not_found ->
    ()
