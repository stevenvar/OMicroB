open OByteLib

type word =
| INT     of int
| FLOAT   of float
| CHARS   of char list
| BYTES   of int list
| CUSTOM  of string
| HEADER  of int * int
| POINTER of int

(******************************************************************************)

let export arch data =
  let heap = ref [] in
  let heap_ind = ref 0 in
  let push w = heap := w :: !heap; incr heap_ind in
  let rec export_value d =
    match d with
    | Value.Int n -> (
      (match arch with
      | Arch.A16 -> assert (n >= -0x8000 && n < 0x8000)
      | Arch.A32 -> assert (n >= -0x8000_0000 && n < 0x8000_0000)
      | Arch.A64 -> ());
      INT n
    )
    | Value.Int32 n -> (
      let n0 = Int32.to_int (Int32.logand n 0xFFl) in
      let n1 = Int32.to_int (Int32.logand (Int32.shift_right n  8) 0xFFl) in
      let n2 = Int32.to_int (Int32.logand (Int32.shift_right n 16) 0xFFl) in
      let n3 = Int32.to_int (Int32.logand (Int32.shift_right n 24) 0xFFl) in
      match arch with
      | Arch.A16 ->
        push (HEADER (Obj.custom_tag, 3));
        let ptr = POINTER !heap_ind in
        push (CUSTOM "int32");
        push (BYTES [ n3; n2 ]);
        push (BYTES [ n1; n0 ]);
        ptr
      | Arch.A32 ->
        push (HEADER (Obj.custom_tag, 2));
        let ptr = POINTER !heap_ind in
        push (CUSTOM "int32");
        push (BYTES [ n3; n2; n1; n0 ]);
        ptr
      | Arch.A64 ->
        push (HEADER (Obj.custom_tag, 2));
        let ptr = POINTER !heap_ind in
        push (CUSTOM "int32");
        push (BYTES [ 0; 0; 0; 0; n3; n2; n1; n0 ]);
        ptr
    )
    | Value.Int64 n -> (
      let n0 = Int64.to_int (Int64.logand n 0xFFL) in
      let n1 = Int64.to_int (Int64.logand (Int64.shift_right n  8) 0xFFL) in
      let n2 = Int64.to_int (Int64.logand (Int64.shift_right n 16) 0xFFL) in
      let n3 = Int64.to_int (Int64.logand (Int64.shift_right n 24) 0xFFL) in
      let n4 = Int64.to_int (Int64.logand (Int64.shift_right n 32) 0xFFL) in
      let n5 = Int64.to_int (Int64.logand (Int64.shift_right n 40) 0xFFL) in
      let n6 = Int64.to_int (Int64.logand (Int64.shift_right n 48) 0xFFL) in
      let n7 = Int64.to_int (Int64.logand (Int64.shift_right n 56) 0xFFL) in
      match arch with
      | Arch.A16 ->
        push (HEADER (Obj.custom_tag, 5));
        let ptr = POINTER !heap_ind in
        push (CUSTOM "int64");
        push (BYTES [ n7; n6 ]);
        push (BYTES [ n5; n4 ]);
        push (BYTES [ n3; n2 ]);
        push (BYTES [ n1; n0 ]);
        ptr
      | Arch.A32 ->
        push (HEADER (Obj.custom_tag, 3));
        let ptr = POINTER !heap_ind in
        push (CUSTOM "int64");
        push (BYTES [ n7; n6; n5; n4 ]);
        push (BYTES [ n3; n2; n1; n0 ]);
        ptr
      | Arch.A64 ->
        push (HEADER (Obj.custom_tag, 2));
        let ptr = POINTER !heap_ind in
        push (CUSTOM "int64");
        push (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
        ptr
    )
    | Value.Nativeint n -> (
      push (HEADER (Obj.custom_tag, 2));
      let ptr = POINTER !heap_ind in
      push (CUSTOM "nativeint");
      (match arch with
      | Arch.A16 ->
        if n < -0x8000n || n >= 0x8000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000) 0x7FFF;
        let n0 = Nativeint.to_int (Nativeint.logand n 0xFFn) in
        let n1 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 8) 0xFFn) in
        push (BYTES [ n1; n0 ]);
      | Arch.A32 ->
        if n < -0x8000_0000n || n >= 0x8000_0000n then Tools.fail "nativeint %nd out of bounds [ %d; %d ]" n (-0x8000_0000) 0x7FFF_FFFF;
        let n0 = Nativeint.to_int (Nativeint.logand n 0xFFn) in
        let n1 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n  8) 0xFFn) in
        let n2 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 16) 0xFFn) in
        let n3 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 24) 0xFFn) in
        push (BYTES [ n3; n2; n1; n0 ]);
      | Arch.A64 ->
        let n0 = Nativeint.to_int (Nativeint.logand n 0xFFn) in
        let n1 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n  8) 0xFFn) in
        let n2 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 16) 0xFFn) in
        let n3 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 24) 0xFFn) in
        let n4 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 32) 0xFFn) in
        let n5 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 40) 0xFFn) in
        let n6 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 48) 0xFFn) in
        let n7 = Nativeint.to_int (Nativeint.logand (Nativeint.shift_right n 56) 0xFFn) in
        push (BYTES [ n7; n6; n5; n4; n3; n2; n1; n0 ]);
      );
      ptr
    )
    | Value.Float x ->
      FLOAT x
    | Value.Float_array tbl ->
      push (HEADER (0, Array.length tbl));
      let ptr = POINTER !heap_ind in
      Array.iter (fun x -> push (FLOAT x)) tbl;
      ptr
    | Value.String str ->
      let len = String.length str in
      let word_size =
        match arch with
        | Arch.A16 -> 2
        | Arch.A32 -> 4
        | Arch.A64 -> 8 in
      let block_size = len / word_size + 1 in
      let current_strdata = ref [] in
      push (HEADER (Obj.string_tag, block_size));
      let ptr = POINTER !heap_ind in
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
    | Value.Object fields ->
      let words = Array.map export_value fields in
      push (HEADER (Obj.object_tag, Array.length fields));
      let ptr = POINTER !heap_ind in
      Array.iter push words;
      ptr
    | Value.Block (tag, fields) ->
      let words = Array.map export_value fields in
      push (HEADER (tag, Array.length fields));
      let ptr = POINTER !heap_ind in
      Array.iter push words;
      ptr
  in
  let glob = Array.map export_value data in
  (Array.to_list glob, List.rev !heap)

(******************************************************************************)
