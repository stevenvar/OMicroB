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
end

external delay : int -> unit = "caml_delay" [@@noalloc]
external millis : unit -> int = "caml_millis" [@@noalloc]

module Serial = struct
  external init: unit -> unit = "caml_avr_serial_init" [@@noalloc]
  external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
  external write : char -> unit = "caml_avr_serial_write" [@@noalloc]

  let write_string s =
    String.iter write s

  let write_int n =
    write_string (string_of_int n)
end
