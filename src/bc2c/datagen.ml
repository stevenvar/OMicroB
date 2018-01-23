open T

(******************************************************************************)

let int32_bytes n =
  let n0 = Int32.to_int (Int32.logand n 0xFFl) in
  let n1 = Int32.to_int (Int32.logand (Int32.shift_right n  8) 0xFFl) in
  let n2 = Int32.to_int (Int32.logand (Int32.shift_right n 16) 0xFFl) in
  let n3 = Int32.to_int (Int32.logand (Int32.shift_right n 24) 0xFFl) in
  (n0, n1, n2, n3)

let int64_bytes n =
  let n0 = Int64.to_int (Int64.logand n 0xFFL) in
  let n1 = Int64.to_int (Int64.logand (Int64.shift_right n  8) 0xFFL) in
  let n2 = Int64.to_int (Int64.logand (Int64.shift_right n 16) 0xFFL) in
  let n3 = Int64.to_int (Int64.logand (Int64.shift_right n 24) 0xFFL) in
  let n4 = Int64.to_int (Int64.logand (Int64.shift_right n 32) 0xFFL) in
  let n5 = Int64.to_int (Int64.logand (Int64.shift_right n 40) 0xFFL) in
  let n6 = Int64.to_int (Int64.logand (Int64.shift_right n 48) 0xFFL) in
  let n7 = Int64.to_int (Int64.logand (Int64.shift_right n 56) 0xFFL) in
  (n0, n1, n2, n3, n4, n5, n6, n7)

let nativeint_bytes n =
  let n0 = Nativeint.to_int (Nativeint.logand n 0xFFn) in
  let n1 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n  8) 0xFFn) in
  let n2 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 16) 0xFFn) in
  let n3 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 24) 0xFFn) in
  let n4 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 32) 0xFFn) in
  let n5 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 40) 0xFFn) in
  let n6 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 48) 0xFFn) in
  let n7 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 56) 0xFFn) in
  (n0, n1, n2, n3, n4, n5, n6, n7)

(******************************************************************************)

