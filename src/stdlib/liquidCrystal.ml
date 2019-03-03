(*******************************************************************************)
(*                                                                             *)
(*            Port of the LiquidCrystal library in OCaml (for OMicroB)         *)
(*       Original lib : https://github.com/arduino-libraries/LiquidCrystal     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

let lcd_cleardisplay = 0x01
(* and lcd_returnhome = 0x02 *)
and lcd_entrymodeset = 0x04
and lcd_displaycontrol = 0x08
(* and lcd_cursorshift = 0x10 *)
and lcd_functionset = 0x20
(* and lcd_setcgramaddr = 0x40 *)
and lcd_setddramaddr = 0x80

(* Flags for display on / off control *)
let lcd_displayon = 0x04
(* and lcd_displayoff = 0x00 *)
(* and lcd_cursoron = 0x02 *)
and lcd_cursoroff = 0x00
(* and lcd_blinkon = 0x01 *)
and lcd_blinkoff = 0x00

(* Flags for entry mode *)
let lcd_entryleft = 0x02
(* and lcd_entryright = 0x00 *)
(* and lcd_entryshiftincrement = 0x01 *)
and lcd_entryshiftdecrement = 0x00

(* Flags for display/cursor move *)
(* let lcd_displaymove = 0x08 *)
(* and lcd_cursormove = 0x00 *)
(* and lcd_moveright = 0x04
 * and lcd_moveleft = 0x00 *)

(* Flags for function set *)
let lcd_4bitmode = 0x00
and lcd_2line = 0x08
(* and lcd_1line = 0x00 *)
(* and lcd_5x10dots = 0x04 *)
and lcd_5x8dots = 0x00;

module type LCDConnection = sig
  type pin
  type level
  include Circuits.Connection with type pin := pin with type level := level
  val rsPin: pin
  val enablePin: pin
  val d4Pin: pin
  val d5Pin: pin
  val d6Pin: pin
  val d7Pin: pin
end

module MakeLCD(L: LCDConnection): Circuits.Display with type level = L.level = struct
  type level = L.level

  let cursorLine = ref 0

  (********************** Low level data pushing commands ************************)

  let pulseEnable () =
    L.digital_write L.enablePin L.low;
    L.delay 1;
    L.digital_write L.enablePin L.high;
    L.delay 1;
    L.digital_write L.enablePin L.low;
    L.delay 1

  let write4bits value =
    L.digital_write L.d4Pin (if ((value lsr 0) land 0x01)> 0 then L.high else L.low);
    L.digital_write L.d5Pin (if ((value lsr 1) land 0x01)> 0 then L.high else L.low);
    L.digital_write L.d6Pin (if ((value lsr 2) land 0x01)> 0 then L.high else L.low);
    L.digital_write L.d7Pin (if ((value lsr 3) land 0x01)> 0 then L.high else L.low);
    pulseEnable ()

  let send value mode =
    L.digital_write L.rsPin mode;

    write4bits (value lsr 4);
    write4bits value

  (**************** Mid level commands, for sending data / cmds ******************)

  let command value = send value L.low

  let write value = send value L.high

  (*********************** High level, user exposed commands *********************)

  let clear_screen () = command lcd_cleardisplay; L.delay 2

  let init () =
    (* Set output mode for the pins *)
    L.pin_mode L.rsPin L.output_mode;
    L.pin_mode L.enablePin L.output_mode;
    L.pin_mode L.d4Pin L.output_mode;
    L.pin_mode L.d5Pin L.output_mode;
    L.pin_mode L.d6Pin L.output_mode;
    L.pin_mode L.d7Pin L.output_mode;

    L.delay 50;

    L.digital_write L.rsPin L.low;
    L.digital_write L.enablePin L.low;

    write4bits 0x03;
    L.delay 5;
    write4bits 0x03;
    L.delay 5;
    write4bits 0x03;
    L.delay 1;
    write4bits 0x02;

    command (lcd_functionset lor lcd_4bitmode lor lcd_2line lor lcd_5x8dots);

    (* Turn the display on *)
    command (lcd_displaycontrol lor lcd_displayon lor lcd_cursoroff lor lcd_blinkoff);

    (* Clear the display *)
    clear_screen ();

    (* Set entry mode *)
    command (lcd_entrymodeset lor lcd_entryleft lor lcd_entryshiftdecrement)

  let print_string s = String.iter (fun c -> write (int_of_char c)) s
  let print_int i = print_string (string_of_int i)

  let print_newline () =
    if !cursorLine > 0 then clear_screen ();
    cursorLine := (!cursorLine + 1) mod 2;
    command (lcd_setddramaddr lor if (!cursorLine = 0) then 0x00 else 0x40)

  let print_image _ = ()

  let set_pixel _ _ _ = ()
end
