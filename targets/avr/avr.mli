(*******************************************************************************)
(*                                                                             *)
(*                  Generic avr pin communication library                      *)
(*                                                                             *)
(*******************************************************************************)

type level = HIGH | LOW
type mode = INPUT | OUTPUT | INPUT_PULLUP

type yes
type no
type 'a analog_pin = YES : yes analog_pin | NO : no analog_pin

module type AvrPins = sig
  type ('a, 'b, 'c, 'd) pin
  type 'a register
  val port_of_pin:
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a register
  val ddr_of_pin:
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b register
  val input_of_pin:
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c register
  val port_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a
  val ddr_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b
  val input_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c
  val pin_mode :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> mode -> unit
  val digital_write :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> level -> unit
  val digital_read :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> level
  val write_register : 'a register -> int -> unit
  val read_register : 'a register -> int
  val set_bit : 'a register -> 'a -> unit
  val clear_bit : 'a register -> 'a -> unit
  val read_bit : 'a register -> 'a -> bool
  val pin_change_callback:
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> (unit -> unit) -> unit
end

val delay : int -> unit
val millis : unit -> int

module Serial : sig
  val init : unit -> unit
  val read : unit -> char
  val write : char -> unit
  val write_string : string -> unit
  val write_int : int -> unit
end

module type Timer = sig
  val set_period : int -> unit
  val set_callback : (unit -> unit) -> unit
end

module Timer0: Timer
module Timer2: Timer

