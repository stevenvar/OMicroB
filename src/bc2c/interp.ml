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
  | Int32             i -> Printf.bprintf buf "%ld" i
  | Int64             i -> Printf.bprintf buf "%Ld" i
  | Nativeint         i -> Printf.bprintf buf "%nd" i
  | Float             x -> Printf.bprintf buf "%F"  x
  | Float_array (m, xs) -> Printf.bprintf buf "[%a|" bprint_mutability m; Array.iter (Printf.bprintf buf " %F;") xs; Printf.bprintf buf " |]"
  | Bytes        (m, b) -> Printf.bprintf buf "(%a) %S" bprint_mutability m (Bytes.unsafe_to_string b)
  | Object      (m, vs) -> Printf.bprintf buf "<%a|" bprint_mutability m; Array.iter (Printf.bprintf buf " %a;" bprint_value) vs; Printf.bprintf buf " >"
  | Block  (m, tag, vs) -> Printf.bprintf buf "[%a|%d|" bprint_mutability m tag; Array.iter (Printf.bprintf buf " %a;" bprint_value) vs; Printf.bprintf buf " ]"
  | Closure           _ -> Printf.bprintf buf "<fun>"
  | CodePtr          cp -> Printf.bprintf buf "#%d" cp

let pprint_value v =
  let buf = Buffer.create 16 in
  bprint_value buf v;
  Buffer.contents buf

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
        | OByteLib.Value.Block (tag, vs) -> Block (Immutable, tag, Array.map import_value vs) in
      Qhtbl.put qhtbl v result;
      result in
  import_value

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
  | Block (_mut, _tag, values) ->
    assert (i >= 0 && i < Array.length values);
    values.(i)
  | _ ->
    assert false

let set_field blk i v =
  match blk with
  | Block (mut, _tag, values) ->
    assert (mut = Mutable);
    assert (i >= 0 && i < Array.length values);
    values.(i) <- v
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
  let tbl = match obj.(0) with Block (_mut, 0, tbl) -> tbl | _ -> assert false in
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
    | Block (_mut0, 0, [| Block (_mut1, 0, v); rest |]) -> to_list (v :: acc) rest
    | _ -> assert false in
  let l = List.rev (to_list [] lst) in
  let tbl = Array.concat l in
  Block (Mutable, 0, tbl)

let caml_hash i j seed v =
  ignore (i, j, seed, v);
  raise Exit (* TODO *)

external format_float : bytes -> float -> bytes = "caml_format_float"
external format_int : bytes -> int -> bytes = "caml_format_int"

