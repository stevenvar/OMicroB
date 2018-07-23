open Avr

let test1 () =
  let rec f x =
    if x = 0 then 0
    else g (x - 1) + 1
      
  and g x =
    if x = 0 then 0
    else h (x - 1) + 10
      
  and h x =
    if x = 0 then 0
    else f (x - 1) + 100 in

  f 10
    
let () =
  pin_mode PIN10 OUTPUT;
  tracei (test1 ())

let iterLeds leds =
  let rec run l rest =
    digital_write l HIGH; delay 250; digital_write l LOW;
    iter rest

  and iter leds = match leds with
    | [] -> ()
    | l::rest -> run l rest

  in iter leds

let () =
  let r = PIN9 and g = PIN10 and b = PIN11 in
  pin_mode r OUTPUT; pin_mode g OUTPUT; pin_mode b OUTPUT;
  let leds = [r;g;b;r] in
  iterLeds leds

