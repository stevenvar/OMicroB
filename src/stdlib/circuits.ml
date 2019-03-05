(*******************************************************************************)
(*                                                                             *)
(*                  Generic circuit representation library                     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

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

module type Sensor = sig
  val is_on: unit -> bool
end

module type Actuator = sig
  val on: unit -> unit
  val off: unit -> unit
end

(*******************************************************************************)

module type Led = sig
  val init: unit -> unit
  val on: unit -> unit
  val off: unit -> unit
end

module type LedConnection = sig
  type pin
  include MCUConnection with type pin := pin
  val connectedPin: pin
end

module MakeLed(LC: LedConnection): Led = struct
  let init () = LC.pin_mode LC.connectedPin LC.output_mode
  let on () = LC.digital_write LC.connectedPin LC.high
  let off () = LC.digital_write LC.connectedPin LC.low
end

(*******************************************************************************)

module type Button = sig
  val init: unit -> unit
  val is_on: unit -> bool
end

module type ButtonConnection = sig
  type pin
  include MCUConnection with type pin := pin
  val connectedPin: pin
end

module MakeButton(BC: ButtonConnection): Button = struct
  let init () = BC.pin_mode BC.connectedPin BC.input_mode
  let is_on () =
    if (BC.digital_read BC.connectedPin) = BC.high then true else false
end

(*******************************************************************************)

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
