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
  | VECTLENGTH | GETVECTITEM | SETVECTITEM | GETBYTESCHAR | SETBYTESCHAR | GETSTRINGCHAR
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

let code_ptrs_of_value v =
  let rec loop ((seen, ptrs) as acc) v =
    if List.memq v seen then acc else
      match v with
      | Int _ | Int32 _ | Int64 _ | Nativeint _
      | Float _ | Float_array _ | Bytes _ ->
        acc
      | Object (_mut, vs) | Block (_mut, _, vs) ->
        Array.fold_left loop (v :: seen, ptrs) vs
      | Closure { ofs = _; ptrs = new_ptrs; env } ->
        Array.fold_left loop (v :: seen, Array.to_list new_ptrs @ ptrs) env
      | CodePtr pc ->
        (v :: seen, pc :: ptrs) in
  snd (loop ([], []) v)
    
let rec mark_living code living_code globals read_globals written_globals pc =
  assert (pc >= 0 && pc < Array.length code);
  if not living_code.(pc) then (
    living_code.(pc) <- true;
    begin
      match code.(pc) with
      | GETGLOBAL n | PUSHGETGLOBAL n | GETGLOBALFIELD (n, _) | PUSHGETGLOBALFIELD (n, _) ->
        assert (n >= 0 && n < Array.length read_globals);
        read_globals.(n) <- true;
        List.iter (mark_living code living_code globals read_globals written_globals) (code_ptrs_of_value globals.(n));
      | SETGLOBAL n ->
        assert (n >= 0 && n < Array.length written_globals);
        written_globals.(n) <- true;
      | _ ->
        ()
    end;
    List.iter (mark_living code living_code globals read_globals written_globals) (nexts code pc)
  )

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
  | VECTLENGTH | GETVECTITEM | SETVECTITEM | GETBYTESCHAR | SETBYTESCHAR | GETSTRINGCHAR
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

let rec remap_value code_mapper qhtbl v =
  match v with
  | Int _ | Int32 _ | Int64 _ | Nativeint _
  | Float _ | Float_array _ | Bytes _ ->
    v
  | Object (mut, old_vs) -> (
    try Qhtbl.find qhtbl v with Not_found ->
      let new_vs = Array.copy old_vs in
      let res = Object (mut, new_vs) in
      Qhtbl.put qhtbl v res;
      Array.iteri (fun i v -> new_vs.(i) <- remap_value code_mapper qhtbl v) old_vs;
      res
  )
  | Block (mut, tag, old_vs) -> (
    try Qhtbl.find qhtbl v with Not_found ->
      let new_vs = Array.copy old_vs in
      let res = Block (mut, tag, new_vs) in
      Qhtbl.put qhtbl v res;
      Array.iteri (fun i v -> new_vs.(i) <- remap_value code_mapper qhtbl v) old_vs;
      res
  )
  | Closure { ofs; ptrs = old_ptrs; env = old_env } -> (
    try Qhtbl.find qhtbl v with Not_found ->
      let new_ptrs = Array.map (fun ptr -> code_mapper.(ptr)) old_ptrs in
      let new_env = Array.copy old_env in
      let res = Closure { ofs; ptrs = new_ptrs; env = new_env } in
      Qhtbl.put qhtbl v res;
      Array.iteri (fun i v -> new_env.(i) <- remap_value code_mapper qhtbl v) old_env;
      res
  )
  | CodePtr ptr ->
    CodePtr code_mapper.(ptr)

let list_used_primitives prims code =
  let prim_nb = Array.length prims in
  let used_prims = Array.make prim_nb false in
  Array.iter (fun instr ->
    match instr with
    | C_CALL1 idx | C_CALL2 idx | C_CALL3 idx | C_CALL4 idx | C_CALL5 idx | C_CALLN (_, idx) ->
      assert (idx >= 0 && idx < prim_nb);
      used_prims.(idx) <- true;
    | _ -> ()
  ) code;
  used_prims

let clean_primitives old_prims old_code =
  let old_prim_nb = Array.length old_prims in
  let used_prims = list_used_primitives old_prims old_code in
  let prim_mapper = Array.make old_prim_nb (-1) in
  let new_prim_nb = Array.fold_left (fun acc b -> if b then acc + 1 else acc) 0 used_prims in
  let new_prims = Array.make new_prim_nb "" in
  let new_i = ref 0 in
  Array.iteri (fun old_i b ->
    if b then (
      prim_mapper.(old_i) <- !new_i;
      new_prims.(!new_i) <- old_prims.(old_i);
      incr new_i;
    )
  ) used_prims;
  assert (!new_i = new_prim_nb);
  let new_code =
    Array.map (fun instr ->
      match instr with
      | C_CALL1 idx -> C_CALL1 prim_mapper.(idx)
      | C_CALL2 idx -> C_CALL2 prim_mapper.(idx)
      | C_CALL3 idx -> C_CALL3 prim_mapper.(idx)
      | C_CALL4 idx -> C_CALL4 prim_mapper.(idx)
      | C_CALL5 idx -> C_CALL5 prim_mapper.(idx)
      | C_CALLN (narg, idx) -> C_CALLN (narg, prim_mapper.(idx))
      | _ -> instr
    ) old_code in
  (new_prims, new_code)

