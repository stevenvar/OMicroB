(*******************************************************************************)
(*                                                                             *)
(*                  Generic avr pin communication library                      *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

(** Digital and anologue communication pins *)
type bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7
type register = PORTA | PORTB | PORTC | PORTD | PORTE | PORTF
              | PORTG | PORTH | PORTJ | PORTK | PORTL
              | DDRA | DDRB | DDRC | DDRD | DDRE | DDRF
              | DDRG | DDRH | DDRJ | DDRK | DDRL
              | PINA | PINB | PINC | PIND | PINE | PINF
              | PING | PINH | PINJ | PINK | PINL
              | SPCR | SPSR | SPDR

(** Pin modes *)
type mode = INPUT | OUTPUT | INPUT_PULLUP

(** Read and write levels (HIGH = 5v, LOW = 0v) *)
type level = HIGH | LOW

external write_register : register -> int -> unit = "caml_avr_write_register" [@@noalloc]
external read_register : register -> int = "caml_avr_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_avr_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_avr_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_avr_read_bit" [@@noalloc]
external delay : int -> unit = "caml_avr_delay" [@@noalloc]
external millis : unit -> int = "caml_avr_millis" [@@noalloc]

(** Pin layout of the Arduboy *)
module ArduboyPins: sig
  type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7 | PIN8
           | PIN9 | PIN10 | PIN11 | PIN12 | PIN13
           | MISO | SCK | MOSI | SS
           | PINA0 | PINA1 | PINA2 | PINA3 | PINA4 | PINA5
  val port_of_pin: pin -> register
  val ddr_of_pin: pin -> register
  val input_of_pin: pin -> register
  val bit_of_pin: pin -> bit
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  module MCUConnection: Circuits.MCUConnection
    with type pin = pin
    with type mode = mode
    with type level = level
end

(** Pin layout of the Arduino Mega 2560 *)
module ArduinoMegaPins: sig
  type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
           | PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
           | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21
           | PIN22 | PIN23 | PIN24 | PIN25 | PIN26 | PIN27 | PIN28
           | PIN29 | PIN30 | PIN31 | PIN32 | PIN33 | PIN34 | PIN35
           | PIN36 | PIN37 | PIN38 | PIN39 | PIN40 | PIN41 | PIN42
           | PIN43 | PIN44 | PIN45 | PIN46 | PIN47 | PIN48 | PIN49
           | MISO | SCK | MOSI | SS
           | PINA0 | PINA1 | PINA2 | PINA3 | PINA4 | PINA5 | PINA6 | PINA7 | PINA8
           | PINA9 | PINA10 | PINA11 | PINA12 | PINA13 | PINA14 | PINA15
  val port_of_pin: pin -> register
  val ddr_of_pin: pin -> register
  val input_of_pin: pin -> register
  val bit_of_pin: pin -> bit
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  module MCUConnection: Circuits.MCUConnection
    with type pin = pin
    with type mode = mode
    with type level = level
end

(** Pin layout of the Arduino Uno *)
module ArduinoUnoPins: sig
  type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7 | PIN8
           | PIN9 | PIN10 | PIN11 | PIN12 | PIN13
           | MISO | SCK | MOSI | SS
           | PINA0 | PINA1 | PINA2 | PINA3 | PINA4 | PINA5
  val port_of_pin: pin -> register
  val ddr_of_pin: pin -> register
  val input_of_pin: pin -> register
  val bit_of_pin: pin -> bit
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  module MCUConnection: Circuits.MCUConnection
    with type pin = pin
    with type mode = mode
    with type level = level
end


(** Serial communication *)
module Serial: sig
  val init: unit -> unit
  val write: string -> unit
  val read: unit -> string
end
