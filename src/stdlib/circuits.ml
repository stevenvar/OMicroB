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
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  val analog_read: pin -> int
  val delay: int -> unit
  val millis: unit -> int
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
  type level
  type mode
  val high: level
  val low: level
  val output_mode: mode
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
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
  type level
  type mode
  val high: level
  val low: level
  val input_mode: mode
  val pin_mode: pin -> mode -> unit
  val digital_read: pin -> level
  val connectedPin: pin
end

module MakeButton(BC: ButtonConnection): Button = struct
  let init () = BC.pin_mode BC.connectedPin BC.input_mode
  let is_on () =
    if (BC.digital_read BC.connectedPin) = BC.high then true else false
end

(*******************************************************************************)

module type ClockConnection = sig
  val millis: unit -> int
  val period: int
end

module MakeClock(C: ClockConnection) = struct
  let is_on () = if (C.millis () mod C.period) < C.period/2 then true else false
end

(*******************************************************************************)

module type AnalogInConnection = sig
  type pin
  type mode
  val input_mode: mode
  val pin_mode: pin -> mode -> unit
  val analog_read: pin -> int
  val connectedPin: pin
end

module type AnalogSensor = sig
  val init: unit -> unit
  val level: unit -> int
end

module MakeAnalogSensor(AC: AnalogInConnection) = struct
  let init () = AC.pin_mode AC.connectedPin AC.input_mode
  let level () = AC.analog_read AC.connectedPin
end

(*******************************************************************************)

module And(SL: Sensor)(SR: Sensor) = struct
  let is_on () = SL.is_on () && SR.is_on ()
end

module Or(SL: Sensor)(SR: Sensor) = struct
  let is_on () = SL.is_on () || SR.is_on ()
end

module Not(S: Sensor) = struct
  let is_on () = not (S.is_on ())
end

(*******************************************************************************)

module MultiAct(AL: Actuator)(AR: Actuator) = struct
  let on () = AL.on (); AR.on ()
  let off () = AL.off (); AR.off ()
end

(*******************************************************************************)

module type Circuit = sig
  val update: unit -> unit
end

module Connect(S: Sensor)(A: Actuator) = struct
  let update () = if S.is_on () then A.on () else A.off ()
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
