(* module Arduboy = struct *)
(*   external millis : unit -> int = "ocaml_arduboy_millis" *)
(*   external init    : unit   -> unit = "ocaml_arduboy_init" *)
(*   external print_int : int -> unit = "ocaml_arduboy_print_int" *)
(*   external print_string : string -> unit = "ocaml_arduboy_print" *)
(*   external display : unit   -> unit = "ocaml_arduboy_display" *)
(* end;; *)


(* Arduboy.init ();; *)

(* let rec facto x = *)
(*   if x = 0 then 1 *)
(*   else *)
(*     (facto (x-1)) * x *)

(* (\* let rec facto x = *\) *)
(* (\*   let rec aux x acc =  *\) *)
(* (\*   if x = 0 then acc *\) *)
(* (\*   else *\) *)
(* (\*     aux (x-1) (x*acc) *\) *)
(* (\*   in *\) *)
(* (\*   aux x 1 *\) *)


(* let () = *)

(*   (\* for i = 0 to 1000 do  *\) *)
(*   (\*   (i,i)  *\) *)
(*   (\* done; *\) *)
(*   for i = 0 to 10 do *)
(*     Arduboy.print_int i; *)
(*     Arduboy.print_string "! = "; *)
(*     Arduboy.print_int (facto i); *)
(*     Arduboy.print_string "\n"; *)
(*     Arduboy.display(); *)
(*   done; *)

(* let _ = *)
  (* Arduboy.init() *)

(* let _ = () *)
  (* Arduboy.print_int 1; *)
  (* Arduboy.display(); *)