let export arch codemap accu stack data =
  let sharer = Sharer.create () in

  let heap = Heap.create () in

  let rec export_value d =
    match d with
    | Int n -> export_int n
    | Int32 n -> export_int32 n
    | Int64 n -> export_int64 n
    | Nativeint n -> export_nativeint n
    | Float x -> export_float x
    | Float_array (_mut, tbl) -> export_float_array tbl (* TODO *)
    | Bytes (_mut, str) -> export_bytes str (* TODO *)
    | Object (_mut, fields) -> export_block Obj.object_tag fields (* TODO *)
    | Block (_mut, tag, fields) -> export_block tag fields (* TODO *)
    | Closure closure -> export_closure closure
    | CodePtr pc -> export_code_ptr pc

  and export_int n =
    begin
      match arch with
      | Arch.A16 -> assert (n >= -0x8000 && n < 0x8000)
      | Arch.A32 -> assert (n >= -0x8000_0000 && n < 0x8000_0000)
      | Arch.A64 -> ()
    end;
    INT n

  and export_int32 n =
    try Sharer.find_int32 sharer n with Not_found ->
      let ptr =
        let (n0, n1, n2, n3) = int32_bytes n in
        match arch with
        | Arch.A16 ->
          Heap.push heap (HEADER (Obj.custom_tag, 3));
          let ptr = POINTER (Heap.pointer heap) in
          Heap.push heap (CUSTOM "int32");
          Heap.push heap (BYTES [ n3; n2 ]);
          Heap.push heap (BYTES [ n1; n0 ]);
          ptr
        | Arch.A32 ->
          Heap.push heap (HEADER (Obj.custom_tag, 2));
          let ptr = POINTER (Heap.pointer heap) in
          Heap.push heap (CUSTOM "int32");
          Heap.push heap (BYTES [ n3; n2; n1; n0 ]);
          ptr
        | Arch.A64 ->
          Heap.push heap (HEADER (Obj.custom_tag, 2));
          let ptr = POINTER (Heap.pointer heap) in
          Heap.push heap (CUSTOM "int32");
          Heap.push heap (BYTES [ 0; 0; 0; 0; n3; n2; n1; n0 ]);
          ptr in
      Sharer.put_int32 sharer n ptr;
      ptr

  and export_int64 n =
    try Sharer.find_int64 sharer n with Not_found ->
      let ptr =
        let (n0, n1, n2, n3, n4, n5, n6, n7) = int64_bytes n in
        match arch with
        | Arch.A16 ->
          Heap.push heap (HEADER (Obj.custom_tag, 5));
          let ptr = POINTER (Heap.pointer heap) in
          Heap.push heap (CUSTOM "int64");
          Heap.push heap (BYTES [ n7; n6 ]);
          Heap.push heap (BYTES [ n5; n4 ]);
          Heap.push heap (BYTES [ n3; n2 ]);
          Heap.push heap (BYTES [ n1; n0 ]);
          ptr
        | Arch.A32 ->
          Heap.push heap (HEADER (Obj.custom_tag, 3));
          let ptr = POINTER (Heap.pointer heap) in
          Heap.push heap (CUSTOM "int64");
          Heap.push heap (BYTES [ n7; n6; n5; n4 ]);
          Heap.push heap (BYTES [ n3; n2; n1; n0 ]);
          ptr
        | Arch.A64 ->
          Heap.push heap (HEADER (Obj.custom_tag, 2));
          let ptr = POINTER (Heap.pointer heap) in
          Heap.push heap (CUSTOM "int64");
          Heap.push heap (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
          ptr in
      Sharer.put_int64 sharer n ptr;
      ptr

  and export_nativeint n =
    try Sharer.find_nativeint sharer n with Not_found ->
      let ptr =
        Heap.push heap (HEADER (Obj.custom_tag, 2));
        let ptr = POINTER (Heap.pointer heap) in
        Heap.push heap (CUSTOM "nativeint");
        match arch with
        | Arch.A16 ->
          if n < -0x8000n || n >= 0x8000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000) 0x7FFF;
          let n0 = Nativeint.to_int (Nativeint.logand n 0xFFn) in
          let n1 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 8) 0xFFn) in
          Heap.push heap (BYTES [ n1; n0 ]);
          ptr
        | Arch.A32 ->
          if n < -0x8000_0000n || n >= 0x8000_0000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000_0000) 0x7FFF_FFFF;
          let (n0, n1, n2, n3, _, _, _, _) = nativeint_bytes n in
          Heap.push heap (BYTES [ n3; n2; n1; n0 ]);
          ptr
        | Arch.A64 ->
          let (n0, n1, n2, n3, n4, n5, n6, n7) = nativeint_bytes n in
          Heap.push heap (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
          ptr in
      Sharer.put_nativeint sharer n ptr;
      ptr

  and export_float x =
    match arch with
    | Arch.A16 ->
      assert false (* TODO *)
    | Arch.A32 ->
      let n = Int32.bits_of_float x in
      let (n0, n1, n2, n3) = int32_bytes n in
      FLOAT [ n3; n2; n1; n0 ]
    | Arch.A64 ->
      let n = Int64.bits_of_float x in
      let (n0, n1, n2, n3, n4, n5, n6, n7) = int64_bytes n in
      FLOAT [ n7; n6; n5; n4; n3; n2; n1; n0 ]

  and export_float_array tbl =
    try Sharer.find_float_array sharer tbl with Not_found ->
      Heap.push heap (HEADER (0, Array.length tbl));
      let ptr = POINTER (Heap.pointer heap) in
      Sharer.put_float_array sharer tbl ptr;
      Array.iter (fun x -> Heap.push heap (export_float x)) tbl;
      ptr

  and export_bytes str =
    try Sharer.find_bytes sharer str with Not_found ->
      let len = Bytes.length str in
      let word_size =
        match arch with
        | Arch.A16 -> 2
        | Arch.A32 -> 4
        | Arch.A64 -> 8 in
      let block_size = len / word_size + 1 in
      let current_strdata = ref [] in
      Heap.push heap (HEADER (Obj.string_tag, block_size));
      let ptr = POINTER (Heap.pointer heap) in
      Sharer.put_bytes sharer str ptr;
      Bytes.iter (fun c ->
        current_strdata := c :: !current_strdata;
        if List.length !current_strdata = word_size then (
          Heap.push heap (CHARS (List.rev !current_strdata));
          current_strdata := [];
        )
      ) str;
      let zero_pad = word_size - List.length !current_strdata - 1 in
      for _i = 1 to zero_pad do current_strdata := '\x00' :: !current_strdata done;
      Heap.push heap (CHARS (List.rev (char_of_int zero_pad :: !current_strdata)));
      ptr

  and export_exception tag fields =
    if tag <> Obj.object_tag then raise Exit;
    match fields with
    | [| Bytes (_mut, str); Int (-1) |] when Bytes.to_string str = "Out_of_memory"    -> EXCEPTION OUT_OF_MEMORY
    | [| Bytes (_mut, str); Int (-9) |] when Bytes.to_string str = "Stack_overflow"   -> EXCEPTION STACK_OVERFLOW
    | [| Bytes (_mut, str); Int (-6) |] when Bytes.to_string str = "Division_by_zero" -> EXCEPTION DIVISION_BY_ZERO
    | [| Bytes (_mut, str); Int (-4) |] when Bytes.to_string str = "Invalid_argument" -> EXCEPTION INVALID_ARGUMENT
    | _ -> raise Exit
       
  and export_block tag fields =
    try export_exception tag fields with Exit ->
    try Sharer.find_block sharer fields with Not_found ->
      Heap.push heap (HEADER (tag, Array.length fields));
      let ptr = POINTER (Heap.pointer heap) in
      Sharer.put_block sharer fields ptr;
      let refs = Array.map (fun _ -> Heap.push_ref heap) fields in
      Array.iter2 (fun r field -> r := export_value field) refs fields;
      ptr

  and export_closure { ofs; ptrs; env } =
    assert (Array.length ptrs > 0 && ofs < Array.length ptrs);
    match Sharer.find_closure sharer ptrs env with
    | POINTER ptr -> POINTER (ptr + 2 * ofs)
    | _ -> assert false (* Impossible *)
    | exception Not_found ->
      Heap.push heap (HEADER (Obj.closure_tag, 2 * Array.length ptrs - 1 + Array.length env));
      let ptr = POINTER (Heap.pointer heap) in
      Sharer.put_closure sharer ptrs env ptr;
      Heap.push heap (CODEPTR codemap.(ptrs.(0)));
      for i = 1 to Array.length ptrs - 1 do
        Heap.push heap (HEADER (Obj.infix_tag, 2 * i));
        Heap.push heap (CODEPTR codemap.(ptrs.(i)));
      done;
      let refs = Array.map (fun _ -> Heap.push_ref heap) env in
      Array.iter2 (fun r e -> r := export_value e) refs env;
      match ptr with
      | POINTER ptr -> POINTER (ptr + 2 * ofs)
      | _ -> assert false (* Impossible *)

  and export_code_ptr code_ptr =
    CODEPTR codemap.(code_ptr) in

  let accu = export_value accu in
  let stack = List.map export_value stack in
  let glob = Array.map export_value data in
  (accu, stack, Array.to_list glob, Heap.contents heap)

(******************************************************************************)

let reverse_stack stack_size stackdata =
  let len = ref (List.length stackdata) in
  let result = ref stackdata in
  if !len > stack_size then failwith (Printf.sprintf "too small stack: %d words (%d words required after initialisation)" stack_size !len);
  while !len < stack_size do
    result := INT 0 :: !result;
    incr len;
  done;
  !result

(******************************************************************************)
