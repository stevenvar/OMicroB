(******************************************************************************)

module QHTBL : sig
  type ('k, 'v) t
  val create : unit -> ('k, 'v) t
  val put  : ('k, 'v) t -> 'k -> 'v -> unit
  val find : ('k, 'v) t -> 'k -> 'v
end = struct
  type ('k, 'v) t = ('k, ('k * 'v) list ref) Hashtbl.t

  let create () = Hashtbl.create 16

  let put qhtbl k v =
    try
      let rl = Hashtbl.find qhtbl k in
      assert (not (List.mem_assq k !rl));
      rl := (k, v) :: !rl;
    with Not_found ->
      Hashtbl.add qhtbl k (ref [ (k, v) ])

  let find qhtbl k =
    List.assq k !(Hashtbl.find qhtbl k)
end

(******************************************************************************)

type 'a t = {
  int32_cache       : (int32, 'a) Hashtbl.t;
  int64_cache       : (int64, 'a) Hashtbl.t;
  nativeint_cache   : (nativeint, 'a) Hashtbl.t;
  float_array_cache : (float array, 'a) QHTBL.t;
  bytes_cache       : (bytes, 'a) QHTBL.t;
  block_cache       : (T.value array, 'a) QHTBL.t;
  closure_cache     : (T.code_ptr array * T.value array, 'a) Hashtbl.t;
}

(******************************************************************************)

let create () =
  let int32_cache = Hashtbl.create 16 in
  let int64_cache = Hashtbl.create 16 in
  let nativeint_cache = Hashtbl.create 16 in
  let float_array_cache = QHTBL.create () in
  let bytes_cache = QHTBL.create () in
  let block_cache = QHTBL.create () in
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
  QHTBL.find sh.float_array_cache xs

let find_bytes sh b =
  QHTBL.find sh.bytes_cache b

let find_block sh b =
  QHTBL.find sh.block_cache b

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
  QHTBL.put sh.float_array_cache fs x

let put_bytes sh b x =
  QHTBL.put sh.bytes_cache b x

let put_block sh b x =
  QHTBL.put sh.block_cache b x

let put_closure sh cp vs x =
  assert (not (Hashtbl.mem sh.closure_cache (cp, vs)));
  Hashtbl.add sh.closure_cache (cp, vs) x

(******************************************************************************)
