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
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
  val digital_read: pin -> level
  (* val analog_read: pin -> int
  val analog_write: pin -> int -> unit *)
  val delay: int -> unit
  val millis: unit -> int
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
  type level
  type mode
  val high: level
  val low: level
  val output_mode: mode
  val pin_mode: pin -> mode -> unit
  val digital_write: pin -> level -> unit
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
  type level
  type mode
  val high: level
  val low: level
  val input_mode: mode
  val pin_mode: pin -> mode -> unit
  val digital_read: pin -> level
  val connectedPin: pin
end

(** Make a Switch from a SwitchConnection *)
module MakeButton(BC: ButtonConnection): Button

(*******************************************************************************)

(** Connect a clock to the MCU *)
module type ClockConnection = sig
  val millis: unit -> int
  val period: int
end

(** Simple clock *)
module MakeClock(C: ClockConnection): Sensor

(*******************************************************************************)

(** Connect an analog sensor to the MCU *)
module type AnalogInConnection = sig
  type pin
  type mode
  val input_mode: mode
  val pin_mode: pin -> mode -> unit
  val analog_read: pin -> int
  val connectedPin: pin
end

(** Generic analog sensor *)
module type AnalogSensor = sig
  val init: unit -> unit
  val level: unit -> int
end

(** Make an analog sensor *)
module MakeAnalogSensor(AC: AnalogInConnection): AnalogSensor

(*******************************************************************************)

(** Connect an RGB Led to the MCU *)
module type RGBLedConnection = sig
  type pin
  type mode
  val output_mode: mode
  val pin_mode: pin -> mode -> unit
  val analog_write: pin -> int -> unit
  val redPin: pin
  val greenPin: pin
  val bluePin: pin
end

(** RGB led *)
module type RGBLed = sig
  val init: unit -> unit
  val set_color: int -> int -> int -> unit
end

(** Make a RGB led *)
module MakeRGBLed(RLC: RGBLedConnection): RGBLed

(*******************************************************************************)

(** And gate *)
module And(SL: Sensor)(SR: Sensor): Sensor

(** Or gate *)
module Or(SL: Sensor)(SR: Sensor): Sensor

(** Not gate *)
module Not(S: Sensor): Sensor

(*******************************************************************************)

(** Connect multiple actuators *)
module MultiAct(AL: Actuator)(AR: Actuator): Actuator

(*******************************************************************************)

(** Whole circuit, that can be updated
    (propagate the signals through the circuit) *)
module type Circuit = sig
  val update: unit -> unit
end

(** Connect a sensor to an actuator *)
module Connect(S: Sensor)(A: Actuator): Circuit

(*******************************************************************************)

(** Display that can be printed on *)
module type Display = sig
  val init: unit -> unit
  val print_int: int -> unit
  val print_string: string -> unit
  val print_newline: unit -> unit
  val print_image: bool list list -> unit
  val set_pixel: int -> int -> bool -> unit
  val clear_screen: unit -> unit
end
