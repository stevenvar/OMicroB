





external write_register : 'a register -> int -> unit = "caml_pic32_write_register" [@@noalloc]
external read_register : 'a register -> int = "caml_pic32_read_register" [@@noalloc]
external set_bit : 'a register -> 'a -> unit = "caml_pic32_set_bit" [@@noalloc]
external clear_bit : 'a register -> 'a -> unit = "caml_pic32_clear_bit" [@@noalloc]
external read_bit : 'a register -> 'a -> bool = "caml_pic32_read_bit" [@@noalloc]

let pin_mode p m =
  let tris = tris_of_pin p in 
  let bit = tris_bit_of_pin p in
  match m with
    | OUTPUT -> clear_bit tris bit
    | INPUT -> set_bit tris bit

let digital_write p l = 
  let lat = lat_of_pin p in 
  let bit = lat_bit_of_pin p in
  match l with
    | HIGH -> set_bit lat bit
    | LOW -> clear_bit lat bit

let digital_read p =
  let port = port_of_pin p in 
  let bit = port_bit_of_pin p in 
  match read_bit port bit with
  | true -> HIGH
  | false -> LOW
