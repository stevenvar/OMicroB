open OByteLib
open Instr

(******************************************************************************)

type value =
| Int         of int
| Int32       of Int32.t
| Int64       of Int64.t
| Nativeint   of Nativeint.t
| Float       of float
| Float_array of float array
| Bytes       of bytes
| Object      of value array
| Block       of int * value array
| Closure     of closure
| CodePtr     of pc

and closure = {
  ofs  : int;
  ptrs : pc array;
  env  : value array;
}

and pc = int
and stack = value list

(******************************************************************************)
(* Value pretty printer. *)

let rec bprint_value buf v =
  match v with
  | Int           i -> Printf.bprintf buf "%d"  i
  | Int32         i -> Printf.bprintf buf "%ld" i
  | Int64         i -> Printf.bprintf buf "%Ld" i
  | Nativeint     i -> Printf.bprintf buf "%nd" i
  | Float         x -> Printf.bprintf buf "%F"  x
  | Float_array  xs -> Printf.bprintf buf "[|"; Array.iter (Printf.bprintf buf " %F;") xs; Printf.bprintf buf " |]"
  | Bytes         b -> Printf.bprintf buf "%S" (Bytes.unsafe_to_string b)
  | Object       vs -> Printf.bprintf buf "<"; Array.iter (Printf.bprintf buf " %a;" bprint_value) vs; Printf.bprintf buf " >"
  | Block (tag, vs) -> Printf.bprintf buf "[%d|" tag; Array.iter (Printf.bprintf buf " %a;" bprint_value) vs; Printf.bprintf buf " ]"
  | Closure       _ -> Printf.bprintf buf "<fun>"
  | CodePtr      pc -> Printf.bprintf buf "#%d" pc

let pprint_value v =
  let buf = Buffer.create 16 in
  bprint_value buf v;
  Buffer.contents buf

(******************************************************************************)
(* Conversion from OByteLib.Value.t to value. *)

let rec import_value v =
  match v with
  | Value.Int n -> Int n
  | Value.Int32 n -> Int32 n
  | Value.Int64 n -> Int64 n
  | Value.Nativeint n -> Nativeint n
  | Value.Float x -> Float x
  | Value.Float_array xs -> Float_array xs
  | Value.String s -> Bytes (Bytes.of_string s)
  | Value.Object vs -> Object (Array.map import_value vs)
  | Value.Block (tag, vs) -> Block (tag, Array.map import_value vs)

(******************************************************************************)
(* Stack tools. *)

let acc stack i =
  let rec loop stack i =
    match i, stack with
    | _, [] -> assert false
    | 0, v :: _ -> v
    | _, _ :: r -> loop r (i - 1) in
  assert (i >= 0);
  loop !stack i

let push stack v =
  stack := v :: !stack

let pop stack =
  match !stack with
  | [] -> assert false
  | v :: rest -> stack := rest; v

let popn stack n =
  let rec loop stack n =
    match n, stack with
    | 0, _ -> stack
    | _, _ :: rest -> loop rest (n - 1)
    | _, [] -> assert false in
  assert (n >= 0);
  stack := loop !stack n

let assign stack i v =
  let rec loop stack i v =
    match i, stack with
    | 0, _ :: rest -> v :: rest
    | _, t :: rest -> t :: loop rest (i - 1) v
    | _, [] -> assert false in
  assert (i >= 0);
  stack := loop !stack i v

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
  | Bytes s -> s
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
  | Block (_tag, values) ->
    assert (i >= 0 && i < Array.length values);
    values.(i)
  | _ ->
    assert false

let set_field blk i v =
  match blk with
  | Block (_tag, values) ->
    assert (i >= 0 && i < Array.length values);
    values.(i) <- v
  | _ ->
    assert false

let get_float_field blk i =
  match blk with
  | Float_array xs ->
    assert (i >= 0 && i < Array.length xs);
    xs.(i)
  | _ ->
    assert false

let set_float_field blk i v =
  match blk with
  | Float_array xs ->
    assert (i >= 0 && i < Array.length xs);
    xs.(i) <- v
  | _ ->
    assert false

let get_size blk =
  match blk with
  | Block (_tag, values) -> Array.length values
  | _ -> assert false

