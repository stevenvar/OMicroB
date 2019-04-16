type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
         | PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
         | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21
         | PIN22 | PIN23 | PIN24 | PIN25 | PIN26 | PIN27 | PIN28
         | PIN29 | PIN30 | PIN31 | PIN32
         | MISO | SCK | MOSI | SS
         | PINA0 | PINA1 | PINA2 | PINA3 | PINA4 | PINA5 | PINA6
         | PINA7 | PINA8 | PINA9 | PINA10 | PINA11 | PINA12

(** Pin modes *)
type mode = INPUT | OUTPUT | INPUT_PULLUP

(** Read and write levels (HIGH = 5v, LOW = 0v) *)
type level = LOW | HIGH

external pin_mode: pin -> mode -> unit = "caml_pic32_pin_mode" [@@noalloc]
external digital_write: pin -> level -> unit = "caml_pic32_digital_write" [@@noalloc]
external digital_read: pin -> level = "caml_pic32_digital_read" [@@noalloc]
val analog_write: pin -> int -> unit
val analog_read: pin -> int

external delay: int -> unit = "caml_pic32_delay" [@@noalloc]
external millis: unit -> int = "caml_pic32_millis" [@@noalloc]

external _init: unit -> unit = "caml_pic32_init" [@@noalloc]
external schedule_task: unit -> unit = "caml_pic32_schedule_task" [@@noalloc]

module Serial: sig
  val init: unit -> unit
  val write: string -> unit
  val read: unit -> string
end

module MCUConnection: Circuits.MCUConnection with type pin = pin with type mode = mode with type level = level
