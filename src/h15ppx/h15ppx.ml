(******************************************************************************)

let mangle_name =
  let hash_name s =
    let accu = ref 0 in
    for i = 0 to String.length s - 1 do
      accu := 223 * !accu + Char.code s.[i];
    done;
    accu := !accu land (1 lsl 31 - 1);
    if !accu > 0x3FFFFFFF then !accu - (1 lsl 31) else !accu in

  let rec coeff i =
    if i = 0 then 1 else 223 * coeff (i - 1) in

  let is_valid hash =
    let msbs = (hash lsr 14) land 0x1FFFF in
    msbs = 0 || msbs = 0x1FFFF in

  let ctable =
    Array.init 62 (fun i ->
      if i < 26 then Char.code 'A' + i
      else if i < 52 then Char.code 'a' + i - 26
      else Char.code '0' + i - 52
    ) in

  let coeffs =
    Array.init 4 (fun i -> coeff (5 - i)) in

  let memoization_htbl =
    Hashtbl.create 16 in

  fun prefix ->
    try Hashtbl.find memoization_htbl prefix with Not_found ->
      let values = [| 0; 0; 0; 0 |] in
      let hash = ref (hash_name (prefix ^ "__AAAA__")) in
      let rec incr_values i ofs =
        let old_value = values.(i) in
        let new_value = old_value + ofs in
        let new_value = if new_value < 62 then new_value else new_value - 62 in
        values.(i) <- new_value;
        hash := !hash + (ctable.(new_value) - ctable.(old_value)) * coeffs.(i);
        if new_value < old_value then
          incr_values (if i = 3 then 0 else i + 1) 5 in
      while not (is_valid !hash) do
        incr_values 0 1;
      done;
      let prefix_len = String.length prefix in
      let buf = Bytes.create (prefix_len + 8) in
      String.blit prefix 0 buf 0 prefix_len;
      List.iter (fun i -> Bytes.set buf (prefix_len + i) '_') [ 0; 1; 6; 7 ];
      Array.iteri (fun i value -> Bytes.set buf (prefix_len + i + 2) (char_of_int ctable.(value))) values;
      let result = Bytes.unsafe_to_string buf in
      assert (is_valid (hash_name result));
      Hashtbl.add memoization_htbl prefix result;
      result

(******************************************************************************)

open Ast_mapper
open Parsetree
open Location

let mangle_label label =
  { label with txt = mangle_name label.txt }

let rec expr_mapper mapper expr =
  match expr.pexp_desc with
  | Pexp_variant (label, arg) ->
    { expr with pexp_desc = Pexp_variant (mangle_name label, map_opt (expr_mapper mapper) arg) }
  | Pexp_send (obj, meth) ->
    { expr with pexp_desc = Pexp_send (expr_mapper mapper obj, mangle_label meth) } 
  | _ ->
    default_mapper.expr mapper expr

let rec pat_mapper mapper pat =
  match pat.ppat_desc with
  | Ppat_variant (label, arg) ->
    { pat with ppat_desc = Ppat_variant (mangle_name label, map_opt (pat_mapper mapper) arg) }
  | _ ->
    default_mapper.pat mapper pat

let rec typ_mapper mapper typ =
  match typ.ptyp_desc with
  | Ptyp_variant (row_fields, closed_tag, labels) ->
    let row_fields =
      List.map (fun row_field ->
        match row_field with
        | Rtag (label, attributes, flag, args) ->
          Rtag (mangle_label label, attributes, flag, List.map (typ_mapper mapper) args)
        | Rinherit ct ->
          Rinherit (typ_mapper mapper ct)
      ) row_fields in
    let labels =
      match labels with
      | None -> None
      | Some l -> Some (List.map mangle_name l) in
    { typ with ptyp_desc = Ptyp_variant (row_fields, closed_tag, labels) }
  | _ ->
    default_mapper.typ mapper typ

let class_type_field_mapper mapper ctf =
  match ctf.pctf_desc with
  | Pctf_method (name, private_flag, virtual_flag, core_type) ->
    { ctf with pctf_desc = Pctf_method (mangle_label name, private_flag, virtual_flag, typ_mapper mapper core_type) }
  | _ ->
    default_mapper.class_type_field mapper ctf

let class_field_kind_mapper mapper cfk =
  match cfk with
  | Cfk_virtual typ -> Cfk_virtual (typ_mapper mapper typ)
  | Cfk_concrete (ovf, expr) -> Cfk_concrete (ovf, expr_mapper mapper expr)

let class_field_mapper mapper cf =
  match cf.pcf_desc with
  | Pcf_method (name, private_flag, class_field_kind) ->
    { cf with pcf_desc = Pcf_method (mangle_label name, private_flag, class_field_kind_mapper mapper class_field_kind) }
  | _ ->
    default_mapper.class_field mapper cf

let () =
  run_main (fun _argv -> {
    default_mapper with
      expr             = expr_mapper;
      pat              = pat_mapper;
      typ              = typ_mapper;
      class_type_field = class_type_field_mapper;
      class_field      = class_field_mapper;
  });

(******************************************************************************)
