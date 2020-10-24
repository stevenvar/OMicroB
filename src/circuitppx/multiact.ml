(*******************************************************************************)
(*                                                                             *)
(*                         let%component extension point                       *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

open Parsetree

let create_apply l r =
  { pmod_desc = Pmod_apply (l, r);
    pmod_loc = Location.none;
    pmod_attributes = [] }

let create_pmod_apply_of_sequence s =
  let rec aux m = match m.pmod_desc with
    | Pmod_apply ({pmod_desc = Pmod_apply({pmod_desc = Pmod_ident _;_} as init, _); _}, _) ->
      (init, m)
    | Pmod_apply(l, r) ->
      let (init, m) = aux l in
      let app = create_apply (create_apply init m) r in (init, app)
    | _ -> failwith "module%multiact: internal binding"

  in snd (aux s)

let create_node pstr _ = match pstr with
  | PStr [{pstr_desc = Pstr_module binding;pstr_loc}] ->
    [{
      pstr_desc = Pstr_module ({
          pmb_name = binding.pmb_name;
          pmb_expr = create_pmod_apply_of_sequence binding.pmb_expr;
          pmb_loc = pstr_loc;
          pmb_attributes = [];
        });
      pstr_loc = pstr_loc;
    }]
  | _ -> failwith "Invalid syntax"
