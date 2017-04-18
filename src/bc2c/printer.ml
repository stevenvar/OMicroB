let print_c_array oc ty name size data =
  let ind = ref 0 in
  Printf.fprintf oc "%s %s[%s] = {\n  " ty name size;
  List.iter (fun byte ->
    assert (byte >= 0 && byte < 256);
    if !ind > 0 then
      if !ind mod 16 = 0 then Printf.fprintf oc ",\n  "
      else Printf.fprintf oc ", ";
    Printf.fprintf oc "0x%02X" byte;
    incr ind;
  ) data;
  if !ind <> 0 then Printf.fprintf oc "\n";
  Printf.fprintf oc "};\n"

let print_opgen oc ops =
  List.iter (fun (opcode, n) ->
    Printf.fprintf oc "#define OCAML_%-20s 0x%02X\n" (Opcode.to_string opcode) n;
  ) (List.sort Pervasives.compare ops)

let print_prim oc prim =
  let prim_nb = Array.length prim in
  let prim_ind = ref 0 in
  Printf.fprintf oc "PROGMEM void *ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {\n";
  Array.iter (fun prim_name ->
    Printf.fprintf oc "  (void *) &%s" prim_name;
    incr prim_ind;
    if !prim_ind <> prim_nb then Printf.fprintf oc ",";
    Printf.fprintf oc "\n";
  ) prim;
  Printf.fprintf oc "};\n"
