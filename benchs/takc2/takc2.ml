  
let rec takc (x, y, z) =
  if x > y then takc (takc( (x-1), y, z), (takc( (y-1), z, x)), (takc( (z-1), x, y)))
           else z


let repeat n =
  let r = ref 0 and i = ref 0 in 
  while (!i < n) do 
    r := !r + takc(3,2,1);
    i := !i + 1;
  done;
  !r

let main () =
  let start = millis () in
  ignore (repeat 200000);
  let stop = millis () in
  Serial.write_string (string_of_int (stop-start));;

main();;
