open OByteLib

type word =
| INT     of int
| FLOAT   of int list
| CHARS   of char list
| BYTES   of int list
| CUSTOM  of string
| HEADER  of int * int
| POINTER of int

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

let export arch data =
  let heap = ref [] in
  let heap_ind = ref 0 in
  let push w = heap := w :: !heap; incr heap_ind in
  let pointer () = POINTER (!heap_ind * Arch.byte_count arch) in

  let rec export_value d =
    match d with
    | Value.Int n -> export_int n
    | Value.Int32 n -> export_int32 n
    | Value.Int64 n -> export_int64 n
    | Value.Nativeint n -> export_nativeint n
    | Value.Float x -> export_float x
    | Value.Float_array tbl -> export_float_array tbl
    | Value.String str -> export_string str
    | Value.Object fields -> export_block Obj.object_tag fields
    | Value.Block (tag, fields) -> export_block tag fields

  and export_int n =
    begin
      match arch with
      | Arch.A16 -> assert (n >= -0x8000 && n < 0x8000)
      | Arch.A32 -> assert (n >= -0x8000_0000 && n < 0x8000_0000)
      | Arch.A64 -> ()
    end;
    INT n

  and export_int32 n =
    let (n0, n1, n2, n3) = int32_bytes n in
    match arch with
    | Arch.A16 ->
      push (HEADER (Obj.custom_tag, 3));
      let ptr = pointer () in
      push (CUSTOM "int32");
      push (BYTES [ n3; n2 ]);
      push (BYTES [ n1; n0 ]);
      ptr
    | Arch.A32 ->
      push (HEADER (Obj.custom_tag, 2));
      let ptr = pointer () in
      push (CUSTOM "int32");
      push (BYTES [ n3; n2; n1; n0 ]);
      ptr
    | Arch.A64 ->
      push (HEADER (Obj.custom_tag, 2));
      let ptr = pointer () in
      push (CUSTOM "int32");
      push (BYTES [ 0; 0; 0; 0; n3; n2; n1; n0 ]);
      ptr

  and export_int64 n =
    let (n0, n1, n2, n3, n4, n5, n6, n7) = int64_bytes n in
    match arch with
    | Arch.A16 ->
      push (HEADER (Obj.custom_tag, 5));
      let ptr = pointer () in
      push (CUSTOM "int64");
      push (BYTES [ n7; n6 ]);
      push (BYTES [ n5; n4 ]);
      push (BYTES [ n3; n2 ]);
      push (BYTES [ n1; n0 ]);
      ptr
    | Arch.A32 ->
      push (HEADER (Obj.custom_tag, 3));
      let ptr = pointer () in
      push (CUSTOM "int64");
      push (BYTES [ n7; n6; n5; n4 ]);
      push (BYTES [ n3; n2; n1; n0 ]);
      ptr
    | Arch.A64 ->
      push (HEADER (Obj.custom_tag, 2));
      let ptr = pointer () in
      push (CUSTOM "int64");
      push (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
      ptr

  and export_nativeint n =
    push (HEADER (Obj.custom_tag, 2));
    let ptr = pointer () in
    push (CUSTOM "nativeint");
    match arch with
    | Arch.A16 ->
      if n < -0x8000n || n >= 0x8000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000) 0x7FFF;
      let n0 = Nativeint.to_int (Nativeint.logand n 0xFFn) in
      let n1 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 8) 0xFFn) in
      push (BYTES [ n1; n0 ]);
      ptr
    | Arch.A32 ->
      if n < -0x8000_0000n || n >= 0x8000_0000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000_0000) 0x7FFF_FFFF;
      let (n0, n1, n2, n3, _, _, _, _) = nativeint_bytes n in
      push (BYTES [ n3; n2; n1; n0 ]);
      ptr
    | Arch.A64 ->
      let (n0, n1, n2, n3, n4, n5, n6, n7) = nativeint_bytes n in
      push (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
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
    push (HEADER (0, Array.length tbl));
    let ptr = pointer () in
    Array.iter (fun x -> push (export_float x)) tbl;
    ptr

  and export_string str =
    let len = String.length str in
    let word_size =
      match arch with
      | Arch.A16 -> 2
      | Arch.A32 -> 4
      | Arch.A64 -> 8 in
    let block_size = len / word_size + 1 in
    let current_strdata = ref [] in
    push (HEADER (Obj.string_tag, block_size));
    let ptr = pointer () in
    String.iter (fun c ->
      current_strdata := c :: !current_strdata;
      if List.length !current_strdata = word_size then (
        push (CHARS (List.rev !current_strdata));
        current_strdata := [];
      )
    ) str;
    let zero_pad = word_size - List.length !current_strdata - 1 in
    for _i = 1 to zero_pad do current_strdata := '\x00' :: !current_strdata done;
    push (CHARS (List.rev (char_of_int zero_pad :: !current_strdata)));
    ptr

  and export_block tag fields =
    let words = Array.map export_value fields in
    push (HEADER (tag, Array.length fields));
    let ptr = pointer () in
    Array.iter push words;
    ptr in

  let glob = Array.map export_value data in
  (Array.to_list glob, List.rev !heap)

(******************************************************************************)
