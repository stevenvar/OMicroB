module Array = struct 
  external length : 'a array -> int = "%array_length"
  external get: 'a array -> int -> 'a = "%array_safe_get"
  external set: 'a array -> int -> 'a -> unit = "%array_safe_set"
  external create: int -> 'a -> 'a array = "caml_make_vect"
end;;

module Arduboy = struct
  external init    : unit   -> unit = "ocaml_arduboy_init"
  external print_int : int -> unit = "ocaml_arduboy_print_int"
  external print_string : string -> unit = "ocaml_arduboy_print"
  external display : unit   -> unit = "ocaml_arduboy_display"
end;;

open Arduboy;;

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


let incr x = x:=!x+1;;
let print_endline s = print_string s;print_string "\n";;

type peg = Out | Empty | Peg;;

print_string "board";;print_string "\n" ;;
let board = [|
 [| Out; Out; Out; Out; Out; Out; Out; Out; Out|];
 [| Out; Out; Out; Peg; Peg; Peg; Out; Out; Out|];
 [| Out; Out; Out; Peg; Peg; Peg; Out; Out; Out|];
 [| Out; Peg; Peg; Peg; Peg; Peg; Peg; Peg; Out|];
 [| Out; Peg; Peg; Peg; Empty; Peg; Peg; Peg; Out|];
 [| Out; Peg; Peg; Peg; Peg; Peg; Peg; Peg; Out|];
 [| Out; Out; Out; Peg; Peg; Peg; Out; Out; Out|];
 [| Out; Out; Out; Peg; Peg; Peg; Out; Out; Out|];
 [| Out; Out; Out; Out; Out; Out; Out; Out; Out|]
|]
;;
print_string "apres board ";;print_string "\n";;
(*let moves = make_vect 31 ([||] : int vect vect);;*)
let moves = Array.create 31 ([||] : int array array);;

let dir = [| [|0;1|]; [|1;0|];[|0;-1|];[|-1;0|] |];;

let counter = ref 0;;

exception Found;;

let rec solve m =

  incr counter;
  if m = 31 then
    begin match board.(4).(4) with Peg -> true | _ -> false end
  else
    try
      if !counter mod 500 = 0 then begin
        print_int !counter; print_string "\n"
      end;
      for i=1 to 7 do
      for j=1 to 7 do
        match board.(i).(j) with
          Peg ->
            for k=0 to 3 do
              let d1 = dir.(k).(0) in
              let d2 = dir.(k).(1) in
              let i1 = i+d1 in
              let i2 = i1+d1 in
              let j1 = j+d2 in
              let j2 = j1+d2 in
              match board.(i1).(j1) with
                Peg ->
                  begin match board.(i2).(j2) with
                    Empty ->
                      board.(i).(j) <- Empty;
                      board.(i1).(j1) <- Empty;
                      board.(i2).(j2) <- Peg;
                      if solve(m+1) then begin
                        moves.(m) <- [| [| i; j |]; [| i2; j2 |] |];
                        raise Found
                      end;
                      board.(i).(j) <- Peg;
                      board.(i1).(j1) <- Peg;
                      board.(i2).(j2) <- Empty;
                      ()
                    | _ -> ()
                  end
              | _ -> ()
            done
        | _ -> ()
      done
      done;
      false
    with Found ->
      true
;;

let print_peg = function
    Out -> print_string "."
  | Empty -> print_string " "
  | Peg -> print_string "$"
;;

let print_board board =
 for i=0 to 8 do
 for j=0 to 8 do
    print_peg board.(i).(j)
 done;
 print_string "\n"
 done
;;

(*
.........
...   ...
...   ...
.       .
.   $   .
.       .
...   ...
...   ...
.........
*)


let () =
  
  for i = 1 to 5 do
    if solve 0 then (print_string "\n"; print_board board)
    else print_endline "Pas trouve"
  done;

  (* Arduboy.init(); *)

  Arduboy.display();
