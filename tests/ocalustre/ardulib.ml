(* open Avr *)

(* Generated code *)
let rising_edge in_f =
  let st__aux_1 = ref false  in
  let rising_edge_step in_f =
    let _aux_1 = !st__aux_1  in
    let out_f = in_f && (not _aux_1)  in st__aux_1 := in_f; out_f  in
  rising_edge_step 
let button_led button_pinin =
  let st_led_pinout = ref false  in
  let rising_edge1_step = rising_edge button_pinin  in
  let button_led_step button_pinin =
    let button_pressed = rising_edge1_step button_pinin  in
    let led_pinout = !st_led_pinout  in
    st_led_pinout := (if button_pressed then not led_pinout else led_pinout);
    led_pinout  in
  button_led_step
(* . *)

(* let bool_of_level = function
 *   | LOW -> false
 *   | HIGH -> true
 * 
 * let level_of_bool = function
 *   | false -> LOW
 *   | true -> HIGH *)

let () =
  (* let r = PIN9 in *)
  (* pin_mode r OUTPUT; *)
  (* let button = PIN7 in *)
  let bl = button_led false in
  for i = 0 to 10 do
    (* let bval = digital_read button in *)
    ignore (bl true)
    (* digital_write r (level_of_bool rv) *)
  done
  
