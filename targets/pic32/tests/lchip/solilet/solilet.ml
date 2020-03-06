(*************************************************************************)
(*                                                                       *)
(*                                OMicrob                                *)
(*                                                                       *)
(*                                                                       *)
(*    This file is distributed under the terms of the CeCILL license.    *)
(*    See file ../../LICENSE-en.                                         *)
(*                                                                       *)
(*************************************************************************)

open Pic32

let ignore x = () ;;


type peg = Out | Empty | Peg ;;

exception Found;;

let toggleGreen n =
    for i = 1 to n do
      digital_write PIN82 HIGH;
      delay 500;
      digital_write PIN82 LOW;
      delay 500;
    done
;;

let toggleRed n =
    for i = 1 to n do
      digital_write PIN78 HIGH;
      delay 500;
      digital_write PIN78 LOW;
      delay 500;
    done
;; 


 let set_pin_analog pin =
  match pin with
    | PIN25 -> clear_bit_adc AD1PCFG PCFG0
    | PIN24 -> clear_bit_adc AD1PCFG PCFG1
    | PIN23 -> clear_bit_adc AD1PCFG PCFG2
    | PIN22 -> clear_bit_adc AD1PCFG PCFG3
    | PIN21 -> clear_bit_adc AD1PCFG PCFG4
    | PIN20 -> clear_bit_adc AD1PCFG PCFG5
    | PIN26 -> clear_bit_adc AD1PCFG PCFG6
    | PIN27 -> clear_bit_adc AD1PCFG PCFG7
    | PIN32 -> clear_bit_adc AD1PCFG PCFG8
    | PIN33 -> clear_bit_adc AD1PCFG PCFG9
    | PIN34 -> clear_bit_adc AD1PCFG PCFG10
    | PIN35 -> clear_bit_adc AD1PCFG PCFG11
    | PIN41 -> clear_bit_adc AD1PCFG PCFG12
    | PIN42 -> clear_bit_adc AD1PCFG PCFG13
    | PIN43 -> clear_bit_adc AD1PCFG PCFG14
    | PIN44 -> clear_bit_adc AD1PCFG PCFG15
;;

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
    (* incr counter;
    toggleRed (m+1);
    delay 4000; *)
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
                        raise Found;
                       (* toggleGreen 5 *)

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

(*
let main () = 
  digital_write PIN1 LOW;  (* D3 *)
  begin 
    try
        let i = ref 0 in
        while (!i) < 1 do
          ignore (solve 0);
          incr i;
        done;
        digital_write PIN2 LOW  (* D1 *)
    with
      | Stack_overflow -> digital_write PIN3 LOW  (* D0 *)
      | Out_of_memory ->  digital_write PIN3 LOW
      | _ ->   digital_write PIN3 LOW
  end
;;
*)

let check() =
  let cpt = ref 0 in  
    Array.iter (fun v -> cpt := !cpt + v.(0).(0) + v.(0).(1) + v.(1).(0) + v.(1).(1))
                moves ;
    !cpt 
;;

