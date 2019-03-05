(*******************************************************************************)
(*                                                                             *)
(*                  Generic circuit representation library                     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

(** Connection between a micro-controller (via it's pins).
    Should be implemented for each specific MCU. *)
module type MCUConnection = sig
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
  val delay: int -> unit
end

(*******************************************************************************)

(** Generic digital sensor *)
module type Sensor = sig
  val is_on: unit -> bool
end

(** Generic digital actuator *)
module type Actuator = sig
  val on: unit -> unit
  val off: unit -> unit
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
  include MCUConnection with type pin := pin
  val connectedPin: pin
end

(** Make a Led from a LedConnection *)
module MakeLed(LC: LedConnection): Led

(*******************************************************************************)

(** Simple button-like input *)
module type Button = sig
  val init: unit -> unit
  val is_on: unit -> bool
end

(** Used to connect a switch to the MCU *)
module type ButtonConnection = sig
  type pin
  include MCUConnection with type pin := pin
  val connectedPin: pin
end

(** Make a Switch from a SwitchConnection *)
module MakeButton(BC: ButtonConnection): Button

(*******************************************************************************)

(** Display that can be printed on *)
module type Display = sig
  type level
  val init: unit -> unit
  val print_int: int -> unit
  val print_string: string -> unit
  val print_newline: unit -> unit
  val print_image: level list list -> unit
  val set_pixel: int -> int -> level -> unit
  val clear_screen: unit -> unit
end
