(*******************************************************************************)
(*                                                                             *)
(*                  Generic PIC32 pin communication library                    *)
(*                                                                             *)
(*******************************************************************************)



type level = HIGH | LOW
type mode = INTPUT | OUTPUT

type yes
type no
type 'a analog_pin = YES : yes analog_pin | NO : no analog_pin

(* Control registers on PIC32:

   Each I/O port is associated to a:
   - TRIS register (controlling the data direction flow)
   - PORT register (to allow read accesses of I/O pin)
   - LAT register (for holding written data to port I/O pin)
*)

module type Pic32Pins = sig
  type ('a, 'b, 'c, 'd) pin
  type 'a register
  val lat_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a register
  val tris_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b register
  val port_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c register
  val lat_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a
  val tris_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b
  val port_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c
  val pin_mode : 
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> mode -> unit
  val digital_write :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> level -> unit
  val digital_read :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> level
  val write_register : 'a register -> int -> unit
  val read_register : 'a register -> int 
  val set_bit : 'a register -> 'a -> unit
  val clear_bit : 'a register -> 'a -> unit
  val read_bit : 'a register -> 'a -> bool
end

external delay : int -> unit = "caml_pic32_delay" [@@noalloc]

