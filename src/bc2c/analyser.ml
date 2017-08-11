open OByteLib.Instr
open Pstack

type typevar = int
type codeptr = int
type blocktag = int
type closureofs = int

type closure = {
  ptrs : codeptr list;
  ofs  : closureofs;
  env  : typevar list;
}

type value_descr =
| Unknown
| Int | Int32 | Int64 | Nativeint | Float
| Float_array | String
| Codeptr of codeptr
| Closure of closure
| Block   of blocktag * typevar list
| Typevar of typevar
| Field   of typevar * int
| Cell    of typevar

let annotate_function globals closure args code =
  let next_typevar = ref 0 in
  let new_typevar () =
    incr next_typevar;
    !next_typevar - 1 in

  let instr_nb = Array.length code in

  let accus = Array.make instr_nb (-1) in
  let stacks = Array.make instr_nb [] in
  let initialized = Array.make instr_nb false in

  let result = new_typevar () in
  let set_globals = ref [] in

  let constraints = ref [] in
  let new_constraint c =
    constraints := c :: !constraints in
  let new_constrained_typevar vd =
    let tv = new_typevar () in
    new_constraint (vd, tv);
    tv in

  let ret_addrs = ref [] in

  let applies = ref [] in
  let new_apply fun_tv arg_tvs result_tv =
    applies := (fun_tv, arg_tvs, result_tv) :: !applies in

  let merge_typevars tv1 tv2 =
    if (tv1 : typevar) <> (tv2 : typevar)
    then new_constraint (Typevar tv1, tv2) in
  let merge_stacks stack1 stack2 =
    List.iter2 merge_typevars stack1 stack2 in

  let offsetclosure n =
    assert (n land 1 = 0);
    let new_ofs = closure.ofs + (n asr 1) in
    assert (new_ofs >= 0 && new_ofs < List.length closure.ptrs);
    let new_closure = if new_ofs = closure.ofs then closure else { closure with ofs = new_ofs } in
    new_constrained_typevar (Closure new_closure) in
      
  let rec loop instr_ind accu stack =
    assert (instr_ind >= 0 && instr_ind < instr_nb);
    if initialized.(instr_ind) then (
      merge_typevars accu accus.(instr_ind);
      merge_stacks stack stacks.(instr_ind);
    ) else (
      initialized.(instr_ind) <- true;
      accus.(instr_ind) <- accu;
      stacks.(instr_ind) <- stack;

      match code.(instr_ind) with
      | ACC0             -> loop (instr_ind + 1) (acc stack 0) stack
      | ACC1             -> loop (instr_ind + 1) (acc stack 1) stack
      | ACC2             -> loop (instr_ind + 1) (acc stack 2) stack
      | ACC3             -> loop (instr_ind + 1) (acc stack 3) stack
      | ACC4             -> loop (instr_ind + 1) (acc stack 4) stack
      | ACC5             -> loop (instr_ind + 1) (acc stack 5) stack
      | ACC6             -> loop (instr_ind + 1) (acc stack 6) stack
      | ACC7             -> loop (instr_ind + 1) (acc stack 7) stack
      | ACC n            -> loop (instr_ind + 1) (acc stack n) stack

      | PUSH | PUSHACC0  -> loop (instr_ind + 1) accu (push stack accu)
      | PUSHACC1         -> loop (instr_ind + 1) (acc stack 0) (push stack accu)
      | PUSHACC2         -> loop (instr_ind + 1) (acc stack 1) (push stack accu)
      | PUSHACC3         -> loop (instr_ind + 1) (acc stack 2) (push stack accu)
      | PUSHACC4         -> loop (instr_ind + 1) (acc stack 3) (push stack accu)
      | PUSHACC5         -> loop (instr_ind + 1) (acc stack 4) (push stack accu)
      | PUSHACC6         -> loop (instr_ind + 1) (acc stack 5) (push stack accu)
      | PUSHACC7         -> loop (instr_ind + 1) (acc stack 6) (push stack accu)
      | PUSHACC n        -> loop (instr_ind + 1) (acc stack (n - 1)) (push stack accu)

      | POP n            -> loop (instr_ind + 1) accu (popn stack n)
      | ASSIGN n         -> loop (instr_ind + 1) accu (assign stack n accu)

      | ENVACC1          -> loop (instr_ind + 1) (acc closure.env 0) stack
      | ENVACC2          -> loop (instr_ind + 1) (acc closure.env 1) stack
      | ENVACC3          -> loop (instr_ind + 1) (acc closure.env 2) stack
      | ENVACC4          -> loop (instr_ind + 1) (acc closure.env 3) stack
      | ENVACC n         -> loop (instr_ind + 1) (acc closure.env (n - 1)) stack
      | PUSHENVACC1      -> loop (instr_ind + 1) (acc closure.env 0) (push stack accu)
      | PUSHENVACC2      -> loop (instr_ind + 1) (acc closure.env 1) (push stack accu)
      | PUSHENVACC3      -> loop (instr_ind + 1) (acc closure.env 2) (push stack accu)
      | PUSHENVACC4      -> loop (instr_ind + 1) (acc closure.env 3) (push stack accu)
      | PUSHENVACC n     -> loop (instr_ind + 1) (acc closure.env (n - 1)) (push stack accu)

      | PUSH_RETADDR ptr ->
        Mstack.push ret_addrs ptr;
        loop (instr_ind + 1) accu (new_typevar () :: new_typevar () :: new_typevar () :: stack)
      | APPLY n ->
        assert (n > 3);
        let result = new_typevar () in
        new_apply accu (topn stack n) result;
        loop (Mstack.pop ret_addrs) result (popn stack (n + 3))
      | APPLY1 ->
        let result = new_typevar () in
        new_apply accu (topn stack 1) result;
        loop (instr_ind + 1) result (popn stack 1)
      | APPLY2 ->
        let result = new_typevar () in
        new_apply accu (topn stack 2) result;
        loop (instr_ind + 1) result (popn stack 2)
      | APPLY3 ->
        let result = new_typevar () in
        new_apply accu (topn stack 3) result;
        loop (instr_ind + 1) result (popn stack 3)

      | APPTERM (n, _) -> new_apply accu (topn stack n) result
      | APPTERM1 _     -> new_apply accu (topn stack 1) result
      | APPTERM2 _     -> new_apply accu (topn stack 2) result
      | APPTERM3 _     -> new_apply accu (topn stack 3) result

      | RETURN _ -> merge_typevars accu result
      | RESTART  -> assert false
      | GRAB _   -> assert false

      | CLOSURE (v, ptr) ->
        let env = if v = 0 then [] else accu :: topn stack (v - 1) in
        let new_accu = new_constrained_typevar (Closure { ptrs = [ ptr ]; ofs = 0; env }) in
        loop (instr_ind + 1) new_accu (if v = 0 then stack else popn stack (v - 1))
      | CLOSUREREC (_f, v, o, t) ->
        let env = if v = 0 then [] else accu :: topn stack (v - 1) in
        let ptrs = o :: Array.to_list t in
        let new_accu = new_constrained_typevar (Closure { ptrs; ofs = 0; env }) in
        let new_stack =
          let rs = ref (if v = 0 then stack else popn stack (v - 1)) in
          Mstack.push rs new_accu;
          for i = 1 to Array.length t do
            Mstack.push rs (new_constrained_typevar (Closure { ptrs; ofs = i; env }));
          done;
          !rs in
        loop (instr_ind + 1) new_accu new_stack

      | OFFSETCLOSUREM2 -> loop (instr_ind + 1) (offsetclosure (-2)) stack
      | OFFSETCLOSURE0  -> loop (instr_ind + 1) (offsetclosure 0) stack
      | OFFSETCLOSURE2  -> loop (instr_ind + 1) (offsetclosure 2) stack
      | OFFSETCLOSURE n -> loop (instr_ind + 1) (offsetclosure n) stack

      | PUSHOFFSETCLOSUREM2 -> loop (instr_ind + 1) (offsetclosure (-2)) (push stack accu)
      | PUSHOFFSETCLOSURE0  -> loop (instr_ind + 1) (offsetclosure 0) (push stack accu)
      | PUSHOFFSETCLOSURE2  -> loop (instr_ind + 1) (offsetclosure 2) (push stack accu)
      | PUSHOFFSETCLOSURE n -> loop (instr_ind + 1) (offsetclosure n) (push stack accu)

      | GETGLOBAL n -> loop (instr_ind + 1) (new_constrained_typevar globals.(n)) stack
      | PUSHGETGLOBAL n -> loop (instr_ind + 1) (new_constrained_typevar globals.(n)) (push stack accu)
      | GETGLOBALFIELD (n, p) -> loop (instr_ind + 1) (new_constrained_typevar (Field (new_constrained_typevar globals.(n), p))) stack
      | PUSHGETGLOBALFIELD (n, p) -> loop (instr_ind + 1) (new_constrained_typevar (Field (new_constrained_typevar globals.(n), p))) (push stack accu)
      | SETGLOBAL n -> Mstack.push set_globals (n, accu); loop (instr_ind + 1) accu stack

      | ATOM0 -> loop (instr_ind + 1) (new_constrained_typevar (Block (0, []))) stack
      | ATOM tag -> loop (instr_ind + 1) (new_constrained_typevar (Block (tag, []))) stack
      | PUSHATOM0 -> loop (instr_ind + 1) (new_constrained_typevar (Block (0, []))) (push stack accu)
      | PUSHATOM tag -> loop (instr_ind + 1) (new_constrained_typevar (Block (tag, []))) (push stack accu)

      | MAKEBLOCK (tag, sz) -> loop (instr_ind + 1) (new_constrained_typevar (Block (tag, accu :: topn stack (sz - 1)))) (popn stack (sz - 1))
      | MAKEBLOCK1 tag -> loop (instr_ind + 1) (new_constrained_typevar (Block (tag, [ accu ]))) stack
      | MAKEBLOCK2 tag -> loop (instr_ind + 1) (new_constrained_typevar (Block (tag, accu :: topn stack 1))) (popn stack 1)
      | MAKEBLOCK3 tag -> loop (instr_ind + 1) (new_constrained_typevar (Block (tag, accu :: topn stack 2))) (popn stack 2)
      | MAKEFLOATBLOCK sz -> loop (instr_ind + 1) (new_constrained_typevar Float_array) (popn stack (sz - 1))

      | _ -> assert false (* TODO *)
    ) in
  loop 0 (-1) args
    
