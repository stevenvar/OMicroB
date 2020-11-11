(*******************************************************************************)
(*                                                                             *)
(*                           Microbit library                                  *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type level = LOW | HIGH

type pin = PIN0 | PIN1 | PIN2 | PIN8 | PIN12 | PIN16

type mode = INPUT | OUTPUT
type _mode = mode

module ButtonA: Circuits.Button

module ButtonB: Circuits.Button

val pin_mode: pin -> mode -> unit

val digital_write: pin -> level -> unit

val digital_read: pin -> level

val analog_write: pin -> int -> unit

val analog_read: pin -> int

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

(* module Accelerometer: sig
 *   val x: unit -> int
 *   (\** Returns the x acceleration in milli-gs *\)
 * 
 *   val y: unit -> int
 *   (\** Returns the y acceleration in milli-gs *\)
 * 
 *   val z: unit -> int
 *   (\** Returns the z acceleration in milli-gs *\)
 * 
 *   val pitch: unit -> int
 *   (\** Returns the pitch, in degrees *\)
 * 
 *   val roll: unit -> int
 *   (\** Returns the roll, in degrees *\)
 * end *)

(* module Compass: sig
 *   val calibrate: unit -> unit
 *   (\** Calibrate the compass *\)
 * 
 *   val heading: unit -> int
 *   (\** Heading of the device relative to magnetic north (in degrees) *\)
 * end *)

(** Radio communication *)
(* module Radio: sig
 *   val init: unit -> unit
 *   val send: string -> unit
 *   val recv: unit -> string
 * end *)

(* module MCUConnection: Circuits.MCUConnection with type pin = pin with type level = level
 * 
 * (\** I2C communication for the micro:bit *\)
 * module I2C(A: sig val address: int end): Circuits.I2C
 * 
 * (\** SPI communication for the micro:bit *\)
 * module MakeSPIMaster(SC: sig val slavePin: pin end): Circuits.SPI *)
