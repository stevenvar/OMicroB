open OByteLib.Instr
open Mstack
open T

(******************************************************************************)
(* Value pretty printer. *)

let bprint_mutability buf mut =
  match mut with
  | Mutable   -> Buffer.add_string buf "rw"
  | Immutable -> Buffer.add_string buf "ro"

let rec bprint_value buf v =
  match v with
  | Int               i -> Printf.bprintf buf "%d"  i
  | Int32             i -> Printf.bprintf buf "%ldl" i
  | Int64             i -> Printf.bprintf buf "%LdL" i
  | Nativeint         i -> Printf.bprintf buf "%ndn" i
  | Float             x -> Printf.bprintf buf "%F"  x
  | Float_array (m, xs) -> Printf.bprintf buf "[%a|" bprint_mutability m; Array.iter (Printf.bprintf buf " %F;") xs; Printf.bprintf buf " |]"
  | Bytes        (m, b) -> Printf.bprintf buf "(%a) %S" bprint_mutability m (Bytes.unsafe_to_string b)
  | Object      (m, vs) -> Printf.bprintf buf "<%a|" bprint_mutability m; Array.iter (Printf.bprintf buf " %a;" bprint_value) vs; Printf.bprintf buf " >"
  | Block  (m, tag, vs) -> Printf.bprintf buf "[%a|%d|" bprint_mutability m !tag; Array.iter (Printf.bprintf buf " %a;" bprint_value) vs; Printf.bprintf buf " ]"
  | Closure           _ -> Printf.bprintf buf "<fun>"
  | CodePtr          cp -> Printf.bprintf buf "#%d" cp

let pprint_value v =
  let buf = Buffer.create 16 in
  bprint_value buf v;
  Buffer.contents buf

let rec bprint_exception_arg buf arg =
  match arg with
  | Int        i -> Printf.bprintf buf "%d" i
  | Int32      i -> Printf.bprintf buf "%ldl" i
  | Int64      i -> Printf.bprintf buf "%LdL" i
  | Nativeint  i -> Printf.bprintf buf "%ndn" i
  | Float      f -> Printf.bprintf buf "%F" f
  | Bytes (_, b) -> Printf.bprintf buf "%S" (Bytes.to_string b)
  | Block (Immutable, { contents = 0 }, vs) ->
    Buffer.add_char buf '(';
    Array.iteri (fun i arg ->
      if i > 0 then Buffer.add_string buf ", ";
      bprint_exception_arg buf arg;
    ) vs;
    Buffer.add_char buf ')';
  | Block (Mutable, { contents = 0 }, vs) ->
    Buffer.add_string buf "[| ";
    Array.iteri (fun i arg ->
      if i > 0 then Buffer.add_string buf "; ";
      bprint_exception_arg buf arg;
    ) vs;
    Buffer.add_string buf " |]";
  | _ -> bprint_value buf arg

let pprint_exception_args name args =
  match args with
  | [] ->
    name
  | [ arg ] ->
    let buf = Buffer.create 16 in
    Printf.bprintf buf "%s %a" name bprint_exception_arg arg;
    Buffer.contents buf
  | arg0 :: rest ->
    let buf = Buffer.create 16 in
    Printf.bprintf buf "%s (%a" name bprint_exception_arg arg0;
    List.iter (fun arg -> Printf.bprintf buf ", %a" bprint_exception_arg arg) rest;
    Printf.bprintf buf ")";
    Buffer.contents buf

let pprint_exception v =
  match v with
  | Object (_, [| Bytes (_, name); Int _ |]) ->
    Bytes.to_string name
  | Block (_, { contents = 0 }, tbl) -> (
    match Array.to_list tbl with
    | Object (_, [| Bytes (_, name); Int _ |]) :: args -> pprint_exception_args (Bytes.to_string name) args
    | _ -> pprint_value v
  )
  | _ -> pprint_value v

(******************************************************************************)

let rec value_equal v1 v2 =
  match v1, v2 with
  | Int i1, Int i2 -> i1 = i2
  | Int32 i1, Int32 i2 -> Int32.equal i1 i2
  | Int64 i1, Int64 i2 -> Int64.equal i1 i2
  | Nativeint i1, Nativeint i2 -> Nativeint.equal i1 i2
  | Float x1, Float x2 -> x1 = x2
  | Float_array (_, xs1), Float_array (_, xs2) -> xs1 = xs2
  | Bytes (_, b1), Bytes (_, b2) -> b1 = b2
  | Object (_, vs1), Object (_, vs2) -> values_equal vs1 vs2
  | Block (_, tag1, vs1), Block (_, tag2, vs2) -> tag1 = tag2 && values_equal vs1 vs2
  | Closure cl1, Closure cl2 -> cl1.ofs = cl2.ofs && cl1.ptrs = cl2.ptrs && values_equal cl1.env cl2.env
  | CodePtr ptr1, CodePtr ptr2 -> ptr1 = ptr2
  | _ -> false

and values_equal vs1 vs2 =
  let len1 = Array.length vs1 and len2 = Array.length vs2 in
  if len1 <> len2 then false else (
    try
      for i = 0 to len1 - 1 do
        if not (value_equal vs1.(i) vs2.(i)) then raise Exit;
      done;
      true
    with Exit ->
      false
  )

(******************************************************************************)
(* Conversion from OByteLib.Value.t to value. *)

let make_import_value () =
  let qhtbl = Qhtbl.create () in
  let rec import_value v =
    try Qhtbl.find qhtbl v with Not_found ->
      let result =
        match v with
        | OByteLib.Value.Int           n -> Int n
        | OByteLib.Value.Int32         n -> Int32 n
        | OByteLib.Value.Int64         n -> Int64 n
        | OByteLib.Value.Nativeint     n -> Nativeint n
        | OByteLib.Value.Float         x -> Float x
        | OByteLib.Value.Float_array  xs -> Float_array (Immutable, Array.copy xs)
        | OByteLib.Value.String        s -> Bytes (Immutable, Bytes.of_string s)
        | OByteLib.Value.Object       vs -> Object (Immutable, Array.map import_value vs)
        | OByteLib.Value.Block (tag, vs) -> Block (Immutable, ref tag, Array.map import_value vs) in
      Qhtbl.put qhtbl v result;
      result in
  import_value

let import_globals globals =
  let import_value = make_import_value () in
  Array.map import_value globals

(******************************************************************************)
(* Value tools. *)

let code_ptr_of_value v =
  match v with
  | CodePtr ptr -> ptr
  | _ -> assert false

let closure_of_value v =
  match v with
  | Closure c -> c
  | _ -> assert false