let ccall ooid prim args =
  match prim, args with
  | "caml_abs_float", [ Float x ] -> Float (abs_float x)
  | "caml_acos_float", [ Float x ] -> Float (acos x)
  | "caml_add_float", [ Float x; Float y ] -> Float (x +. y)
  | "caml_array_append", [ Block (_mut0, 0, v0); Block (_mut1, 0, v1) ] -> Block (Mutable, 0, Array.append v0 v1)
  | "caml_array_blit", [ Block (_mut0, 0, v0); Int s0; Block (mut1, 0, v1); Int s1; Int len ] -> assert (mut1 = Mutable); Array.blit v0 s0 v1 s1 len; Int 0
  | "caml_array_concat", [ lst ] -> caml_array_concat lst
  | "caml_array_sub", [ Block (_mut, 0, v); Int ofs; Int len ] -> Block (Mutable, 0, Array.sub v ofs len)
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
  | "caml_create_bytes", [ Int size ] -> Bytes (Mutable, Bytes.create size)
  | "caml_create_string", [ Int size ] -> Bytes (Immutable, Bytes.create size)
  | "caml_exp_float", [ Float x ] -> Float (exp x)
  | "caml_expm1_float", [ Float x ] -> Float (expm1 x)
  | ("caml_fill_bytes" | "caml_fill_string"), [ Bytes (mut, b); Int ofs; Int len; Int c ] -> assert (mut = Mutable); Bytes.fill b ofs len (char_of_int c); Int 0
  | "caml_float_of_string", [ Bytes (_mut, b) ] -> Float (float_of_string (Bytes.unsafe_to_string b))
  | "caml_floor_float", [ Float x ] -> Float (floor x)
  | "caml_fmod_float", [ Float x; Float y ] -> Float (mod_float x y)
  | "caml_format_float", [ Bytes (_mut, b); Float x ] -> Bytes (Immutable, format_float b x)
  | "format_int", [ Bytes (_mut, b); Int i ] -> Bytes (Immutable, format_int b i)
  | "caml_frexp_float", [ Float x ] -> let y, i = frexp x in Block (Immutable, 0, [| Float y; Int i |])
  | "caml_gc_compaction", [ Int 0 ] -> Gc.compact (); Int 0
  | "caml_gc_counters", [ Int 0 ] -> let x, y, z = Gc.counters () in Block (Immutable, 0, [| Float x; Float y; Float z |])
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
  | "caml_hash", [ Int i; Int j; Int k; v ] -> caml_hash i j k v
  | "caml_hash_univ_param", [ Int i; Int j; v ] -> caml_hash i j 0 v
  | "caml_hypot_float", [ Float x; Float y ] -> Float (hypot x y)
  | "caml_int32_bits_of_float", [ Float x ] -> Int32 (Int32.bits_of_float x)
  | "caml_int32_float_of_bits", [ Int32 i ] -> Float (Int32.float_of_bits i)
  | "caml_int32_format", [ Bytes (_mut, b); Int32 i ] -> Bytes (Immutable, Bytes.unsafe_of_string (Int32.format (Bytes.unsafe_to_string b) i))
  | "caml_int32_of_float", [ Float x ] -> Int32 (Int32.of_float x)
  | "caml_int32_of_string", [ Bytes (_mut, b) ] -> Int32 (Int32.of_string (Bytes.unsafe_to_string b))
  | "caml_int32_to_float", [ Int32 i ] -> Float (Int32.to_float i)
  | "caml_int64_bits_of_float", [ Float x ] -> Int64 (Int64.bits_of_float x)
  | "caml_int64_float_of_bits", [ Int64 i ] -> Float (Int64.float_of_bits i)
  | "caml_int64_format", [ Bytes (_mut, b); Int64 i ] -> Bytes (Immutable, Bytes.unsafe_of_string (Int64.format (Bytes.unsafe_to_string b) i))
  | "caml_int64_of_float", [ Float x ] -> Int64 (Int64.of_float x)
  | "caml_int64_of_string", [ Bytes (_mut, b) ] -> Int64 (Int64.of_string (Bytes.unsafe_to_string b))
  | "caml_int64_to_float", [ Int64 i ] -> Float (Int64.to_float i)
  | "caml_int_of_string", [ Bytes (_mut, b) ] -> Int (int_of_string (Bytes.unsafe_to_string b))
  | "caml_ldexp_float", [ Float x; Int i ] -> Float (ldexp x i)
  | "caml_log10_float", [ Float x ] -> Float (log10 x)
  | "caml_log1p_float", [ Float x ] -> Float (log1p x)
  | "caml_log_float", [ Float x ] -> Float (log x)
  | "caml_make_float_vect", [ Int i ] -> Float_array (Mutable, Array.create_float i)
  | "caml_make_vect", [ Int 0; _ ] -> Block (Mutable, 0, [||])
  | "caml_make_vect", [ Int i; Float x ] -> Float_array (Mutable, Array.make i x)
  | "caml_make_vect", [ Int i; v ] -> Block (Mutable, 0, Array.make i v)
  | "caml_modf_float", [ Float x ] -> let y, z = modf x in Block (Immutable, 0, [| Float y; Float z |])
  | "caml_nativeint_format", [ Bytes (_mut, b); Nativeint i ] -> Bytes (Immutable, Bytes.unsafe_of_string (Nativeint.format (Bytes.unsafe_to_string b) i))
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
  | "caml_obj_dup", [ Block (_mut, tag, tbl) ] -> Block (Mutable, tag, Array.copy tbl)
  | _ -> raise Exit

(******************************************************************************)

