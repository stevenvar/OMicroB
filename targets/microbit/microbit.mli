(*******************************************************************************)
(*                                                                             *)
(*                           Microbit library                                  *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type level = LOW | HIGH

type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN1  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN2  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN4  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM | `BUTTON_A ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN7  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN8  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM | `BUTTON_B ] pin
  | PIN12 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN13 : [< `DREAD | `DWRITE | `PWM | `SCK ] pin
  | PIN14 : [< `DREAD | `DWRITE | `PWM | `MISO ] pin
  | PIN15 : [< `DREAD | `DWRITE | `PWM | `MOSI ] pin
  | PIN16 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN19 : [< `DREAD | `DWRITE | `PWM | `SCL ] pin
  | PIN20 : [< `DREAD | `DWRITE | `PWM | `SDA ] pin

type mode = INPUT | OUTPUT
type _mode = mode

module ButtonA: Circuits.Button

module ButtonB: Circuits.Button

val pin_mode: 'a pin -> mode -> unit

val digital_write: [ `DWRITE ] pin -> level -> unit

val digital_read: [ `DREAD ] pin -> level

val analog_write: [ `PWM ] pin -> int -> unit

val analog_read: [ `AREAD ] pin -> int

val delay: int -> unit

val millis: unit -> int

module Screen: sig
  include Circuits.Display
  val set_pixel : int -> int -> bool -> unit
end

module Serial: sig
  val init: unit -> unit
  val write: string -> unit
  val read: unit -> string
end

module Accelerometer: sig
  val x: unit -> int
  (** Returns the x acceleration in milli-gs *)

  val y: unit -> int
  (** Returns the y acceleration in milli-gs *)

  val z: unit -> int
  (** Returns the z acceleration in milli-gs *)
end

(* module Compass: sig
 *   val calibrate: unit -> unit
 *   (\** Calibrate the compass *\)
 * 
 *   val heading: unit -> int
 *   (\** Heading of the device relative to magnetic north (in degrees) *\)
 * end *)

(** Radio communication *)
module Radio: sig
  val send: string -> unit
  val recv: unit -> string
end

module MCUConnection: Circuits.MCUConnection with type 'a pin = 'a pin with type level = level

(** I2C communication for the micro:bit *)
(* module I2C(A: sig val address: int end): Circuits.I2C *)

(* (\** SPI communication for the micro:bit *\) *)
(* module MakeSPIMaster(SC: sig val slavePin: pin end): Circuits.SPI *)
