open Avr

let test () =
  begin
    let rec l = 1 :: l in
    match l with
    | 1 :: 1 :: 1 :: 1 :: 1 :: _ -> ()
    | _ -> assert false
  end;
  
  begin
    let rec l1 = 42. :: l1 in
    let rec l2 = 42. :: l2 in
    match l1, l2 with
    | x :: _, y :: _ ->
      assert (x = y)
    | _ ->
      assert false
  end;

  begin
    let rec l1 = 1 :: l2
    and l2 = 2 :: l1 in
    begin
      match l1 with
      | 1 :: 2 :: 1 :: 2 :: 1 :: 2 :: _ -> ()
      | _ -> assert false
    end;
    begin
      match l2 with
      | 2 :: 1 :: 2 :: 1 :: 2 :: _ -> ()
      | _ -> assert false
    end;
  end;
  
  begin
    let rec l = f :: l
    and f () =
      match l with
      | _ :: _ -> ()
      | [] -> assert false in
    f ()
  end;

  ()

let () =
  test ();
  pin_mode PIN9 OUTPUT;
  test ();
