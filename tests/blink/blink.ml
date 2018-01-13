(******************************************************************************)

(*
let fst t (x,y) = x

let blink pin small_time long_time =

  pin_mode pin OUTPUT;
  for i = 1 to 100 do
    let g = fst 8 in
    for _j = 1 to i do
      digital_write pin true;
      delay (small_time + g (1,2) );
      digital_write pin false;
      delay small_time;
    done;
    delay long_time;
  done
*)

(******************************************************************************)

module Array = struct
  external get : 'a array -> int -> 'a = "array_get"
  external set : 'a array -> int -> 'a -> unit = "array_set"
  external length : 'a array -> int = "array_length"
end

let sort (tbl : int array) =
  let len = Array.length tbl in
  for _i = 1 to len do
    for i = 0 to len - 2 do
      let a = tbl.(i) and b = tbl.(i + 1) in
      if a > b then (
        tbl.(i) <- b;
        tbl.(i + 1) <- a;
      )
    done
  done

let () =
  digital_write PIN13 false;
  let tbl = [| 1; 3; 5 |] in
  sort tbl;
  for i = 1 to 1000 do
    digital_write PIN13 (tbl.(i) = 0);
  done

(******************************************************************************)

(*
let () =
  blink PIN13 100 1000

type 'a ref = { mutable contents : 'a }

let ref x = { contents= x }

let (:=) a b =
  a.contents <- b

external (!) : 'a ref -> 'a =  "%field0"

let incr x = x := !x+1

let cpt =
  let cpt = ref 0 in
  fun () ->
    incr cpt;
    !cpt

let u = 42

let make_pair x = (x,x+u)
let fst (x,y) = x

let _ =
  digital_write PIN13 true;
  let k = ref 0 in
  for i = 0 to 1000 do
    let v =  make_pair i in
    k := fst v;
    delay !k
  done;
*)
    
(******************************************************************************)
    
(*
let blink () =
  pin_mode PIN13 OUTPUT;
  for i = 1 to 1000 do
    digital_write PIN13 true;
    delay 100;
    digital_write PIN13 false;
    delay 100;
  done

let _ =
  (* let x = millis () in *)
  blink ();
  (* let y = millis () - x in *)
  (* () *)
*)

(******************************************************************************)
    
