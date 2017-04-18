type t = {
  mutable cnt : int;
  htbl : (Opcode.t, int) Hashtbl.t;
}

let create () =
  let cnt = 0 and htbl = Hashtbl.create 1024 in
  { cnt; htbl }

let generate opgen opcode =
  match Hashtbl.find opgen.htbl opcode with
  | n -> n
  | exception Not_found ->
    let n = opgen.cnt in
    opgen.cnt <- n + 1;
    Hashtbl.add opgen.htbl opcode n;
    n

let sort opgen =
  let sorted = ref `ALREADY_SORTED in
  let lst = Hashtbl.fold (fun opcode _ acc -> opcode :: acc) opgen.htbl [] in
  let lst = List.sort Pervasives.compare lst in
  let ind = ref 0 in
  List.iter (fun opcode ->
    if Hashtbl.find opgen.htbl opcode <> !ind then (
      Hashtbl.replace opgen.htbl opcode !ind;
      sorted := `SORTED;
    );
    incr ind
  ) lst;
  !sorted

let export opgen =
  Hashtbl.fold (fun opcode n acc -> (opcode, n) :: acc) opgen.htbl []
