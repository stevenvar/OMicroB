external init : int -> unit  = "caml_random_init"
external bits : int -> int   = "caml_random_bits"
external bool : unit -> bool = "caml_random_bool"    

let int bound =
  if bound <= 0 then raise (Invalid_argument "Random.int");
  bits bound

let bits () =
  bits 0x3FFF_FFFF
