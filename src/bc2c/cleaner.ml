open OByteLib.Instr
open T

let nexts code pc =
  assert (pc >= 0 && pc < Array.length code);
  match code.(pc) with
  | ACC0 | ACC1 | ACC2 | ACC3 | ACC4 | ACC5 | ACC6 | ACC7 | ACC _
  | PUSH | PUSHACC0 | PUSHACC1 | PUSHACC2 | PUSHACC3 | PUSHACC4
  | PUSHACC5 | PUSHACC6 | PUSHACC7 | PUSHACC _ | POP _ | ASSIGN _
  | ENVACC1 | ENVACC2 | ENVACC3 | ENVACC4 | ENVACC _
  | PUSHENVACC1 | PUSHENVACC2 | PUSHENVACC3 | PUSHENVACC4 | PUSHENVACC _
  | APPLY1 | APPLY2 | APPLY3 | RESTART
  | OFFSETCLOSUREM2 | OFFSETCLOSURE0 | OFFSETCLOSURE2 | OFFSETCLOSURE _
  | PUSHOFFSETCLOSUREM2 | PUSHOFFSETCLOSURE0 | PUSHOFFSETCLOSURE2 | PUSHOFFSETCLOSURE _
  | ATOM0 | ATOM _ | PUSHATOM0 | PUSHATOM _
  | MAKEBLOCK _ | MAKEBLOCK1 _ | MAKEBLOCK2 _ | MAKEBLOCK3 _ | MAKEFLOATBLOCK _
  | GETFIELD0 | GETFIELD1 | GETFIELD2 | GETFIELD3 | GETFIELD _ | GETFLOATFIELD _
  | SETFIELD0 | SETFIELD1 | SETFIELD2 | SETFIELD3 | SETFIELD _ | SETFLOATFIELD _
  | VECTLENGTH | GETVECTITEM | SETVECTITEM | GETSTRINGCHAR | SETSTRINGCHAR
  | GETGLOBAL _ | PUSHGETGLOBAL _ | GETGLOBALFIELD (_, _) | PUSHGETGLOBALFIELD (_, _)
  | SETGLOBAL _ | BOOLNOT | POPTRAP | CHECK_SIGNALS
  | C_CALL1 _ | C_CALL2 _ | C_CALL3 _ | C_CALL4 _ | C_CALL5 _ | C_CALLN _
  | CONST0 | CONST1 | CONST2 | CONST3 | CONSTINT _
  | PUSHCONST0 | PUSHCONST1 | PUSHCONST2 | PUSHCONST3 | PUSHCONSTINT _
  | NEGINT | ADDINT | SUBINT | MULINT | DIVINT | MODINT | ANDINT | ORINT
  | XORINT | LSLINT | LSRINT | ASRINT
  | EQ | NEQ | LTINT | LEINT | GTINT | GEINT
  | OFFSETINT _ | OFFSETREF _
  | ISINT | GETMETHOD
  | ULTINT | UGEINT
  | GETPUBMET _ | GETDYNMET ->
    [ pc + 1 ]
  | PUSH_RETADDR ptr | CLOSURE (_, ptr) | BRANCHIF ptr | BRANCHIFNOT ptr | PUSHTRAP ptr
  | BEQ (_, ptr) | BNEQ (_, ptr) | BLTINT (_, ptr) | BLEINT (_, ptr) | BGTINT (_, ptr)
  | BGEINT (_, ptr) | BULTINT (_, ptr) | BUGEINT (_, ptr) ->
    [ pc + 1; ptr ]
  | APPLY _ | APPTERM _ | APPTERM1 _ | APPTERM2 _ | APPTERM3 _ | RETURN _
  | RAISE | RERAISE | RAISE_NOTRACE
  | STOP | EVENT | BREAK ->
    []
  | GRAB _ ->
    [ pc - 1; pc + 1 ]
  | CLOSUREREC (_f, _v, o, t) ->
    pc + 1 :: o :: Array.to_list t
  | BRANCH ptr ->
    [ ptr ]
  | SWITCH (_, ptrs) ->
    Array.to_list ptrs

let rec mark_living code living_code read_globals written_globals pc =
  assert (pc >= 0 && pc < Array.length code);
  if not living_code.(pc) then (
    living_code.(pc) <- true;
    begin
      match code.(pc) with
      | GETGLOBAL n | PUSHGETGLOBAL n | GETGLOBALFIELD (n, _) | PUSHGETGLOBALFIELD (n, _) ->
        assert (n >= 0 && n < Array.length read_globals);
        read_globals.(n) <- true;
      | SETGLOBAL n ->
        assert (n >= 0 && n < Array.length written_globals);
        written_globals.(n) <- true;
      | _ ->
        ()
    end;
    List.iter (mark_living code living_code read_globals written_globals) (nexts code pc)
  )

