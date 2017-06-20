(******************************************************************************)

type 'a t = {
  int32_cache       : (int32, 'a) Hashtbl.t;
  int64_cache       : (int64, 'a) Hashtbl.t;
  nativeint_cache   : (nativeint, 'a) Hashtbl.t;
  float_array_cache : (float array, 'a) Qhtbl.t;
  bytes_cache       : (bytes, 'a) Qhtbl.t;
  block_cache       : (T.value array, 'a) Qhtbl.t;
  closure_cache     : (T.code_ptr array * T.value array, 'a) Hashtbl.t;
}

(******************************************************************************)

let create () =
  let int32_cache = Hashtbl.create 16 in
  let int64_cache = Hashtbl.create 16 in
  let nativeint_cache = Hashtbl.create 16 in
  let float_array_cache = Qhtbl.create () in
  let bytes_cache = Qhtbl.create () in
  let block_cache = Qhtbl.create () in
  let closure_cache = Hashtbl.create 16 in
  { int32_cache; int64_cache; nativeint_cache; float_array_cache; bytes_cache; block_cache; closure_cache }

(******************************************************************************)

let find_int32 sh i =
  Hashtbl.find sh.int32_cache i

let find_int64 sh i =
  Hashtbl.find sh.int64_cache i

let find_nativeint sh i =
  Hashtbl.find sh.nativeint_cache i

let find_float_array sh xs =
  Qhtbl.find sh.float_array_cache xs

let find_bytes sh b =
  Qhtbl.find sh.bytes_cache b

let find_block sh b =
  Qhtbl.find sh.block_cache b

let find_closure sh cp vs =
  Hashtbl.find sh.closure_cache (cp, vs)

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

let put_float_array sh fs x =
  Qhtbl.put sh.float_array_cache fs x

let put_bytes sh b x =
  Qhtbl.put sh.bytes_cache b x

let put_block sh b x =
  Qhtbl.put sh.block_cache b x

let put_closure sh cp vs x =
  assert (not (Hashtbl.mem sh.closure_cache (cp, vs)));
  Hashtbl.add sh.closure_cache (cp, vs) x

(******************************************************************************)
