(*************************************************************************)
(*                                                                       *)
(*                                OMicrob                                *)
(*                                                                       *)
(*                                                                       *)
(*    This file is distributed under the terms of the CeCILL license.    *)
(*    See file ../../LICENSE-en.                                         *)
(*                                                                       *)
(*************************************************************************)

open Avr

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
  digital_write PIN1 true;  (* D3 *)
  begin 
    try
        let i = ref 0 in
        while (!i) < 1 do
          ignore (solve 0);
          incr i;
        done;
        digital_write PIN2 true  (* D1 *)
    with
      | Stack_overflow -> digital_write PIN3 true  (* D0 *)
      | Out_of_memory ->  digital_write PIN3 true
      | _ ->   digital_write PIN3 true
  end
;;


let check() =
  let cpt = ref 0 in  
    Array.iter (fun v -> cpt := !cpt + v.(0).(0) + v.(0).(1) + v.(1).(0) + v.(1).(1))
                moves ;
    !cpt 
;;

let init_pins () = 
  pin_mode PIN1 OUTPUT;  digital_write PIN1 true;  (* D3 *)
  pin_mode PIN2 OUTPUT;  digital_write PIN2 true;  (* D1 *)
  pin_mode PIN3 OUTPUT;  digital_write PIN3 true;  (* D0 *)
  pin_mode PIN4 OUTPUT;  digital_write PIN4 true;  (* D4 *)
  pin_mode PIN5 OUTPUT;  digital_write PIN5 true;  (* C6 *)
  pin_mode PIN6 OUTPUT;  digital_write PIN6  true; (* D7 *)
  pin_mode PIN7 OUTPUT;  digital_write PIN7  true; (* ?? *)
  pin_mode PIN8 OUTPUT;  digital_write PIN8  true; (* B4 *) 
  pin_mode PIN9 OUTPUT;  digital_write PIN9  true; (* ?? *)
  digital_write PIN1 false;
  digital_write PIN2 false;
  digital_write PIN3 false;
  digital_write PIN4 false;
  digital_write PIN5 false;
  digital_write PIN6 false;
  digital_write PIN7 false;
  digital_write PIN8 false;
  digital_write PIN9 false;
  ()
;;
 
let _ = 
 init_pins(); 
 digital_write PIN5 true;  (* C6 *)
 main(); 
 digital_write PIN6 true;  (* D7 *)
 let r = check() in
   if r = 476 then  digital_write PIN4  true (* D4 *)
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

