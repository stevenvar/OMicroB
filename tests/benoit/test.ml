open Avr

let () =
  pin_mode PIN9 OUTPUT;
  let tbl = Array.init 10 (fun i -> 2 * i + 1) in
  Array.iter (fun i -> write_register PORTB i) tbl;
  for i = 1 to 1_000_000 do
    Array.iter (fun i -> let _ = i in ()) tbl;
  done;
  digital_write PIN9 true;
  
