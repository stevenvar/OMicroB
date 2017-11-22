
module Arduino = struct
  external serial_begin : int -> unit = "ocaml_arduino_serial_begin"
  external millis : unit -> int = "ocaml_arduino_millis"
end;;

let rec facto = function
    0 -> 1
  | x -> facto (x-1) * x

let _ =
  Arduino.serial_begin 57600;
  let x = Arduino.millis () in
  for i = 0 to 100 do
    (* Arduboy.print_int(facto i); *)
    for i = 0 to 10 do
      facto i;
    done;
  done;
  let y = Arduino.millis () in
  (* print_string "\n"; *)
  print_int (y-x);
  print_string "finish"
