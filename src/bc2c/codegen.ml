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
    | ACC0 ->
      export_opcode Opcode.ACC0;
    | ACC1 ->
      export_opcode Opcode.ACC1;
    | ACC2 ->
      export_opcode Opcode.ACC2;
    | ACC3 ->
      export_opcode Opcode.ACC3;
    | ACC4 ->
      export_opcode Opcode.ACC4;
    | ACC5 ->
      export_opcode Opcode.ACC5;
    | ACC6 ->
      export_opcode Opcode.ACC6;
    | ACC7 ->
      export_opcode Opcode.ACC7;
    | ACC n ->
      check_bounds "ACC" n 8 255;
      export_opcode Opcode.ACC;
      export_uint8 n;
    | PUSH | PUSHACC0 ->
      export_opcode Opcode.PUSH;
    | PUSHACC1 ->
      export_opcode Opcode.PUSHACC1;
    | PUSHACC2 ->
      export_opcode Opcode.PUSHACC2;
    | PUSHACC3 ->
      export_opcode Opcode.PUSHACC3;
    | PUSHACC4 ->
      export_opcode Opcode.PUSHACC4;
    | PUSHACC5 ->
      export_opcode Opcode.PUSHACC5;
    | PUSHACC6 ->
      export_opcode Opcode.PUSHACC6;
    | PUSHACC7 ->
      export_opcode Opcode.PUSHACC7;
    | PUSHACC n ->
      check_bounds "PUSHACC" n 8 255;
      export_opcode Opcode.PUSHACC;
      export_uint8 n;
    | POP n ->
      check_bounds "POP" n 1 255;
      export_opcode Opcode.POP;
      export_uint8 n;
    | ASSIGN n ->
      check_bounds "ASSIGN" n 0 255;
      export_opcode Opcode.ASSIGN;
      export_uint8 n;
    | ENVACC1 | ENVACC 1 ->
      export_opcode Opcode.ENVACC1;
    | ENVACC2 | ENVACC 2 ->
      export_opcode Opcode.ENVACC2;
    | ENVACC3 | ENVACC 3 ->
      export_opcode Opcode.ENVACC3;
    | ENVACC4 | ENVACC 4 ->
      export_opcode Opcode.ENVACC4;
    | ENVACC n ->
      check_bounds "ENVACC" n 5 255;
      export_opcode Opcode.ENVACC;
      export_uint8 n;
    | PUSHENVACC1 | PUSHENVACC 1 ->
      export_opcode Opcode.PUSHENVACC1;
    | PUSHENVACC2 | PUSHENVACC 2 ->
      export_opcode Opcode.PUSHENVACC2;
    | PUSHENVACC3 | PUSHENVACC 3 ->
      export_opcode Opcode.PUSHENVACC3;
    | PUSHENVACC4 | PUSHENVACC 4 ->
      export_opcode Opcode.PUSHENVACC4;
    | PUSHENVACC n ->
      check_bounds "PUSHENVACC" n 5 255;
      export_opcode Opcode.PUSHENVACC;
      export_uint8 n;
    | PUSH_RETADDR ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.push_retaddr in
      export_opcode opcode;
      export_ofs ofs;
    | APPLY n ->
      check_bounds "APPLY" n 4 255;
      export_opcode Opcode.APPLY;
      export_uint8 n;
    | APPLY1 ->
      export_opcode Opcode.APPLY1;
    | APPLY2 ->
      export_opcode Opcode.APPLY2;
    | APPLY3 ->
      export_opcode Opcode.APPLY3;
    | APPTERM (n, p) ->
      check_bounds "APPTERM n:" n 0 255;
      check_bounds "APPTERM p:" p 0 255;
      export_opcode Opcode.APPTERM;
      export_uint8 n;
      export_uint8 p;
    | APPTERM1 n ->
      check_bounds "APPTERM1" n 0 255;
      export_opcode Opcode.APPTERM1;
      export_uint8 n;
    | APPTERM2 n ->
      check_bounds "APPTERM2" n 0 255;
      export_opcode Opcode.APPTERM2;
      export_uint8 n;
    | APPTERM3 n ->
      check_bounds "APPTERM3" n 0 255;
      export_opcode Opcode.APPTERM3;
      export_uint8 n;
    | RETURN n ->
      check_bounds "RETURN" n 0 255;
      export_opcode Opcode.RETURN;
      export_uint8 n;
    | RESTART ->
      export_opcode Opcode.RESTART;
    | GRAB n ->
      check_bounds "GRAB" n 0 255;
      export_opcode Opcode.GRAB;
      export_uint8 n;
    | CLOSURE (n, ptr) ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.closure in
      export_opcode opcode;
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
      export_opcode opcode;
      export_uint8 f;
      export_uint8 v;
      export_ofs oofs;
      Array.iter export_ofs tofss;
    | OFFSETCLOSUREM2 ->
      export_opcode Opcode.OFFSETCLOSUREM2;
    | OFFSETCLOSURE0 ->
      export_opcode Opcode.OFFSETCLOSURE0;
    | OFFSETCLOSURE2 ->
      export_opcode Opcode.OFFSETCLOSURE2;
    | OFFSETCLOSURE n ->
      check_bounds "CLOSUREREC" n (-0x80) 0x7F;
      export_opcode Opcode.OFFSETCLOSURE;
      export_int8 n;
    | PUSHOFFSETCLOSUREM2 ->
      export_opcode Opcode.PUSHOFFSETCLOSUREM2;
    | PUSHOFFSETCLOSURE0 ->
      export_opcode Opcode.PUSHOFFSETCLOSURE0;
    | PUSHOFFSETCLOSURE2 ->
      export_opcode Opcode.PUSHOFFSETCLOSURE2;
    | PUSHOFFSETCLOSURE n ->
      check_bounds "PUSHOFFSETCLOSURE" n (-0x80) 0x7F;
      export_opcode Opcode.PUSHOFFSETCLOSURE;
      export_int8 n;
    | GETGLOBAL n ->
      check_bounds "GETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_opcode Opcode.GETGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.GETGLOBAL_2B;
        export_uint16 n;
      )
    | PUSHGETGLOBAL n ->
      check_bounds "PUSHGETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_opcode Opcode.PUSHGETGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.PUSHGETGLOBAL_2B;
        export_uint16 n;
      )
    | GETGLOBALFIELD (n, p) ->
      check_bounds "GETGLOBALFIELD n:" n 0 0x10000;
      check_bounds "GETGLOBALFIELD p:" p 0 0x100;
      if n < 0x100 then (
        export_opcode Opcode.GETGLOBALFIELD_1B;
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_opcode Opcode.GETGLOBALFIELD_2B;
        export_uint16 n;
        export_uint8 p;
      )
    | PUSHGETGLOBALFIELD (n, p) ->
      check_bounds "PUSHGETGLOBALFIELD n:" n 0 0x10000;
      check_bounds "PUSHGETGLOBALFIELD p:" p 0 0x100;
      if n < 0x100 then (
        export_opcode Opcode.PUSHGETGLOBALFIELD_1B;
        export_uint8 n;
        export_uint8 p;
      ) else (
        export_opcode Opcode.PUSHGETGLOBALFIELD_2B;
        export_uint16 n;
        export_uint8 p;
      )
    | SETGLOBAL n ->
      check_bounds "SETGLOBAL" n 0 0x10000;
      if n < 0x100 then (
        export_opcode Opcode.SETGLOBAL_1B;
        export_uint8 n;
      ) else (
        export_opcode Opcode.SETGLOBAL_2B;
        export_uint16 n;
      )
    | ATOM0 ->
      export_opcode Opcode.ATOM0;
    | ATOM _ ->
      Tools.fail "ATOM with non-zero tag is not supported";
    | PUSHATOM0 ->
      export_opcode Opcode.PUSHATOM0;
    | PUSHATOM _ ->
      Tools.fail "PUSHATOM with non-zero tag is not supported";
    | MAKEBLOCK (tag, size) ->
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
    | MAKEBLOCK1 tag ->
      check_bounds "MAKEBLOCK1" tag 0 255;
      export_opcode Opcode.MAKEBLOCK1;
      export_uint8 tag;
    | MAKEBLOCK2 tag ->
      check_bounds "MAKEBLOCK2" tag 0 255;
      export_opcode Opcode.MAKEBLOCK2;
      export_uint8 tag;
    | MAKEBLOCK3 tag ->
      check_bounds "MAKEBLOCK3" tag 0 255;
      export_opcode Opcode.MAKEBLOCK3;
      export_uint8 tag;
    | MAKEFLOATBLOCK 1 ->
      export_opcode Opcode.MAKEBLOCK1;
      export_uint8 0;
    | MAKEFLOATBLOCK 2 ->
      export_opcode Opcode.MAKEBLOCK2;
      export_uint8 0;
    | MAKEFLOATBLOCK 3 ->
      export_opcode Opcode.MAKEBLOCK3;
      export_uint8 0;
    | MAKEFLOATBLOCK size ->
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
    | GETFIELD0 | GETFLOATFIELD 0 ->
      export_opcode Opcode.GETFIELD0;
    | GETFIELD1 | GETFLOATFIELD 1 ->
      export_opcode Opcode.GETFIELD1;
    | GETFIELD2 | GETFLOATFIELD 2 ->
      export_opcode Opcode.GETFIELD2;
    | GETFIELD3 | GETFLOATFIELD 3 ->
      export_opcode Opcode.GETFIELD3;
    | GETFIELD n | GETFLOATFIELD n ->
      check_bounds "GETFIELD" n 4 255;
      export_opcode Opcode.GETFIELD;
      export_uint8 n;
    | SETFIELD0 | SETFLOATFIELD 0 ->
      export_opcode Opcode.SETFIELD0;
    | SETFIELD1 | SETFLOATFIELD 1 ->
      export_opcode Opcode.SETFIELD1;
    | SETFIELD2 | SETFLOATFIELD 2 ->
      export_opcode Opcode.SETFIELD2;
    | SETFIELD3 | SETFLOATFIELD 3 ->
      export_opcode Opcode.SETFIELD3;
    | SETFIELD n | SETFLOATFIELD n ->
      check_bounds "SETFIELD" n 0 255;
      export_opcode Opcode.SETFIELD;
      export_uint8 n;
    | VECTLENGTH ->
      export_opcode Opcode.VECTLENGTH;
    | GETVECTITEM ->
      export_opcode Opcode.GETVECTITEM;
    | SETVECTITEM ->
      export_opcode Opcode.SETVECTITEM;
    | GETSTRINGCHAR ->
      export_opcode Opcode.GETSTRINGCHAR;
    | SETSTRINGCHAR ->
      export_opcode Opcode.SETSTRINGCHAR;
    | BRANCH ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branch in
      export_opcode opcode;
      export_ofs ofs;
    | BRANCHIF ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branchif in
      export_opcode opcode;
      export_ofs ofs;
    | BRANCHIFNOT ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.branchifnot in
      export_opcode opcode;
      export_ofs ofs;
    | SWITCH (n, ptrs) ->
      check_bounds "SWITCH ofs:" (n land 0xFFFF) 0 255;
      check_bounds "SWITCH sz:" (n lsr 16) 0 255;
      let ofss = Array.map ofs_of_ptr ptrs in
      let kind = kind_of_int_list (Array.to_list ofss) in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.switch in
      export_opcode opcode;
      export_uint8 (n land 0xFFFF);
      export_uint8 (n lsr 16);
      Array.iter export_ofs ofss;
    | BOOLNOT ->
      export_opcode Opcode.BOOLNOT;
    | PUSHTRAP ptr ->
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int ofs in
      let export_ofs = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushtrap in
      export_opcode opcode;
      export_ofs ofs;
    | POPTRAP ->
      export_opcode Opcode.POPTRAP;
    | RAISE ->
      export_opcode Opcode.RAISE;
    | RERAISE ->
      export_opcode Opcode.RAISE;
    | RAISE_NOTRACE ->
      export_opcode Opcode.RAISE;
    | CHECK_SIGNALS ->
      export_opcode Opcode.CHECK_SIGNALS;
    | C_CALL1 idx ->
      check_bounds "C_CALL1" idx 0 255;
      export_opcode Opcode.C_CALL1;
      export_uint8 idx;
    | C_CALL2 idx ->
      check_bounds "C_CALL2" idx 0 255;
      export_opcode Opcode.C_CALL2;
      export_uint8 idx;
    | C_CALL3 idx ->
      check_bounds "C_CALL3" idx 0 255;
      export_opcode Opcode.C_CALL3;
      export_uint8 idx;
    | C_CALL4 idx ->
      check_bounds "C_CALL4" idx 0 255;
      export_opcode Opcode.C_CALL4;
      export_uint8 idx;
    | C_CALL5 idx ->
      check_bounds "C_CALL5" idx 0 255;
      export_opcode Opcode.C_CALL5;
      export_uint8 idx;
    | C_CALLN (narg, idx) ->
      check_bounds "C_CALLN narg:" narg 0 255;
      check_bounds "C_CALLN idx:" idx 0 255;
      export_opcode Opcode.C_CALLN;
      export_uint8 narg;
      export_uint8 idx;
    | CONST0 ->
      export_opcode Opcode.CONST0;
    | CONST1 ->
      export_opcode Opcode.CONST1;
    | CONST2 ->
      export_opcode Opcode.CONST2;
    | CONST3 ->
      export_opcode Opcode.CONST3;
    | CONSTINT n ->
      check_bounds "CONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.constint in
      export_opcode opcode;
      export_int n;
    | PUSHCONST0 ->
      export_opcode Opcode.PUSHCONST0;
    | PUSHCONST1 ->
      export_opcode Opcode.PUSHCONST1;
    | PUSHCONST2 ->
      export_opcode Opcode.PUSHCONST2;
    | PUSHCONST3 ->
      export_opcode Opcode.PUSHCONST3;
    | PUSHCONSTINT n ->
      check_bounds "PUSHCONSTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.pushconstint in
      export_opcode opcode;
      export_int n;
    | NEGINT ->
      export_opcode Opcode.NEGINT;
    | ADDINT ->
      export_opcode Opcode.ADDINT;
    | SUBINT ->
      export_opcode Opcode.SUBINT;
    | MULINT ->
      export_opcode Opcode.MULINT;
    | DIVINT ->
      export_opcode Opcode.DIVINT;
    | MODINT ->
      export_opcode Opcode.MODINT;
    | ANDINT ->
      export_opcode Opcode.ANDINT;
    | ORINT ->
      export_opcode Opcode.ORINT;
    | XORINT ->
      export_opcode Opcode.XORINT;
    | LSLINT ->
      export_opcode Opcode.LSLINT;
    | LSRINT ->
      export_opcode Opcode.LSRINT;
    | ASRINT ->
      export_opcode Opcode.ASRINT;
    | EQ ->
      export_opcode Opcode.EQ;
    | NEQ ->
      export_opcode Opcode.NEQ;
    | LTINT ->
      export_opcode Opcode.LTINT;
    | LEINT ->
      export_opcode Opcode.LEINT;
    | GTINT ->
      export_opcode Opcode.GTINT;
    | GEINT ->
      export_opcode Opcode.GEINT;
    | OFFSETINT n ->
      check_bounds "OFFSETINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetint in
      export_opcode opcode;
      export_int n;
    | OFFSETREF n ->
      check_bounds "OFFSETREF" n (-0x8000_0000) 0x7FFF_FFFF;
      let kind = kind_of_int n in
      let export_int = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.offsetref in
      export_opcode opcode;
      export_int n;
    | ISINT ->
      export_opcode Opcode.ISINT;
    | GETMETHOD ->
      export_opcode Opcode.GETMETHOD;
    | BEQ (n, ptr) ->
      check_bounds "BEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.beq in
      export_opcode opcode;
      export n;
      export ofs;
    | BNEQ (n, ptr) ->
      check_bounds "BNEQ" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bneq in
      export_opcode opcode;
      export n;
      export ofs;
    | BLTINT (n, ptr) ->
      check_bounds "BLTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bltint in
      export_opcode opcode;
      export n;
      export ofs;
    | BLEINT (n, ptr) ->
      check_bounds "BLEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bleint in
      export_opcode opcode;
      export n;
      export ofs;
    | BGTINT (n, ptr) ->
      check_bounds "BGTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgtint in
      export_opcode opcode;
      export n;
      export ofs;
    | BGEINT (n, ptr) ->
      check_bounds "BGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bgeint in
      export_opcode opcode;
      export n;
      export ofs;
    | ULTINT ->
      export_opcode Opcode.ULTINT;
    | UGEINT ->
      export_opcode Opcode.UGEINT;
    | BULTINT (n, ptr) ->
      check_bounds "BULTINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bultint in
      export_opcode opcode;
      export n;
      export ofs;
    | BUGEINT (n, ptr) ->
      check_bounds "BUGEINT" n (-0x8000_0000) 0x7FFF_FFFF;
      let ofs = ofs_of_ptr ptr in
      let kind = kind_of_int_list [ n; ofs ] in
      let export = export_of_kind kind in
      let opcode = opcode_of_kind kind Opcode.bugeint in
      export_opcode opcode;
      export n;
      export ofs;
    | GETPUBMET (htag, _cache) ->
      export_opcode Opcode.GETPUBMET;
      export_uint32 htag;
    | GETDYNMET ->
      export_opcode Opcode.GETDYNMET;
    | STOP ->
      export_opcode Opcode.STOP;
    | EVENT ->
      Tools.fail "unexpected debug instruction: EVENT";
    | BREAK ->
      Tools.fail "unexpected debug instruction: BREAK";
  ) code;
  List.rev !bytecode

(******************************************************************************)

let opcodes_of_bytecode bytecode =
  let htbl = Hashtbl.create 16 in
  List.iter (fun word ->
    match word with
    | SBYTE _ | UBYTE _ -> ()
    | OPCODE op -> Hashtbl.replace htbl op ()
  ) bytecode;
  let lst = Hashtbl.fold (fun op () acc -> op :: acc) htbl [] in
  List.sort Pervasives.compare lst

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
