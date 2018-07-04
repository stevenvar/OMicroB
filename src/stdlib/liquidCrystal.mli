(*******************************************************************************)
(*                                                                             *)
(*            Port of the LiquidCrystal library in OCaml (for OMicroB)         *)
(*       Original lib : https://github.com/arduino-libraries/LiquidCrystal     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*            see : https://www.arduino.cc/en/Reference/LiquidCrystal          *)
(*******************************************************************************)

open Avr

type ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd

(** Initialise a LCD in 4-bit mode : [create_4bitmode rs enable d0 d1 d2 d3] *)
val create4bitmode : ('a register, 'b register, 'c register) pin ->
  ('d register, 'e register, 'f register) pin ->
  ('g register, 'h register, 'i register) pin -> ('g register, 'h register, 'i register) pin ->
  ('g register, 'h register, 'i register) pin -> ('g register, 'h register, 'i register) pin ->
  ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd

(** Initialise a LCD in 8-bit mode : [create_8bitmode rs enable d0 d1 d2 d3 d4 d5 d6 d7] *)
val create8bitmode :  ('a register, 'b register, 'c register) pin ->
  ('d register, 'e register, 'f register) pin ->
  ('g register, 'h register, 'i register) pin -> ('g register, 'h register, 'i register) pin ->
  ('g register, 'h register, 'i register) pin -> ('g register, 'h register, 'i register) pin ->
  ('g register, 'h register, 'i register) pin -> ('g register, 'h register, 'i register) pin ->
  ('g register, 'h register, 'i register) pin -> ('g register, 'h register, 'i register) pin ->
  ('a, 'b, 'c, 'd, 'e, 'f, 'g, 'h, 'i) lcd

(** Start the LCD display with c columns and l lines : [lcdBegin lcd c l]. Was named [begin] in the C library, but is renamed because begin is a keyword in OCaml *)
val lcdBegin : _ lcd -> int -> int -> unit

(** Clear the LCD display *)
val clear : _ lcd -> unit

(** Set the cursor to home position *)
val home : _ lcd -> unit

(** Turn off the LCD display, without loosing it's text *)
val noDisplay : _ lcd -> unit

(** Turn on the LCD display *)
val display : _ lcd -> unit

(** Turn off the blinking cursor *)
val noBlink : _ lcd -> unit

(** Turn on the blinking cursor *)
val blink : _ lcd -> unit

(** Turn off the cursor *)
val noCursor : _ lcd -> unit

(** Turn on the cursor *)
val cursor : _ lcd -> unit

(** Scroll the content (text and cursor) of display one space to the left *)
val scrollDisplayLeft : _ lcd -> unit

(** Scroll the content (text and cursor) of display one space to the right *)
val scrollDisplayRight : _ lcd -> unit

(** Write from left to right (default) *)
val leftToRight : _ lcd -> unit

(** Write from right to left *)
val rightToLeft : _ lcd -> unit

(** Turn on autoscroll *)
val autoscroll : _ lcd -> unit

(** Turn off autoscroll *)
val noAutoscroll : _ lcd -> unit

(** Set the cursor to column c and row r : [setCursor lcd c r]*)
val setCursor : _ lcd -> int -> int -> unit

(** Write a character to the LCD display *)
val write : _ lcd -> int -> unit

(** Print text to the LCD display *)
val print : _ lcd -> string -> unit

(** Create a special character in one of the 8 CGRAM locations : [createChar lcd loc data] where loc is a number between 0 and 7, and data is an int array of size 7. Use before begin ! *)
val createChar : _ lcd -> int -> int array -> unit
