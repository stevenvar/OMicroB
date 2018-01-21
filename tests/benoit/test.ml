open Avr

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

let () =
  let pins = [ PIN9; PIN11; PIN10 ] in
  List.iter (fun pin -> pin_mode pin OUTPUT) pins;
  List.iter (fun pin -> digital_write pin true) pins;
  while true do
    List.iter (fun pin ->
      digital_write pin false;
      for _i = 1 to 1_000 do () done;
      digital_write pin true;
    ) pins;
  done

(*
let () =
  pin_mode PIN9 OUTPUT;
  digital_write PIN9 false;
*)
