open T

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)

let exception_list = [
  ("Out_of_memory", -1);
  ("Stack_overflow", -9);
  ("Division_by_zero", -6);
  ("Invalid_argument", -4);
]

(******************************************************************************)
(******************************************************************************)
(******************************************************************************)

let split_globals globals code =
  let open OByteLib.Instr in
  let global_nb = Array.length globals in
  let is_get_tbl = Array.make global_nb false in
  let is_set_tbl = Array.make global_nb false in
  Array.iter (fun instr ->
    match instr with
    | GETGLOBAL n | PUSHGETGLOBAL n
    | GETGLOBALFIELD (n, _) | PUSHGETGLOBALFIELD (n, _) -> is_get_tbl.(n) <- true
    | SETGLOBAL n -> is_set_tbl.(n) <- true
    | _ -> ()
  ) code;

  let global_map = Array.make global_nb 0 in
  
  let ram_lst   = ref [] in
  let flash_lst = ref [] in

  let ram_ind   = ref 0 in
  let flash_ind = ref 0 in

  for i = 0 to global_nb - 1 do
    if is_set_tbl.(i) then (
      global_map.(i) <- !ram_ind + 1;
      ram_lst := globals.(i) :: !ram_lst;
      incr ram_ind;
    ) else if is_get_tbl.(i) then (
      global_map.(i) <- - !flash_ind - 1;
      flash_lst := globals.(i) :: !flash_lst;
      incr flash_ind;
    )
  done;

  let ram_globals = Array.of_list (List.rev !ram_lst) in
  let flash_globals = Array.of_list (List.rev !flash_lst) in

  let new_code =
    Array.map (fun instr ->
      match instr with
      | GETGLOBAL n -> GETGLOBAL global_map.(n)
      | PUSHGETGLOBAL n -> PUSHGETGLOBAL global_map.(n)
      | GETGLOBALFIELD (n, p) -> GETGLOBALFIELD (global_map.(n), p)
      | PUSHGETGLOBALFIELD (n, p) -> PUSHGETGLOBALFIELD (global_map.(n), p)
      | SETGLOBAL n -> SETGLOBAL global_map.(n)
      | _ -> instr
    ) code in
  
  (ram_globals, flash_globals, new_code)
  
(******************************************************************************)
(******************************************************************************)
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

