(******************************************************************************)

let new_opcode =
  let cnt = ref (-1) in
  fun () -> incr cnt; assert (!cnt < 256); !cnt

let new_opcode_12 () =
  let op_1B = new_opcode () in
  let op_2B = new_opcode () in
  (op_1B, op_2B)

let new_opcode_124 () =
  let op_1B = new_opcode () in
  let op_2B = new_opcode () in
  let op_4B = new_opcode () in
  (op_1B, op_2B, op_4B)
    
(******************************************************************************)

let acc0                  = new_opcode ()
let acc1                  = new_opcode ()
let acc2                  = new_opcode ()
let acc3                  = new_opcode ()
let acc4                  = new_opcode ()
let acc5                  = new_opcode ()
let acc6                  = new_opcode ()
let acc7                  = new_opcode ()
let acc                   = new_opcode ()
let push                  = new_opcode ()
let pushacc1              = new_opcode ()
let pushacc2              = new_opcode ()
let pushacc3              = new_opcode ()
let pushacc4              = new_opcode ()
let pushacc5              = new_opcode ()
let pushacc6              = new_opcode ()
let pushacc7              = new_opcode ()
let pushacc               = new_opcode ()
let pop                   = new_opcode ()
let assign                = new_opcode ()
let envacc1               = new_opcode ()
let envacc2               = new_opcode ()
let envacc3               = new_opcode ()
let envacc4               = new_opcode ()
let envacc                = new_opcode ()
let pushenvacc1           = new_opcode ()
let pushenvacc2           = new_opcode ()
let pushenvacc3           = new_opcode ()
let pushenvacc4           = new_opcode ()
let pushenvacc            = new_opcode ()
let push_retaddr          = new_opcode_124 ()
let apply                 = new_opcode ()
let apply1                = new_opcode ()
let apply2                = new_opcode ()
let apply3                = new_opcode ()
let appterm               = new_opcode ()
let appterm1              = new_opcode ()
let appterm2              = new_opcode ()
let appterm3              = new_opcode ()
let return                = new_opcode ()
let restart               = new_opcode ()
let grab                  = new_opcode ()
let closure               = new_opcode_124 ()
let closurerec            = new_opcode_124 ()
let offsetclosurem2       = new_opcode ()
let offsetclosure0        = new_opcode ()
let offsetclosure2        = new_opcode ()
let offsetclosure         = new_opcode ()
let pushoffsetclosurem2   = new_opcode ()
let pushoffsetclosure0    = new_opcode ()
let pushoffsetclosure2    = new_opcode ()
let pushoffsetclosure     = new_opcode ()
let getglobal             = new_opcode_12 ()
let pushgetglobal         = new_opcode_12 ()
let getglobalfield        = new_opcode_12 ()
let pushgetglobalfield    = new_opcode_12 ()
let setglobal             = new_opcode_12 ()
let atom0                 = new_opcode ()
let pushatom0             = new_opcode ()
let makeblock             = new_opcode_12 ()
let makeblock1            = new_opcode ()
let makeblock2            = new_opcode ()
let makeblock3            = new_opcode ()
let makefloatblock        = new_opcode ()
let getfield0             = new_opcode ()
let getfield1             = new_opcode ()
let getfield2             = new_opcode ()
let getfield3             = new_opcode ()
let getfield              = new_opcode ()
let getfloatfield         = new_opcode ()
let setfield0             = new_opcode ()
let setfield1             = new_opcode ()
let setfield2             = new_opcode ()
let setfield3             = new_opcode ()
let setfield              = new_opcode ()
let setfloatfield         = new_opcode ()
let vectlength            = new_opcode ()
let getvectitem           = new_opcode ()
let setvectitem           = new_opcode ()
let getstringchar         = new_opcode ()
let setstringchar         = new_opcode ()
let branch                = new_opcode_124 ()
let branchif              = new_opcode_124 ()
let branchifnot           = new_opcode_124 ()
let switch                = new_opcode_124 ()
let boolnot               = new_opcode ()
let pushtrap              = new_opcode_124 ()
let poptrap               = new_opcode ()
let raise                 = new_opcode ()
let check_signals         = new_opcode ()
let c_call1               = new_opcode ()
let c_call2               = new_opcode ()
let c_call3               = new_opcode ()
let c_call4               = new_opcode ()
let c_call5               = new_opcode ()
let c_calln               = new_opcode ()
let const0                = new_opcode ()
let const1                = new_opcode ()
let const2                = new_opcode ()
let const3                = new_opcode ()
let constint              = new_opcode_124 ()
let pushconst0            = new_opcode ()
let pushconst1            = new_opcode ()
let pushconst2            = new_opcode ()
let pushconst3            = new_opcode ()
let pushconstint          = new_opcode_124 ()
let negint                = new_opcode ()
let addint                = new_opcode ()
let subint                = new_opcode ()
let mulint                = new_opcode ()
let divint                = new_opcode ()
let modint                = new_opcode ()
let andint                = new_opcode ()
let orint                 = new_opcode ()
let xorint                = new_opcode ()
let lslint                = new_opcode ()
let lsrint                = new_opcode ()
let asrint                = new_opcode ()
let eq                    = new_opcode ()
let neq                   = new_opcode ()
let ltint                 = new_opcode ()
let leint                 = new_opcode ()
let gtint                 = new_opcode ()
let geint                 = new_opcode ()
let offsetint             = new_opcode_124 ()
let offsetref             = new_opcode_124 ()
let isint                 = new_opcode ()
let getmethod             = new_opcode ()
let beq                   = new_opcode_124 ()
let bneq                  = new_opcode_124 ()
let bltint                = new_opcode_124 ()
let bleint                = new_opcode_124 ()
let bgtint                = new_opcode_124 ()
let bgeint                = new_opcode_124 ()
let ultint                = new_opcode ()
let ugeint                = new_opcode ()
let bultint               = new_opcode_124 ()
let bugeint               = new_opcode_124 ()
let getpubmet             = new_opcode ()
let getdynmet             = new_opcode ()
let stop                  = new_opcode ()

