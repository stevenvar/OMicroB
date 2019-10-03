(* type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
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
external lchip_digital_write_lled: level -> unit = "caml_lchip_digital_write_lled" [@@noalloc]
external lchip_digital_write_rled: level -> unit = "caml_lchip_digital_write_rled" [@@noalloc]
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

module MCUConnection: Circuits.MCUConnection with type pin = pin with type mode = mode with type level = level *)


type bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7  
         | B8 | B9 | B10 | B11 | B12 | B13 | B14 | B15 
         | B16 | B17 | B18 | B19 | B20 | B21 | B22 | B23 
         | B24 | B25 | B26 | B27 | B28 | B29 | B30 | B31

type register = TRISA | TRISB | TRISC | TRISD | TRISE | TRISF | TRISG
              | LATA | LATB | LATC | LATD | LATE | LATF | LATG
              | PORTA | PORTB | PORTC | PORTD | PORTE | PORTF | PORTG

type mode = INPUT | OUTPUT

type level = HIGH | LOW

external write_register : register -> int -> unit = "caml_pic32_write_register" [@@noalloc]
external read_register : register -> int = "caml_pic32_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_pic32_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_pic32_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_pic32_read_bit" [@@noalloc]
external delay : int -> unit = "caml_pic32_delay" [@@noalloc]
external millis : unit -> int = "caml_pic32_millis" [@@noalloc]


module FubarinoMiniPins: sig
  type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
           | PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
           | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21
           | PIN22 | PIN23 | PIN24 | PIN25 | PIN26 | PIN27 | PIN28
           | PIN29 | PIN30 | PIN31 | PIN32
         
  val port_of_pin: pin -> register
  val lat_of_pin: pin -> register
  val tris_of_pin: pin -> register
  val bit_of_pin: pin -> bit
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  module MCUConnection: Circuits.MCUConnection
    with type pin = pin
    with type mode = mode
    with type level = level
end


module LchipPins: sig
  type pin = PIN1 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7 | PIN8 | PIN9 | PIN10 | PIN11
           | PIN12 | PIN14 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21 | PIN22 | PIN23 
           | PIN24 | PIN25 | PIN26 | PIN27 | PIN28 | PIN29 | PIN32 | PIN33 | PIN34
           | PIN35 | PIN38 | PIN39 | PIN40 | PIN41 | PIN42 | PIN43 | PIN44 | PIN47
           | PIN48 | PIN49 | PIN50 | PIN51 | PIN52 | PIN53 | PIN56 | PIN57 | PIN58
           | PIN59 | PIN60 | PIN61 | PIN63 | PIN64 | PIN66 | PIN67 | PIN68 | PIN69
           | PIN70 | PIN71 | PIN72 | PIN73 | PIN74 | PIN76 | PIN77 | PIN78 | PIN79
           | PIN80 | PIN81 | PIN82 | PIN83 | PIN84 | PIN87 | PIN88 | PIN89 | PIN90
           | PIN91 | PIN92 | PIN93 | PIN94 | PIN95 | PIN96 | PIN97 | PIN98 | PIN99
           | PIN100
  val port_of_pin: pin -> register
  val lat_of_pin: pin -> register
  val tris_of_pin: pin -> register
  val bit_of_pin: pin -> bit
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  module MCUConnection: Circuits.MCUConnection
    with type pin = pin
    with type mode = mode
    with type level = level
end