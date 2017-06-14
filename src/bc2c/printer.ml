let print_c_array oc ty name size data pp =
  let len = List.length data in
  let padding =
    let pad = ref 1 and bound = ref 10 in
    while len >= !bound do
      pad := !pad + 1;
      bound := !bound * 10;
    done;
    !pad in
  Printf.fprintf oc "%s %s[%s] = {\n" ty name size;
  List.iteri (fun ind x ->
    if ind > 0 then Printf.fprintf oc ",\n";
    Printf.fprintf oc "  /* %*d */  " padding ind;
    Printf.fprintf oc "%s" (pp x);
  ) data;
  if len > 0 then Printf.fprintf oc "\n";
  Printf.fprintf oc "};\n"

let print_codegen_word_array oc ty name size data =
  let pp word =
    match word with
    | Codegen.SBYTE byte ->
      assert (byte >= -0x80 && byte < 0x80);
      string_of_int byte;
    | Codegen.UBYTE byte ->
      assert (byte >= 0 && byte < 0x100);
      string_of_int byte;
    | Codegen.OPCODE opcode ->
      "OCAML_" ^ Opcode.to_string opcode
  in
  print_c_array oc ty name size data pp

let print_datagen_word_array oc ty name size data =
  let bprint_char buf c =
    match c with
    | '\\' -> Printf.bprintf buf "'\\\\'"
    | '\'' -> Printf.bprintf buf "'\\''"
    | '\x00' .. '\x07' -> Printf.bprintf buf "'\\%d'" (int_of_char c)
    | '\x20' .. '\x7E' -> Printf.bprintf buf "'%c'" c
    | _ -> Printf.bprintf buf "0x%02X" (int_of_char c) in
  let print_chars chars =
    let buf = Buffer.create 16 in
    Printf.bprintf buf "Make_string_data(";
    List.iteri (fun i c ->
      if i > 0 then Printf.bprintf buf ", ";
      bprint_char buf c;
    ) chars;
    Printf.bprintf buf ")";
    Buffer.contents buf in
  let print_bytes constr bytes =
    let buf = Buffer.create 16 in
    Printf.bprintf buf "%s(" constr;
    List.iteri (fun i c ->
      if i > 0 then Printf.bprintf buf ", ";
      Printf.bprintf buf "0x%02X" c;
    ) bytes;
    Printf.bprintf buf ")";
    Buffer.contents buf in
  let print_tag tag =
         if tag = Obj.lazy_tag then "Lazy_tag"
    else if tag = Obj.closure_tag then "Closure_tag"
    else if tag = Obj.object_tag then "Object_tag"
    else if tag = Obj.infix_tag then "Infix_tag"
    else if tag = Obj.forward_tag then "Forward_tag"
    else if tag = Obj.abstract_tag then "Abstract_tag"
    else if tag = Obj.string_tag then "String_tag"
    else if tag = Obj.double_tag then "Double_tag"
    else if tag = Obj.double_array_tag then "Double_array_tag"
    else if tag = Obj.custom_tag then "Custom_tag"
    else string_of_int tag in
  let pp word =
    match word with
    | Datagen.INT n              -> Printf.sprintf "Val_int(%d)" n
    | Datagen.FLOAT bytes        -> print_bytes "Make_float" bytes
    | Datagen.CHARS chars        -> print_chars chars
    | Datagen.BYTES bytes        -> print_bytes "Make_custom_data" bytes
    | Datagen.CUSTOM name        -> Printf.sprintf "(val_t) &%s_custom_operations" name
    | Datagen.HEADER (tag, size) -> Printf.sprintf "Make_header(%s, %d)" (print_tag tag) size
    | Datagen.POINTER ind        -> Printf.sprintf "Val_block(%d)" ind
  in
  print_c_array oc ty name size data pp

let print_opcodes oc opcodes =
  List.iteri (fun i opcode ->
    Printf.fprintf oc "#define OCAML_%-21s %3d\n" (Opcode.to_string opcode) i;
  ) opcodes

let print_prim oc prim =
  let prim_nb = Array.length prim in
  let prim_ind = ref 0 in
  Printf.fprintf oc "PROGMEM void * const ocaml_primitives[OCAML_PRIMITIVE_NUMBER] = {\n";
  Array.iter (fun prim_name ->
    Printf.fprintf oc "  (void *) &%s" prim_name;
    incr prim_ind;
    if !prim_ind <> prim_nb then Printf.fprintf oc ",";
    Printf.fprintf oc "\n";
  ) prim;
  Printf.fprintf oc "};\n"
