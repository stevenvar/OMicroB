(*******************************************************************************)
(*                                                                             *)
(*                         let%component extension point                       *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

open Asttypes
open Parsetree
open Longident

let create_initial_pmod loc = Pmod_ident loc

let create_pmod_apply funct param =
  Pmod_apply (
    {
      pmod_desc = funct;
      pmod_loc = Location.none;
      pmod_attributes = [];
    },
    match param with
    | Pexp_construct (loc, _) -> {
        pmod_desc = Pmod_ident loc;
        pmod_loc = Location.none;
        pmod_attributes = [];
      }
    | _ -> failwith "Invalid syntax (interior binding)"
  )

let create_pmod_apply_of_sequence acc s = match s with
  | Pexp_sequence (h, t) ->
    let acc = create_pmod_apply acc h.pexp_desc in
    create_pmod_apply acc t.pexp_desc
  | _ -> failwith "Invalid syntax (wrong number of parameters)"

let create_node pstr loc = match pstr with
  | PStr [{pstr_desc = Pstr_value (Nonrecursive, [binding]);pstr_loc}]->
    [{
      pstr_desc = Pstr_module ({
          pmb_name = {
            txt = (match binding.pvb_pat.ppat_desc with
                | Ppat_var s -> s.txt
                | Ppat_construct ({txt=(Lident s);_},_) -> s
                | _ -> failwith "Invalid syntax (name)");
            loc = pstr_loc;
          };
          pmb_expr = {
            pmod_desc = (match binding.pvb_expr.pexp_desc with
                | Pexp_construct (f, (Some m)) -> create_pmod_apply_of_sequence (create_initial_pmod f) m.pexp_desc
                | _ -> failwith "Invalid syntax (binding)");
            pmod_loc = loc;
            pmod_attributes = [];
          };
          pmb_attributes = [];
          pmb_loc = loc;
        });
      pstr_loc = loc;
    }]
  | _ -> failwith "Invalid syntax"
