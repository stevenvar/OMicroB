
open Types

(* 128 * 8 pages of 1 byte (here : an int)  *)

let size = 128*8

let create () = Array.make size 0

let fill c display =
   Array.fill display.ddram 0 (Array.length display.ddram) c

let translate_position col page display =
  page*display.width + col

let write =
  let i = ref 0 in
  fun c display ->
      display.ddram.(!i) <- c;
      incr i;
      i := !i mod size

let to_matrix display =
  let ddram = display.ddram in
  let matrix = display.matrix in
  for i = 0 to size-1 do
    let col = i mod 128 in (* 128 is col 0 *)
    let row = (i / 128)*8 in (* 128 is row 8 *)
    (* Probably shoudn't be hard-coded this way but there's no time ..  *)
    try
      matrix.(col).(row) <- if ddram.(i) land 0b00000001 = 1 then true else false;
      matrix.(col).(row+1) <- if ddram.(i) land 0b00000010 = 0b10 then true else false;
      matrix.(col).(row+2) <- if ddram.(i) land 0b00000100 = 0b100 then true else false;
      matrix.(col).(row+3) <- if ddram.(i) land 0b00001000 = 0b1000 then true else false;
      matrix.(col).(row+4) <- if ddram.(i) land 0b00010000 = 0b10000 then true else false;
      matrix.(col).(row+5) <- if ddram.(i) land 0b00100000 = 0b000100000 then true else false;
      matrix.(col).(row+6) <- if ddram.(i) land 0b01000000 = 0b001000000 then true else false;
      matrix.(col).(row+7) <- if ddram.(i) land 0b10000000 = 0b10000000 then true else false;
    with _ -> failwith "to_matrix"
  done

let print_ddram display =
  let oc = open_out "ddram.txt" in
  for i = 0 to size-1 do
      Printf.fprintf oc "%d" display.ddram.(i)
    done;
  close_out oc

let print_matrix display =
  let oc = open_out "matrix.txt" in
  let print_bool = function
      true -> "#"
    | false -> "_"
  in
  let matrix = display.matrix in
  for i = 0 to 64-1 do
    for j = 0 to 128-1 do
      Printf.fprintf oc "%s" (print_bool matrix.(j).(i))
    done;
    Printf.fprintf oc  "\n"
  done;
  close_out oc