let bytes_of_value v =
  match v with
  | Bytes (_mut, s) -> s
  | _ -> assert false

let int_of_value v =
  match v with
  | Int i -> i
  | _ -> assert false

let char_of_value v =
  match v with
  | Int i -> char_of_int i
  | _ -> assert false

let float_of_value v =
  match v with
  | Float x -> x
  | _ -> assert false

let object_of_value v =
  match v with
  | Object (_mut, o) -> o
  | _ -> assert false

(******************************************************************************)
(* Env tools. *)

let envacc env i =
  match env with
  | Closure { ofs; ptrs; env } ->
    let ind = i - (Array.length ptrs - ofs) * 2 + 1 in
    assert (ind >= 0 && ind < Array.length env);
    env.(ind)
  | _ ->
    assert false

let code_ptr_of_closure { ofs; ptrs; env = _ } =
  assert (ofs >= 0 && ofs < Array.length ptrs);
  ptrs.(ofs)

let code_ptr_of_env env =
  code_ptr_of_closure (closure_of_value env)

let offsetclosure env n =
  assert (n land 1 = 0);
  match env with
  | Closure { ofs; ptrs; env } -> Closure { ofs = ofs + n / 2; ptrs; env }
  | _ -> assert false

(******************************************************************************)
(* Globals tools. *)

let get_global globals i =
  assert (i >= 0 && i < Array.length globals);
  globals.(i)

let set_global globals i v =
  assert (i >= 0 && i < Array.length globals);
  globals.(i) <- v

(******************************************************************************)
(* Block tools. *)

let get_field blk i =
  match blk with
  | Block (_mut, _, values) | Object (_mut, values) ->
    assert (i >= 0 && i < Array.length values);
    values.(i)
  | _ ->
    assert false

let set_field blk i v =
  match blk with
  | Block (mut, _, values) | Object (mut, values) ->
    assert (mut = Mutable);
    assert (i >= 0 && i < Array.length values);
    values.(i) <- v;
  | _ ->
    assert false

let get_float_field blk i =
  match blk with
  | Float_array (_mut, xs) ->
    assert (i >= 0 && i < Array.length xs);
    xs.(i)
  | _ ->
    assert false

let set_float_field blk i v =
  match blk with
  | Float_array (mut, xs) ->
    assert (mut = Mutable);
    assert (i >= 0 && i < Array.length xs);
    xs.(i) <- v
  | _ ->
    assert false

let get_size blk =
  match blk with
  | Block (_mut, _tag, values) -> Array.length values
  | Float_array (_mut,values) ->
     Array.length values
     (* Printf.printf "float array is error"; assert false *)
  | _ -> assert false

(******************************************************************************)
(* Physical comparison. *)

let eq v1 v2 =
  match v1, v2 with
  | Int i1, Int i2 -> i1 = i2
  | Closure c1, Closure c2 -> c1.ofs = c2.ofs && c1.ptrs == c2.ptrs
  | v1, v2 -> v1 == v2

(******************************************************************************)
(* Find Object Method. *)

let find_object_method obj meth =
  let rec bin_search tbl meth li hi =
    if li >= hi then tbl.(li - 1) else
      let mi = ((li + hi) lsr 1) lor 1 in
      let meth' = match tbl.(mi) with Int meth' -> meth' | _ -> assert false in
      if meth < meth' then bin_search tbl meth li (mi - 2)
      else bin_search tbl meth mi hi
  in
  assert (Array.length obj > 0);
  let tbl = match obj.(0) with Block (_mut, { contents = 0 }, tbl) -> tbl | _ -> assert false in
  let hi = match tbl.(0) with Int hi -> (hi lsl 1) lor 1 | _ -> assert false in
  bin_search tbl meth 3 hi

(******************************************************************************)
(* C Primitive Call. *)

let get_prim prims idx =
  assert (idx >= 0 && idx < Array.length prims);
  prims.(idx)

let caml_array_concat lst =
  let rec to_list acc lst =
    match lst with
    | Int 0 -> acc
    | Block (_mut0, { contents = 0 }, [| Block (_mut1, { contents = 0 }, v); rest |]) -> to_list (v :: acc) rest
    | _ -> assert false in
  let l = List.rev (to_list [] lst) in
  let tbl = Array.concat l in
  Block (Mutable, ref 0, tbl)

let caml_hash =
  let trunc n = Int64.logand n 0xFFFF_FFFFL in
  let mul n p = trunc (Int64.mul (trunc n) (trunc p)) in
  let add n p = trunc (Int64.add (trunc n) (trunc p)) in
  let rec hash arch count limit h v =
    if !count <= 1 || !limit = 0 then h else (
      decr count;
      match v with
      | Int i ->
        decr limit;
        add (mul h 223L) (Int64.of_int (2 * i + 1))
      | Int32 _ | Int64 _ | Nativeint _ ->
        (* TODO: mangage custom blocks *)
        Printf.eprintf "Warning: caml_hash: fail to hash custom block";
        raise Exit
      | Float _ | Float_array _ ->
        (* TODO: mangage floats *)
        Printf.eprintf "Warning: caml_hash: fail to hash float";
        raise Exit
      | Bytes (_mut, b) ->
        let len = Bytes.length b in
        let blk_wolen = len / Arch.byte_count arch + 1 in
        let blk_bylen = blk_wolen * Arch.byte_count arch in
        let get i =
          if i < len then int_of_char (Bytes.get b i)
          else if i = blk_bylen - 1 then blk_bylen - len - 1
          else 0 in
        let h = ref (add (mul h 223L) (Int64.of_int Obj.string_tag)) in
        for i = 0 to blk_wolen - 1 do
          let w = ref 0 in
          for j = Arch.byte_count arch - 1 downto 0 do
            w := !w * 256 + get (i * Arch.byte_count arch + j);
          done;
          h := add (mul !h 223L) (Int64.of_int !w);
        done;
        if !limit < blk_wolen then limit := 0
        else limit := !limit - blk_wolen;
        !h
      | Object (_mut, tbl) -> (
        match tbl.(1) with
        | exception _ -> assert false (* Impossible *)
        | Int i -> decr limit; add (mul h 223L) (Int64.of_int (2 * i + 1))
        | _ -> assert false (* Impossible *)
      )
      | Block (_mut, { contents = tag }, tbl) ->
        let sz = Array.length tbl in
        let h = add (mul h 223L) (Int64.of_int tag) in
        let rec loop h i =
          if i = sz then h else (
            let h = hash arch count limit h tbl.(i) in
            if !count = 0 || !limit = 0 then h
            else loop h (i + 1)
          ) in
        loop h 0
      | Closure _ ->
        (* TODO: manage closures *)
        Printf.eprintf "Warning: caml_hash: fail to hash closure";
        raise Exit
      | CodePtr _ ->
        (* TODO: manage code pointers *)
        Printf.eprintf "Warning: caml_hash: fail to hash code pointer";
        raise Exit
    ) in
  fun arch count limit seed v ->
    Int64.to_int (Int64.logand (hash arch (ref count) (ref limit) (trunc (Int64.of_int seed)) v) 0x3FFF_FFFFL)

