let rec fibo n =
  if n <= 1 then n
  else (fibo (n-1) + fibo (n-2));;

let rec repeat n =
  if n = 0 then ()
  else (ignore (fibo 5); repeat (n-1))

let _ =
  let start = millis () in
  repeat 1000000;
  let stop = millis () in () (* in *)
  (* Serial.write_string (string_of_int (stop-start)) *)
