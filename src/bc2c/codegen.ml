open OByteLib.Instr

(******************************************************************************)

let export_code_from_addrs_opgen code addrs opgen =
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
      export_uint8 (Opgen.generate opgen Opcode.ACC0);
    | ACC1 ->
      export_uint8 (Opgen.generate opgen Opcode.ACC1);
    | ACC2 ->
      export_uint8 (Opgen.generate opgen Opcode.ACC2);
    | ACC3 ->
      export_uint8 (Opgen.generate opgen Opcode.ACC3);
    | ACC4 ->
      export_uint8 (Opgen.generate opgen Opcode.ACC4);
    | ACC5 ->
      export_uint8 (Opgen.generate opgen Opcode.ACC5);
    | ACC6 ->
      export_uint8 (Opgen.generate opgen Opcode.ACC6);
    | ACC7 ->
      export_uint8 (Opgen.generate opgen Opcode.ACC7);
    | ACC n ->
      check_bounds "ACC" n 8 255;
      export_uint8 (Opgen.generate opgen Opcode.ACC);
      export_uint8 n;
    | PUSH | PUSHACC0 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSH);
    | PUSHACC1 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC1);
    | PUSHACC2 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC2);
    | PUSHACC3 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC3);
    | PUSHACC4 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC4);
    | PUSHACC5 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC5);
    | PUSHACC6 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC6);
    | PUSHACC7 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC7);
    | PUSHACC n ->
      check_bounds "PUSHACC" n 8 255;
      export_uint8 (Opgen.generate opgen Opcode.PUSHACC);
      export_uint8 n;
    | POP n ->
      check_bounds "POP" n 1 255;
      export_uint8 (Opgen.generate opgen Opcode.POP);
      export_uint8 n;
    | ASSIGN n ->
      check_bounds "ASSIGN" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.ASSIGN);
      export_uint8 n;
    | ENVACC1 ->
      export_uint8 (Opgen.generate opgen Opcode.ENVACC1);
    | ENVACC2 ->
      export_uint8 (Opgen.generate opgen Opcode.ENVACC2);
    | ENVACC3 ->
      export_uint8 (Opgen.generate opgen Opcode.ENVACC3);
    | ENVACC4 ->
      export_uint8 (Opgen.generate opgen Opcode.ENVACC4);
    | ENVACC n ->
      check_bounds "ENVACC" n 5 255;
      export_uint8 (Opgen.generate opgen Opcode.ENVACC);
      export_uint8 n;
    | PUSHENVACC1 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHENVACC1);
    | PUSHENVACC2 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHENVACC2);
    | PUSHENVACC3 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHENVACC3);
    | PUSHENVACC4 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHENVACC4);
    | PUSHENVACC n ->
      check_bounds "PUSHENVACC" n 5 255;
      export_uint8 (Opgen.generate opgen Opcode.PUSHENVACC);
      export_uint8 n;
    | PUSH_RETADDR ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.push_retaddr in
      export_uint8 (Opgen.generate opgen opcode);
      export_ofs ofs;
    | APPLY n ->
      check_bounds "APPLY" n 4 255;
      export_uint8 (Opgen.generate opgen Opcode.APPLY);
      export_uint8 n;
    | APPLY1 ->
      export_uint8 (Opgen.generate opgen Opcode.APPLY1);
    | APPLY2 ->
      export_uint8 (Opgen.generate opgen Opcode.APPLY2);
    | APPLY3 ->
      export_uint8 (Opgen.generate opgen Opcode.APPLY3);
    | APPTERM (n, p) ->
      check_bounds "APPTERM n:" n 0 255;
      check_bounds "APPTERM p:" p 0 255;
      export_uint8 (Opgen.generate opgen Opcode.APPTERM);
      export_uint8 n;
      export_uint8 p;
    | APPTERM1 n ->
      check_bounds "APPTERM1" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.APPTERM1);
      export_uint8 n;
    | APPTERM2 n ->
      check_bounds "APPTERM2" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.APPTERM2);
      export_uint8 n;
    | APPTERM3 n ->
      check_bounds "APPTERM3" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.APPTERM3);
      export_uint8 n;
    | RETURN n ->
      check_bounds "RETURN" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.RETURN);
      export_uint8 n;
    | RESTART ->
      export_uint8 (Opgen.generate opgen Opcode.RESTART);
    | GRAB n ->
      check_bounds "GRAB" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.GRAB);
      export_uint8 n;
    | CLOSURE (n, ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.closure in
      export_uint8 (Opgen.generate opgen opcode);
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
      export_uint8 (Opgen.generate opgen opcode);
      export_uint8 f;
      export_uint8 v;
      export_ofs oofs;
      Array.iter export_ofs tofss;
    | OFFSETCLOSUREM2 ->
      export_uint8 (Opgen.generate opgen Opcode.OFFSETCLOSUREM2);
    | OFFSETCLOSURE0 ->
      export_uint8 (Opgen.generate opgen Opcode.OFFSETCLOSURE0);
    | OFFSETCLOSURE2 ->
      export_uint8 (Opgen.generate opgen Opcode.OFFSETCLOSURE2);
    | OFFSETCLOSURE n ->
      check_bounds "CLOSUREREC" n (-0x80) 0x7F;
      export_uint8 (Opgen.generate opgen Opcode.OFFSETCLOSURE);
      export_int8 n;
    | PUSHOFFSETCLOSUREM2 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHOFFSETCLOSUREM2);
    | PUSHOFFSETCLOSURE0 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHOFFSETCLOSURE0);
    | PUSHOFFSETCLOSURE2 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHOFFSETCLOSURE2);
    | PUSHOFFSETCLOSURE n ->
      check_bounds "PUSHOFFSETCLOSURE" n (-0x80) 0x7F;
      export_uint8 (Opgen.generate opgen Opcode.PUSHOFFSETCLOSURE);
      export_int8 n;
    | GETGLOBAL n ->
      check_bounds "GETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_uint8 (Opgen.generate opgen Opcode.GETGLOBAL_1B);
        export_uint8 n;
      ) else (
        export_uint8 (Opgen.generate opgen Opcode.GETGLOBAL_2B);
        export_uint16 n;
      )
    | PUSHGETGLOBAL n ->
      check_bounds "PUSHGETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_uint8 (Opgen.generate opgen Opcode.PUSHGETGLOBAL_1B);
        export_uint8 n;
      ) else (
        export_uint8 (Opgen.generate opgen Opcode.PUSHGETGLOBAL_2B);
        export_uint16 n;
      )
    | GETGLOBALFIELD (n, p) ->
      check_bounds "GETGLOBALFIELD n:" n 0 0x10000;
      check_bounds "GETGLOBALFIELD p:" p 0 0x100;
      if n < 0x100 then (
        export_uint8 (Opgen.generate opgen Opcode.GETGLOBALFIELD_1B);
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_uint8 (Opgen.generate opgen Opcode.GETGLOBALFIELD_2B);
        export_uint16 n;
        export_uint8 p;
      )
    | PUSHGETGLOBALFIELD (n, p) ->
      check_bounds "PUSHGETGLOBALFIELD n:" n 0 0x10000;
      check_bounds "PUSHGETGLOBALFIELD p:" p 0 0x100;
      if n < 0x100 then (
        export_uint8 (Opgen.generate opgen Opcode.PUSHGETGLOBALFIELD_1B);
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_uint8 (Opgen.generate opgen Opcode.PUSHGETGLOBALFIELD_2B);
        export_uint16 n;
        export_uint8 p;
      )
    | SETGLOBAL n ->
      check_bounds "SETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_uint8 (Opgen.generate opgen Opcode.SETGLOBAL_1B);
        export_uint8 n;
      ) else (
        export_uint8 (Opgen.generate opgen Opcode.SETGLOBAL_2B);
        export_uint16 n;
      )
    | ATOM0 ->
      export_uint8 (Opgen.generate opgen Opcode.ATOM0);
    | ATOM _ ->
      Tools.fail "ATOM with non-zero tag is not supported";
    | PUSHATOM0 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHATOM0);
    | PUSHATOM _ ->
      Tools.fail "PUSHATOM with non-zero tag is not supported";
    | MAKEBLOCK (tag, size) ->
      check_bounds "MAKEBLOCK tag:" tag 0 0xFF;
      check_bounds "MAKEBLOCK size:" size 0 0xFFFF;
      if size < 0x100 then (
        export_uint8 (Opgen.generate opgen Opcode.MAKEBLOCK_1B);
        export_uint8 tag;
        export_uint8 size;
      ) else (
        export_uint8 (Opgen.generate opgen Opcode.MAKEBLOCK_2B);
        export_uint8 tag;
        export_uint16 size;
      )
    | MAKEBLOCK1 tag ->
      check_bounds "MAKEBLOCK1" tag 0 255;
      export_uint8 (Opgen.generate opgen Opcode.MAKEBLOCK1);
      export_uint8 tag;
    | MAKEBLOCK2 tag ->
      check_bounds "MAKEBLOCK2" tag 0 255;
      export_uint8 (Opgen.generate opgen Opcode.MAKEBLOCK2);
      export_uint8 tag;
    | MAKEBLOCK3 tag ->
      check_bounds "MAKEBLOCK3" tag 0 255;
      export_uint8 (Opgen.generate opgen Opcode.MAKEBLOCK3);
      export_uint8 tag;
    | MAKEFLOATBLOCK size ->
      check_bounds "MAKEFLOATBLOCK" size 0 255;
      export_uint8 (Opgen.generate opgen Opcode.MAKEFLOATBLOCK);
      export_uint8 size;
    | GETFIELD0 ->
      export_uint8 (Opgen.generate opgen Opcode.GETFIELD0);
    | GETFIELD1 ->
      export_uint8 (Opgen.generate opgen Opcode.GETFIELD1);
    | GETFIELD2 ->
      export_uint8 (Opgen.generate opgen Opcode.GETFIELD2);
    | GETFIELD3 ->
      export_uint8 (Opgen.generate opgen Opcode.GETFIELD3);
    | GETFIELD n ->
      check_bounds "GETFIELD" n 4 255;
      export_uint8 (Opgen.generate opgen Opcode.GETFIELD);
      export_uint8 n;
    | GETFLOATFIELD n ->
      check_bounds "GETFLOATFIELD" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.GETFLOATFIELD);
      export_uint8 n;
    | SETFIELD0 ->
      export_uint8 (Opgen.generate opgen Opcode.SETFIELD0);
    | SETFIELD1 ->
      export_uint8 (Opgen.generate opgen Opcode.SETFIELD1);
    | SETFIELD2 ->
      export_uint8 (Opgen.generate opgen Opcode.SETFIELD2);
    | SETFIELD3 ->
      export_uint8 (Opgen.generate opgen Opcode.SETFIELD3);
    | SETFIELD n ->
      check_bounds "SETFIELD" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.SETFIELD);
      export_uint8 n;
    | SETFLOATFIELD n ->
      check_bounds "SETFLOATFIELD" n 0 255;
      export_uint8 (Opgen.generate opgen Opcode.SETFLOATFIELD);
      export_uint8 n;
    | VECTLENGTH ->
      export_uint8 (Opgen.generate opgen Opcode.VECTLENGTH);
    | GETVECTITEM ->
      export_uint8 (Opgen.generate opgen Opcode.GETVECTITEM);
    | SETVECTITEM ->
      export_uint8 (Opgen.generate opgen Opcode.SETVECTITEM);
    | GETSTRINGCHAR ->
      export_uint8 (Opgen.generate opgen Opcode.GETSTRINGCHAR);
    | SETSTRINGCHAR ->
      export_uint8 (Opgen.generate opgen Opcode.SETSTRINGCHAR);
    | BRANCH ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branch in
      export_uint8 (Opgen.generate opgen opcode);
      export_ofs ofs;
    | BRANCHIF ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branch in
      export_uint8 (Opgen.generate opgen opcode);
      export_ofs ofs;
    | BRANCHIFNOT ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branchifnot in
      export_uint8 (Opgen.generate opgen opcode);
      export_ofs ofs;
    | SWITCH (n, ptrs) ->
      check_bounds "SWITCH ofs:" (n land 0xFFFF) 0 255;
      check_bounds "SWITCH sz:" (n lsr 16) 0 255;
      let ofss = Array.map ofs_of_ptr ptrs in
      let kind = kind_of_int_list (Array.to_list ofss) in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.switch in
      export_uint8 (Opgen.generate opgen opcode);
      export_uint8 (n land 0xFFFF);
      export_uint8 (n lsr 16);
      Array.iter export_ofs ofss;
    | BOOLNOT ->
      export_uint8 (Opgen.generate opgen Opcode.BOOLNOT)
    | PUSHTRAP ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushtrap in
      export_uint8 (Opgen.generate opgen opcode);
      export_ofs ofs;
    | POPTRAP ->
      export_uint8 (Opgen.generate opgen Opcode.POPTRAP);
    | RAISE ->
      export_uint8 (Opgen.generate opgen Opcode.RAISE);
    | RERAISE ->
      export_uint8 (Opgen.generate opgen Opcode.RAISE);
    | RAISE_NOTRACE ->
      export_uint8 (Opgen.generate opgen Opcode.RAISE);
    | CHECK_SIGNALS ->
      export_uint8 (Opgen.generate opgen Opcode.CHECK_SIGNALS);
    | C_CALL1 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 (Opgen.generate opgen Opcode.C_CALL1);
    | C_CALL2 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 (Opgen.generate opgen Opcode.C_CALL2);
    | C_CALL3 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 (Opgen.generate opgen Opcode.C_CALL3);
    | C_CALL4 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 (Opgen.generate opgen Opcode.C_CALL4);
    | C_CALL5 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_uint8 (Opgen.generate opgen Opcode.C_CALL5);
    | C_CALLN (narg, idx) ->
      check_bounds "C_CALLN narg:" narg 0 255;
      check_bounds "C_CALLN idx:" idx 0 255;
      export_uint8 (Opgen.generate opgen Opcode.C_CALLN);
      export_uint8 narg;
      export_uint8 idx;
    | CONST0 ->
      export_uint8 (Opgen.generate opgen Opcode.CONST0);
    | CONST1 ->
      export_uint8 (Opgen.generate opgen Opcode.CONST1);
    | CONST2 ->
      export_uint8 (Opgen.generate opgen Opcode.CONST2);
    | CONST3 ->
      export_uint8 (Opgen.generate opgen Opcode.CONST3);
    | CONSTINT n ->
      check_bounds "CONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.constint in
      export_uint8 (Opgen.generate opgen opcode);
      export_int n;
    | PUSHCONST0 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHCONST0);
    | PUSHCONST1 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHCONST1);
    | PUSHCONST2 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHCONST2);
    | PUSHCONST3 ->
      export_uint8 (Opgen.generate opgen Opcode.PUSHCONST3);
    | PUSHCONSTINT n ->
      check_bounds "PUSHCONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushconstint in
      export_uint8 (Opgen.generate opgen opcode);
      export_int n;
    | NEGINT ->
      export_uint8 (Opgen.generate opgen Opcode.NEGINT);
    | ADDINT ->
      export_uint8 (Opgen.generate opgen Opcode.ADDINT);
    | SUBINT ->
      export_uint8 (Opgen.generate opgen Opcode.SUBINT);
    | MULINT ->
      export_uint8 (Opgen.generate opgen Opcode.MULINT);
    | DIVINT ->
      export_uint8 (Opgen.generate opgen Opcode.DIVINT);
    | MODINT ->
      export_uint8 (Opgen.generate opgen Opcode.MODINT);
    | ANDINT ->
      export_uint8 (Opgen.generate opgen Opcode.ANDINT);
    | ORINT ->
      export_uint8 (Opgen.generate opgen Opcode.ORINT);
    | XORINT ->
      export_uint8 (Opgen.generate opgen Opcode.XORINT);
    | LSLINT ->
      export_uint8 (Opgen.generate opgen Opcode.LSLINT);
    | LSRINT ->
      export_uint8 (Opgen.generate opgen Opcode.LSRINT);
    | ASRINT ->
      export_uint8 (Opgen.generate opgen Opcode.ASRINT);
    | EQ ->
      export_uint8 (Opgen.generate opgen Opcode.EQ);
    | NEQ ->
      export_uint8 (Opgen.generate opgen Opcode.NEQ);
    | LTINT ->
      export_uint8 (Opgen.generate opgen Opcode.LTINT);
    | LEINT ->
      export_uint8 (Opgen.generate opgen Opcode.LEINT);
    | GTINT ->
      export_uint8 (Opgen.generate opgen Opcode.GTINT);
    | GEINT ->
      export_uint8 (Opgen.generate opgen Opcode.GEINT);
    | OFFSETINT n ->
      check_bounds "OFFSETINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetint in
      export_uint8 (Opgen.generate opgen opcode);
      export_int n;
    | OFFSETREF n ->
      check_bounds "OFFSETREF" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetref in
      export_uint8 (Opgen.generate opgen opcode);
      export_int n;
    | ISINT ->
      export_uint8 (Opgen.generate opgen Opcode.ISINT);
    | GETMETHOD ->
      export_uint8 (Opgen.generate opgen Opcode.GETMETHOD);
    | BEQ (n, ptr) ->
      check_bounds "BEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.beq in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | BNEQ (n, ptr) ->
      check_bounds "BNEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bneq in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | BLTINT (n, ptr) ->
      check_bounds "BLTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bltint in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | BLEINT (n, ptr) ->
      check_bounds "BLEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bleint in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | BGTINT (n, ptr) ->
      check_bounds "BGTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgtint in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | BGEINT (n, ptr) ->
      check_bounds "BGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgeint in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | ULTINT ->
      export_uint8 (Opgen.generate opgen Opcode.ULTINT);
    | UGEINT ->
      export_uint8 (Opgen.generate opgen Opcode.UGEINT);
    | BULTINT (n, ptr) ->
      check_bounds "BULTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bultint in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | BUGEINT (n, ptr) ->
      check_bounds "BUGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bugeint in
      export_uint8 (Opgen.generate opgen opcode);
      export n;
      export ofs;
    | GETPUBMET (htag, _cache) ->
      export_uint8 (Opgen.generate opgen Opcode.GETPUBMET);
      export_uint32 htag;
    | GETDYNMET ->
      export_uint8 (Opgen.generate opgen Opcode.GETDYNMET);
    | STOP ->
      export_uint8 (Opgen.generate opgen Opcode.STOP);
    | EVENT ->
      Tools.fail "unexpected debug instruction: EVENT";
    | BREAK ->
      Tools.fail "unexpected debug instruction: BREAK";
  ) code;
  List.rev !bytecode

(******************************************************************************)

let export code =
  let addrs = Array.map (fun _ -> -1) code in
  let opgen = Opgen.create () in
  let bytecode = ref [] in
  let continue = ref true in
  while !continue do
    let new_bytecode = export_code_from_addrs_opgen code addrs opgen in
    if Opgen.sort opgen = `ALREADY_SORTED && new_bytecode = !bytecode then continue := false
    else bytecode := new_bytecode;
  done;
  (!bytecode, Opgen.export opgen)

(******************************************************************************)