let rec caml_compare v0 v1 =
  match v0, v1 with
  | Int i0, Int i1 -> compare i0 i1
  | Int32 i0, Int32 i1 -> Int32.compare i0 i1
  | Int64 i0, Int64 i1 -> Int64.compare i0 i1
  | Nativeint i0, Nativeint i1 -> Nativeint.compare i0 i1
  | Float f0, Float f1 -> compare f0 f1 (* May be incorrect with runtime representation of floats *)
  | Float_array (_mut0, tbl0), Float_array(_mut1, tbl1) -> compare tbl0 tbl1
  | Bytes (_mut0, b0), Bytes (_mut1, b1) -> Bytes.compare b0 b1
  | Object (_mut0, tbl0), Object (_mut1, tbl1) -> caml_compare_arrays tbl0 tbl1
  | Block (_mut0, tag0, tbl0), Block (_mut1, tag1, tbl1) ->
     if tag0 < tag1 then -1
     else if tag0 > tag1 then 1
     else caml_compare_arrays tbl0 tbl1
  | Closure _, Closure _ -> invalid_arg "compare: functional value"
  | CodePtr _, CodePtr _ -> invalid_arg "compare: functional value"
  | _ -> Printf.eprintf "Warning: caml_compare: fail to compare some values\n%!"; raise Exit

and caml_compare_arrays tbl0 tbl1 =
  let len0 = Array.length tbl0 in
  let len1 = Array.length tbl1 in
  if len0 < len1 then -1
  else if len0 > len1 then 1
  else
    let rec loop i =
      if i = len0 then 0 else
        let c = caml_compare tbl0.(i) tbl1.(i) in
        if c = 0 then loop (i + 1) else c in
    loop 0

external format_float : string -> float -> string = "caml_format_float"
external format_int : string -> int -> string = "caml_format_int"