(******************************************************************************)

let opcodes = [
  ("ACC0", `SIMPLE acc0);
  ("ACC1", `SIMPLE acc1);
  ("ACC2", `SIMPLE acc2);
  ("ACC3", `SIMPLE acc3);
  ("ACC4", `SIMPLE acc4);
  ("ACC5", `SIMPLE acc5);
  ("ACC6", `SIMPLE acc6);
  ("ACC7", `SIMPLE acc7);
  ("ACC", `SIMPLE acc);
  ("PUSH", `SIMPLE push);
  ("PUSHACC1", `SIMPLE pushacc1);
  ("PUSHACC2", `SIMPLE pushacc2);
  ("PUSHACC3", `SIMPLE pushacc3);
  ("PUSHACC4", `SIMPLE pushacc4);
  ("PUSHACC5", `SIMPLE pushacc5);
  ("PUSHACC6", `SIMPLE pushacc6);
  ("PUSHACC7", `SIMPLE pushacc7);
  ("PUSHACC", `SIMPLE pushacc);
  ("POP", `SIMPLE pop);
  ("ASSIGN", `SIMPLE assign);
  ("ENVACC1", `SIMPLE envacc1);
  ("ENVACC2", `SIMPLE envacc2);
  ("ENVACC3", `SIMPLE envacc3);
  ("ENVACC4", `SIMPLE envacc4);
  ("ENVACC", `SIMPLE envacc);
  ("PUSHENVACC1", `SIMPLE pushenvacc1);
  ("PUSHENVACC2", `SIMPLE pushenvacc2);
  ("PUSHENVACC3", `SIMPLE pushenvacc3);
  ("PUSHENVACC4", `SIMPLE pushenvacc4);
  ("PUSHENVACC", `SIMPLE pushenvacc);
  ("PUSH_RETADDR", `TRIPLE push_retaddr);
  ("APPLY", `SIMPLE apply);
  ("APPLY1", `SIMPLE apply1);
  ("APPLY2", `SIMPLE apply2);
  ("APPLY3", `SIMPLE apply3);
  ("APPTERM", `SIMPLE appterm);
  ("APPTERM1", `SIMPLE appterm1);
  ("APPTERM2", `SIMPLE appterm2);
  ("APPTERM3", `SIMPLE appterm3);
  ("RETURN", `SIMPLE return);
  ("RESTART", `SIMPLE restart);
  ("GRAB", `SIMPLE grab);
  ("CLOSURE", `TRIPLE closure);
  ("CLOSUREREC", `TRIPLE closurerec);
  ("OFFSETCLOSUREM2", `SIMPLE offsetclosurem2);
  ("OFFSETCLOSURE0", `SIMPLE offsetclosure0);
  ("OFFSETCLOSURE2", `SIMPLE offsetclosure2);
  ("OFFSETCLOSURE", `SIMPLE offsetclosure);
  ("PUSHOFFSETCLOSUREM2", `SIMPLE pushoffsetclosurem2);
  ("PUSHOFFSETCLOSURE0", `SIMPLE pushoffsetclosure0);
  ("PUSHOFFSETCLOSURE2", `SIMPLE pushoffsetclosure2);
  ("PUSHOFFSETCLOSURE", `SIMPLE pushoffsetclosure);
  ("GETGLOBAL", `DOUBLE getglobal);
  ("PUSHGETGLOBAL", `DOUBLE pushgetglobal);
  ("GETGLOBALFIELD", `DOUBLE getglobalfield);
  ("PUSHGETGLOBALFIELD", `DOUBLE pushgetglobalfield);
  ("SETGLOBAL", `DOUBLE setglobal);
  ("ATOM0", `SIMPLE atom0);
  ("PUSHATOM0", `SIMPLE pushatom0);
  ("MAKEBLOCK", `DOUBLE makeblock);
  ("MAKEBLOCK1", `SIMPLE makeblock1);
  ("MAKEBLOCK2", `SIMPLE makeblock2);
  ("MAKEBLOCK3", `SIMPLE makeblock3);
  ("MAKEFLOATBLOCK", `SIMPLE makefloatblock);
  ("GETFIELD0", `SIMPLE getfield0);
  ("GETFIELD1", `SIMPLE getfield1);
  ("GETFIELD2", `SIMPLE getfield2);
  ("GETFIELD3", `SIMPLE getfield3);
  ("GETFIELD", `SIMPLE getfield);
  ("GETFLOATFIELD", `SIMPLE getfloatfield);
  ("SETFIELD0", `SIMPLE setfield0);
  ("SETFIELD1", `SIMPLE setfield1);
  ("SETFIELD2", `SIMPLE setfield2);
  ("SETFIELD3", `SIMPLE setfield3);
  ("SETFIELD", `SIMPLE setfield);
  ("SETFLOATFIELD", `SIMPLE setfloatfield);
  ("VECTLENGTH", `SIMPLE vectlength);
  ("GETVECTITEM", `SIMPLE getvectitem);
  ("SETVECTITEM", `SIMPLE setvectitem);
  ("GETSTRINGCHAR", `SIMPLE getstringchar);
  ("SETSTRINGCHAR", `SIMPLE setstringchar);
  ("BRANCH", `TRIPLE branch);
  ("BRANCHIF", `TRIPLE branchif);
  ("BRANCHIFNOT", `TRIPLE branchifnot);
  ("SWITCH", `TRIPLE switch);
  ("BOOLNOT", `SIMPLE boolnot);
  ("PUSHTRAP", `TRIPLE pushtrap);
  ("POPTRAP", `SIMPLE poptrap);
  ("RAISE", `SIMPLE raise);
  ("CHECK_SIGNALS", `SIMPLE check_signals);
  ("C_CALL1", `SIMPLE c_call1);
  ("C_CALL2", `SIMPLE c_call2);
  ("C_CALL3", `SIMPLE c_call3);
  ("C_CALL4", `SIMPLE c_call4);
  ("C_CALL5", `SIMPLE c_call5);
  ("C_CALLN", `SIMPLE c_calln);
  ("CONST0", `SIMPLE const0);
  ("CONST1", `SIMPLE const1);
  ("CONST2", `SIMPLE const2);
  ("CONST3", `SIMPLE const3);
  ("CONSTINT", `TRIPLE constint);
  ("PUSHCONST0", `SIMPLE pushconst0);
  ("PUSHCONST1", `SIMPLE pushconst1);
  ("PUSHCONST2", `SIMPLE pushconst2);
  ("PUSHCONST3", `SIMPLE pushconst3);
  ("PUSHCONSTINT", `TRIPLE pushconstint);
  ("NEGINT", `SIMPLE negint);
  ("ADDINT", `SIMPLE addint);
  ("SUBINT", `SIMPLE subint);
  ("MULINT", `SIMPLE mulint);
  ("DIVINT", `SIMPLE divint);
  ("MODINT", `SIMPLE modint);
  ("ANDINT", `SIMPLE andint);
  ("ORINT", `SIMPLE orint);
  ("XORINT", `SIMPLE xorint);
  ("LSLINT", `SIMPLE lslint);
  ("LSRINT", `SIMPLE lsrint);
  ("ASRINT", `SIMPLE asrint);
  ("EQ", `SIMPLE eq);
  ("NEQ", `SIMPLE neq);
  ("LTINT", `SIMPLE ltint);
  ("LEINT", `SIMPLE leint);
  ("GTINT", `SIMPLE gtint);
  ("GEINT", `SIMPLE geint);
  ("OFFSETINT", `TRIPLE offsetint);
  ("OFFSETREF", `TRIPLE offsetref);
  ("ISINT", `SIMPLE isint);
  ("GETMETHOD", `SIMPLE getmethod);
  ("BEQ", `TRIPLE beq);
  ("BNEQ", `TRIPLE bneq);
  ("BLTINT", `TRIPLE bltint);
  ("BLEINT", `TRIPLE bleint);
  ("BGTINT", `TRIPLE bgtint);
  ("BGEINT", `TRIPLE bgeint);
  ("ULTINT", `SIMPLE ultint);
  ("UGEINT", `SIMPLE ugeint);
  ("BULTINT", `TRIPLE bultint);
  ("BUGEINT", `TRIPLE bugeint);
  ("GETPUBMET", `SIMPLE getpubmet);
  ("GETDYNMET", `SIMPLE getdynmet);
  ("STOP", `SIMPLE stop);
]

(******************************************************************************)

let export_opcodes oc =
  List.iter (fun (name, ops) ->
    match ops with
    | `SIMPLE op -> Printf.fprintf oc "  %s = %d,\n" name op
    | `DOUBLE (op1, op2) -> Printf.fprintf oc "  %s_1B = %d,\n  %s_2B = %d,\n" name op1 name op2
    | `TRIPLE (op1, op2, op3) -> Printf.fprintf oc "  %s_1B = %d,\n  %s_2B = %d,\n  %s_3B = %d,\n" name op1 name op2 name op3
  ) opcodes

(******************************************************************************)
