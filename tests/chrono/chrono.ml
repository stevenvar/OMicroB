(*************************************************************************)
(*                                                                       *)
(*                                OCaPIC                                 *)
(*                                                                       *)
(*                             Benoit Vaugon                             *)
(*                                                                       *)
(*    This file is distributed under the terms of the CeCILL license.    *)
(*    See file ../../LICENSE-en.                                         *)
(*                                                                       *)
(*************************************************************************)

(* Configuration de la connection PIC/Afficheur LCD *)
module%comp Disp = Circuits.MakeLCD(struct
    let rsPin = PIN11
    let enablePin = PIN12
    let d4Pin = PIN2
    let d5Pin = PIN3
    let d6Pin = PIN4
    let d7Pin = PIN5
  end)

let button = PIN6
let buttonp = PIN7
let buttonm = PIN8
let led = PIN9

(* Compteur (reference sur un Int32) *)
let counter = ref 0l

(* Utilitaire pour l'affichage *)
let print_02d n =
  if n < 10 then Disp.print_string "0";
  Disp.print_int n

(* Affiche la valeur du compteur *)
let print () =
  let t = !counter in
  let t60 = Int32.div t 60l in
  let s = Int32.to_int (Int32.rem t 60l) in
  let m = Int32.to_int (Int32.rem t60 60l) in
  let h = Int32.to_int (Int32.div t60 60l) in
  Disp.clear_screen ();
  print_02d h;
  Disp.print_string ":";
  print_02d m;
  Disp.print_string ":";
  print_02d s

(* Utilitaires de gestion des overflow *)
let is_null () = !counter <= 0l and is_full () = !counter >= 359999l

(* Incremente le compteur de n *)
let incr n =
  counter := Int32.add !counter (Int32.of_int n);
  if is_full () then counter := 359999l

(* Decremente le compteur de n *)
let decr n =
  counter := Int32.sub !counter (Int32.of_int n);
  if is_null () then counter := 0l

(* Incremente/Decremente le compteur de 1 *)
let decr1 () =
  if not (is_null ()) then counter := Int32.pred !counter

let incr1 () =
  if not (is_full ()) then counter := Int32.succ !counter

(* Fonction d'acceleration pour le reglage du temps *)
let step n = n / 32 * n / 16 * n + n / 16 * n / 16 + n / 8 + 1

let test_pin p =
  match (digital_read p) with
  | LOW -> false
  | HIGH -> true

(* Petite machine a etat *)
let rec run n =
  if is_null () || test_pin button then stop ()
  else if test_pin buttonp then ( incr_start () ; run 0 )
  else if test_pin buttonm then ( decr_start () ; run 0 )
  else if n = 79 then ( delay 7 ; decr1 () ; print () ; run 0 )
  else ( delay 10 ; run (succ n) )
and pause () =
  delay 10;
  if test_pin button && not (is_null ()) then start ()
  else if test_pin buttonp then ( incr_start () ; pause () )
  else if test_pin buttonm then ( decr_start () ; pause () )
  else pause ();
and start () =
  digital_write led HIGH;
  delay 10;
  if test_pin button then start () else run 0;
and stop () =
  digital_write led LOW;
  delay 10;
  if test_pin button then stop () else pause ();
and incr_start () =
  incr1 ();
  print ();
  delay 300;
  incr_loop 1;
and decr_start () =
  decr1 ();
  print ();
  delay 300;
  decr_loop 1;
and incr_loop n =
  if test_pin buttonp then (
    incr (step n);
    print ();
    delay 100;
    if not (is_full ()) then incr_loop (succ n);
  )
and decr_loop n =
  if test_pin buttonm then (
    decr (step n);
    print ();
    delay 100;
    if not (is_null ()) then decr_loop (succ n);
  )

let _ =
  Disp.init ();
  pin_mode button INPUT;
  pin_mode buttonp INPUT;
  pin_mode buttonm INPUT;
  pin_mode led OUTPUT;
  print ();                   (* Affichage de 00:00:00 *)
  stop ();                    (* Point d'entree de la machine a etat *)