let code_ptrs_of_value v =
  let rec loop acc v =
    match v with
    | Int _ | Int32 _ | Int64 _ | Nativeint _
    | Float _ | Float_array _ | Bytes _ ->
      acc
    | Object vs | Block (_, vs) ->
      Array.fold_left loop acc vs
    | Closure { ofs = _; ptrs; env } ->
      Array.fold_left loop (Array.to_list ptrs @ acc) env
    | CodePtr pc ->
      pc :: acc in
  loop [] v
    
let clean_set_globals code living_code read_globals written_globals =
  let wbnr_globals = Array.map2 (fun r w -> w && not r) read_globals written_globals in
  Array.iteri (fun i instr ->
    match instr with
    | SETGLOBAL n when wbnr_globals.(n) -> living_code.(i) <- false
    | _ -> ()
  ) code

let clean_table table living =
  let lst = ref [] in
  for i = Array.length table - 1 downto 0 do
    if living.(i) then lst := table.(i) :: !lst;
  done;
  Array.of_list !lst

let compute_mapper living =
  let mapper = Array.map (fun _ -> -1) living in
  let ind = ref 0 in
  Array.iteri (fun i b ->
    if b then (
      mapper.(i) <- !ind;
      incr ind;
    );
  ) living;
  mapper

let remap_instr code_mapper globals_mapper instr =
  match instr with
  | ACC0 | ACC1 | ACC2 | ACC3 | ACC4 | ACC5 | ACC6 | ACC7 | ACC _
  | PUSH | PUSHACC0 | PUSHACC1 | PUSHACC2 | PUSHACC3 | PUSHACC4
  | PUSHACC5 | PUSHACC6 | PUSHACC7 | PUSHACC _ | POP _ | ASSIGN _
  | ENVACC1 | ENVACC2 | ENVACC3 | ENVACC4 | ENVACC _
  | PUSHENVACC1 | PUSHENVACC2 | PUSHENVACC3 | PUSHENVACC4 | PUSHENVACC _
  | APPLY1 | APPLY2 | APPLY3 | RESTART
  | OFFSETCLOSUREM2 | OFFSETCLOSURE0 | OFFSETCLOSURE2 | OFFSETCLOSURE _
  | PUSHOFFSETCLOSUREM2 | PUSHOFFSETCLOSURE0 | PUSHOFFSETCLOSURE2 | PUSHOFFSETCLOSURE _
  | ATOM0 | ATOM _ | PUSHATOM0 | PUSHATOM _
  | MAKEBLOCK _ | MAKEBLOCK1 _ | MAKEBLOCK2 _ | MAKEBLOCK3 _ | MAKEFLOATBLOCK _
  | GETFIELD0 | GETFIELD1 | GETFIELD2 | GETFIELD3 | GETFIELD _ | GETFLOATFIELD _
  | SETFIELD0 | SETFIELD1 | SETFIELD2 | SETFIELD3 | SETFIELD _ | SETFLOATFIELD _
  | VECTLENGTH | GETVECTITEM | SETVECTITEM | GETSTRINGCHAR | SETSTRINGCHAR
  | BOOLNOT | POPTRAP | CHECK_SIGNALS
  | C_CALL1 _ | C_CALL2 _ | C_CALL3 _ | C_CALL4 _ | C_CALL5 _ | C_CALLN _
  | CONST0 | CONST1 | CONST2 | CONST3 | CONSTINT _
  | PUSHCONST0 | PUSHCONST1 | PUSHCONST2 | PUSHCONST3 | PUSHCONSTINT _
  | NEGINT | ADDINT | SUBINT | MULINT | DIVINT | MODINT | ANDINT | ORINT
  | XORINT | LSLINT | LSRINT | ASRINT
  | EQ | NEQ | LTINT | LEINT | GTINT | GEINT
  | OFFSETINT _ | OFFSETREF _
  | ISINT | GETMETHOD
  | ULTINT | UGEINT
  | GETPUBMET _ | GETDYNMET
  | APPLY _ | APPTERM _ | APPTERM1 _ | APPTERM2 _ | APPTERM3 _ | RETURN _
  | RAISE | RERAISE | RAISE_NOTRACE
  | STOP | EVENT | BREAK
  | GRAB _ -> instr
  | GETGLOBAL n -> GETGLOBAL globals_mapper.(n)
  | PUSHGETGLOBAL n -> PUSHGETGLOBAL globals_mapper.(n)
  | GETGLOBALFIELD (n, p) -> GETGLOBALFIELD (globals_mapper.(n), p)
  | PUSHGETGLOBALFIELD (n, p) -> PUSHGETGLOBALFIELD (globals_mapper.(n), p)
  | SETGLOBAL n -> SETGLOBAL globals_mapper.(n)
  | PUSH_RETADDR ptr -> PUSH_RETADDR code_mapper.(ptr)
  | CLOSURE (n, ptr) -> CLOSURE (n, code_mapper.(ptr))
  | BRANCHIF ptr -> BRANCHIF code_mapper.(ptr)
  | BRANCHIFNOT ptr -> BRANCHIFNOT code_mapper.(ptr)
  | PUSHTRAP ptr -> PUSHTRAP code_mapper.(ptr)
  | BEQ (n, ptr) -> BEQ (n, code_mapper.(ptr))
  | BNEQ (n, ptr) -> BNEQ (n, code_mapper.(ptr))
  | BLTINT (n, ptr) -> BLTINT (n, code_mapper.(ptr))
  | BLEINT (n, ptr) -> BLEINT (n, code_mapper.(ptr))
  | BGTINT (n, ptr) -> BGTINT (n, code_mapper.(ptr))
  | BGEINT (n, ptr) -> BGEINT (n, code_mapper.(ptr))
  | BULTINT (n, ptr) -> BULTINT (n, code_mapper.(ptr))
  | BUGEINT (n, ptr) -> BUGEINT (n, code_mapper.(ptr))
  | BRANCH ptr -> BRANCH code_mapper.(ptr)
  | CLOSUREREC (f, v, o, t) -> CLOSUREREC (f, v, code_mapper.(o), Array.map (fun p -> code_mapper.(p)) t)
  | SWITCH (n, ptrs) -> SWITCH (n, Array.map (fun p -> code_mapper.(p)) ptrs)

