open OByteLib.Instr
open T

(******************************************************************************)

let export_code_from_codemap code codemap =
  let bytecode = ref [] in
  let pc = ref 0 in

  (***)

  let export_opcode op =
    bytecode := OPCODE op :: !bytecode;
    incr pc in

  let export_int8 n =
    assert (n >= -0x80 && n < 0x80);
    bytecode := SBYTE n :: !bytecode;
    incr pc in

  let export_uint8 n =
    assert (n >= 0 && n < 0x100);
    bytecode := UBYTE n :: !bytecode;
    incr pc in

  let export_xint8 n =
    assert (n >= 0 && n < 0x100);
    bytecode := XBYTE n :: !bytecode;
    incr pc in

  let export_uint16 n =
    assert (n >= 0 && n < 0x10000);
    export_uint8 (n lsr 8);
    export_uint8 (n land 0xFF) in

  let export_int16 n =
    assert (n >= -0x8000 && n < 0x8000);
    export_int8 (n asr 8);
    export_uint8 (n land 0xFF) in

  let export_uint32 n =
    assert (n >= 0 && n < 0x1_0000_0000);
    export_uint8 (n lsr 24);
    export_uint8 ((n lsr 16) land 0xFF);
    export_uint8 ((n lsr 8) land 0xFF);
    export_uint8 (n land 0xFF) in

  let export_int32 n =
    assert (n >= -0x8000_0000 && n < 0x8000_0000);
    export_int8 (n asr 24);
    export_uint8 ((n lsr 16) land 0xFF);
    export_uint8 ((n lsr 8) land 0xFF);
    export_uint8 (n land 0xFF) in

  (***)

  let ofs_of_ptr ptr =
    let addr = codemap.(ptr) in
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
    codemap.(instr_ind) <- !pc;
    match instr with
    | STD ACC0 ->
      export_opcode Opcode.ACC0;
    | STD ACC1 ->
      export_opcode Opcode.ACC1;
    | STD ACC2 ->
      export_opcode Opcode.ACC2;
    | STD ACC3 ->
      export_opcode Opcode.ACC3;
    | STD ACC4 ->
      export_opcode Opcode.ACC4;
    | STD ACC5 ->
      export_opcode Opcode.ACC5;
    | STD ACC6 ->
      export_opcode Opcode.ACC6;
    | STD ACC7 ->
      export_opcode Opcode.ACC7;
    | STD (ACC n) ->
      check_bounds "ACC" n 8 0xFF;
      export_opcode Opcode.ACC;
      export_uint8 n;
    | STD PUSH | STD PUSHACC0 ->
      export_opcode Opcode.PUSH;
    | STD PUSHACC1 ->
      export_opcode Opcode.PUSHACC1;
    | STD PUSHACC2 ->
      export_opcode Opcode.PUSHACC2;
    | STD PUSHACC3 ->
      export_opcode Opcode.PUSHACC3;
    | STD PUSHACC4 ->
      export_opcode Opcode.PUSHACC4;
    | STD PUSHACC5 ->
      export_opcode Opcode.PUSHACC5;
    | STD PUSHACC6 ->
      export_opcode Opcode.PUSHACC6;
    | STD PUSHACC7 ->
      export_opcode Opcode.PUSHACC7;
    | STD (PUSHACC n) ->
      check_bounds "PUSHACC" n 8 0xFF;
      export_opcode Opcode.PUSHACC;
      export_uint8 n;
    | STD (POP n) ->
      check_bounds "POP" n 1 0xFF;
      export_opcode Opcode.POP;
      export_uint8 n;
    | STD (ASSIGN n) ->
      check_bounds "ASSIGN" n 0 0xFF;
      export_opcode Opcode.ASSIGN;
      export_uint8 n;
    | STD ENVACC1 | STD (ENVACC 1) ->
      export_opcode Opcode.ENVACC1;
    | STD ENVACC2 | STD (ENVACC 2) ->
      export_opcode Opcode.ENVACC2;
    | STD ENVACC3 | STD (ENVACC 3) ->
      export_opcode Opcode.ENVACC3;
    | STD ENVACC4 | STD (ENVACC 4) ->
      export_opcode Opcode.ENVACC4;
    | STD (ENVACC n) ->
      check_bounds "ENVACC" n 5 0xFF;
      export_opcode Opcode.ENVACC;
      export_uint8 n;
    | STD PUSHENVACC1 | STD (PUSHENVACC 1) ->
      export_opcode Opcode.PUSHENVACC1;
    | STD PUSHENVACC2 | STD (PUSHENVACC 2) ->
      export_opcode Opcode.PUSHENVACC2;
    | STD PUSHENVACC3 | STD (PUSHENVACC 3) ->
      export_opcode Opcode.PUSHENVACC3;
    | STD PUSHENVACC4 | STD (PUSHENVACC 4) ->
      export_opcode Opcode.PUSHENVACC4;
    | STD (PUSHENVACC n) ->
      check_bounds "PUSHENVACC" n 5 0xFF;
      export_opcode Opcode.PUSHENVACC;
      export_uint8 n;
    | STD (PUSH_RETADDR ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.push_retaddr in
      export_opcode opcode;
      export_ofs ofs;
    | STD (APPLY n) ->
      check_bounds "APPLY" n 4 0xFF;
      export_opcode Opcode.APPLY;
      export_uint8 n;
    | STD APPLY1 ->
      export_opcode Opcode.APPLY1;
    | STD APPLY2 ->
      export_opcode Opcode.APPLY2;
    | STD APPLY3 ->
      export_opcode Opcode.APPLY3;
    | STD (APPTERM (n, p)) ->
      check_bounds "APPTERM n:" n 0 0xFF;
      check_bounds "APPTERM p:" p 0 0xFF;
      export_opcode Opcode.APPTERM;
      export_uint8 n;
      export_uint8 p;
    | STD (APPTERM1 n) ->
      check_bounds "APPTERM1" n 0 0xFF;
      export_opcode Opcode.APPTERM1;
      export_uint8 n;
    | STD (APPTERM2 n) ->
      check_bounds "APPTERM2" n 0 0xFF;
      export_opcode Opcode.APPTERM2;
      export_uint8 n;
    | STD (APPTERM3 n) ->
      check_bounds "APPTERM3" n 0 0xFF;
      export_opcode Opcode.APPTERM3;
      export_uint8 n;
    | STD (RETURN n) ->
      check_bounds "RETURN" n 0 0xFF;
      export_opcode Opcode.RETURN;
      export_uint8 n;
    | STD RESTART ->
      export_opcode Opcode.RESTART;
    | STD (GRAB n) ->
      check_bounds "GRAB" n 0 0xFF;
      export_opcode Opcode.GRAB;
      export_uint8 n;
    | STD (CLOSURE (n, ptr)) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.closure in
      export_opcode opcode;
      export_uint8 n;
      export_ofs ofs;
    | STD (CLOSUREREC (f, v, o, t)) ->
      check_bounds "CLOSUREREC f:" f 0 0xFF;
      check_bounds "CLOSUREREC v:" v 0 0xFF;
      let oofs = ofs_of_ptr o in
      let tofss = Array.map ofs_of_ptr t in
      let kind = kind_of_int_list (oofs :: Array.to_list tofss) in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.closurerec in
      export_opcode opcode;
      export_uint8 f;
      export_uint8 v;
      export_ofs oofs;
      Array.iter export_ofs tofss;
    | STD OFFSETCLOSUREM2 ->
      export_opcode Opcode.OFFSETCLOSUREM2;
    | STD OFFSETCLOSURE0 ->
      export_opcode Opcode.OFFSETCLOSURE0;
    | STD OFFSETCLOSURE2 ->
      export_opcode Opcode.OFFSETCLOSURE2;
    | STD (OFFSETCLOSURE n) ->
      check_bounds "CLOSUREREC" n (-0x80) 0x7F;
      export_opcode Opcode.OFFSETCLOSURE;
      export_int8 n;
    | STD PUSHOFFSETCLOSUREM2 ->
      export_opcode Opcode.PUSHOFFSETCLOSUREM2;
    | STD PUSHOFFSETCLOSURE0 ->
      export_opcode Opcode.PUSHOFFSETCLOSURE0;
    | STD PUSHOFFSETCLOSURE2 ->
      export_opcode Opcode.PUSHOFFSETCLOSURE2;
    | STD (PUSHOFFSETCLOSURE n) ->
      check_bounds "PUSHOFFSETCLOSURE" n (-0x80) 0x7F;
      export_opcode Opcode.PUSHOFFSETCLOSURE;
      export_int8 n;
    | STD (GETGLOBAL _)
    | STD (PUSHGETGLOBAL _)
    | STD (GETGLOBALFIELD _)
    | STD (PUSHGETGLOBALFIELD _) ->
      assert false
    | GETRAMGLOBAL n ->
      check_bounds "GETGLOBAL" n 0 0xFFFF;
      if n < 0x100 then (
        export_opcode Opcode.GETRAMGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.GETRAMGLOBAL_2B;
        export_uint16 n;
      )
    | GETFLASHGLOBAL n ->
      check_bounds "GETGLOBAL" n 0 0xFFFF;
      if n < 0x100 then (
        export_opcode Opcode.GETFLASHGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.GETFLASHGLOBAL_2B;
        export_uint16 n;
      )
    | PUSHGETRAMGLOBAL n ->
      check_bounds "PUSHGETGLOBAL" n 0 0xFFFF;
      if n < 0x100 then (
        export_opcode Opcode.PUSHGETRAMGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.PUSHGETRAMGLOBAL_2B;
        export_uint16 n;
      )
    | PUSHGETFLASHGLOBAL n ->
      check_bounds "PUSHGETGLOBAL" n 0 0xFFFF;
      if n < 0x100 then (
        export_opcode Opcode.PUSHGETFLASHGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.PUSHGETFLASHGLOBAL_2B;
        export_uint16 n;
      )
    | GETRAMGLOBALFIELD (n, p) ->
      check_bounds "GETGLOBALFIELD n:" n 0 0xFFFF;
      check_bounds "GETGLOBALFIELD p:" p 0 0xFF;
      if n < 0x100 then (
        export_opcode Opcode.GETRAMGLOBALFIELD_1B;
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_opcode Opcode.GETRAMGLOBALFIELD_2B;
        export_uint16 n;
        export_uint8 p;
      )
    | GETFLASHGLOBALFIELD (n, p) ->
      check_bounds "GETGLOBALFIELD n:" n 0 0xFFFF;
      check_bounds "GETGLOBALFIELD p:" p 0 0xFF;
      if n < 0x100 then (
        export_opcode Opcode.GETFLASHGLOBALFIELD_1B;
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_opcode Opcode.GETFLASHGLOBALFIELD_2B;
        export_uint16 n;
        export_uint8 p;
      )
    | PUSHGETRAMGLOBALFIELD (n, p) ->
      check_bounds "PUSHGETGLOBALFIELD n:" n 0 0xFFFF;
      check_bounds "PUSHGETGLOBALFIELD p:" p 0 0xFF;
      if n < 0x100 then (
        export_opcode Opcode.PUSHGETRAMGLOBALFIELD_1B;
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_opcode Opcode.PUSHGETRAMGLOBALFIELD_2B;
        export_uint16 n;
        export_uint8 p;
      )
    | PUSHGETFLASHGLOBALFIELD (n, p) ->
      check_bounds "PUSHGETGLOBALFIELD n:" n 0 0xFFFF;
      check_bounds "PUSHGETGLOBALFIELD p:" p 0 0xFF;
      if n < 0x100 then (
        export_opcode Opcode.PUSHGETFLASHGLOBALFIELD_1B;
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_opcode Opcode.PUSHGETFLASHGLOBALFIELD_2B;
        export_uint16 n;
        export_uint8 p;
      )
    | STD (SETGLOBAL n) ->
      check_bounds "SETRAMGLOBAL" n 0 0xFFFF;
      if n < 0x100 then (
        export_opcode Opcode.SETRAMGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.SETRAMGLOBAL_2B;
        export_uint16 n;
      )
    | STD ATOM0 ->
      export_opcode Opcode.ATOM0;
    | STD (ATOM _) ->
      Tools.fail "ATOM with non-zero tag is not supported";
    | STD PUSHATOM0 ->
      export_opcode Opcode.PUSHATOM0;
    | STD (PUSHATOM _) ->
      Tools.fail "PUSHATOM with non-zero tag is not supported";
    | STD (MAKEBLOCK (tag, size)) ->
      check_bounds "MAKEBLOCK tag:" tag 0 0xFF;
      check_bounds "MAKEBLOCK size:" size 1 0xFFFF;
      if size < 0x100 then (
        export_opcode Opcode.MAKEBLOCK_1B;
        export_uint8 tag;
        export_uint8 size;
      ) else (
        export_opcode Opcode.MAKEBLOCK_2B;
        export_uint8 tag;
        export_uint16 size;
      )
    | STD (MAKEBLOCK1 tag) ->
      check_bounds "MAKEBLOCK1" tag 0 0xFF;
      export_opcode Opcode.MAKEBLOCK1;
      export_uint8 tag;
    | STD (MAKEBLOCK2 tag) ->
      check_bounds "MAKEBLOCK2" tag 0 0xFF;
      export_opcode Opcode.MAKEBLOCK2;
      export_uint8 tag;
    | STD (MAKEBLOCK3 tag) ->
      check_bounds "MAKEBLOCK3" tag 0 0xFF;
      export_opcode Opcode.MAKEBLOCK3;
      export_uint8 tag;
    | STD (MAKEFLOATBLOCK 1) ->
      export_opcode Opcode.MAKEBLOCK1;
      export_uint8 0;
    | STD (MAKEFLOATBLOCK 2) ->
      export_opcode Opcode.MAKEBLOCK2;
      export_uint8 0;
    | STD (MAKEFLOATBLOCK 3) ->
      export_opcode Opcode.MAKEBLOCK3;
      export_uint8 0;
    | STD (MAKEFLOATBLOCK size) ->
      check_bounds "MAKEFLOATBLOCK" size 4 0xFFFF;
      if size < 0x100 then (
        export_opcode Opcode.MAKEBLOCK_1B;
        export_uint8 0;
        export_uint8 size;
      ) else (
        export_opcode Opcode.MAKEBLOCK_2B;
        export_uint8 0;
        export_uint16 size;
      )
    | STD GETFIELD0 | STD (GETFLOATFIELD 0) ->
      export_opcode Opcode.GETFIELD0;
    | STD GETFIELD1 | STD (GETFLOATFIELD 1) ->
      export_opcode Opcode.GETFIELD1;
    | STD GETFIELD2 | STD (GETFLOATFIELD 2) ->
      export_opcode Opcode.GETFIELD2;
    | STD GETFIELD3 | STD (GETFLOATFIELD 3) ->
      export_opcode Opcode.GETFIELD3;
    | STD GETFIELD n | STD (GETFLOATFIELD n) ->
      check_bounds "GETFIELD" n 4 0xFF;
      export_opcode Opcode.GETFIELD;
      export_uint8 n;
    | STD SETFIELD0 | STD (SETFLOATFIELD 0) ->
      export_opcode Opcode.SETFIELD0;
    | STD SETFIELD1 | STD (SETFLOATFIELD 1) ->
      export_opcode Opcode.SETFIELD1;
    | STD SETFIELD2 | STD (SETFLOATFIELD 2) ->
      export_opcode Opcode.SETFIELD2;
    | STD SETFIELD3 | STD (SETFLOATFIELD 3) ->
      export_opcode Opcode.SETFIELD3;
    | STD (SETFIELD n) | STD (SETFLOATFIELD n) ->
      check_bounds "SETFIELD" n 0 0xFF;
      export_opcode Opcode.SETFIELD;
      export_uint8 n;
    | STD VECTLENGTH ->
      export_opcode Opcode.VECTLENGTH;
    | STD GETVECTITEM ->
      export_opcode Opcode.GETVECTITEM;
    | STD SETVECTITEM ->
      export_opcode Opcode.SETVECTITEM;
    | STD GETBYTESCHAR ->
      export_opcode Opcode.GETBYTESCHAR;
    | STD SETBYTESCHAR ->
      export_opcode Opcode.SETBYTESCHAR;
    | STD GETSTRINGCHAR ->
      export_opcode Opcode.GETBYTESCHAR;
    | STD (BRANCH ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branch in
      export_opcode opcode;
      export_ofs ofs;
    | STD (BRANCHIF ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branchif in
      export_opcode opcode;
      export_ofs ofs;
    | STD (BRANCHIFNOT ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branchifnot in
      export_opcode opcode;
      export_ofs ofs;
    | STD (SWITCH (n, ptrs)) ->
      check_bounds "SWITCH ofs:" (n land 0xFFFF) 0 0xFF;
      check_bounds "SWITCH sz:" (n lsr 16) 0 0xFF;
      let ofss = Array.map ofs_of_ptr ptrs in
      let kind = kind_of_int_list (Array.to_list ofss) in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.switch in
      export_opcode opcode;
      export_uint8 (n land 0xFFFF);
      export_uint8 (n lsr 16);
      Array.iter export_ofs ofss;
    | STD BOOLNOT ->
      export_opcode Opcode.BOOLNOT;
    | STD (PUSHTRAP ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushtrap in
      export_opcode opcode;
      export_ofs ofs;
    | STD POPTRAP ->
      export_opcode Opcode.POPTRAP;
    | STD RAISE ->
      export_opcode Opcode.RAISE;
    | STD RERAISE ->
      export_opcode Opcode.RAISE;
    | STD RAISE_NOTRACE ->
      export_opcode Opcode.RAISE;
    | STD CHECK_SIGNALS ->
      export_opcode Opcode.CHECK_SIGNALS;
    | STD (C_CALL1 idx) ->
      check_bounds "C_CALL1" idx 0 0xFF;
      export_opcode Opcode.C_CALL1;
      export_uint8 idx;
    | STD (C_CALL2 idx) ->
      check_bounds "C_CALL2" idx 0 0xFF;
      export_opcode Opcode.C_CALL2;
      export_uint8 idx;
    | STD (C_CALL3 idx) ->
      check_bounds "C_CALL3" idx 0 0xFF;
      export_opcode Opcode.C_CALL3;
      export_uint8 idx;
    | STD (C_CALL4 idx) ->
      check_bounds "C_CALL4" idx 0 0xFF;
      export_opcode Opcode.C_CALL4;
      export_uint8 idx;
    | STD (C_CALL5 idx) ->
      check_bounds "C_CALL5" idx 0 0xFF;
      export_opcode Opcode.C_CALL5;
      export_uint8 idx;
    | STD (C_CALLN (narg, idx)) ->
      check_bounds "C_CALLN narg:" narg 0 0xFF;
      check_bounds "C_CALLN idx:" idx 0 0xFF;
      export_opcode Opcode.C_CALLN;
      export_uint8 narg;
      export_uint8 idx;
    | CONSTFLOAT bytes ->
      export_opcode Opcode.CONSTFLOAT;
      List.iter export_xint8 bytes;
    | PUSHCONSTFLOAT bytes ->
      export_opcode Opcode.PUSHCONSTFLOAT;
      List.iter export_xint8 bytes;
    | STD CONST0 | STD (CONSTINT 0) ->
      export_opcode Opcode.CONST0;
    | STD CONST1 | STD (CONSTINT 1) ->
      export_opcode Opcode.CONST1;
    | STD CONST2 | STD (CONSTINT 2) ->
      export_opcode Opcode.CONST2;
    | STD CONST3 | STD (CONSTINT 3) ->
      export_opcode Opcode.CONST3;
    | STD (CONSTINT n) ->
      check_bounds "CONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.constint in
      export_opcode opcode;
      export_int n;
    | STD PUSHCONST0 | STD (PUSHCONSTINT 0) ->
      export_opcode Opcode.PUSHCONST0;
    | STD PUSHCONST1 | STD (PUSHCONSTINT 1) ->
      export_opcode Opcode.PUSHCONST1;
    | STD PUSHCONST2 | STD (PUSHCONSTINT 2) ->
      export_opcode Opcode.PUSHCONST2;
    | STD PUSHCONST3 | STD (PUSHCONSTINT 3) ->
      export_opcode Opcode.PUSHCONST3;
    | STD (PUSHCONSTINT n) ->
      check_bounds "PUSHCONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushconstint in
      export_opcode opcode;
      export_int n;
    | STD NEGINT ->
      export_opcode Opcode.NEGINT;
    | STD ADDINT ->
      export_opcode Opcode.ADDINT;
    | STD SUBINT ->
      export_opcode Opcode.SUBINT;
    | STD MULINT ->
      export_opcode Opcode.MULINT;
    | STD DIVINT ->
      export_opcode Opcode.DIVINT;
    | STD MODINT ->
      export_opcode Opcode.MODINT;
    | STD ANDINT ->
      export_opcode Opcode.ANDINT;
    | STD ORINT ->
      export_opcode Opcode.ORINT;
    | STD XORINT ->
      export_opcode Opcode.XORINT;
    | STD LSLINT ->
      export_opcode Opcode.LSLINT;
    | STD LSRINT ->
      export_opcode Opcode.LSRINT;
    | STD ASRINT ->
      export_opcode Opcode.ASRINT;
    | STD EQ ->
      export_opcode Opcode.EQ;
    | STD NEQ ->
      export_opcode Opcode.NEQ;
    | STD LTINT ->
      export_opcode Opcode.LTINT;
    | STD LEINT ->
      export_opcode Opcode.LEINT;
    | STD GTINT ->
      export_opcode Opcode.GTINT;
    | STD GEINT ->
      export_opcode Opcode.GEINT;
    | STD (OFFSETINT 0) ->
      ()
    | STD (OFFSETINT n) ->
      check_bounds "OFFSETINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetint in
      export_opcode opcode;
      export_int n;
    | STD (OFFSETREF 0) ->
      ()
    | STD (OFFSETREF n) ->
      check_bounds "OFFSETREF" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetref in
      export_opcode opcode;
      export_int n;
    | STD ISINT ->
      export_opcode Opcode.ISINT;
    | STD GETMETHOD ->
      export_opcode Opcode.GETMETHOD;
    | STD (BEQ (n, ptr)) ->
      check_bounds "BEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.beq in
      export_opcode opcode;
      export n;
      export ofs;
    | STD (BNEQ (n, ptr)) ->
      check_bounds "BNEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bneq in
      export_opcode opcode;
      export n;
      export ofs;
    | STD (BLTINT (n, ptr)) ->
      check_bounds "BLTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bltint in
      export_opcode opcode;
      export n;
      export ofs;
    | STD (BLEINT (n, ptr)) ->
      check_bounds "BLEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bleint in
      export_opcode opcode;
      export n;
      export ofs;
    | STD (BGTINT (n, ptr)) ->
      check_bounds "BGTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgtint in
      export_opcode opcode;
      export n;
      export ofs;
    | STD (BGEINT (n, ptr)) ->
      check_bounds "BGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgeint in
      export_opcode opcode;
      export n;
      export ofs;
    | STD ULTINT ->
      export_opcode Opcode.ULTINT;
    | STD UGEINT ->
      export_opcode Opcode.UGEINT;
    | STD (BULTINT (n, ptr)) ->
      check_bounds "BULTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bultint in
      export_opcode opcode;
      export n;
      export ofs;
    | STD (BUGEINT (n, ptr)) ->
      check_bounds "BUGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bugeint in
      export_opcode opcode;
      export n;
      export ofs;
    | STD (GETPUBMET (htag, _cache)) ->
      export_opcode Opcode.GETPUBMET;
      export_uint32 (htag land 0x7FFF_FFFF);
    | STD GETDYNMET ->
      export_opcode Opcode.GETDYNMET;
    | STD STOP ->
      export_opcode Opcode.STOP;
    | STD EVENT ->
      Tools.fail "unexpected debug instruction: EVENT";
    | STD BREAK ->
      Tools.fail "unexpected debug instruction: BREAK";
  ) code;
  List.rev !bytecode

(******************************************************************************)

let opcodes_of_bytecode bytecode =
  let htbl = Hashtbl.create 16 in
  List.iter (fun word ->
    match word with
    | SBYTE _ | UBYTE _ | XBYTE _ -> ()
    | OPCODE op -> Hashtbl.replace htbl op ()
  ) bytecode;
  let lst = Hashtbl.fold (fun op () acc -> op :: acc) htbl [] in
  List.sort compare lst

(******************************************************************************)

let export code =
  let codemap = Array.map (fun _ -> -1) code in
  let bytecode = ref [] in
  let continue = ref true in
  while !continue do
    let new_bytecode = export_code_from_codemap code codemap in
    if new_bytecode = !bytecode then continue := false
    else bytecode := new_bytecode;
  done;
  (!bytecode, opcodes_of_bytecode !bytecode, codemap)

(******************************************************************************)
