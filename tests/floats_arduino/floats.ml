module Arduino = struct
  external serial_begin : int -> unit = "ocaml_arduino_serial_begin"
  external millis : unit -> int = "ocaml_arduino_millis"
end

let integrale f a b n =
  let h = (b -. a) /. n in
  let rec integ x =
    if  x >=  b then 0.0 else (f x) +. integ (x +. h) in
  integ  a *. h


let poly x = x *. x

let repeat n =
  for i = 0 to (n-1) do
    integrale poly 0.0 1.0 10.;
    (* force_gc(); *)
  done;
  integrale poly 0.0 1.0 10.

let _ =
  Arduino.serial_begin 57600;
  let x = Arduino.millis () in
  repeat 100;
  let y = Arduino.millis () - x in
  print_int (y -x);
  print_string "finish"

