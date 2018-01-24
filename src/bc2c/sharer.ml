(******************************************************************************)

type 'a t = {
  int32_cache           : (int32, 'a) Hashtbl.t;
  int64_cache           : (int64, 'a) Hashtbl.t;
  nativeint_cache       : (nativeint, 'a) Hashtbl.t;
  float_array_cache_imm : (float array, 'a) Hashtbl.t;
  float_array_cache_mut : (float array, 'a) Qhtbl.t;
  bytes_cache_imm       : (bytes, 'a) Hashtbl.t;
  bytes_cache_mut       : (bytes, 'a) Qhtbl.t;
  block_cache_imm       : (int * T.value array, 'a) Hashtbl.t;
  block_cache_mut       : (T.value array, 'a) Qhtbl.t;
  closure_cache_imm     : (T.code_ptr array * T.value array, 'a) Hashtbl.t;
  closure_cache_mut     : (T.code_ptr array, (T.value array, 'a) Qhtbl.t) Qhtbl.t;
}

(******************************************************************************)

let create () =
  let int32_cache = Hashtbl.create 16 in
  let int64_cache = Hashtbl.create 16 in
  let nativeint_cache = Hashtbl.create 16 in
  let float_array_cache_imm = Hashtbl.create 16 in
  let float_array_cache_mut = Qhtbl.create () in
  let bytes_cache_imm = Hashtbl.create 16 in
  let bytes_cache_mut = Qhtbl.create () in
  let block_cache_imm = Hashtbl.create 16 in
  let block_cache_mut = Qhtbl.create () in
  let closure_cache_imm = Hashtbl.create 16 in
  let closure_cache_mut = Qhtbl.create () in
  {
    int32_cache; int64_cache; nativeint_cache;
    float_array_cache_imm; float_array_cache_mut;
    bytes_cache_imm; bytes_cache_mut;
    block_cache_imm; block_cache_mut;
    closure_cache_imm; closure_cache_mut;
  }

(******************************************************************************)

let value_mutability value =
  let open T in
  let qhtbl = Qhtbl.create () in
  let rec loop value =
    if Qhtbl.mem qhtbl value then false else (
      Qhtbl.put qhtbl value ();
      match value with
      | Int _ | Int32 _ | Int64 _ | Nativeint _ | Float _ | CodePtr _ -> false
      | Float_array (mut, _) | Bytes (mut, _) | Object (mut, _) -> mut = Mutable
      | Block (mut, _tag, tbl) -> mut = Mutable || Array.exists loop tbl
      | Closure clo -> Array.exists loop clo.env
    ) in
  if loop value then Mutable else Immutable

(******************************************************************************)

let find_int32 sh i =
  Hashtbl.find sh.int32_cache i

let find_int64 sh i =
  Hashtbl.find sh.int64_cache i

let find_nativeint sh i =
  Hashtbl.find sh.nativeint_cache i

let find_float_array sh mut xs =
  match mut with
  | T.Immutable -> Hashtbl.find sh.float_array_cache_imm xs
  | T.Mutable -> Qhtbl.find sh.float_array_cache_mut xs

let find_bytes sh mut b =
  match mut with
  | T.Immutable -> Hashtbl.find sh.bytes_cache_imm b
  | T.Mutable -> Qhtbl.find sh.bytes_cache_mut b

let find_block sh mut tag b =
  match value_mutability (T.Block (mut, tag, b)) with
  | T.Immutable -> Hashtbl.find sh.block_cache_imm (tag, b)
  | T.Mutable -> Qhtbl.find sh.block_cache_mut b

let find_closure sh cp vs =
  match value_mutability (T.Closure { T.ofs = 0; ptrs = cp; env = vs }) with
  | T.Immutable -> Hashtbl.find sh.closure_cache_imm (cp, vs)
  | T.Mutable -> Qhtbl.find (Qhtbl.find sh.closure_cache_mut cp) vs

(******************************************************************************)

let put_int32 sh i x =
  assert (not (Hashtbl.mem sh.int32_cache i));
  Hashtbl.add sh.int32_cache i x

let put_int64 sh i x =
  assert (not (Hashtbl.mem sh.int64_cache i));
  Hashtbl.add sh.int64_cache i x

let put_nativeint sh i x =
  assert (not (Hashtbl.mem sh.nativeint_cache i));
  Hashtbl.add sh.nativeint_cache i x

let put_float_array sh mut fs x =
  match mut with
  | T.Immutable ->
    assert (not (Hashtbl.mem sh.float_array_cache_imm fs));
    Hashtbl.add sh.float_array_cache_imm fs x
  | T.Mutable ->
    Qhtbl.put sh.float_array_cache_mut fs x

let put_bytes sh mut b x =
  match mut with
  | T.Immutable ->
    assert (not (Hashtbl.mem sh.bytes_cache_imm b));
    Hashtbl.add sh.bytes_cache_imm b x
  | T.Mutable ->
    Qhtbl.put sh.bytes_cache_mut b x

let put_block sh mut tag b x =
  match value_mutability (T.Block (mut, tag, b)) with
  | T.Immutable ->
    assert (not (Hashtbl.mem sh.block_cache_imm (tag, b)));
    Hashtbl.add sh.block_cache_imm (tag, b) x
  | T.Mutable ->
    Qhtbl.put sh.block_cache_mut b x
                    
let put_closure sh cp vs x =
  match value_mutability (T.Closure { T.ofs = 0; ptrs = cp; env = vs }) with
  | T.Immutable ->
    assert (not (Hashtbl.mem sh.closure_cache_imm (cp, vs)));
    Hashtbl.add sh.closure_cache_imm (cp, vs) x
  | T.Mutable -> (
    let sub_qhtbl =
      match Qhtbl.find sh.closure_cache_mut cp with
      | sub_qhtbl -> sub_qhtbl
      | exception Not_found ->
        let sub_qhtbl = Qhtbl.create () in
        Qhtbl.put sh.closure_cache_mut cp sub_qhtbl;
        sub_qhtbl in
    Qhtbl.put sub_qhtbl vs x
  )

(******************************************************************************)
