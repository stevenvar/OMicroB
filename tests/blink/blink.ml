

let rec facto x =
  if x = 0 then 1
  else
    (facto (x-1)) * x

let _ =
    let x = facto 7  in
    (* write_reg TRISB 0x00; *)
    (* write_reg PORTB x *)
    ()
