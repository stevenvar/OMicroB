open Avr

let prod tbl =
  Array.fold_left ( *. ) 1. tbl

let mktbl =
  let rec loop i acc =
    if i = 0 then acc
    else loop (i - 1) (Array.append [| 1. /. float_of_int i |] acc) in
  fun i -> loop i [||]

let test_cmp x y =
  trace ("compare " ^ string_of_float x ^ " " ^ string_of_float y ^ " = " ^ string_of_int (compare x y))

let test_op name op x y =
  trace (string_of_float x ^ name ^ string_of_float y ^ " = " ^ string_of_bool (op x y))

let test_all xys =
  List.iter (fun (x, y) ->
    test_cmp x y;
  ) xys;
  List.iter (fun (name, op) ->
    trace "################################";
    List.iter (fun (x, y) ->
      test_op name op x y;
    ) xys;
  ) [
    (" < ", (<));
    (" > ", (>));
    (" <= ", (<=));
    (" >= ", (>=));
    (" = ", (=));
    (" <> ", (<>));
  ]
    
let () =
  pin_mode PIN9 OUTPUT;
  trace (string_of_float (prod (mktbl 4)));
  trace (string_of_float nan);
  test_all [
    (3.14, 6.99);
    (-19.8, 983.);
    (-3., -17.);
    (nan, -123.);
    (nan, 0.);
    (nan, 123.);
    (nan, nan);
    (nan, infinity);
    (nan, neg_infinity);
    (infinity, -10.);
    (infinity, 0.);
    (infinity, 918.);
    (infinity, infinity);
    (infinity, neg_infinity);
    (neg_infinity, (-137.));
    (neg_infinity, 0.);
    (neg_infinity, 188.);
    (neg_infinity, neg_infinity);
  ]
    
