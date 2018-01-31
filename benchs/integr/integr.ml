let integrale f a b n =
  let h = (b -. a) /. n in
  let rec integ x =
    if  x >=  b then 0.0 else (f x) +. integ (x +. h) in
  integ  a *. h


let poly x = x *. x

let repeat n =
  for _i = 0 to (n-1) do
    ignore (integrale poly 0.0 1.0 10.);
    (* force_gc(); *)
  done;
  integrale poly 0.0 1.0 10.

let _ =
  Avr.(pin_mode PIN9 OUTPUT);
  (* integrale poly 0.0 1.0 10.; *)
  (* force_gc(); *)
  repeat 100;
