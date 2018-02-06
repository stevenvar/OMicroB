open Avr

let prod tbl =
  Array.fold_left ( *. ) 1. tbl

let mktbl =
  let rec loop i acc =
    if i = 0 then acc
    else loop (i - 1) (Array.append [| 1. /. float_of_int i |] acc) in
  fun i -> loop i [||]

let generic_cmp x y = compare x y
let generic_eq  x y = x =  y
let generic_neq x y = x <> y
let generic_lt  x y = x <  y
let generic_gt  x y = x >  y
let generic_le  x y = x <= y
let generic_ge  x y = x >= y

let test_float_cmp x y =
  trace ("Float.compare " ^ string_of_float x ^ " " ^ string_of_float y ^ " = " ^ string_of_int (compare x y))

let test_pervasives_cmp x y =
  trace ("Pervasives.compare " ^ string_of_float x ^ " " ^ string_of_float y ^ " = " ^ string_of_int (generic_cmp x y))

let test_op name op x y =
  trace (string_of_float x ^ name ^ string_of_float y ^ " = " ^ string_of_bool (op x y))

let test_all xys =
  trace "################################";
  List.iter (fun (x, y) ->
    test_float_cmp x y;
  ) xys;
  trace "################################";
  List.iter (fun (x, y) ->
    test_pervasives_cmp x y;
  ) xys;
  trace "################################";
  List.iter (fun (name, op) ->
    trace "################################";
    List.iter (fun (x, y) ->
      test_op name op x y;
    ) xys;
  ) [
    (" < "  , ( <  ));
    (" > "  , ( >  ));
    (" <= " , ( <= ));
    (" >= " , ( >= ));
    (" = "  , ( =  ));
    (" <> " , ( <> ));
  ];
  trace "################################";
  List.iter (fun (name, op) ->
    trace "################################";
    List.iter (fun (x, y) ->
      test_op name op x y;
    ) xys;
  ) [
    (" < "  , generic_lt);
    (" > "  , generic_gt);
    (" <= " , generic_le);
    (" >= " , generic_ge);
    (" = "  , generic_eq);
    (" <> " , generic_neq);
  ]

let rec l1 = 42. :: l1
let rec l2 = 42. :: l2

let () =
  pin_mode PIN9 OUTPUT;
  Gc.run ();
  begin
    match l1, l2 with
    | x :: _, y :: _ ->
      trace (string_of_float x);
      trace (string_of_float y);
    | _ ->
      trace "Ouch!"
  end;
  trace (string_of_float infinity);
  trace (string_of_float neg_infinity);
  trace (string_of_float 0.);
  trace (string_of_float (-0.));
  trace (string_of_float nan);
  trace (string_of_float 3.14);
  trace (string_of_float (-3.14));
  trace (string_of_float (prod (mktbl 4)));
  trace (if generic_eq 16128 16128 then "OK" else "Ouch!");
  test_all [
    (3.14, 6.99);
    (-19.8, 983.);
    (-3., -17.);
    (0., 0.);
    (-0., 0.);
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
