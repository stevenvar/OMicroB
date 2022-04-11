(*******************************************************************************)
(*                                                                             *)
(*                  Generic avr pin communication library                      *)
(*                                                                             *)
(*******************************************************************************)

type level = HIGH | LOW
type mode = INPUT | OUTPUT | INPUT_PULLUP

type bit = BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5 | BIT6 | BIT7

module type AvrPins = sig
  type 'a pin
  type register
  val port_of_pin: 'a pin -> register
  val ddr_of_pin: 'a pin -> register
  val input_of_pin: 'a pin -> register
  val port_bit_of_pin : 'a pin -> bit
  val ddr_bit_of_pin : 'a pin -> bit
  val input_bit_of_pin : 'a pin -> bit
  val pin_mode : 'a pin -> mode -> unit
  val digital_write : [> `DWRITE ] pin -> level -> unit
  val digital_read : [> `DREAD ] pin -> level
  val write_register : register -> int -> unit
  val read_register : register -> int
  val set_bit : register -> bit -> unit
  val clear_bit : register -> bit -> unit
  val read_bit : register -> bit -> bool
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
