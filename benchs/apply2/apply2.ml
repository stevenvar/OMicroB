
let double f x = f (f x) ;;
let quad n = double double n ;;
let oct n = quad quad n  ;;
let succ n = n + 1 ;;

let rec repeat a n = 
  if n <= 0 then  a else  repeat (a + (double (quad succ) n)) (n-1)  ;;

let main () =
  let start = millis () in
  ignore (repeat 0 100000);
  let stop = millis () in
  Serial.write_string (string_of_int (stop-start));;


main() ;;
  
