open Pic32

(** Monte Carlo *)

let r = 10 (** circle radius *)
let n = 30 (** number of points *)

let points () =
  let rec loop n acc =
    match n with
    |0 -> acc
    |n -> loop (n - 1) ((Random.int r, Random.int r)::acc)
  in loop n []

let list_in_circle l =
  List.filter (fun (x,y) -> x*x + y*y <= r*r) l

let approximation_pi () =
  4. *. (float_of_int (List.length (list_in_circle (points ())))) /. (float_of_int n)

let pi = approximation_pi ()

let calcul () =
  pi > 3. && pi < 4.

let _ =
  _init ();
  schedule_task ();
  pin_mode PIN1 OUTPUT;
  digital_write PIN1 (if calcul () then HIGH else LOW)
