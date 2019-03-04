(*******************************************************************************)
(*                                                                             *)
(*            Port of the LiquidCrystal library in OCaml (for OMicroB)         *)
(*       Original lib : https://github.com/arduino-libraries/LiquidCrystal     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*            see : https://www.arduino.cc/en/Reference/LiquidCrystal          *)
(*******************************************************************************)

(* open Avr
 *
 * module type Writeable = sig
 *   val pin_mode: pin -> mode -> unit
 *   val digital_write: pin -> level -> unit
 * end
 *
 * module type LCD = sig
 *   type lcd
 *
 *   (\** Initialise a LCD in 4-bit mode : [create_4bitmode rs enable d0 d1 d2 d3] *\)
 *   val create4bitmode : pin -> pin -> pin -> pin -> pin -> pin -> lcd
 *
 *   (\** Initialise a LCD in 8-bit mode : [create_8bitmode rs enable d0 d1 d2 d3 d4 d5 d6 d7] *\)
 *   val create8bitmode :  pin -> pin -> pin -> pin -> pin -> pin ->
 *     pin -> pin -> pin -> pin -> lcd
 *
 *   (\** Start the LCD display with c columns and l lines : [lcdBegin lcd c l]. Was named [begin] in the C library, but is renamed because begin is a keyword in OCaml *\)
 *   val lcdBegin : lcd -> int -> int -> unit
 *
 *   (\** Clear the LCD display *\)
 *   val clear : lcd -> unit
 *
 *   (\** Set the cursor to home position *\)
 *   val home : lcd -> unit
 *
 *   (\** Turn off the LCD display, without loosing it's text *\)
 *   val noDisplay : lcd -> unit
 *
 *   (\** Turn on the LCD display *\)
 *   val display : lcd -> unit
 *
 *   (\** Turn off the blinking cursor *\)
 *   val noBlink : lcd -> unit
 *
 *   (\** Turn on the blinking cursor *\)
 *   val blink : lcd -> unit
 *
 *   (\** Turn off the cursor *\)
 *   val noCursor : lcd -> unit
 *
 *   (\** Turn on the cursor *\)
 *   val cursor : lcd -> unit
 *
 *   (\** Scroll the content (text and cursor) of display one space to the left *\)
 *   val scrollDisplayLeft : lcd -> unit
 *
 *   (\** Scroll the content (text and cursor) of display one space to the right *\)
 *   val scrollDisplayRight : lcd -> unit
 *
 *   (\** Write from left to right (default) *\)
 *   val leftToRight : lcd -> unit
 *
 *   (\** Write from right to left *\)
 *   val rightToLeft : lcd -> unit
 *
 *   (\** Turn on autoscroll *\)
 *   val autoscroll : lcd -> unit
 *
 *   (\** Turn off autoscroll *\)
 *   val noAutoscroll : lcd -> unit
 *
 *   (\** Set the cursor to column c and row r : [setCursor lcd c r]*\)
 *   val setCursor : lcd -> int -> int -> unit
 *
 *   (\** Write a character to the LCD display *\)
 *   val write : lcd -> int -> unit
 *
 *   (\** Print text to the LCD display *\)
 *   val print : lcd -> string -> unit
 *
 *   (\** Create a special character in one of the 8 CGRAM locations : [createChar lcd loc data] where loc is a number between 0 and 7, and data is an int array of size 7. Use before begin ! *\)
 *   val createChar : lcd -> int -> int array -> unit
 * end *)

(** Creates an LCD module, given a Writable interface *)
(* module MakeLCD(W: Writeable): LCD *)

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
module MakeLCD(L: LCDConnection): Circuits.Display with type level = L.level
