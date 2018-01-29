let () =
  let htbl = Hashtbl.create 4 in
  let lst = [
    ("un", 1);
    ("deux", 2);
    ("trois", 3);
    ("quatre", 4);
    ("cinq", 5);
    ("six", 6);
    ("sept", 7);
    ("huit", 8);
    ("neuf", 9);
    ("dix", 10);
    ("onze", 11);
    ("douze", 12);
  ] in
  List.iter (fun (s, i) ->
    Hashtbl.add htbl [ "abc"; s ] i
  ) lst;
  List.iter (fun (s, i) ->
    trace s;
    tracei i;
    tracei (Hashtbl.find htbl [ "abc"; s ]);
  ) lst

