type pin =
    PIN0
  | PIN1
  | PIN2
  | PIN3
  | PIN4
  | PIN5
  | PIN6
  | PIN7
  | PIN8
  | PIN9
  | PIN10
  | PIN11
  | PIN12
  | PIN13
  | PIN14
  | PIN15
  | PIN16
  | PIN17
type mode = INPUT | OUTPUT
type picReg = PORTB | TRISB
type picPin = RB1 | RB2 | RB3 | RB4
external not : bool -> bool = "%boolnot"
external ( & ) : bool -> bool -> bool = "%sequand"
external ( && ) : bool -> bool -> bool = "%sequand"
external ( or ) : bool -> bool -> bool = "%sequor"
external ( || ) : bool -> bool -> bool = "%sequor"
external ( ~- ) : int -> int = "%negint"
external ( ~+ ) : int -> int = "%identity"
external succ : int -> int = "%succint"
external pred : int -> int = "%predint"
external ( + ) : int -> int -> int = "%addint"
external ( - ) : int -> int -> int = "%subint"
external ( * ) : int -> int -> int = "%mulint"
external ( / ) : int -> int -> int = "%divint"
external ( mod ) : int -> int -> int = "%modint"
external ( = ) : 'a -> 'a -> bool = "%equal"
external ( <> ) : 'a -> 'a -> bool = "%notequal"
external ( < ) : 'a -> 'a -> bool = "%lessthan"
external ( > ) : 'a -> 'a -> bool = "%greaterthan"
external ( <= ) : 'a -> 'a -> bool = "%lessequal"
external ( >= ) : 'a -> 'a -> bool = "%greaterequal"
external compare : 'a -> 'a -> int = "%compare"
type 'a ref = { mutable contents : 'a; }
external ref : 'a -> 'a ref = "%makemutable"
external ( ! ) : 'a ref -> 'a = "%field0"
external ( := ) : 'a ref -> 'a -> unit = "%setfield0"
external incr : int ref -> unit = "%incr"
external decr : int ref -> unit = "%decr"
external print_string : int -> unit = "caml_print_string"
external print_int : int -> unit = "caml_print_int"
external write_reg : picReg -> int -> unit = "caml_write_reg"
external set_bit : picPin -> unit = "caml_set_bit"
external clear_bit : picPin -> unit = "caml_clear_bit"
external pin_mode : pin -> mode -> unit = "caml_pin_mode" [@@noalloc]
external digital_read : pin -> bool = "caml_digital_read" [@@noalloc]
external digital_write : pin -> bool -> unit = "caml_digital_write"
  [@@noalloc]
external delay : int -> unit = "caml_delay" [@@noalloc]
external millis : unit -> int = "ocaml_arduino_millis" [@@noalloc]
external serial_begin : int -> unit = "ocaml_arduino_serial_begin"
  [@@noalloc]
external raise : exn -> 'a = "%raise"
val ( @ ) : 'a list -> 'a list -> 'a list
