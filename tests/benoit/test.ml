open Avr

let pin = PIN9
  
let () =
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
