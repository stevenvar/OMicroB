(******************************************************************************)

let export data =
  let objs = OByteLib.Data.to_objs data in
  let acc = ref [] in
  Array.iter (fun obj ->
    let str = Marshal.to_string obj [] in
    String.iter (fun c -> acc := int_of_char c :: !acc) str;
  ) objs;
  (List.rev !acc, Array.length objs)

(******************************************************************************)
