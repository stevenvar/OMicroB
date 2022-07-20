open Types

(* 128 * 8 pages of 1 byte (here : an int)  *)

module DDRAM(M : Simul.MCUSimul) = struct
  open DisplayTypes(M)
  let size = 128 * 8

  let create () = Array.make size 0

  let fill c display =
    Array.fill display.ddram 0 (Array.length display.ddram) c

  let translate_position col page display =
    page * display.width + col

  let write, set_line, set_column_low, set_column_high =
    let i = ref 0 in
    let write c display =
      (* if c <> 0 then *)
      (* Printf.printf "i = %d , c = %d " !i c; *)
      display.ddram.(!i) <- c;
      incr i;
      i := !i mod size
    and set_line n =
      i := (!i land 0x007F) lor (n lsl 7);
    and set_column_low n =
      i := (!i land 0xFFF0) lor n;
    and set_column_high n =
      i := (!i land 0xFF8F) lor ((n land 0x07) lsl 4) in
    write, set_line, set_column_low, set_column_high

  let to_matrix (display:display) =
    let ddram = display.ddram in
    let matrix = display.matrix in
    for i = 0 to size - 1 do
      let col = i mod 128 in (* 128 is col 0 *)
      let row = (i / 128) * 8 in (* 128 is row 8 *)
      (* Probably shoudn't be hard-coded this way but there's no time ..  *)
      try
        matrix.(col).(row+0) <- ddram.(i) land 0b00000001 = 0b00000001;
        matrix.(col).(row+1) <- ddram.(i) land 0b00000010 = 0b00000010;
        matrix.(col).(row+2) <- ddram.(i) land 0b00000100 = 0b00000100;
        matrix.(col).(row+3) <- ddram.(i) land 0b00001000 = 0b00001000;
        matrix.(col).(row+4) <- ddram.(i) land 0b00010000 = 0b00010000;
        matrix.(col).(row+5) <- ddram.(i) land 0b00100000 = 0b00100000;
        matrix.(col).(row+6) <- ddram.(i) land 0b01000000 = 0b01000000;
        matrix.(col).(row+7) <- ddram.(i) land 0b10000000 = 0b10000000;
      with _ -> failwith "to_matrix"
    done

  let print_ddram display =
    let oc = open_out "ddram.txt" in
    for i = 0 to size - 1 do
      Printf.fprintf oc "%d" display.ddram.(i)
    done;
    close_out oc

  let print_matrix display =
    let oc = open_out "matrix.txt" in
    let char_of_bool = function
      | true  -> '#'
      | false -> '_'
    in
    let matrix = display.matrix in
    for i = 0 to display.height - 1 do
      for j = 0 to display.width - 1 do
        Printf.fprintf oc "%c" (char_of_bool matrix.(j).(i))
      done;
      Printf.fprintf  oc "\n"
    done;
    close_out oc
end