let export arch codemap accu stack ram_globals flash_globals =
  let sharer = Sharer.create () in

  let static_heap = Heap.create () in
  let flash_heap = Heap.create () in
  let static_pointer () = SPOINTER (Heap.pointer static_heap) in
  let flash_pointer () = FPOINTER (Heap.pointer flash_heap) in
  let heap_pointer_of_mutability mut =
    match mut with
    | Mutable -> static_heap, static_pointer
    | Immutable -> flash_heap, flash_pointer in

  let rec export_value d =
    match d with
    | Int n -> export_int n
    | Int32 n -> export_int32 n
    | Int64 n -> export_int64 n
    | Nativeint n -> export_nativeint n
    | Float x -> export_float x
    | Float_array (mut, tbl) -> export_float_array mut tbl
    | Bytes (mut, str) -> export_bytes mut str
    | Object (mut, fields) -> export_block mut Obj.object_tag fields
    | Block (mut, tag, fields) -> export_block mut tag fields
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
          Heap.push flash_heap (HEADER (Obj.custom_tag, 3));
          let ptr = flash_pointer () in
          Heap.push flash_heap (CUSTOM "int32");
          Heap.push flash_heap (BYTES [ n3; n2 ]);
          Heap.push flash_heap (BYTES [ n1; n0 ]);
          ptr
        | Arch.A32 ->
          Heap.push flash_heap (HEADER (Obj.custom_tag, 2));
          let ptr = flash_pointer () in
          Heap.push flash_heap (CUSTOM "int32");
          Heap.push flash_heap (BYTES [ n3; n2; n1; n0 ]);
          ptr
        | Arch.A64 ->
          Heap.push flash_heap (HEADER (Obj.custom_tag, 2));
          let ptr = flash_pointer () in
          Heap.push flash_heap (CUSTOM "int32");
          Heap.push flash_heap (BYTES [ 0; 0; 0; 0; n3; n2; n1; n0 ]);
          ptr in
      Sharer.put_int32 sharer n ptr;
      ptr

  and export_int64 n =
    try Sharer.find_int64 sharer n with Not_found ->
      let ptr =
        let (n0, n1, n2, n3, n4, n5, n6, n7) = int64_bytes n in
        match arch with
        | Arch.A16 ->
          Heap.push flash_heap (HEADER (Obj.custom_tag, 5));
          let ptr = flash_pointer () in
          Heap.push flash_heap (CUSTOM "int64");
          Heap.push flash_heap (BYTES [ n7; n6 ]);
          Heap.push flash_heap (BYTES [ n5; n4 ]);
          Heap.push flash_heap (BYTES [ n3; n2 ]);
          Heap.push flash_heap (BYTES [ n1; n0 ]);
          ptr
        | Arch.A32 ->
          Heap.push flash_heap (HEADER (Obj.custom_tag, 3));
          let ptr = flash_pointer () in
          Heap.push flash_heap (CUSTOM "int64");
          Heap.push flash_heap (BYTES [ n7; n6; n5; n4 ]);
          Heap.push flash_heap (BYTES [ n3; n2; n1; n0 ]);
          ptr
        | Arch.A64 ->
          Heap.push flash_heap (HEADER (Obj.custom_tag, 2));
          let ptr = flash_pointer () in
          Heap.push flash_heap (CUSTOM "int64");
          Heap.push flash_heap (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
          ptr in
      Sharer.put_int64 sharer n ptr;
      ptr

  and export_nativeint n =
    try Sharer.find_nativeint sharer n with Not_found ->
      let ptr =
        Heap.push flash_heap (HEADER (Obj.custom_tag, 2));
        let ptr = flash_pointer () in
        Heap.push flash_heap (CUSTOM "nativeint");
        match arch with
        | Arch.A16 ->
          if n < -0x8000n || n >= 0x8000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000) 0x7FFF;
          let n0 = Nativeint.to_int (Nativeint.logand n 0xFFn) in
          let n1 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 8) 0xFFn) in
          Heap.push flash_heap (BYTES [ n1; n0 ]);
          ptr
        | Arch.A32 ->
          if n < -0x8000_0000n || n >= 0x8000_0000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000_0000) 0x7FFF_FFFF;
          let (n0, n1, n2, n3, _, _, _, _) = nativeint_bytes n in
          Heap.push flash_heap (BYTES [ n3; n2; n1; n0 ]);
          ptr
        | Arch.A64 ->
          let (n0, n1, n2, n3, n4, n5, n6, n7) = nativeint_bytes n in
          Heap.push flash_heap (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
          ptr in
      Sharer.put_nativeint sharer n ptr;
      ptr

  and export_float x =
    match arch with
    | Arch.A16 ->
      assert false (* TODO *)
    | Arch.A32 ->
      if classify_float x = FP_nan then (
        FLOAT [ 0x7F; 0xA0; 0x00; 0x00 ]
      ) else (
        let n = Int32.bits_of_float x in
        let (n0, n1, n2, n3) = int32_bytes n in
        if n3 land 0x80 <> 0 then
          FLOAT [ n3 lxor 0x7F; n2 lxor 0xFF; n1 lxor 0xFF; n0 lxor 0xFF ]
        else
          FLOAT [ n3; n2; n1; n0 ]
      )
    | Arch.A64 ->
      if classify_float x = FP_nan then (
        FLOAT [ 0x7F; 0xFF; 0x00; 0x00; 0x00; 0x00; 0x00; 0x00 ]
      ) else (
        let n = Int64.bits_of_float x in
        let (n0, n1, n2, n3, n4, n5, n6, n7) = int64_bytes n in
        FLOAT [ n7; n6; n5; n4; n3; n2; n1; n0 ]
      )

  and export_float_array mut tbl =
    let heap, pointer = heap_pointer_of_mutability mut in
    try Sharer.find_float_array sharer mut tbl with Not_found ->
      Heap.push heap (HEADER (0, Array.length tbl));
      let ptr = pointer () in
      Sharer.put_float_array sharer mut tbl ptr;
      Array.iter (fun x -> Heap.push heap (export_float x)) tbl;
      ptr

  and export_bytes mut str =
    let heap, pointer = heap_pointer_of_mutability mut in
    try Sharer.find_bytes sharer mut str with Not_found ->
      let len = Bytes.length str in
      let word_size =
        match arch with
        | Arch.A16 -> 2
        | Arch.A32 -> 4
        | Arch.A64 -> 8 in
      let block_size = len / word_size + 1 in
      let current_strdata = ref [] in
      Heap.push heap (HEADER (Obj.string_tag, block_size));
      let ptr = pointer () in
      Sharer.put_bytes sharer mut str ptr;
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

  and export_block mut tag fields =
    let heap, pointer = heap_pointer_of_mutability mut in
    try Sharer.find_block sharer mut tag fields with Not_found ->
      Heap.push heap (HEADER (tag, Array.length fields));
      let ptr = pointer () in
      Sharer.put_block sharer mut tag fields ptr;
      let refs = Array.map (fun _ -> Heap.push_ref heap) fields in
      Array.iter2 (fun r field -> r := export_value field) refs fields;
      ptr

  and export_closure { ofs; ptrs; env } =
    assert (Array.length ptrs > 0 && ofs < Array.length ptrs);
    match Sharer.find_closure sharer ptrs env with
    | SPOINTER ptr -> SPOINTER (ptr + 2 * ofs)
    | FPOINTER ptr -> FPOINTER (ptr + 2 * ofs)
    | _ -> assert false (* Impossible *)
    | exception Not_found ->
      Heap.push flash_heap (HEADER (Obj.closure_tag, 2 * Array.length ptrs - 1 + Array.length env));
      let ptr = flash_pointer () in
      Sharer.put_closure sharer ptrs env ptr;
      Heap.push flash_heap (CODEPTR codemap.(ptrs.(0)));
      for i = 1 to Array.length ptrs - 1 do
        Heap.push flash_heap (HEADER (Obj.infix_tag, 2 * i));
        Heap.push flash_heap (CODEPTR codemap.(ptrs.(i)));
      done;
      let refs = Array.map (fun _ -> Heap.push_ref flash_heap) env in
      Array.iter2 (fun r e -> r := export_value e) refs env;
      match ptr with
      | SPOINTER ptr -> SPOINTER (ptr + 2 * ofs)
      | FPOINTER ptr -> FPOINTER (ptr + 2 * ofs)
      | _ -> assert false (* Impossible *)

  and export_code_ptr code_ptr =
    CODEPTR codemap.(code_ptr) in

  let atom0 = export_value (Block (Immutable, 0, [||])) in
  
  let exceptions =
    List.map (fun (name, id) ->
      let block = Block (Immutable, Obj.object_tag, [| Bytes (Immutable, Bytes.of_string name); Int id |]) in
      (name, export_value block)
    ) exception_list in
  
  let accu = export_value accu in
  let stack = List.map export_value stack in
  let ram_global_data = Array.map export_value ram_globals in
  let flash_global_data = Array.map export_value flash_globals in
  (atom0, exceptions, accu, stack, Array.to_list ram_global_data, Array.to_list flash_global_data, Heap.contents static_heap, Heap.contents flash_heap)

(******************************************************************************)
(******************************************************************************)
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
(******************************************************************************)
(******************************************************************************)
