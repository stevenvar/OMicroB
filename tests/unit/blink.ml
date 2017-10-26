
type 'a truc = { mutable c : 'a }

let () =
  serial_begin 9600;
  let x = { c = 3 } in
  x.c <- 4;
  print_int x.c;
  ()