let exec prims globals code cycle_limit =
  let import_value = make_import_value () in
  let globals = Array.map import_value globals in
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
          let blk = Array.make (!extra_args + 2) !accu in
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
        accu := Block (Immutable, 0, [||]);
        incr pc;
      | ATOM tag ->
        accu := Block (Immutable, tag, [||]);
        incr pc;
      | PUSHATOM0 ->
        push stack !accu;
        accu := Block (Immutable, 0, [||]);
        incr pc;
      | PUSHATOM tag ->
        push stack !accu;
        accu := Block (Immutable, tag, [||]);
        incr pc;

      | MAKEBLOCK (tag, sz) ->
        let blk = Array.make sz !accu in
        for i = 1 to sz - 1 do blk.(i) <- pop stack done;
        accu := Block (Mutable, tag, blk);
        incr pc;
      | MAKEBLOCK1 tag ->
        let blk = [| !accu |] in
        accu := Block (Mutable, tag, blk);
        incr pc;
      | MAKEBLOCK2 tag ->
        let blk = [| !accu; pop stack |] in
        accu := Block (Mutable, tag, blk);
        incr pc;
      | MAKEBLOCK3 tag ->
        let v1 = pop stack in
        let v2 = pop stack in
        let blk = [| !accu; v1; v2 |] in
        accu := Block (Mutable, tag, blk);
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

      | GETSTRINGCHAR ->
        accu := Int (int_of_char (Bytes.get (bytes_of_value !accu) (int_of_value (pop stack))));
        incr pc;
      | SETSTRINGCHAR ->
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
          | Block (_mut, tag, _values) -> tag + n land 0xFFFF
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
        if !trap_sp = -1 then failwith (Printf.sprintf "Evaluation failed: uncaught exception: %s.\n" (pprint_value !accu));
        let ofs = List.length !stack - !trap_sp in
        popn stack ofs;
        pc         := code_ptr_of_value (pop stack);
        trap_sp    := int_of_value (pop stack);
        env        := pop stack;
        extra_args := int_of_value (pop stack);

      | CHECK_SIGNALS ->
        incr pc;

      | C_CALL1 idx ->
        accu := ccall ooid (get_prim prims idx) [ !accu ];
        incr pc;
      | C_CALL2 idx ->
        accu := ccall ooid (get_prim prims idx) [ !accu; pop stack ];
        incr pc;
      | C_CALL3 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        accu := ccall ooid (get_prim prims idx) [ !accu; v1; v2 ];
        incr pc;
      | C_CALL4 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        let v3 = pop stack in
        accu := ccall ooid (get_prim prims idx) [ !accu; v1; v2; v3 ];
        incr pc;
      | C_CALL5 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        let v3 = pop stack in
        let v4 = pop stack in
        accu := ccall ooid (get_prim prims idx) [ !accu; v1; v2; v3; v4 ];
        incr pc;
      | C_CALLN (narg, idx) ->
        let args = ref [ !accu ] in
        for _i = 2 to narg do args := pop stack :: !args done;
        accu := ccall ooid (get_prim prims idx) (List.rev !args);
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
        accu := Int (- (int_of_value !accu));
        incr pc;
      | ADDINT ->
        accu := Int (int_of_value !accu + int_of_value (pop stack));
        incr pc;
      | SUBINT ->
        accu := Int (int_of_value !accu - int_of_value (pop stack));
        incr pc;
      | MULINT ->
        accu := Int (int_of_value !accu * int_of_value (pop stack));
        incr pc;
      | DIVINT ->
        accu := Int (int_of_value !accu / int_of_value (pop stack));
        incr pc;
      | MODINT ->
        accu := Int (int_of_value !accu mod int_of_value (pop stack));
        incr pc;
      | ANDINT ->
        accu := Int (int_of_value !accu land int_of_value (pop stack));
        incr pc;
      | ORINT ->
        accu := Int (int_of_value !accu lor int_of_value (pop stack));
        incr pc;
      | XORINT ->
        accu := Int (int_of_value !accu lxor int_of_value (pop stack));
        incr pc;
      | LSLINT ->
        accu := Int (int_of_value !accu lsl int_of_value (pop stack));
        incr pc;
      | LSRINT ->
        accu := Int (int_of_value !accu lsr int_of_value (pop stack));
        incr pc;
      | ASRINT ->
        accu := Int (int_of_value !accu asr int_of_value (pop stack));
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
        accu := Int (int_of_value !accu + ofs);
        incr pc;
      | OFFSETREF ofs -> (
        match !accu with
        | Block (mut, 0, ([| n |] as tbl)) -> assert (mut = Mutable); tbl.(0) <- Int (int_of_value n + ofs)
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

let run prims globals code =
  let _, _, _, _, _, cycle_limit = exec prims globals code max_int in
  let pc, ooid, accu, stack, globals, _ = exec prims globals code cycle_limit in
  pc, ooid, accu, stack, globals

(******************************************************************************)
