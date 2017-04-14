open OByteLib.Instr

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)

let export_code_from_addrs code addrs =
  let bytecode = ref [] in
  let pc = ref 0 in

  (***)

  let export_int8 n =
    assert (n >= -0x80 && n < 0x80);
    bytecode := (n land 0xFF) :: !bytecode;
    incr pc in

  let export_uint8 n =
    assert (n >= 0 && n < 0x100);
    bytecode := n :: !bytecode;
    incr pc in

  let export_uint16 n =
    assert (n >= 0 && n < 0x10000);
    export_uint8 (n lsr 8);
    export_uint8 (n land 0xFF) in

  let export_int16 n =
    assert (n >= -0x8000 && n < 0x8000);
    export_uint8 ((n lsr 8) land 0xFF);
    export_uint8 (n land 0xFF) in

  let export_uint32 n =
    assert (n >= 0 && n < 0x1_0000_0000);
    export_uint8 (n lsr 24);
    export_uint8 ((n lsr 16) land 0xFF);
    export_uint8 ((n lsr 8) land 0xFF);
    export_uint8 (n land 0xFF) in

  let export_int32 n =
    assert (n >= -0x8000_0000 && n < 0x8000_0000);
    export_uint8 ((n lsr 24) land 0xFF);
    export_uint8 ((n lsr 16) land 0xFF);
    export_uint8 ((n lsr 8) land 0xFF);
    export_uint8 (n land 0xFF) in

  (***)

  let ofs_of_ptr ptr =
    let addr = addrs.(ptr) in
    if addr = -1 then 0
    else addr - !pc in

  let kind_of_int n =
    if n >= -0x80 && n < 0x80 then `INT8
    else if n >= -0x8000 && n < 0x8000 then `INT16
    else `INT32 in

  let kind_of_int_list l =
    List.fold_left (fun acc n ->
      match acc, kind_of_int n with
      | `INT8, `INT8 -> `INT8
      | `INT8, `INT16 | `INT16, `INT8 | `INT16, `INT16 -> `INT16
      | _ -> `INT32
    ) `INT8 l in

  let export_of_kind kind =
    match kind with
    | `INT8  -> export_int8
    | `INT16 -> export_int16
    | `INT32 -> export_int32 in

  let opcode_of_kind kind (op1, op2, op3) =
    match kind with
    | `INT8  -> op1
    | `INT16 -> op2
    | `INT32 -> op3 in

  (***)

  let check_bounds op n low high =
    if n < low || n > high then
      Tools.fail "%s %d, argument out of bounds [ %d .. %d ]" op n low high in

  (***)

  Array.iteri (fun instr_ind instr ->
    addrs.(instr_ind) <- !pc;
    match instr with
    | ACC0 ->
      export_uint8 Opcode.acc0;
    | ACC1 ->
      export_uint8 Opcode.acc1;
    | ACC2 ->
      export_uint8 Opcode.acc2;
    | ACC3 ->
      export_uint8 Opcode.acc3;
    | ACC4 ->
      export_uint8 Opcode.acc4;
    | ACC5 ->
      export_uint8 Opcode.acc5;
    | ACC6 ->
      export_uint8 Opcode.acc6;
    | ACC7 ->
      export_uint8 Opcode.acc7;
    | ACC n ->
      check_bounds "ACC" n 8 255;
      export_uint8 Opcode.acc;
      export_uint8 n;
    | PUSH ->
      export_uint8 Opcode.push;
    | PUSHACC0 ->
      export_uint8 Opcode.push;
    | PUSHACC1 ->
      export_uint8 Opcode.pushacc1;
    | PUSHACC2 ->
      export_uint8 Opcode.pushacc2;
    | PUSHACC3 ->
      export_uint8 Opcode.pushacc3;
    | PUSHACC4 ->
      export_uint8 Opcode.pushacc4;
    | PUSHACC5 ->
      export_uint8 Opcode.pushacc5;
    | PUSHACC6 ->
      export_uint8 Opcode.pushacc6;
    | PUSHACC7 ->
      export_uint8 Opcode.pushacc7;
    | PUSHACC n ->
      check_bounds "PUSHACC" n 8 255;
      export_uint8 Opcode.pushacc;
      export_uint8 n;
    | POP n ->
      check_bounds "POP" n 1 255;
      export_uint8 Opcode.pop;
      export_uint8 n;
    | ASSIGN n ->
      check_bounds "ASSIGN" n 0 255;
      export_uint8 Opcode.assign;
      export_uint8 n;
    | ENVACC1 ->
      export_uint8 Opcode.envacc1;
    | ENVACC2 ->
      export_uint8 Opcode.envacc2;
    | ENVACC3 ->
      export_uint8 Opcode.envacc3;
    | ENVACC4 ->
      export_uint8 Opcode.envacc4;
    | ENVACC n ->
      check_bounds "ENVACC" n 5 255;
      export_uint8 Opcode.envacc;
      export_uint8 n;
    | PUSHENVACC1 ->
      export_uint8 Opcode.pushenvacc1;
    | PUSHENVACC2 ->
      export_uint8 Opcode.pushenvacc2;
    | PUSHENVACC3 ->
      export_uint8 Opcode.pushenvacc3;
    | PUSHENVACC4 ->
      export_uint8 Opcode.pushenvacc4;
    | PUSHENVACC n ->
      check_bounds "PUSHENVACC" n 5 255;
      export_uint8 Opcode.pushenvacc;
      export_uint8 n;
    | PUSH_RETADDR ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.push_retaddr in
      export_uint8 opcode;
      export_ofs ofs;
    | APPLY n ->
      check_bounds "APPLY" n 4 255;
      export_uint8 Opcode.apply;
      export_uint8 n;
    | APPLY1 ->
      export_uint8 Opcode.apply1;
    | APPLY2 ->
      export_uint8 Opcode.apply2;
    | APPLY3 ->
      export_uint8 Opcode.apply3;
    | APPTERM (n, p) ->
      check_bounds "APPTERM n:" n 0 255;
      check_bounds "APPTERM p:" p 0 255;
      export_uint8 Opcode.appterm;
      export_uint8 n;
      export_uint8 p;
    | APPTERM1 n ->
      check_bounds "APPTERM1" n 0 255;
      export_uint8 Opcode.appterm1;
      export_uint8 n;
    | APPTERM2 n ->
      check_bounds "APPTERM2" n 0 255;
      export_uint8 Opcode.appterm2;
      export_uint8 n;
    | APPTERM3 n ->
      check_bounds "APPTERM3" n 0 255;
      export_uint8 Opcode.appterm3;
      export_uint8 n;
    | RETURN n ->
      check_bounds "RETURN" n 0 255;
      export_uint8 Opcode.return;
      export_uint8 n;
    | RESTART ->
      export_uint8 Opcode.restart;
    | GRAB n ->
      check_bounds "GRAB" n 0 255;
      export_uint8 Opcode.grab;
      export_uint8 n;
    | CLOSURE (n, ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.closure in
      export_uint8 opcode;
      export_uint8 n;
      export_ofs ofs;
    | CLOSUREREC (f, v, o, t) ->
      check_bounds "CLOSUREREC f:" f 0 255;
      check_bounds "CLOSUREREC v:" v 0 255;
      let oofs = ofs_of_ptr o in
      let tofss = Array.map ofs_of_ptr t in
      let kind = kind_of_int_list (oofs :: Array.to_list tofss) in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.closurerec in
      export_uint8 opcode;
      export_uint8 f;
      export_uint8 v;
      export_ofs oofs;
      Array.iter export_ofs tofss;
    | OFFSETCLOSUREM2 ->
      export_uint8 Opcode.offsetclosurem2;
    | OFFSETCLOSURE0 ->
      export_uint8 Opcode.offsetclosure0;
    | OFFSETCLOSURE2 ->
      export_uint8 Opcode.offsetclosure2;
    | OFFSETCLOSURE n ->
      check_bounds "CLOSUREREC" n (-128) 127;
      export_uint8 Opcode.offsetclosure;
      export_uint8 n;
    | PUSHOFFSETCLOSUREM2 ->
      export_uint8 Opcode.pushoffsetclosurem2;
    | PUSHOFFSETCLOSURE0 ->
      export_uint8 Opcode.pushoffsetclosure0;
    | PUSHOFFSETCLOSURE2 ->
      export_uint8 Opcode.pushoffsetclosure2;
    | PUSHOFFSETCLOSURE n ->
      check_bounds "PUSHOFFSETCLOSURE" n (-128) 127;
      export_uint8 Opcode.pushoffsetclosure;
      export_uint8 n;
    | GETGLOBAL n ->
      check_bounds "GETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_uint8 (fst Opcode.getglobal);
        export_uint8 n;
      ) else (
        export_uint8 (snd Opcode.getglobal);
        export_uint16 n;
      )
    | PUSHGETGLOBAL n ->
      check_bounds "PUSHGETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_uint8 (fst Opcode.pushgetglobal);
        export_uint8 n;
      ) else (
        export_uint8 (snd Opcode.pushgetglobal);
        export_uint16 n;
      )
    | GETGLOBALFIELD (n, p) ->
      check_bounds "GETGLOBALFIELD n:" n 0 0x10000;
      check_bounds "GETGLOBALFIELD p:" p 0 0x100;
      if n < 0x100 then (
        export_uint8 (fst Opcode.getglobalfield);
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_uint8 (snd Opcode.getglobalfield);
        export_uint16 n;
        export_uint8 p;
      )
    | PUSHGETGLOBALFIELD (n, p) ->
      check_bounds "PUSHGETGLOBALFIELD n:" n 0 0x10000;
      check_bounds "PUSHGETGLOBALFIELD p:" p 0 0x100;
      if n < 0x100 then (
        export_uint8 (fst Opcode.pushgetglobalfield);
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_uint8 (snd Opcode.pushgetglobalfield);
        export_uint16 n;
        export_uint8 p;
      )
    | SETGLOBAL n ->
      check_bounds "SETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_uint8 (fst Opcode.setglobal);
        export_uint8 n;
      ) else (
        export_uint8 (snd Opcode.setglobal);
        export_uint16 n;
      )
    | ATOM0 ->
      export_uint8 Opcode.atom0;
    | ATOM _ ->
      Tools.fail "ATOM with non-zero tag is not supported";
    | PUSHATOM0 ->
      export_uint8 Opcode.pushatom0;
    | PUSHATOM _ ->
      Tools.fail "PUSHATOM with non-zero tag is not supported";
    | MAKEBLOCK (tag, size) ->
      check_bounds "MAKEBLOCK tag:" tag 0 255;
      check_bounds "MAKEBLOCK size:" size 0 255;
      export_uint8 Opcode.makeblock;
      export_uint8 tag;
      export_uint8 size;
    | MAKEBLOCK1 tag ->
      check_bounds "MAKEBLOCK1" tag 0 255;
      export_uint8 Opcode.makeblock1;
      export_uint8 tag;
    | MAKEBLOCK2 tag ->
      check_bounds "MAKEBLOCK2" tag 0 255;
      export_uint8 Opcode.makeblock2;
      export_uint8 tag;
    | MAKEBLOCK3 tag ->
      check_bounds "MAKEBLOCK3" tag 0 255;
      export_uint8 Opcode.makeblock3;
      export_uint8 tag;
    | MAKEFLOATBLOCK size ->
      check_bounds "MAKEFLOATBLOCK" size 0 255;
      export_uint8 Opcode.makefloatblock;
      export_uint8 size;
    | GETFIELD0 ->
      export_uint8 Opcode.getfield0;
    | GETFIELD1 ->
      export_uint8 Opcode.getfield1;
    | GETFIELD2 ->
      export_uint8 Opcode.getfield2;
    | GETFIELD3 ->
      export_uint8 Opcode.getfield3;
    | GETFIELD n ->
      check_bounds "GETFIELD" n 4 255;
      export_uint8 Opcode.getfield;
      export_uint8 n;
    | GETFLOATFIELD n ->
      check_bounds "GETFLOATFIELD" n 0 255;
      export_uint8 Opcode.getfloatfield;
      export_uint8 n;
    | SETFIELD0 ->
      export_uint8 Opcode.setfield0;
    | SETFIELD1 ->
      export_uint8 Opcode.setfield1;
    | SETFIELD2 ->
      export_uint8 Opcode.setfield2;
    | SETFIELD3 ->
      export_uint8 Opcode.setfield3;
    | SETFIELD n ->
      check_bounds "SETFIELD" n 0 255;
      export_uint8 Opcode.setfield;
      export_uint8 n;
    | SETFLOATFIELD n ->
      check_bounds "SETFLOATFIELD" n 0 255;
      export_uint8 Opcode.setfloatfield;
      export_uint8 n;
    | VECTLENGTH ->
      export_uint8 Opcode.vectlength;
    | GETVECTITEM ->
      export_uint8 Opcode.getvectitem;
    | SETVECTITEM ->
      export_uint8 Opcode.setvectitem;
    | GETSTRINGCHAR ->
      export_uint8 Opcode.getstringchar;
    | SETSTRINGCHAR ->
      export_uint8 Opcode.setstringchar;
    | BRANCH ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branch in
      export_uint8 opcode;
      export_ofs ofs;
    | BRANCHIF ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branch in
      export_uint8 opcode;
      export_ofs ofs;
    | BRANCHIFNOT ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branchifnot in
      export_uint8 opcode;
      export_ofs ofs;
    | SWITCH (n, ptrs) ->
      check_bounds "SWITCH ofs:" (n land 0xFFFF) 0 255;
      check_bounds "SWITCH sz:" (n lsr 16) 0 255;
      let ofss = Array.map ofs_of_ptr ptrs in
      let kind = kind_of_int_list (Array.to_list ofss) in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.switch in
      export_uint8 opcode;
      export_uint8 (n land 0xFFFF);
      export_uint8 (n lsr 16);
      Array.iter export_ofs ofss;
    | BOOLNOT ->
      export_uint8 Opcode.boolnot
    | PUSHTRAP ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushtrap in
      export_uint8 opcode;
      export_ofs ofs;
    | POPTRAP ->
      export_uint8 Opcode.poptrap;
    | RAISE ->
      export_uint8 Opcode.raise;
    | RERAISE ->
      export_uint8 Opcode.raise;
    | RAISE_NOTRACE ->
      export_uint8 Opcode.raise;
    | CHECK_SIGNALS ->
      export_uint8 Opcode.check_signals;
    | C_CALL1 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 Opcode.c_call1;
    | C_CALL2 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 Opcode.c_call2;
    | C_CALL3 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 Opcode.c_call3;
    | C_CALL4 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 Opcode.c_call4;
    | C_CALL5 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 Opcode.c_call5;
    | C_CALLN (narg, idx) ->
      check_bounds "C_CALLN narg:" narg 0 255;
      check_bounds "C_CALLN idx:" idx 0 255;
      export_uint8 Opcode.c_calln;
      export_uint8 narg;
      export_uint8 idx;
    | CONST0 ->
      export_uint8 Opcode.const0;
    | CONST1 ->
      export_uint8 Opcode.const1;
    | CONST2 ->
      export_uint8 Opcode.const2;
    | CONST3 ->
      export_uint8 Opcode.const3;
    | CONSTINT n ->
      check_bounds "CONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.constint in
      export_uint8 opcode;
      export_int n;
    | PUSHCONST0 ->
      export_uint8 Opcode.pushconst0;
    | PUSHCONST1 ->
      export_uint8 Opcode.pushconst1;
    | PUSHCONST2 ->
      export_uint8 Opcode.pushconst2;
    | PUSHCONST3 ->
      export_uint8 Opcode.pushconst3;
    | PUSHCONSTINT n ->
      check_bounds "PUSHCONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushconstint in
      export_uint8 opcode;
      export_int n;
    | NEGINT ->
      export_uint8 Opcode.negint;
    | ADDINT ->
      export_uint8 Opcode.addint;
    | SUBINT ->
      export_uint8 Opcode.subint;
    | MULINT ->
      export_uint8 Opcode.mulint;
    | DIVINT ->
      export_uint8 Opcode.divint;
    | MODINT ->
      export_uint8 Opcode.modint;
    | ANDINT ->
      export_uint8 Opcode.andint;
    | ORINT ->
      export_uint8 Opcode.orint;
    | XORINT ->
      export_uint8 Opcode.xorint;
    | LSLINT ->
      export_uint8 Opcode.lslint;
    | LSRINT ->
      export_uint8 Opcode.lsrint;
    | ASRINT ->
      export_uint8 Opcode.asrint;
    | EQ ->
      export_uint8 Opcode.eq;
    | NEQ ->
      export_uint8 Opcode.neq;
    | LTINT ->
      export_uint8 Opcode.ltint;
    | LEINT ->
      export_uint8 Opcode.leint;
    | GTINT ->
      export_uint8 Opcode.gtint;
    | GEINT ->
      export_uint8 Opcode.geint;
    | OFFSETINT n ->
      check_bounds "OFFSETINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetint in
      export_uint8 opcode;
      export_int n;
    | OFFSETREF n ->
      check_bounds "OFFSETREF" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetref in
      export_uint8 opcode;
      export_int n;
    | ISINT ->
      export_uint8 Opcode.isint;
    | GETMETHOD ->
      export_uint8 Opcode.getmethod;
    | BEQ (n, ptr) ->
      check_bounds "BEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.beq in
      export_uint8 opcode;
      export n;
      export ptr;
    | BNEQ (n, ptr) ->
      check_bounds "BNEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bneq in
      export_uint8 opcode;
      export n;
      export ptr;
    | BLTINT (n, ptr) ->
      check_bounds "BLTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bltint in
      export_uint8 opcode;
      export n;
      export ptr;
    | BLEINT (n, ptr) ->
      check_bounds "BLEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bleint in
      export_uint8 opcode;
      export n;
      export ptr;
    | BGTINT (n, ptr) ->
      check_bounds "BGTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgtint in
      export_uint8 opcode;
      export n;
      export ptr;
    | BGEINT (n, ptr) ->
      check_bounds "BGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgeint in
      export_uint8 opcode;
      export n;
      export ptr;
    | ULTINT ->
      export_uint8 Opcode.ultint;
    | UGEINT ->
      export_uint8 Opcode.ugeint;
    | BULTINT (n, ptr) ->
      check_bounds "BULTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bultint in
      export_uint8 opcode;
      export n;
      export ptr;
    | BUGEINT (n, ptr) ->
      check_bounds "BUGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bugeint in
      export_uint8 opcode;
      export n;
      export ptr;
    | GETPUBMET (htag, _cache) ->
      export_uint8 Opcode.getpubmet;
      export_uint32 htag;
    | GETDYNMET ->
      export_uint8 Opcode.getdynmet;
    | STOP ->
      export_uint8 Opcode.stop;
    | EVENT ->
      Tools.fail "unexpected debug instruction: EVENT";
    | BREAK ->
      Tools.fail "unexpected debug instruction: BREAK";
  ) code;
  List.rev !bytecode

(******************************************************************************)

let export_code code =
  let addrs = Array.map (fun _ -> -1) code in
  let bytecode = ref [] in
  let continue = ref true in
  while !continue do
    let new_bytecode = export_code_from_addrs code addrs in
    if new_bytecode = !bytecode then continue := false
    else bytecode := new_bytecode;
  done;
  !bytecode

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)

let export_data data =
  let objs = OByteLib.Data.to_objs data in
  let acc = ref [] in
  Array.iter (fun obj ->
    let str = Marshal.to_string obj [] in
    String.iter (fun c -> acc := int_of_char c :: !acc) str;
  ) objs;
  (List.rev !acc, Array.length objs)

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)