let ccall arch ooid prim args =
  match prim, args with
  | "caml_abs_float", [ Float x ] -> Float (abs_float x)
  | "caml_acos_float", [ Float x ] -> Float (acos x)
  | "caml_add_float", [ Float x; Float y ] -> Float (x +. y)
  | "caml_sub_float", [ Float x; Float y ] -> Float (x -. y)
  | "caml_mul_float", [ Float x; Float y ] -> Float (x *. y)
  | "caml_div_float", [ Float x; Float y ] -> Float (x /. y)
  | "caml_ge_float",  [ Float x; Float y ] -> Int (if x >= y then 1 else 0)
  | "caml_le_float",  [ Float x; Float y ] -> Int (if x <= y then 1 else 0)
  | "caml_lt_float",  [ Float x; Float y ] -> Int (if x <  y then 1 else 0)
  | "caml_gt_float",  [ Float x; Float y ] -> Int (if x >  y then 1 else 0)
  | "caml_eq_float",  [ Float x; Float y ] -> Int (if x =  y then 1 else 0)
  | "caml_neq_float", [ Float x; Float y ] -> Int (if x <> y then 1 else 0)
  | "caml_array_append", [ Block (_mut0, { contents = 0 }, v0); Block (_mut1, { contents = 0 }, v1) ] -> Block (Mutable, ref 0, Array.append v0 v1)
  | "caml_array_blit", [ Block (_mut0, { contents = 0 }, v0); Int s0; Block (mut1, { contents = 0 }, v1); Int s1; Int len ] -> assert (mut1 = Mutable); Array.blit v0 s0 v1 s1 len; Int 0
  | "caml_array_concat", [ lst ] -> caml_array_concat lst
  | "caml_array_sub", [ Block (_mut, { contents = 0 }, v); Int ofs; Int len ] -> Block (Mutable, ref 0, Array.sub v ofs len)
  | ("caml_array_get_addr" | "caml_array_unsafe_get" | "caml_array_get"), [ Block (_mut, { contents = 0 }, tbl); Int ind ] -> Array.get tbl ind
  | ("caml_array_get_addr" | "caml_array_unsafe_get" | "caml_array_get"), [ Float_array (_mut, tbl); Int ind ] -> Float (Array.get tbl ind)
  | ("caml_array_set_addr" | "caml_array_unsafe_set" | "caml_array_set"), [ Block (_mut, { contents = 0 }, tbl); Int ind; v ] -> Array.set tbl ind v; Int 0
  | ("caml_floatarray_set"), [ Float_array (_mut, tbl); Int ind; (Float v) ] -> Array.set tbl ind v; Int 0
  | ("caml_floatarray_get"), [ Float_array (_mut, tbl); Int ind ] -> Float (Array.get tbl ind)
  | "caml_array_unsafe_set", [ Object (_mut, values); Int ind; v ] -> Array.set values ind v; Int 0
  | "caml_array_make_vect", [ Int len; init ] -> Block (Mutable, ref 0, Array.make len init)
  | "caml_asin_float", [ Float x ] -> Float (asin x)
  | "caml_atan2_float", [ Float x; Float y ] -> Float (atan2 x y)
  | "caml_atan_float", [ Float x ] -> Float (atan x)
  | ("caml_blit_bytes" | "caml_blit_string"), [ Bytes (_mut0, b0); Int s0; Bytes (mut1, b1); Int s1; Int len ] -> assert (mut1 = Mutable); Bytes.blit b0 s0 b1 s1 len; Int 0
  | "caml_bytes_equal", [ Bytes (_mut0, b0); Bytes (_mut1, b1) ] -> if Bytes.equal b0 b1 then Int 1 else Int 0
  | "caml_ceil_float", [ Float x ] -> Float (ceil x)
  | "caml_classify_float", [ Float x ] -> (match classify_float x with FP_normal -> Int 0 | FP_subnormal -> Int 1 | FP_zero -> Int 2 | FP_infinite -> Int 3 | FP_nan -> Int 4)
  | "caml_copysign_float", [ Float x; Float y ] -> Float (copysign x y)
  | "caml_cos_float", [ Float x ] -> Float (cos x)
  | "caml_cosh_float", [ Float x ] -> Float (cosh x)
  | "caml_create_bytes", [ Int size ] -> Bytes (Mutable, Bytes.make size '\x00')
  | "caml_create_string", [ Int size ] -> Bytes (Immutable, Bytes.make size '\x00')
  | "caml_ml_string_length", [ Bytes (_mut, b) ] -> Int (Bytes.length b)
  | "caml_string_get", [ Bytes (_mut, b); Int n ] -> Int (int_of_char (Bytes.get b n))
  | "caml_exp_float", [ Float x ] -> Float (exp x)
  | "caml_expm1_float", [ Float x ] -> Float (expm1 x)
  | ("caml_fill_bytes" | "caml_fill_string"), [ Bytes (mut, b); Int ofs; Int len; Int c ] -> assert (mut = Mutable); Bytes.fill b ofs len (char_of_int c); Int 0
  | "caml_float_of_string", [ Bytes (_mut, b) ] -> Float (float_of_string (Bytes.unsafe_to_string b))
  | "caml_float_of_int", [ Int i ] -> Float (float_of_int i)
  | "caml_neg_float", [ Float f ] -> Float (-. f)
  | "caml_floor_float", [ Float x ] -> Float (floor x)
  | "caml_fmod_float", [ Float x; Float y ] -> Float (mod_float x y)
  | "caml_format_float", [ Bytes (_mut, b); Float x ] -> Bytes (Immutable, Bytes.of_string (format_float (Bytes.to_string b) x))
  | "caml_string_of_float", [ Float x ] -> Bytes (Immutable, Bytes.of_string (format_float "%.3g" x))
  | "format_int", [ Bytes (_mut, b); Int i ] -> Bytes (Immutable, Bytes.of_string (format_int (Bytes.to_string b) i))
  | ("caml_string_of_int" | "string_of_int"), [ Int i ] -> Bytes (Immutable, Bytes.of_string (format_int "%d" i))
  | "caml_frexp_float", [ Float x ] -> let y, i = frexp x in Block (Immutable, ref 0, [| Float y; Int i |])
  | "caml_gc_compaction", [ Int 0 ] -> Gc.compact (); Int 0
  | "caml_gc_counters", [ Int 0 ] -> let x, y, z = Gc.counters () in Block (Immutable, ref 0, [| Float x; Float y; Float z |])
  | "caml_gc_full_major", [ Int 0 ] -> Gc.full_major (); Int 0
  | "caml_gc_huge_fallback_count", [ Int 0 ] -> Int (Gc.huge_fallback_count ())
  | "caml_gc_major", [ Int 0 ] -> Gc.major (); Int 0
  | "caml_gc_major_slice", [ Int i ] -> Int (Gc.major_slice i)
  | "caml_gc_minor", [ Int 0 ] -> Gc.minor (); Int 0
  | "caml_gc_minor_words", [ Int 0 ] -> Float (Gc.minor_words ())
  | "caml_get_major_bucket", [ Int i ] -> Int (Gc.get_bucket i)
  | "caml_get_major_credit", [ Int 0 ] -> Int (Gc.get_credit ())
  | "caml_get_minor_free", [ Int 0 ] -> Int (Gc.get_minor_free ())
  | "caml_get_public_method", [ Object (_mut, obj); Int tag ] -> find_object_method obj tag
  | "caml_hash", [ Int count; Int limit; Int seed; v ] -> Int (caml_hash arch count limit seed v)
  | "caml_hypot_float", [ Float x; Float y ] -> Float (hypot x y)
  | "caml_int32_bits_of_float", [ Float x ] -> Int32 (Int32.bits_of_float x)
  | "caml_int32_float_of_bits", [ Int32 i ] -> Float (Int32.float_of_bits i)
  | "caml_string_of_int32", [ Int32 i ] -> Bytes (Immutable, Bytes.unsafe_of_string (Int32.to_string i))
  | "caml_int32_of_float", [ Float x ] -> Int32 (Int32.of_float x)
  | "caml_int32_of_string", [ Bytes (_mut, b) ] -> Int32 (Int32.of_string (Bytes.unsafe_to_string b))
  | "caml_int32_to_float", [ Int32 i ] -> Float (Int32.to_float i)
  | "caml_int64_bits_of_float", [ Float x ] -> Int64 (Int64.bits_of_float x)
  | "caml_int64_float_of_bits", [ Int64 i ] -> Float (Int64.float_of_bits i)
  | "caml_string_of_int64", [ Int64 i ] -> Bytes (Immutable, Bytes.unsafe_of_string (Int64.to_string i))
  | "caml_int64_of_float", [ Float x ] -> Int64 (Int64.of_float x)
  | "caml_int64_of_string", [ Bytes (_mut, b) ] -> Int64 (Int64.of_string (Bytes.unsafe_to_string b))
  | "caml_int64_to_float", [ Int64 i ] -> Float (Int64.to_float i)
  | "caml_int_of_string", [ Bytes (_mut, b) ] -> Int (int_of_string (Bytes.unsafe_to_string b))
  | "caml_ldexp_float", [ Float x; Int i ] -> Float (ldexp x i)
  | "caml_log10_float", [ Float x ] -> Float (log10 x)
  | "caml_log1p_float", [ Float x ] -> Float (log1p x)
  | "caml_log_float", [ Float x ] -> Float (log x)
  | "caml_make_float_vect", [ Int i ] -> Float_array (Mutable, Array.create_float i)
  | "caml_make_vect", [ Int 0; _ ] -> Block (Mutable, ref 0, [||])
  | "caml_make_vect", [ Int i; Float x ] -> Float_array (Mutable, Array.make i x)
  | "caml_make_vect", [ Int i; v ] -> Block (Mutable, ref 0, Array.make i v)
  | "caml_modf_float", [ Float x ] -> let y, z = modf x in Block (Immutable, ref 0, [| Float y; Float z |])
  | "caml_int_of_float", [ Float x ] -> Int (int_of_float x)
  | "caml_nativeint_of_float", [ Float x ] -> Nativeint (Nativeint.of_float x)
  | "caml_nativeint_of_string", [ Bytes (_mut, b) ] -> Nativeint (Nativeint.of_string (Bytes.unsafe_to_string b))
  | "caml_nativeint_to_float", [ Nativeint i ] -> Float (Nativeint.to_float i)
  | "caml_power_float", [ Float x; Float y ] -> Float (x ** y)
  | "caml_sin_float", [ Float x ] -> Float (sin x)
  | "caml_sinh_float", [ Float x ] -> Float (sinh x)
  | "caml_sqrt_float", [ Float x ] -> Float (sqrt x)
  | "caml_string_equal", [ Bytes (_mut1, b1); Bytes (_mut2, b2) ] -> if Bytes.equal b1 b2 then Int 1 else Int 0
  | "caml_tan_float", [ Float x ] -> Float (tan x)
  | "caml_tanh_float", [ Float x ] -> Float (tanh x)
  | "caml_fresh_oo_id", [ Int 0 ] -> Int (incr ooid; pred !ooid)
  | "caml_set_oo_id", [ Object (_mut, values) as obj ] -> values.(1) <- Int !ooid; incr ooid; obj
  | "caml_obj_dup", [ Block (_mut, { contents = tag }, tbl) ] -> Block (Mutable, ref tag, Array.copy tbl)
  | "caml_obj_block", [ Int tag; Int size ] -> if tag = Obj.object_tag then Object (Mutable, Array.make size (Int 0)) else Block (Mutable, ref tag, Array.make size (Int 0))
  | "caml_unsafe_string_of_bytes", [ Bytes (_mut, b) ] -> Bytes (Immutable, Bytes.copy b)
  | "caml_unsafe_bytes_of_string", [ Bytes (_mut, b) ] -> Bytes (Mutable, Bytes.copy b)
  | "caml_sys_const_big_endian", [ Int 0 ] -> Int 0
  | "caml_sys_const_word_size", [ Int 0 ] -> Int (Arch.bit_count arch)
  | "caml_sys_const_int_size", [ Int 0 ] -> Int (Arch.bit_count arch - 1)
  | "caml_sys_const_max_wosize", [ Int 0 ] -> Int (1 lsl (Arch.hd_size_bitcnt arch) - 1)
  | "caml_random_bits", [ Int 0 ] -> Int (Random.bits ())
  | "caml_compare", [ v0; v1 ] -> Int (caml_compare v0 v1)
  | "caml_string_compare", [ Bytes (_mut1, b1); Bytes (_mut2, b2) ] -> Int (Bytes.compare b1 b2)
  | "caml_string_notequal", [ Bytes (_mut1, b1); Bytes (_mut2, b2) ] -> if Bytes.equal b1 b2 then Int 0 else Int 1
  | "caml_int_compare", [ Int n1; Int n2 ] -> Int (compare n1 n2)
  | "caml_alloc_dummy", [ Int sz ] -> Block (Mutable, ref 0, Array.make sz (Int 0))
  | "caml_alloc_dummy_function", [ Int sz; Int _ ] -> Closure { ofs = 0; ptrs = [||]; env = Array.make sz (Int 0) }
  | "caml_update_dummy", [ Block (_mut1, tag1, tbl1); Block (_mut2, tag2, tbl2) ] -> assert (Array.length tbl1 = Array.length tbl2); tag1 := !tag2; Array.blit tbl2 0 tbl1 0 (Array.length tbl1); Int 0
  | "caml_update_dummy", [ Closure dummy; Closure newval ] -> dummy.ofs <- newval.ofs; dummy.ptrs <- Array.copy newval.ptrs; dummy.env <- Array.copy newval.env; Int 0
  | "caml_gc_run", [ Int 0 ] -> Int 0
  | "caml_equal", [ v1; v2 ] -> if value_equal v1 v2 then Int 1 else Int 0
  | _ ->
    begin
      match prim with
      | "caml_set_bit" | "caml_clear_bit" | "caml_read_bit"
      | "caml_delay" | "caml_millis"
      | "caml_write_register" | "caml_read_register"
      | "caml_debug_trace" | "caml_debug_tracei"
      | "caml_random_init" | "caml_random_bits" | "caml_random_bool"
      | "caml_avr_serial_init" | "caml_avr_serial_write" | "caml_avr_serial_read"
      | "caml_microbit_print_string" | "caml_microbit_print_int"
      | "caml_microbit_write_pixel" | "caml_microbit_print_image" | "caml_microbit_clear_screen"
      | "caml_microbit_button_is_pressed"
      | "caml_microbit_pin_mode"
      | "caml_microbit_digital_write" | "caml_microbit_digital_read"
      | "caml_microbit_analog_write" | "caml_microbit_analog_read"
      | "caml_microbit_serial_write" | "caml_microbit_serial_read"
      | "caml_microbit_spi_init_master" | "caml_microbit_spi_transmit"
      | "caml_microbit_accelerometer_x" | "caml_microbit_accelerometer_y" | "caml_microbit_accelerometer_z"
      | "caml_microbit_accelerometer_pitch" | "caml_microbit_accelerometer_roll"
      | "caml_microbit_compass_calibrate" | "caml_microbit_compass_heading"
      | "caml_microbit_radio_init" | "caml_microbit_radio_send" | "caml_microbit_radio_recv"
      | "caml_microbit_i2c_init" | "caml_microbit_i2c_write" | "caml_microbit_i2c_read" -> ()
      | _ ->
        let print_arg arg =
          let buf = Buffer.create 16 in
          bprint_value buf arg;
          Buffer.output_buffer stderr buf in
        let rec print_args args =
          match args with
          | [] -> ()
          | [ last ] -> print_arg last
          | arg :: rest -> print_arg arg; Printf.eprintf ", "; print_args rest in
        Printf.eprintf "Warning: unknown primitive %S(" prim;
        print_args args;
        Printf.eprintf ").\n%!"
    end;
    raise Exit

