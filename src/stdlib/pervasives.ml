type pin =
| PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
| PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
| PIN15 | PIN16 | PIN17

type mode =
| INPUT
| OUTPUT

external ( ~- ) : int -> int = "%negint"
external ( ~+ ) : int -> int = "%identity"
external succ : int -> int = "%succint"
external pred : int -> int = "%predint"
external ( + ) : int -> int -> int = "%addint"
external ( - ) : int -> int -> int = "%subint"
external ( * ) : int -> int -> int = "%mulint"
external ( / ) : int -> int -> int = "%divint"
external ( mod ) : int -> int -> int = "%modint"

external pin_mode      : pin -> mode -> unit = "caml_pin_mode"      [@@noalloc]

external digital_read  : pin -> bool         = "caml_digital_read"  [@@noalloc]
external digital_write : pin -> bool -> unit = "caml_digital_write" [@@noalloc]

external delay         : int -> unit         = "caml_delay"         [@@noalloc]
