(*******************************************************************************)
(*                                                                             *)
(*            Port of the LiquidCrystal library in OCaml (for OMicroB)         *)
(*       Original lib : https://github.com/arduino-libraries/LiquidCrystal     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*            see : https://www.arduino.cc/en/Reference/LiquidCrystal          *)
(*******************************************************************************)

(** Allows to connect an external display *)
module type LCDConnection = sig
  type pin
  type level
  include Circuits.MCUConnection with type pin := pin with type level := level
  val rsPin: pin
  val enablePin: pin
  val d4Pin: pin
  val d5Pin: pin
  val d6Pin: pin
  val d7Pin: pin
end

(** Make a LiquidCrystal display from a LCDConnection *)
module MakeLCD(L: LCDConnection): Circuits.Display
