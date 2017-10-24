module Arduboy = struct
  external millis : unit -> int = "ocaml_arduboy_millis"
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end;;


Arduboy.init ();;

(* let facto x = *)
(*   let rec aux x acc = *)
(*     match x with *)
(*     | 0 -> acc *)
(*     | _ -> aux (x-1) (acc*x) *)
(*   in *)
(*   aux x 1 *)

(* type 'a ref = { mutable contents : 'a } *)

type 'a list = Cons of 'a * 'a list | Nil 

(* let rec facto x = *)
(*   if x = 0 then 1 *)
(*   else *)
(*     (facto (x-1)) * x *)

(* let rec facto x = *)
(*   let rec aux x acc =  *)
(*   if x = 0 then acc *)
(*   else *)
(*     aux (x-1) (x*acc) *)
(*   in *)
(*   aux x 1 *)


(* let succ x = x + 1 *)

let sleep () = for i = 0 to 100000 do () done 

let () =
  let x = Arduboy.millis () in 
  sleep ();
  let diff = Arduboy.millis () - x in 
  Arduboy.print_string("TIME = ");
  Arduboy.print_int(diff);

  Arduboy.print_string "\n";
  Arduboy.display();
  (* (\* for i = 0 to 1000 do  *\) *)
  (* (\*   (i,i)  *\) *)
  (* (\* done; *\) *)
  (* for i = 0 to 10 do *)
  (*   Arduboy.print_int i; *)
  (*   (\* Arduboy.print_int (facto i); *\) *)
  (*   Arduboy.print_string "\n"; *)
  (*   Arduboy.display(); *)
  (*   sleep (); *)
  (* done; *)
  (* Arduboy.print_int (plus 1 2); *)
  (* for i = 0 to 10000 do  *)
    (* Cons (i,Nil) *)
  (* done; *)
