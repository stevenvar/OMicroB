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

let dir = [| [|0;1|]; [|1;0|];[|0;0-1|];[|0-1;0|] |];;

let counter = ref 0

let rec solve =
  fun board m  ->
    incr counter;
    if m = 31 then (
      match Array.get (Array.get board 4) 4 with
        | Peg -> true
        | _ -> false
    ) else (
      try (
        (if ((!counter) mod 50) = 0 then
            ()
        );
        (let i = ref 1 in
         while (!i) <= 7 do (
           let j = ref 1 in
           while (!j) <= 7 do (
             match Array.get (Array.get board (!i)) (!j) with
               | Peg ->
                 let k = ref 0 in
                 while (!k) <= 3 do (
                   let d1 = (Array.get (Array.get dir (!k)) 0) in
                   let d2 = (Array.get (Array.get dir (!k)) 1) in
                   let i1 = ((!i)+d1) in
                   let i2 = (i1+d1) in
                   let j1 = ((!j)+d2) in
                   let j2 = (j1+d2) in
                   match Array.get (Array.get board i1) j1 with
                     | Peg ->
                       (match Array.get (Array.get board (i2)) j2 with
                         | Empty -> (
                           Array.set (Array.get board (!i)) (!j) Empty;
                           Array.set (Array.get board i1) j1 Empty;
                           Array.set (Array.get board i2) j2 Peg;
                           (if solve board (m+1) then (
                             raise Found
                            ));
                           Array.set (Array.get board (!i)) (!j) Peg;
                           Array.set (Array.get board i1) j1 Peg;
                           Array.set (Array.get board i2) j2 Empty)
                         | _ -> ())
                     | _ -> ());
                   incr k
                 done
               | _ -> ());
             incr j
           done);
           incr i
         done);
        false
      ) with
        | Found -> true)
;;

let main () = 

begin try
        (pin_mode PIN1 OUTPUT;  digital_write PIN1 true);
        (pin_mode PIN2 OUTPUT;  digital_write PIN2 true);
        (pin_mode PIN3 OUTPUT;  digital_write PIN3 true);
        (pin_mode PIN4 OUTPUT;  digital_write PIN4 true);
        (pin_mode PIN5 OUTPUT;  digital_write PIN5 true);
        (pin_mode PIN6 OUTPUT;  digital_write PIN6  true);
        (pin_mode PIN7 OUTPUT;  digital_write PIN7  true);
        (pin_mode PIN8 OUTPUT;  digital_write PIN8  true);
         digital_write PIN1 false;
         digital_write PIN2 false;
         digital_write PIN3 false;
         digital_write PIN4 false;
         digital_write PIN5 false;
         digital_write PIN6 false;
         digital_write PIN7 false;
         digital_write PIN8 false;
         digital_write PIN1 true;
        let i = ref 0 in
        while (!i) < 1 do
          let board = [|
            [| Out; Out; Out; Out;  Out ; Out; Out; Out; Out|];
            [| Out; Out; Out; Peg;  Peg ; Peg; Out; Out; Out|];
            [| Out; Out; Out; Peg;  Peg ; Peg; Out; Out; Out|];
            [| Out; Peg; Peg; Peg;  Peg ; Peg; Peg; Peg; Out|];
            [| Out; Peg; Peg; Peg; Empty; Peg; Peg; Peg; Out|];
            [| Out; Peg; Peg; Peg;  Peg ; Peg; Peg; Peg; Out|];
            [| Out; Out; Out; Peg;  Peg ; Peg; Out; Out; Out|];
            [| Out; Out; Out; Peg;  Peg ; Peg; Out; Out; Out|];
            [| Out; Out; Out; Out;  Out ; Out; Out; Out; Out|];
          |] in
          ignore (solve board 0);
          incr i;
        done;
        digital_write PIN2 true
  with
    | Stack_overflow -> (pin_mode PIN5 OUTPUT;  digital_write PIN5 true)
    | Out_of_memory -> (pin_mode PIN6 OUTPUT;  digital_write PIN6 true)
    | _ -> (pin_mode PIN7 OUTPUT;  digital_write PIN7 true)
(*
set_bit PORTB PB1
*)
end;;

let _ = 
 pin_mode PIN9 OUTPUT;
 digital_write PIN9 true;
 main(); 
 pin_mode PIN10 OUTPUT;  
 digital_write PIN10 true;;

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

