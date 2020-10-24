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

let create_pmod_apply id s =
  Pmod_apply (
    id,
    {
      pmod_desc = Pmod_structure ((create_mcuConnectionMod_include ())::s);
      pmod_loc = id.pmod_loc;
      pmod_attributes = [];
      })

let create_node pstr loc = match pstr with
  | PStr [{pstr_desc = Pstr_module binding;pstr_loc}] ->
    [{
      pstr_desc = Pstr_module ({
          pmb_name = binding.pmb_name;
          pmb_expr = {
            pmod_desc = (match binding.pmb_expr.pmod_desc with
                | Pmod_apply ({pmod_desc=Pmod_ident _;_ } as id,
                              {pmod_desc=Pmod_structure s;_}) -> create_pmod_apply id s
                | _ -> failwith "Invalid syntax (binding)");
            pmod_loc = loc;
            pmod_attributes = [];
          };
          pmb_attributes = binding.pmb_attributes;
          pmb_loc = binding.pmb_loc;
        });
      pstr_loc = pstr_loc;
    }]
  | _ -> failwith "Invalid syntax"

