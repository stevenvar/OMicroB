let  facto n =
   let rec loop n acc =
     match n with
       | 0 -> acc
       | _ -> loop (n-1) (n*acc)
   in
   loop n 1

let write_answer n =
  let s = string_of_int n in
  String.iter (Avr.Serial.write) s;
  Avr.Serial.write '\n'

let _ =
  Avr.Serial.init ();
  for i = 1 to 10 do
    let m = facto i in
    let n = Avr.millis () in
    write_answer m;
    write_answer n
  done