(******************************************************************************)

let exec arch prims globals code cycle_limit =
  let globals = import_globals globals in
  let code_size = Array.length code in

  let ooid = ref 0 in
  let unit = Int 0 in
  let accu = ref unit in
  let pc = ref 0 in
  let env = ref unit in
  let extra_args = ref 0 in
  let trap_sp = ref (-1) in
  let stack = ref [] in

  let cycle_count = ref 0 in
  let last_valid_cycle = ref 0 in

  try
    while true do
      if !cycle_count = cycle_limit then raise Exit;
      if !env = unit && !trap_sp = -1 then last_valid_cycle := !cycle_count;
      incr cycle_count;

      assert (!pc >= 0 && !pc < code_size);

      match code.(!pc) with
      | ACC0 ->
        accu := acc stack 0;
        incr pc;
      | ACC1 ->
        accu := acc stack 1;
        incr pc;
      | ACC2 ->
        accu := acc stack 2;
        incr pc;
      | ACC3 ->
        accu := acc stack 3;
        incr pc;
      | ACC4 ->
        accu := acc stack 4;
        incr pc;
      | ACC5 ->
        accu := acc stack 5;
        incr pc;
      | ACC6 ->
        accu := acc stack 6;
        incr pc;
      | ACC7 ->
        accu := acc stack 7;
        incr pc;
      | ACC n ->
        accu := acc stack n;
        incr pc;

      | PUSH | PUSHACC0 ->
        push stack !accu;
        incr pc;
      | PUSHACC1 ->
        push stack !accu;
        accu := acc stack 1;
        incr pc;
      | PUSHACC2 ->
        push stack !accu;
        accu := acc stack 2;
        incr pc;
      | PUSHACC3 ->
        push stack !accu;
        accu := acc stack 3;
        incr pc;
      | PUSHACC4 ->
        push stack !accu;
        accu := acc stack 4;
        incr pc;
      | PUSHACC5 ->
        push stack !accu;
        accu := acc stack 5;
        incr pc;
      | PUSHACC6 ->
        push stack !accu;
        accu := acc stack 6;
        incr pc;
      | PUSHACC7 ->
        push stack !accu;
        accu := acc stack 7;
        incr pc;
      | PUSHACC n ->
        push stack !accu;
        accu := acc stack n;
        incr pc;

      | POP n ->
        popn stack n;
        incr pc;

      | ASSIGN n ->
        assign stack n !accu;
        accu := unit;
        incr pc;

      | ENVACC1 ->
        accu := envacc !env 1;
        incr pc;
      | ENVACC2 ->
        accu := envacc !env 2;
        incr pc;
      | ENVACC3 ->
        accu := envacc !env 3;
        incr pc;
      | ENVACC4 ->
        accu := envacc !env 4;
        incr pc;
      | ENVACC n ->
        accu := envacc !env n;
        incr pc;

      | PUSHENVACC1 ->
        push stack !accu;
        accu := envacc !env 1;
        incr pc;
      | PUSHENVACC2 ->
        push stack !accu;
        accu := envacc !env 2;
        incr pc;
      | PUSHENVACC3 ->
        push stack !accu;
        accu := envacc !env 3;
        incr pc;
      | PUSHENVACC4 ->
        push stack !accu;
        accu := envacc !env 4;
        incr pc;
      | PUSHENVACC n ->
        push stack !accu;
        accu := envacc !env n;
        incr pc;

      | PUSH_RETADDR ptr ->
        push stack (Int !extra_args);
        push stack !env;
        push stack (CodePtr ptr);
        incr pc;
      | APPLY n ->
        extra_args := n - 1;
        env := !accu;
        pc := code_ptr_of_env !env;

      | APPLY1 ->
        let arg = pop stack in
        push stack (Int !extra_args);
        push stack !env;
        push stack (CodePtr (!pc + 1));
        push stack arg;
        extra_args := 0;
        env := !accu;
        pc := code_ptr_of_env !env;
      | APPLY2 ->
        let arg1 = pop stack in
        let arg2 = pop stack in
        push stack (Int !extra_args);
        push stack !env;
        push stack (CodePtr (!pc + 1));
        push stack arg2;
        push stack arg1;
        extra_args := 1;
        env := !accu;
        pc := code_ptr_of_env !env;
      | APPLY3 ->
        let arg1 = pop stack in
        let arg2 = pop stack in
        let arg3 = pop stack in
        push stack (Int !extra_args);
        push stack !env;
        push stack (CodePtr (!pc + 1));
        push stack arg3;
        push stack arg2;
        push stack arg1;
        extra_args := 2;
        env := !accu;
        pc := code_ptr_of_env !env;

      | APPTERM (n, s) ->
        for i = 0 to n - 1 do
          assign stack (s - i - 1) (acc stack (n - i - 1));
        done;
        popn stack (s - n);
        extra_args := !extra_args + n - 1;
        env := !accu;
        pc := code_ptr_of_env !env;
      | APPTERM1 s ->
        assign stack (s - 1) (acc stack 0);
        popn stack (s - 1);
        env := !accu;
        pc := code_ptr_of_env !env;
      | APPTERM2 s ->
        assign stack (s - 1) (acc stack 1);
        assign stack (s - 2) (acc stack 0);
        popn stack (s - 2);
        incr extra_args;
        env := !accu;
        pc := code_ptr_of_env !env;
      | APPTERM3 s ->
        assign stack (s - 1) (acc stack 2);
        assign stack (s - 2) (acc stack 1);
        assign stack (s - 3) (acc stack 0);
        popn stack (s - 3);
        extra_args := !extra_args + 2;
        env := !accu;
        pc := code_ptr_of_env !env;

      | RETURN n ->
        popn stack n;
        if !extra_args = 0 then (
          pc         := code_ptr_of_value (pop stack);
          env        := pop stack;
          extra_args := int_of_value (pop stack);
        ) else (
          decr extra_args;
          env := !accu;
          pc := code_ptr_of_env !env;
        )

      | RESTART ->
        let closure = closure_of_value !env in
        let n = Array.length closure.env - 1 in
        for i = n downto 1 do push stack closure.env.(i) done;
        env := closure.env.(0);
        extra_args := !extra_args + n;
        incr pc;
      | GRAB n ->
        if !extra_args >= n then (
          extra_args := !extra_args - n;
          incr pc;
        ) else (
          let blk = Array.make (!extra_args + 2) !env in
          for i = 1 to !extra_args + 1 do blk.(i) <- pop stack done;
          accu       := Closure { ofs = 0; ptrs = [| !pc - 1 |]; env = blk };
          pc         := code_ptr_of_value (pop stack);
          env        := pop stack;
          extra_args := int_of_value (pop stack);
        )

      | CLOSURE (n, ptr) ->
        let blk = Array.make n !accu in
        for i = 1 to n - 1 do blk.(i) <- pop stack done;
        accu := Closure { ofs = 0; ptrs = [| ptr |]; env = blk };
        incr pc;
      | CLOSUREREC (_f, v, o, t) ->
        let blk = Array.make v !accu in
        for i = 1 to v - 1 do blk.(i) <- pop stack done;
        let ptrs = Array.make (Array.length t + 1) o in
        Array.blit t 0 ptrs 1 (Array.length t);
        accu := Closure { ofs = 0; ptrs; env = blk };
        push stack !accu;
        for i = 1 to Array.length t do
          push stack (Closure { ofs = i; ptrs; env = blk });
        done;
        incr pc;

      | OFFSETCLOSUREM2 ->
        accu := offsetclosure !env (-2);
        incr pc;
      | OFFSETCLOSURE0 ->
        accu := offsetclosure !env 0;
        incr pc;
      | OFFSETCLOSURE2 ->
        accu := offsetclosure !env 2;
        incr pc;
      | OFFSETCLOSURE n ->
        accu := offsetclosure !env n;
        incr pc;

      | PUSHOFFSETCLOSUREM2 ->
        push stack !accu;
        accu := offsetclosure !env (-2);
        incr pc;
      | PUSHOFFSETCLOSURE0 ->
        push stack !accu;
        accu := offsetclosure !env 0;
        incr pc;
      | PUSHOFFSETCLOSURE2 ->
        push stack !accu;
        accu := offsetclosure !env 2;
        incr pc;
      | PUSHOFFSETCLOSURE n ->
        push stack !accu;
        accu := offsetclosure !env n;
        incr pc;

      | GETGLOBAL n ->
        accu := get_global globals n;
        incr pc;
      | PUSHGETGLOBAL n ->
        push stack !accu;
        accu := get_global globals n;
        incr pc;
      | GETGLOBALFIELD (n, p) ->
        accu := get_field (get_global globals n) p;
        incr pc;
      | PUSHGETGLOBALFIELD (n, p) ->
        push stack !accu;
        accu := get_field (get_global globals n) p;
        incr pc;
      | SETGLOBAL n ->
        set_global globals n !accu;
        accu := unit;
        incr pc;

      | ATOM0 ->
        accu := Block (Immutable, ref 0, [||]);
        incr pc;
      | ATOM tag ->
        accu := Block (Immutable, ref tag, [||]);
        incr pc;
      | PUSHATOM0 ->
        push stack !accu;
        accu := Block (Immutable, ref 0, [||]);
        incr pc;
      | PUSHATOM tag ->
        push stack !accu;
        accu := Block (Immutable, ref tag, [||]);
        incr pc;

      | MAKEBLOCK (tag, sz) ->
        let blk = Array.make sz !accu in
        for i = 1 to sz - 1 do blk.(i) <- pop stack done;
        accu := if tag = Obj.object_tag then Object (Mutable, blk) else Block (Mutable, ref tag, blk);
        incr pc;
      | MAKEBLOCK1 tag ->
        let blk = [| !accu |] in
        accu := if tag = Obj.object_tag then Object (Mutable, blk) else Block (Mutable, ref tag, blk);
        incr pc;
      | MAKEBLOCK2 tag ->
        let blk = [| !accu; pop stack |] in
        accu := if tag = Obj.object_tag then Object (Mutable, blk) else Block (Mutable, ref tag, blk);
        incr pc;
      | MAKEBLOCK3 tag ->
        let v1 = pop stack in
        let v2 = pop stack in
        let blk = [| !accu; v1; v2 |] in
        accu := if tag = Obj.object_tag then Object (Mutable, blk) else Block (Mutable, ref tag, blk);
        incr pc;
      | MAKEFLOATBLOCK sz ->
        let blk = Array.make sz (float_of_value !accu) in
        for i = 1 to sz - 1 do blk.(i) <- float_of_value (pop stack) done;
        accu := Float_array (Mutable, blk);
        incr pc;

      | GETFIELD0 ->
        accu := get_field !accu 0;
        incr pc;
      | GETFIELD1 ->
        accu := get_field !accu 1;
        incr pc;
      | GETFIELD2 ->
        accu := get_field !accu 2;
        incr pc;
      | GETFIELD3 ->
        accu := get_field !accu 3;
        incr pc;
      | GETFIELD n ->
        accu := get_field !accu n;
        incr pc;
      | GETFLOATFIELD ind ->
        accu := Float (get_float_field !accu ind);
        incr pc;

      | SETFIELD0 ->
        set_field !accu 0 (pop stack);
        accu := unit;
        incr pc;
      | SETFIELD1 ->
        set_field !accu 1 (pop stack);
        accu := unit;
        incr pc;
      | SETFIELD2 ->
        set_field !accu 2 (pop stack);
        accu := unit;
        incr pc;
      | SETFIELD3 ->
        set_field !accu 3 (pop stack);
        accu := unit;
        incr pc;
      | SETFIELD n ->
        set_field !accu n (pop stack);
        accu := unit;
        incr pc;
      | SETFLOATFIELD ind ->
        set_float_field !accu ind (float_of_value (pop stack));
        accu := unit;
        incr pc;

      | VECTLENGTH ->
        accu := Int (get_size !accu);
        incr pc;
      | GETVECTITEM ->
        accu := get_field !accu (int_of_value (pop stack));
        incr pc;
      | SETVECTITEM ->
        let i = pop stack in
        let v = pop stack in
        set_field !accu (int_of_value i) v;
        accu := unit;
        incr pc;

      | GETBYTESCHAR | GETSTRINGCHAR ->
        accu := Int (int_of_char (Bytes.get (bytes_of_value !accu) (int_of_value (pop stack))));
        incr pc;
      | SETBYTESCHAR ->
        let i = pop stack in
        let c = pop stack in
        Bytes.set (bytes_of_value !accu) (int_of_value i) (char_of_value c);
        accu := unit;
        incr pc;

      | BRANCH ptr ->
        pc := ptr;
      | BRANCHIF ptr ->
        if !accu <> Int 0 then pc := ptr else incr pc;
      | BRANCHIFNOT ptr ->
        if !accu = Int 0 then pc := ptr else incr pc;
      | SWITCH (n, ptrs) ->
        let ind =
          match !accu with
          | Int i -> i
          | Block (_mut, { contents = tag }, _values) -> tag + n land 0xFFFF
          | _ -> assert false in
        assert (ind >= 0 && ind < Array.length ptrs);
        pc := ptrs.(ind);

      | BOOLNOT ->
        accu := (match !accu with Int 0 -> Int 1 | Int 1 -> Int 0 | _ -> assert false);
        incr pc;

      | PUSHTRAP ptr ->
        push stack (Int !extra_args);
        push stack !env;
        push stack (Int !trap_sp);
        push stack (CodePtr ptr);
        trap_sp := List.length !stack;
        incr pc;
      | POPTRAP ->
        trap_sp := int_of_value (acc stack 1);
        popn stack 4;
        incr pc;
      | RAISE | RERAISE | RAISE_NOTRACE ->
        if !trap_sp = -1 then failwith (Printf.sprintf "Evaluation failed: uncaught exception: %s.\n" (pprint_exception !accu));
        let ofs = List.length !stack - !trap_sp in
        popn stack ofs;
        pc         := code_ptr_of_value (pop stack);
        trap_sp    := int_of_value (pop stack);
        env        := pop stack;
        extra_args := int_of_value (pop stack);

      | CHECK_SIGNALS ->
        incr pc;

      | C_CALL1 idx ->
        accu := ccall arch ooid (get_prim prims idx) [ !accu ];
        incr pc;
      | C_CALL2 idx ->
        accu := ccall arch ooid (get_prim prims idx) [ !accu; pop stack ];
        incr pc;
      | C_CALL3 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        accu := ccall arch ooid (get_prim prims idx) [ !accu; v1; v2 ];
        incr pc;
      | C_CALL4 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        let v3 = pop stack in
        accu := ccall arch ooid (get_prim prims idx) [ !accu; v1; v2; v3 ];
        incr pc;
      | C_CALL5 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        let v3 = pop stack in
        let v4 = pop stack in
        accu := ccall arch ooid (get_prim prims idx) [ !accu; v1; v2; v3; v4 ];
        incr pc;
      | C_CALLN (narg, idx) ->
        let args = ref [ !accu ] in
        for _i = 2 to narg do args := pop stack :: !args done;
        accu := ccall arch ooid (get_prim prims idx) (List.rev !args);
        incr pc;

      | CONST0 ->
        accu := Int 0;
        incr pc;
      | CONST1 ->
        accu := Int 1;
        incr pc;
      | CONST2 ->
        accu := Int 2;
        incr pc;
      | CONST3 ->
        accu := Int 3;
        incr pc;
      | CONSTINT n ->
        accu := Int n;
        incr pc;

      | PUSHCONST0 ->
        push stack !accu;
        accu := Int 0;
        incr pc;
      | PUSHCONST1 ->
        push stack !accu;
        accu := Int 1;
        incr pc;
      | PUSHCONST2 ->
        push stack !accu;
        accu := Int 2;
        incr pc;
      | PUSHCONST3 ->
        push stack !accu;
        accu := Int 3;
        incr pc;
      | PUSHCONSTINT n ->
        push stack !accu;
        accu := Int n;
        incr pc;

      | NEGINT ->
        accu := Int (Arch.normalize_int arch (- (int_of_value !accu)));
        incr pc;
      | ADDINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu + int_of_value (pop stack)));
        incr pc;
      | SUBINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu - int_of_value (pop stack)));
        incr pc;
      | MULINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu * int_of_value (pop stack)));
        incr pc;
      | DIVINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu / int_of_value (pop stack)));
        incr pc;
      | MODINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu mod int_of_value (pop stack)));
        incr pc;
      | ANDINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu land int_of_value (pop stack)));
        incr pc;
      | ORINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu lor int_of_value (pop stack)));
        incr pc;
      | XORINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu lxor int_of_value (pop stack)));
        incr pc;
      | LSLINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu lsl int_of_value (pop stack)));
        incr pc;
      | LSRINT ->
        let n = int_of_value !accu in
        let n = match arch with Arch.A16 -> n land 0x7F_FF | Arch.A32 -> n land 0x7FFF_FFFF | Arch.A64 -> n in
        accu := Int (Arch.normalize_int arch (n lsr int_of_value (pop stack)));
        incr pc;
      | ASRINT ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu asr int_of_value (pop stack)));
        incr pc;

      | EQ ->
        accu := if eq !accu (pop stack) then Int 1 else Int 0;
        incr pc;
      | NEQ ->
        accu := if eq !accu (pop stack) then Int 0 else Int 1;
        incr pc;

      | LTINT ->
        accu := if int_of_value !accu < int_of_value (pop stack) then Int 1 else Int 0;
        incr pc;
      | LEINT ->
        accu := if int_of_value !accu <= int_of_value (pop stack) then Int 1 else Int 0;
        incr pc;
      | GTINT ->
        accu := if int_of_value !accu > int_of_value (pop stack) then Int 1 else Int 0;
        incr pc;
      | GEINT ->
        accu := if int_of_value !accu >= int_of_value (pop stack) then Int 1 else Int 0;
        incr pc;

      | OFFSETINT ofs ->
        accu := Int (Arch.normalize_int arch (int_of_value !accu + ofs));
        incr pc;
      | OFFSETREF ofs -> (
        match !accu with
        | Block (mut, { contents = 0 }, ([| n |] as tbl)) ->
          assert (mut = Mutable);
          tbl.(0) <- Int (Arch.normalize_int arch (int_of_value n + ofs));
          incr pc;
        | _ -> assert false
      )

      | ISINT ->
        accu := (match !accu with Int _ -> Int 1 | _ -> Int 0);
        incr pc;
      | GETMETHOD ->
        accu := get_field (get_field (acc stack 0) 0) (int_of_value !accu);
        incr pc;

      | BEQ (n, ptr) ->
        if n = int_of_value !accu then pc := ptr else incr pc;
      | BNEQ (n, ptr) ->
        if n <> int_of_value !accu then pc := ptr else incr pc;
      | BLTINT (n, ptr) ->
        if n < int_of_value !accu then pc := ptr else incr pc;
      | BLEINT (n, ptr) ->
        if n <= int_of_value !accu then pc := ptr else incr pc;
      | BGTINT (n, ptr) ->
        if n > int_of_value !accu then pc := ptr else incr pc;
      | BGEINT (n, ptr) ->
        if n >= int_of_value !accu then pc := ptr else incr pc;

      | ULTINT ->
        let n = int_of_value !accu + min_int in
        let p = int_of_value (pop stack) + min_int in
        accu := if n < p then Int 1 else Int 0;
        incr pc;
      | UGEINT ->
        let n = int_of_value !accu + min_int in
        let p = int_of_value (pop stack) + min_int in
        accu := if n >= p then Int 1 else Int 0;
        incr pc;

      | BULTINT (n, ptr) ->
        if n + min_int < int_of_value !accu + min_int then pc := ptr else incr pc;
      | BUGEINT (n, ptr) ->
        if n + min_int >= int_of_value !accu + min_int then pc := ptr else incr pc;

      | GETPUBMET (tag, _cache) ->
        push stack !accu;
        accu := find_object_method (object_of_value !accu) tag;
        incr pc;
      | GETDYNMET ->
        accu := find_object_method (object_of_value (acc stack 0)) (int_of_value !accu);
        incr pc;

      | STOP -> raise Exit

      | EVENT -> failwith "Evaluation failed: unexpected EVENT instruction"
      | BREAK -> failwith "Evaluation failed: unexpected BREAK instruction"
    done;
    assert false (* Unreachable code *)
  with
  | Exit -> !pc, !ooid, !accu, !stack, globals, !last_valid_cycle
  | Stack_overflow   -> failwith "Evaluation failed: stack overflow"
  | Out_of_memory    -> failwith "Evaluation failed: out of memory"
  | Division_by_zero -> failwith "Evaluation failed: division by zero"

(******************************************************************************)

let run arch prims globals code =
  let _, _, _, _, _, cycle_limit = exec arch prims globals code max_int in
  let pc, ooid, accu, stack, globals, _ = exec arch prims globals code cycle_limit in
  pc, ooid, accu, stack, globals

(******************************************************************************)
