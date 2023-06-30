
let rec integ accu x f  b h =
  if  x >=  b then accu else integ (accu +. (f x)) (x +. h) f  b h 
;;

let integrale f a b n =
  let h = (b -. a) /. (float_of_int n) in
  integ  0.0 (a *. h) f  b h 
;;


let poly x = x *. x +. 2. *. x +. 1.
;;


let rec repeat n =
  if n <= 0 then () else (
    ignore(integrale poly 0.0 1.0 10000);
    repeat (n-1)
  )
;;

(* integrale poly 0.0 1.0 10000 -> 2.333583335 (* 0.333383335 *) *)

exception K of string * float *   bool 
;;

let main () =
  let start = millis () in
  repeat 40;
  let stop = millis () in
  Serial.write_string (string_of_int (stop-start));;

main ()
;;

