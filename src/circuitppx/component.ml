(*******************************************************************************)
(*                                                                             *)
(*                         let%component extension point                       *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

open Asttypes
open Parsetree
open Longident

(* We always include the "MCUConnection" module, which gives us pin, level, digital_write, digital_read, ... *)
let create_mcuConnectionMod_include () = {
  pstr_desc = Pstr_include {
      pincl_mod = {
        pmod_desc = Pmod_ident {
            txt = Lident "MCUConnection";
            loc = Location.none;
          };
        pmod_loc = Location.none;
        pmod_attributes = [];
      };
      pincl_loc = Location.none;
      pincl_attributes = [];
    };
  pstr_loc = Location.none;
}

let create_pstr_value_of_apply = function
  | Pexp_apply ({pexp_desc=Pexp_ident {txt=Lident "=";loc;_};_}, [(_, name);(_, expr)]) ->
    (match name.pexp_desc with
     | Pexp_ident {txt=Lident n;_} -> {
         pstr_desc = Pstr_value (Nonrecursive, [{
             pvb_pat = {
               ppat_desc = Ppat_var {txt=n; loc=loc};
               ppat_loc = loc;
               ppat_attributes = [];
             };
             pvb_expr = expr;
             pvb_loc = loc;
             pvb_attributes = [];
           }]);
         pstr_loc = loc;
       }
     | _ -> failwith "Invalid syntax (interior binding)")
  | _ -> failwith "Invalid syntax (interior binding)"

let rec create_pstr_value_of_sequence = function
  | Pexp_sequence (h, t) -> (create_pstr_value_of_apply h.pexp_desc)::(create_pstr_value_of_sequence t.pexp_desc)
  | pexp -> [create_pstr_value_of_apply pexp]

let create_pmod_apply funct bindings =
  Pmod_apply ({
      pmod_desc = Pmod_ident {
          txt = funct.txt;
          loc = funct.loc;
        };
      pmod_loc = Location.none;
      pmod_attributes = [];
    }, {
        pmod_desc = Pmod_structure ((create_mcuConnectionMod_include ())::
                                    (create_pstr_value_of_sequence bindings.pexp_desc));
        pmod_loc = bindings.pexp_loc;
        pmod_attributes = [];
      })

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
                | Pexp_construct (f, (Some m)) -> create_pmod_apply f m
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

