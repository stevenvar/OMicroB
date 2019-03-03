(*******************************************************************************)
(*                                                                             *)
(*                  Generic circuit representation library                     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

(** Connection between a micro-controller (via it's pins).
    Should be implemented for each specific MCU. *)
module type Connection = sig
  type pin
  type level
  type mode
  val high: level
  val low: level
  val input_mode: mode
  val output_mode: mode
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  val pin_mode: pin -> mode -> unit
end

(*******************************************************************************)

(** Simple Led *)
module type Led = sig
  val init: unit -> unit
  val on: unit -> unit
  val off: unit -> unit
end

(** Used to connect a led to the MCU *)
module type LedConnection = sig
  type pin
  include Connection with type pin := pin
  val connectedPin: pin
end

(** Make a Led from a LedConnection *)
module MakeLed(LC: LedConnection): Led
