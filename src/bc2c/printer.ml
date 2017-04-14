let print_data oc ty name data =
  let ind = ref 0 in
  Printf.fprintf oc "%s %s[%d] = {\n  " ty name (List.length data);
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
