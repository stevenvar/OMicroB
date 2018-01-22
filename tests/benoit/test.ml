(*open Avr*)

(*
let () =
  let pin = PIN11 in
  pin_mode pin OUTPUT;
  let r = ref [] in
  let acc = ref 0 in
  for _i = 1 to 1_000 do
    for j = 1 to 100 do
      r := j :: !r;
    done;
    List.iter (fun i -> acc := i + !acc) !r;
    r := [];
  done;
  digital_write pin true;
  digital_write pin false;
  digital_write pin (!acc = 5_050_000);
*)
(*
let blink nsleep =
  let pins = [ PIN9; PIN10; PIN11 ] in
  List.iter (fun pin -> pin_mode pin OUTPUT) pins;
  List.iter (fun pin -> digital_write pin HIGH) pins;
  while true do
    List.iter (fun pin ->
      digital_write pin LOW;
      for _i = 1 to nsleep do () done;
      digital_write pin HIGH;
    ) pins;
  done
*)
(*
let () = pin_mode PIN9 OUTPUT

exception Exn of int
    
let () =
  try
    if true then raise (Exn 10_000);
    trace "Hello";
  with Exn n ->
    trace "World";
    tracei n;
*)
(*
let rec fact n =
  if n = 0 then 1 else n * fact (n - 1)

let () =
  try
    ignore (fact 1_000);
    blink 5_000;
  with Stack_overflow ->
    blink 20_000;
*)
(*
let () =
  let pin = PIN10 in
  pin_mode pin OUTPUT;
  digital_write pin HIGH;
*)

let () =
  for _i = 1 to 1_000_000 do
    tracei (Random.int 1_000_000);
  done
