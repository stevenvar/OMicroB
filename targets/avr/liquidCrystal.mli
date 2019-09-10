(*******************************************************************************)
(*                                                                             *)
(*            Port of the LiquidCrystal library in OCaml (for OMicroB)         *)
(*       Original lib : https://github.com/arduino-libraries/LiquidCrystal     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*            see : https://www.arduino.cc/en/Reference/LiquidCrystal          *)
(*******************************************************************************)

open Avr

module type Writeable = sig
  type 'a register
  type ('a, 'b, 'c, 'd) pin
  val pin_mode: ('a register, 'b register, 'c register, 'd analog_pin) pin -> mode -> unit
  val digital_write: ('a register, 'b register, 'c register, 'd analog_pin) pin -> level -> unit
end

module type LCD = sig
  type 'a register
  type ('a, 'b, 'c, 'd) pin
  type ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd

  (** Initialise a LCD in 4-bit mode : [create_4bitmode rs enable d0 d1 d2 d3] *)
  val create4bitmode :
    ('a register, 'b register, 'c register, no analog_pin) pin ->
    ('d register, 'e register, 'f register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd

  (** Initialise a LCD in 8-bit mode : [create_8bitmode rs enable d0 d1 d2 d3 d4 d5 d6 d7] *)
  val create8bitmode :
    ('a register, 'b register, 'c register, no analog_pin) pin ->
    ('d register, 'e register, 'f register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('g register, 'h register, 'i register, no analog_pin) pin ->
    ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd

  (** Start the LCD display with c columns and l lines : [lcdBegin lcd c l]. Was named [begin] in the C library, but is renamed because begin is a keyword in OCaml *)
  val lcdBegin : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> int -> int -> unit

  (** Clear the LCD display *)
  val clear : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Set the cursor to home position *)
  val home : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn off the LCD display, without loosing it's text *)
  val noDisplay : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn on the LCD display *)
  val display : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn off the blinking cursor *)
  val noBlink : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn on the blinking cursor *)
  val blink : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn off the cursor *)
  val noCursor : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn on the cursor *)
  val cursor : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Scroll the content (text and cursor) of display one space to the left *)
  val scrollDisplayLeft : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Scroll the content (text and cursor) of display one space to the right *)
  val scrollDisplayRight : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Write from left to right (default) *)
  val leftToRight : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Write from right to left *)
  val rightToLeft : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn on autoscroll *)
  val autoscroll : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Turn off autoscroll *)
  val noAutoscroll : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> unit

  (** Set the cursor to column c and row r : [setCursor lcd c r]*)
  val setCursor : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> int -> int -> unit

  (** Write a character to the LCD display *)
  val write : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> int -> unit

  (** Print text to the LCD display *)
  val print : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> string -> unit

  (** Create a special character in one of the 8 CGRAM locations : [createChar lcd loc data] where loc is a number between 0 and 7, and data is an int array of size 7. Use before begin ! *)
  val createChar : ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd -> int -> int array -> unit
end

(** Creates an LCD module, given a Writable interface *)
module MakeLCD(W: Writeable):
  LCD with type ('a, 'b, 'c, 'd) pin = ('a, 'b, 'c, 'd) W.pin
  with type 'a register = 'a W.register
