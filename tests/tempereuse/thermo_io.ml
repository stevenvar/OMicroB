(* déclaration de l'écran *)

module%comp LCD = Circuits.MakeLCD(struct
    let rsPin = PIN11
    let enablePin = PIN12
    let d4Pin = PIN2
    let d5Pin = PIN3
    let d6Pin = PIN4
    let d7Pin = PIN5
  end)

(* déclaration des pins *)
let plus = PIN7
let minus = PIN6
let resistor = PIN10
let sensor = PINA0

(* conversion de température *)
let convert_temp t =
  let f = (float_of_int (1033 - t) /. 11.67) in
  int_of_float (f*.100.)

(* lecture de la température *)
let read_temp () =
  let t = analog_read sensor in
  Serial.write_string "an=";
  Serial.write_int t;
  convert_temp t

(* Affichage des températures sur l'écran LCD *)
let print_temp wanted real =
  let split_temp t =
    let u = t/10 in
    let dec = t mod 10 in
    (u,dec) in
  (* LCD.clear_screen (); *)
  let (wu,wd) = split_temp wanted in
  let (ru,rd) = split_temp real in
  LCD.clear_screen ();
  LCD.print_string "Wanted T :";
  LCD.print_string ((string_of_int wu)^"."^(string_of_int wd));
  LCD.print_newline ();
  LCD.print_string "Actual T :";
  LCD.print_string ((string_of_int ru)^"."^(string_of_int rd));
  delay 200

(*** Fonctions d'entrées/sorties de l'instant synchrone  ***)

(** fonction d'initialisation **)
let init_thermo () =
  (* initialisation de l'affichage *)
  LCD.init ();
  (* initialisation des broches *)
  pin_mode sensor INPUT;
  pin_mode resistor OUTPUT;
  pin_mode plus INPUT;
  pin_mode minus INPUT

let bool_of_level = function
  | HIGH -> true
  | LOW -> false

(** fonction d'entrée **)
let input_thermo () =
  let plus = digital_read plus in
  let minus = digital_read minus in
  let plus = bool_of_level plus in
  let minus = bool_of_level minus in
  let real_temp = read_temp () in
  (plus,minus,real_temp)

(** fonction de sortie **)
let output_thermo (on,wanted,real,res) =
  if on then
    begin
      print_temp wanted real;
      digital_write resistor (if res then HIGH else LOW)
    end
  else
    begin
      LCD.clear_screen ();
      LCD.print_string "..."
    end;