let init () =
  (* Initialisation du system et des interruptions *)
  init_system ();
  init_interrupts 0;

  (* Configuration du module ADC *)
  close_adc10 ();
  set_chan_adc10 CH0NA_0;
  set_pin_analog PIN25;
  set_pin_analog PIN24;
  set_pin_analog PIN21;

  ad1cssl_set [CSSL_0; CSSL_1; CSSL_4];
  ad1con3_set [ADRC_; SAMC_15];
  ad1con2_set [CSCNA_; SMPI_2];
  ad1con1_set [ON_; FORM_0; SSRC_7; ASAM_];



  enable_adc10 ();
  wait_int_flag_ad1 ();

  (* Initialisation du module UART 1 *)

  let u = UART1 in 
  let u1mode = umode_of_uart u in
    let brgh = brgh_bit_of_uart u in
      clear_bit_uart u1mode brgh;
    let ubrg = ubrg_of_uart u in 
      write_register_uart ubrg 9600;

    let stsel = stsel_bit_of_uart u in
      clear_bit_uart u1mode stsel ;
    let pdsel1 = pdsel_bit1_of_uart u in
    let pdsel2 = pdsel_bit2_of_uart u in
      clear_bit_uart u1mode pdsel1; 
      clear_bit_uart u1mode pdsel2;
  
  let u1sta = usta_of_uart u in 
    let utxen = utxen_bit_of_uart u in 
    let urxen = urxen_bit_of_uart u in 
      set_bit_uart u1sta utxen;
      set_bit_uart u1sta urxen;
  
  let on = on_bit_of_uart u in 
    set_bit_uart u1mode on;


  pin_mode PIN82 OUTPUT;  digital_write PIN82  LOW; (* VERT *)
  pin_mode PIN78 OUTPUT;  digital_write PIN78  LOW; (* ROUGE *) 

  digital_write PIN82 HIGH;
  digital_write PIN78 HIGH;

  ()
;;




 
let _ = 
 init ();  

 (* let r = check() in
    if r = 476 then  digital_write PIN82 LOW else  () (* digital_write PIN4  LOW (* D4 *) *)
; *)

let u = UART1 in
let u1sta = usta_of_uart u in 
  let readadc = read_adc10 2 in

    let an_pic1_min = 697.5 in
    let an_pic1_max = 852.5 in
    let an_pic2_min = 930.0 in
    let an_pic2_max = 1136.666666667 in
    let cond1 u = an_pic1_min <= u && u <= an_pic1_max in
    let cond2 u = an_pic2_min <= u && u <= an_pic2_max in
    let convvalue = float_of_int readadc in
    let pic_id () = 
      if cond1 convvalue == true
      then 1
      else if cond2 convvalue == true
      then 2
      else 0
    in
    if pic_id () == 0 
    then   
    ( if solve 0 then digital_write PIN82 LOW else toggleGreen 2;
    delay 2000;
      let r = check() in
        if r == 476 then toggleGreen 3 else toggleGreen 4;
        delay 1000;

      let u1txreg = utxreg_of_uart u in        
        let utxbf = utxbf_bit_of_uart u in
        while (read_bit_uart u1sta utxbf) do () done;
        write_register_uart u1txreg r;
        toggleGreen 5;
   
      let urxda = urxda_bit_of_uart u in 
        while (not (read_bit_uart u1sta urxda)) do () done;

        let u1rxreg = urxreg_of_uart u in 
          if ((read_register_uart u1rxreg) == 220)
          (* then 
            toggleRed 5
          else 
            digital_write PIN78 LOW *)
            then 
              digital_write PIN78 LOW
            else 
              toggleRed 5
    )
      else if pic_id () == 1 
      then 
      ( if solve 0 then digital_write PIN78 LOW else toggleRed 2;
      delay 2000;
        let r = check() in
        if r == 476 then toggleRed 3 else toggleRed 4;
        delay 1000;
        let u1txreg = utxreg_of_uart u in        
        let utxbf = utxbf_bit_of_uart u in
        while (read_bit_uart u1sta utxbf) do () done;
        write_register_uart u1txreg r;
        toggleRed 5;
   
      let urxda = urxda_bit_of_uart u in 
        while (not (read_bit_uart u1sta urxda)) do () done;
        let u1rxreg = urxreg_of_uart u in 
          if ((read_register_uart u1rxreg) == 220)
            (* then 
              toggleGreen 5
            else 
              digital_write PIN82 LOW *)
            then 
              digital_write PIN82 LOW
            else 
              toggleGreen 5 

      )

(* urxda_bit_of_uart u in 
        while (not (read_bit_uart u1sta urxda)) do () done;
        let u1rxreg = urxreg_of_uart u in 
          if ((read_register_uart u1rxreg) == 476)
            then 
              digital_write PIN82 LOW
            else 
              toggleGreen 5 *)


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

