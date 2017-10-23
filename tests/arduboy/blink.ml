module Arduboy = struct
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external display : unit   -> unit = "ocaml_arduboy_display"
end


(* let facto x = *)
(*   let rec aux x acc = *)
(*     match x with *)
(*     | 0 -> acc *)
(*     | _ -> aux (x-1) (acc*x) *)
(*   in *)
(*   aux x 1 *)

(* type 'a ref = { mutable contents : 'a } *)

let plus x y = x + y

let () =
  let c () = 8 in
  (* Arduboy.init (); *)
  for i = 0 to 10 do
    for i = 0 to 10 do ()
    done;
  done;
  (* let k = plus 3 4 in *)
  ();
  print_int (c ());
  (* Arduboy.display(); *)
