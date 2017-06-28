module Arduboy = struct
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print   : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end

let rec facto x =
  match x with
  | 0 -> 1
  | _ -> facto (x - 1) * x

(* let facto x = *)
(*   let rec aux x acc = *)
(*     match x with *)
(*     | 0 -> acc *)
(*     | _ -> aux (x-1) (acc*x) *)
(*   in *)
(*   aux x 1 *)


let () =
  Arduboy.init ();
  for i = 0 to 10 do
  (* Arduboy.print "facto "; *)
  (* Arduboy.print_int i; *)
  (* Arduboy.print " = "; *)
    let x = facto i in
    (* x *)
  Arduboy.print_int (x);
  Arduboy.print " \n";
  Arduboy.display ();
  (* delay 1000 *)
  (* blink PIN17 100 1000 *)
done
