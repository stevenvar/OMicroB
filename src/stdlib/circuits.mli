(*******************************************************************************)
(*                                                                             *)
(*                  Generic circuit representation library                     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

(** Connection between a micro-controller (via it's pins).
    Should be implemented for each specific MCU. *)
module type MCUConnection = sig
  type 'a pin
  type level
  type mode
  val high: level
  val low: level
  val input_mode: mode
  val output_mode: mode
  val pin_mode: 'a pin -> mode -> unit
  val digital_write: [ `DWRITE ] pin -> level -> unit
  val digital_read: [ `DREAD ] pin -> level
  val analog_read: [ `AREAD ] pin -> int
  val analog_write: [ `PWM ] pin -> int -> unit
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
  type 'a pin
  type level
  type mode
  val high: level
  val low: level
  val output_mode: mode
  val pin_mode: 'a pin -> mode -> unit
  val digital_write: [ `DWRITE ] pin -> level -> unit
  val connectedPin: [ `DWRITE ] pin
end

(** Make a Led from a LedConnection *)
module MakeLed(_: LedConnection): Led

(*******************************************************************************)

(** Simple button-like input *)
module type Button = sig
  val init: unit -> unit
  val is_on: unit -> bool
end

(*******************************************************************************)

(** Used to connect a switch to the MCU *)
module type ButtonConnection = sig
  type 'a pin
  type level
  type mode
  val high: level
  val low: level
  val input_mode: mode
  val pin_mode: 'a pin -> mode -> unit
  val digital_read: [ `DREAD ] pin -> level
  val connectedPin: [ `DREAD ] pin
end

(** Make a Switch from a SwitchConnection *)
module MakeButton(_: ButtonConnection): Button

(*******************************************************************************)

(** Connect a clock to the MCU *)
module type ClockConnection = sig
  val millis: unit -> int
  val period: int
end

(** Simple clock *)
module MakeClock(_: ClockConnection): Sensor

(*******************************************************************************)

(** Connect an analog sensor to the MCU *)
module type AnalogInConnection = sig
  type 'a pin
  type mode
  val input_mode: mode
  val pin_mode: 'a pin -> mode -> unit
  val analog_read: [ `AREAD ] pin -> int
  val connectedPin: [ `AREAD ] pin
end

(** Generic analog sensor *)
module type AnalogSensor = sig
  val init: unit -> unit
  val level: unit -> int
end

(** Make an analog sensor *)
module MakeAnalogSensor(_: AnalogInConnection): AnalogSensor

(*******************************************************************************)

(** Connect an RGB Led to the MCU *)
module type RGBLedConnection = sig
  type 'a pin
  type mode
  val output_mode: mode
  val pin_mode: 'a pin -> mode -> unit
  val analog_write: [ `PWM ] pin -> int -> unit
  val redPin: [ `PWM ] pin
  val greenPin: [ `PWM ] pin
  val bluePin: [ `PWM ] pin
end

(** RGB led *)
module type RGBLed = sig
  val init: unit -> unit
  val set_color: int -> int -> int -> unit
end

(** Make a RGB led *)
module MakeRGBLed(_: RGBLedConnection): RGBLed

(*******************************************************************************)

(** And gate *)
module And(_: Sensor)(_: Sensor): Sensor

(** Or gate *)
module Or(_: Sensor)(_: Sensor): Sensor

(** Not gate *)
module Not(_: Sensor): Sensor

(*******************************************************************************)

(** Connect multiple actuators *)
module MultiAct(_: Actuator)(_: Actuator): Actuator

(*******************************************************************************)

(** Whole circuit, that can be updated
    (propagate the signals through the circuit) *)
module type Circuit = sig
  val update: unit -> unit
end

(** Connect a sensor to an actuator *)
module Connect(_: Sensor)(_: Actuator): Circuit

(*******************************************************************************)

(** I2C communication *)
module type I2C = sig
  val init: unit -> unit
  val read: unit -> bytes
  val write: bytes -> unit
end

(*******************************************************************************)

(** SPI communication *)
module type SPI = sig
  val init: unit -> unit
  val transmit: char -> char
end

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

(*******************************************************************************)
(** Liquid crystal display *)
(** see : https://www.arduino.cc/en/Reference/LiquidCrystal *)

module type LCDConnection = sig
  type 'a pin
  type level
  include MCUConnection with type 'a pin := 'a pin with type level := level
  val rsPin: [ `DWRITE ] pin
  val enablePin: [ `DWRITE ] pin
  val d4Pin: [ `DWRITE ] pin
  val d5Pin: [ `DWRITE ] pin
  val d6Pin: [ `DWRITE ] pin
  val d7Pin: [ `DWRITE ] pin
end
module MakeLCD(_: LCDConnection): Display

(*******************************************************************************)
(** SSD1306 Display *)
(** Original lib : https://github.com/adafruit/Adafruit_SSD1306 *)

module MakeSSD1306(_: I2C): Display
