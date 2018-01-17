(*************************************************************************)
(*                                                                       *)
(*                                OMicrob                                *)
(*                                                                       *)
(*                                                                       *)
(*    This file is distributed under the terms of the CeCILL license.    *)
(*    See file ../../LICENSE-en.                                         *)
(*                                                                       *)
(*************************************************************************)


let ignore x = () ;;


type peg = Out | Empty | Peg ;;

exception Found;;

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

let moves = Array.make 31 ([||] : int array array);;

let dir = [| [|0;1|]; [|1;0|];[|0;0-1|];[|0-1;0|] |];;

let counter = ref 0


let rec solve m = 
    incr counter;
    if m = 31 then (
      match board.(4).(4) with
        | Peg -> true
        | _ -> false
    ) 
    else 
    try 
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

let main () = 

begin try
        let i = ref 0 in
        while (!i) < 1 do
          ignore (solve 0);
          incr i;
        done;
  with
    | Stack_overflow -> print_string "Stack overflow"
    | Out_of_memory -> print_string "Out of memry"
    | _ -> print_string "OK"
(*
set_bit PORTB PB1
*)
end;;


let check() =
  let cpt = ref 0 in  
  Array.iter (fun v -> cpt := !cpt + v.(0).(0) + v.(0).(1) + v.(1).(0) + v.(1).(1))
              moves ;
  !cpt ;;

let _ = 
 print_string "debut" ;
 main(); 
 print_string "fin calcul";
 let r = check() in 
  print_int r ;  if r = 476 then( print_newline(); print_int r ; print_newline());;

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

(*
let () =
(*  pin_mode PIN8 OUTPUT; *)
  (* write_register DDRB 0xFF; *)
  (* write_register PORTB 0xAB; *)
(*  digital_write PIN8 true*)

  (* set_bit PORTB PB3; *)
  (* if (read_bit PORTB PB3) then *)
  (* set_bit PORTB PB4; *)
  (* clear_bit PORTB PB3; *)

  (* clear_bit PORTB PB3; *)
*)

