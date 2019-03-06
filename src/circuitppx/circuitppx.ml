(*******************************************************************************)
(*                                                                             *)
(*                  Extension points to help define circuits                   *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

open Ast_mapper
open Parsetree
open Asttypes

let create_node mapper str = match str.pstr_desc with
  | Pstr_extension ((({txt="component";loc}, pstr), _)) ->
    Component.create_node pstr loc
  | Pstr_extension ((({txt="gate";loc}, pstr), _)) ->
    Gate.create_node pstr loc
  | Pstr_extension ((({txt="connect";loc}, pstr), _)) ->
    Connect.create_node pstr loc
  | _ -> [default_mapper.structure_item mapper str]

let circuit_mapper _ = {
  default_mapper with structure =
                        fun mapper st ->
                          let stl = List.map (create_node mapper) st in
                          List.flatten stl
}

let () = register "circuit" circuit_mapper
