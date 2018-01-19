open Avr

let () =
  pin_mode PIN9 OUTPUT;
  let r = ref [] in
  let acc = ref 0 in
  for i = 1 to 1_000 do
    for j = 1 to 100 do
      r := j :: !r;
    done;
    List.iter (fun i -> acc := i + !acc) !r;
    r := [];
  done;
  digital_write PIN9 true;
  digital_write PIN9 false;
  digital_write PIN9 (!acc = 5_050_000);
