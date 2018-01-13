
module Arduino = struct
  external serial_begin : int -> unit = "ocaml_arduino_serial_begin"
  external millis : unit -> int = "ocaml_arduino_millis"
end;;

let rec odd x = 
  if x = 0 then false
  else
    even (x-1)
and even x =
  if x = 0 then true 
  else 
    odd (x-1)

let () =
  Arduino.serial_begin 57600;
  let x = Arduino.millis () in 
  for i = 0 to 100 do 
    odd i;
  done;
  let y = Arduino.millis () - x in 
  print_int y;
