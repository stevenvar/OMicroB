type pin =
| PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
| PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13

type mode =
| INPUT
| OUTPUT

external pin_mode      : pin -> mode -> unit = "caml_pin_mode"      [@@noalloc]

external digital_read  : pin -> bool         = "caml_digital_read"  [@@noalloc]
external digital_write : pin -> bool -> unit = "caml_digital_write" [@@noalloc]

external delay         : int -> unit         = "caml_delay"         [@@noalloc]