let rec remap_value code_mapper sharer v =
  match v with
  | Int _ | Int32 _ | Int64 _ | Nativeint _
  | Float _ | Float_array _ | Bytes _ ->
    v
  | Object vs -> (
    try Sharer.find_block sharer vs with Not_found ->
      let res = Object (Array.map (remap_value code_mapper sharer) vs) in
      Sharer.put_block sharer vs res;
      res
  )
  | Block (tag, vs) -> (
    try Sharer.find_block sharer vs with Not_found ->
      let res = Block (tag, Array.map (remap_value code_mapper sharer) vs) in
      Sharer.put_block sharer vs res;
      res
  )
  | Closure { ofs; ptrs; env } -> (
    try Sharer.find_closure sharer ptrs env with Not_found ->
      let res =
        Closure {
          ofs;
          ptrs = Array.map (fun ptr -> code_mapper.(ptr)) ptrs;
          env = Array.map (remap_value code_mapper sharer) env;
        } in
      Sharer.put_closure sharer ptrs env res;
      res
  )
  | CodePtr ptr ->
    CodePtr code_mapper.(ptr)

let clean prims globals code =
  let pc, accu, stack, globals = Interp.run prims globals code in

  let living_code = Array.map (fun _ -> false) code in
  let read_globals = Array.map (fun _ -> false) globals in
  let written_globals = Array.map (fun _ -> false) globals in
  let mark = mark_living code living_code read_globals written_globals in
  List.iter mark (code_ptrs_of_value accu);
  List.iter (fun v -> List.iter mark (code_ptrs_of_value v)) stack;
  Array.iter (fun v -> List.iter mark (code_ptrs_of_value v)) globals;
  mark pc;

  clean_set_globals code living_code read_globals written_globals;

  let code = clean_table code living_code in
  let code_mapper = compute_mapper living_code in

  let code, code_mapper =
    if code_mapper.(pc) = 0 then code, code_mapper else (
      let code = Array.append [| BRANCH pc |] code in
      let code_mapper = Array.map (fun ptr -> if ptr = -1 then -1 else ptr + 1) code_mapper in
      code, code_mapper
    ) in

  let globals = clean_table globals read_globals in
  let globals_mapper = compute_mapper read_globals in

  let code = Array.map (remap_instr code_mapper globals_mapper) code in

  let sharer = Sharer.create () in
  let globals = Array.map (remap_value code_mapper sharer) globals in
  let stack = List.map (remap_value code_mapper sharer) stack in
  let accu = remap_value code_mapper sharer accu in

  accu, stack, globals, code