(******************************************************************************)
(* C Primitive Call. *)

let get_prim prims idx =
  assert (idx >= 0 && idx < Array.length prims);
  prims.(idx)

let ccall prim args =
  match prim, args with
  | _ -> raise Exit

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
  match obj with
  | Object values ->
    assert (Array.length values > 0);
    let tbl = match values.(0) with Block (0, tbl) -> tbl | _ -> assert false in
    let hi = match tbl.(0) with Int hi -> (hi lsl 1) lor 1 | _ -> assert false in
    bin_search tbl meth 3 hi
  | _ ->
    assert false

(******************************************************************************)

let run prims globals code =
  let globals = Array.map import_value globals in
  let code_size = Array.length code in

  let unit = Int 0 in
  let accu = ref unit in
  let pc = ref 0 in
  let env = ref unit in
  let extra_args = ref 0 in
  let trap_sp = ref (-1) in
  let stack = ref [] in

  try
    while true do
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
        accu :=  Closure { ofs = 0; ptrs; env = blk };
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
        accu := Block (0, [||]);
        incr pc;
      | ATOM tag ->
        accu := Block (tag, [||]);
        incr pc;
      | PUSHATOM0 ->
        push stack !accu;
        accu := Block (0, [||]);
        incr pc;
      | PUSHATOM tag ->
        push stack !accu;
        accu := Block (tag, [||]);
        incr pc;

      | MAKEBLOCK (tag, sz) ->
        let blk = Array.make sz !accu in
        for i = 1 to sz - 1 do blk.(i) <- pop stack done;
        accu := Block (tag, blk);
        incr pc;
      | MAKEBLOCK1 tag ->
        let blk = [| !accu |] in
        accu := Block (tag, blk);
        incr pc;
      | MAKEBLOCK2 tag ->
        let blk = [| !accu; pop stack |] in
        accu := Block (tag, blk);
        incr pc;
      | MAKEBLOCK3 tag ->
        let v1 = pop stack in
        let v2 = pop stack in
        let blk = [| !accu; v1; v2 |] in
        accu := Block (tag, blk);
        incr pc;
      | MAKEFLOATBLOCK sz ->
        let blk = Array.make sz (float_of_value !accu) in
        for i = 1 to sz - 1 do blk.(i) <- float_of_value (pop stack) done;
        accu := Float_array blk;
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
          | Block (tag, _values) -> tag + n land 0xFFFF
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
        accu := ccall (get_prim prims idx) [ !accu ];
        incr pc;
      | C_CALL2 idx ->
        accu := ccall (get_prim prims idx) [ !accu; pop stack ];
        incr pc;
      | C_CALL3 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        accu := ccall (get_prim prims idx) [ !accu; v1; v2 ];
        incr pc;
      | C_CALL4 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        let v3 = pop stack in
        accu := ccall (get_prim prims idx) [ !accu; v1; v2; v3 ];
        incr pc;
      | C_CALL5 idx ->
        let v1 = pop stack in
        let v2 = pop stack in
        let v3 = pop stack in
        let v4 = pop stack in
        accu := ccall (get_prim prims idx) [ !accu; v1; v2; v3; v4 ];
        incr pc;
      | C_CALLN (narg, idx) ->
        let args = ref [ !accu ] in
        for _i = 2 to narg do args := pop stack :: !args done;
        accu := ccall (get_prim prims idx) (List.rev !args);
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
        | Block (0, ([| n |] as tbl)) -> tbl.(0) <- Int (int_of_value n + ofs)
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
        accu := find_object_method !accu tag;
        incr pc;
      | GETDYNMET ->
        accu := find_object_method (acc stack 0) (int_of_value !accu);
        incr pc;

      | STOP -> raise Exit

      | EVENT -> failwith "Evaluation failed: unexpected EVENT instruction"
      | BREAK -> failwith "Evaluation failed: unexpected BREAK instruction"
    done;
    assert false (* Unreachable code *)
  with
  | Exit -> !pc, !stack
  | Stack_overflow   -> failwith "Evaluation failed: stack overflow"
  | Out_of_memory    -> failwith "Evaluation failed: out of memory"
  | Division_by_zero -> failwith "Evaluation failed: division by zero"

(******************************************************************************)
