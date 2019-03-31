type pin = A0 | A1 | A2 | A3 | A4 | A5 | A6 | A7 | A8 | A9 | A10 | A11 | A12

type mode = INPUT | OUTPUT | INPUT_PULLUP

type level = LOW | HIGH

external init: unit -> unit = "caml_pic32_init" [@@noalloc]
external schedule_task: unit -> unit = "caml_pic32_schedule_task" [@@noalloc]
external pin_mode: pin -> mode -> unit = "caml_pic32_pin_mode" [@@noalloc]
external digital_write: pin -> level -> unit = "caml_pic32_digital_write" [@@noalloc]
external digital_read: pin -> level = "caml_pic32_digital_read" [@@noalloc]
external analog_write: pin -> int -> unit = "caml_pic32_analog_write" [@@noalloc]
external analog_read: pin -> int = "caml_pic32_analog_read" [@@noalloc]

external delay: int -> unit = "caml_pic32_delay" [@@noalloc]
external millis: unit -> int = "caml_pic32_millis" [@@noalloc]
