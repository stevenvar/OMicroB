open T

type t = {
  mutable lst : dword ref list;
  mutable len : int;
}

let create () = {
  lst = [];
  len = 0;
}

let push heap dw =
  heap.lst <- ref dw :: heap.lst;
  heap.len <- heap.len + 1
    
let push_ref heap =
  let r = ref (INT 0) in
  heap.lst <- r :: heap.lst;
  heap.len <- heap.len + 1;
  r

let pointer heap =
  heap.len

let contents heap =
  List.rev_map (!) heap.lst
    