let clean_stack code pc stack =
  let stack_max_usage = ref (-1) in
  let usages = Array.map (fun _ -> None) code in
  let rec interp pc stack_ofs =
    match usages.(pc) with
    | Some old_stack_ofs ->
      assert (stack_ofs = old_stack_ofs)
    | None ->
      usages.(pc) <- Some stack_ofs;
      let use_stack ind = stack_max_usage := max !stack_max_usage (ind - stack_ofs) in
      match code.(pc) with
      | ACC0  -> use_stack 0; interp (pc + 1) stack_ofs
      | ACC1  -> use_stack 1; interp (pc + 1) stack_ofs
      | ACC2  -> use_stack 2; interp (pc + 1) stack_ofs
      | ACC3  -> use_stack 3; interp (pc + 1) stack_ofs
      | ACC4  -> use_stack 4; interp (pc + 1) stack_ofs
      | ACC5  -> use_stack 5; interp (pc + 1) stack_ofs
      | ACC6  -> use_stack 6; interp (pc + 1) stack_ofs
      | ACC7  -> use_stack 7; interp (pc + 1) stack_ofs
      | ACC n -> use_stack n; interp (pc + 1) stack_ofs
      | PUSHACC1  -> use_stack 0; interp (pc + 1) (stack_ofs + 1)
      | PUSHACC2  -> use_stack 1; interp (pc + 1) (stack_ofs + 1)
      | PUSHACC3  -> use_stack 2; interp (pc + 1) (stack_ofs + 1)
      | PUSHACC4  -> use_stack 3; interp (pc + 1) (stack_ofs + 1)
      | PUSHACC5  -> use_stack 4; interp (pc + 1) (stack_ofs + 1)
      | PUSHACC6  -> use_stack 5; interp (pc + 1) (stack_ofs + 1)
      | PUSHACC7  -> use_stack 6; interp (pc + 1) (stack_ofs + 1)
      | PUSHACC n -> use_stack (n - 1); interp (pc + 1) (stack_ofs + 1)
      | ASSIGN _ | ENVACC1 | ENVACC2 | ENVACC3 | ENVACC4 | ENVACC _
      | OFFSETCLOSUREM2 | OFFSETCLOSURE0 | OFFSETCLOSURE2 | OFFSETCLOSURE _
      | GETGLOBAL _ | GETGLOBALFIELD _ | SETGLOBAL _ | ATOM0 | ATOM _
      | MAKEBLOCK1 _
      | GETFIELD0 | GETFIELD1 | GETFIELD2 | GETFIELD3 | GETFIELD _ | GETFLOATFIELD _
      | VECTLENGTH | BOOLNOT | CHECK_SIGNALS | C_CALL1 _
      | CONST0 | CONST1 | CONST2 | CONST3 | CONSTINT _
      | NEGINT | OFFSETINT _ | OFFSETREF _ | ISINT
        -> interp (pc + 1) stack_ofs
      | PUSH | PUSHACC0 | PUSHENVACC1 | PUSHENVACC2 | PUSHENVACC3 | PUSHENVACC4 | PUSHENVACC _
      | PUSHOFFSETCLOSUREM2 | PUSHOFFSETCLOSURE0 | PUSHOFFSETCLOSURE2 | PUSHOFFSETCLOSURE _
      | PUSHGETGLOBAL _ | PUSHGETGLOBALFIELD _ | PUSHATOM0 | PUSHATOM _
      | PUSHCONST0 | PUSHCONST1 | PUSHCONST2 | PUSHCONST3 | PUSHCONSTINT _
      | GETPUBMET _
        -> interp (pc + 1) (stack_ofs + 1)
      | PUSH_RETADDR ptr ->
        interp (pc + 1) (stack_ofs + 3);
        interp ptr stack_ofs;
      | APPLY1 -> use_stack 0; interp (pc + 1) (stack_ofs - 1)
      | APPLY2 -> use_stack 1; interp (pc + 1) (stack_ofs - 2)
      | APPLY3 -> use_stack 2; interp (pc + 1) (stack_ofs - 3)
      | CLOSURE (n, _) -> use_stack (n - 2); interp (pc + 1) (stack_ofs - max 0 (n - 1))
      | CLOSUREREC (_f, v, _o, t) -> use_stack (v - 2); interp (pc + 1) (stack_ofs - max 0 (v - 1) + 1 + Array.length t)
      | MAKEBLOCK (_, sz) -> use_stack (sz - 2); interp (pc + 1) (stack_ofs - max 0 (sz - 1))
      | MAKEBLOCK2 _ -> use_stack 0; interp (pc + 1) (stack_ofs - 1)
      | MAKEBLOCK3 _ -> use_stack 1; interp (pc + 1) (stack_ofs - 2)
      | MAKEFLOATBLOCK sz -> use_stack (sz - 2); interp (pc + 1) (stack_ofs - max 0 (sz - 1))
      | SETFIELD0 | SETFIELD1 | SETFIELD2 | SETFIELD3 | SETFIELD _ | SETFLOATFIELD _
      | GETVECTITEM | GETBYTESCHAR | GETSTRINGCHAR
      | ADDINT | SUBINT | MULINT | DIVINT | MODINT | ANDINT | ORINT | XORINT | LSLINT | LSRINT | ASRINT
      | EQ | NEQ | LTINT | LEINT | GTINT | GEINT
      | ULTINT | UGEINT
        -> use_stack 0; interp (pc + 1) (stack_ofs - 1)
      | SETVECTITEM | SETBYTESCHAR
        -> use_stack 1; interp (pc + 1) (stack_ofs - 2)
      | GETMETHOD | GETDYNMET -> use_stack 0; interp (pc + 1) stack_ofs
      | POP n -> interp (pc + 1) (stack_ofs - n)
      | C_CALL2 _ -> use_stack 0; interp (pc + 1) (stack_ofs - 1)
      | C_CALL3 _ -> use_stack 1; interp (pc + 1) (stack_ofs - 2)
      | C_CALL4 _ -> use_stack 2; interp (pc + 1) (stack_ofs - 3)
      | C_CALL5 _ -> use_stack 3; interp (pc + 1) (stack_ofs - 4)
      | C_CALLN (n, _) -> use_stack (n - 2); interp (pc + 1) (stack_ofs - (n - 1))
      | PUSHTRAP ptr -> interp (pc + 1) (stack_ofs + 4); interp ptr stack_ofs
      | POPTRAP -> use_stack 1; interp (pc + 1) (stack_ofs - 4)
      | BRANCH ptr -> interp ptr stack_ofs
      | BRANCHIF ptr | BRANCHIFNOT ptr
      | BEQ (_, ptr) | BNEQ (_, ptr) | BLTINT (_, ptr) | BLEINT (_, ptr) | BGTINT (_, ptr) | BGEINT (_, ptr)
      | BULTINT (_, ptr) | BUGEINT (_, ptr)
        -> interp (pc + 1) stack_ofs; interp ptr stack_ofs
      | SWITCH (_, ptrs) -> Array.iter (fun ptr -> interp ptr stack_ofs) ptrs
      | APPTERM _ | APPTERM1 _ | APPTERM2 _ | APPTERM3 _ | RESTART | GRAB _ | RETURN _ -> assert false
      | APPLY _ | RAISE | RERAISE | RAISE_NOTRACE | STOP | EVENT | BREAK -> () in
  interp pc 0;
  let racc = ref [] and acc = ref stack in
  for _i = 0 to !stack_max_usage do
    match !acc with
    | hd :: tl -> racc := hd :: !racc; acc := tl
    | _ -> assert false
  done;
  List.rev !racc
      
let clean arch prims globals code =
  let pc, ooid, accu, stack, globals = Interp.run arch prims globals code in

  let stack = clean_stack code pc stack in
  
  let living_code = Array.map (fun _ -> false) code in
  let read_globals = Array.map (fun _ -> false) globals in
  let written_globals = Array.map (fun _ -> false) globals in
  let mark pc = mark_living code living_code globals read_globals written_globals pc in
  List.iter mark (code_ptrs_of_value accu);
  List.iter (fun v -> List.iter mark (code_ptrs_of_value v)) stack;
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

  let qhtbl = Qhtbl.create () in
  let globals = Array.map (remap_value code_mapper qhtbl) globals in
  let stack = List.map (remap_value code_mapper qhtbl) stack in
  let accu = remap_value code_mapper qhtbl accu in

  let prims, code = clean_primitives prims code in

  ooid, accu, stack, globals, prims, code
