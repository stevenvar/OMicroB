(*******************************************************************************)
(*                                                                             *)
(*            Port of the LiquidCrystal library in OCaml (for OMicroB)         *)
(*       Original lib : https://github.com/arduino-libraries/LiquidCrystal     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

open Avr

module type Writeable = sig
  type register
  type 'a pin
  val pin_mode: 'a pin -> mode -> unit
  val digital_write: [ `DWRITE ] pin -> level -> unit
end

module type LCD = sig
  type register
  type 'a pin
  type lcd
  val create4bitmode :
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    lcd
  val create8bitmode :
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    [ `DWRITE ] pin ->
    lcd
  val lcdBegin : lcd -> int -> int -> unit
  val clear : lcd -> unit
  val home : lcd -> unit
  val noDisplay : lcd -> unit
  val display : lcd -> unit
  val noBlink : lcd -> unit
  val blink : lcd -> unit
  val noCursor : lcd -> unit
  val cursor : lcd -> unit
  val scrollDisplayLeft : lcd -> unit
  val scrollDisplayRight : lcd -> unit
  val leftToRight : lcd -> unit
  val rightToLeft : lcd -> unit
  val autoscroll : lcd -> unit
  val noAutoscroll : lcd -> unit
  val setCursor : lcd -> int -> int -> unit
  val write : lcd -> int -> unit
  val print : lcd -> string -> unit
  val createChar : lcd -> int -> int array -> unit
end

(* Commands *)
let lcd_cleardisplay = 0x01
and lcd_returnhome = 0x02
and lcd_entrymodeset = 0x04
and lcd_displaycontrol = 0x08
and lcd_cursorshift = 0x10
and lcd_functionset = 0x20
and lcd_setcgramaddr = 0x40
and lcd_setddramaddr = 0x80

(* Flags for display on / off control *)
let lcd_displayon = 0x04
(* and lcd_displayoff = 0x00 *)
and lcd_cursoron = 0x02
and lcd_cursoroff = 0x00
and lcd_blinkon = 0x01
and lcd_blinkoff = 0x00

(* Flags for entry mode *)
let (* lcd_entryright = 0x00
     * and *) lcd_entryleft = 0x02
and lcd_entryshiftincrement = 0x01
and lcd_entryshiftdecrement = 0x00

(* Flags for display/cursor move *)
let lcd_displaymove = 0x08
(* and lcd_cursormove = 0x00 *)
and lcd_moveright = 0x04
and lcd_moveleft = 0x00

(* Flags for function set *)
let lcd_8bitmode = 0x10 and lcd_4bitmode = 0x00
and lcd_2line = 0x08 and lcd_1line = 0x00
(* and lcd_5x10dots = 0x04 *) and lcd_5x8dots = 0x00;

module MakeLCD(W: Writeable) :
  LCD with type 'a pin = 'a W.pin
  with type register = W.register
= struct
  type register = W.register
  type 'a pin = 'a W.pin
  type lcd = {
    is4bitmode : bool;
    rsPin : [ `DWRITE ] pin;
    enablePin : [ `DWRITE ] pin;
    dpins : [ `DWRITE ] pin array;
    mutable displayFunction : int;
    mutable displayMode : int;
    mutable displayControl : int;
    mutable numLines : int;
    mutable rowOffsets : int array;
  }

  (********************** Low level data pushing commands ************************)

  let pulseEnable lcd =
    W.digital_write lcd.enablePin LOW;
    delay 1;
    W.digital_write lcd.enablePin HIGH;
    delay 1;
    W.digital_write lcd.enablePin LOW;
    delay 1

  let write4bits lcd value =
    for i = 0 to 3 do
      W.digital_write lcd.dpins.(i) (if ((value lsr i) land 0x01)> 0 then HIGH else LOW)
    done;

    pulseEnable lcd

  let write8bits lcd value =
    for i = 0 to 7 do
      W.digital_write lcd.dpins.(i) (if ((value lsr i) land 0x01) > 0 then HIGH else LOW)
    done;

    pulseEnable lcd

  let send lcd value mode =
    W.digital_write lcd.rsPin mode;

    if not lcd.is4bitmode then write8bits lcd value
    else (
      write4bits lcd (value lsr 4);
      write4bits lcd value
    )

  (**************** Mid level commands, for sending data / cmds ******************)

  let command lcd value = send lcd value LOW

  let write lcd value = send lcd value HIGH

  (************************** High level user commands ***************************)

  let clear lcd = command lcd lcd_cleardisplay; delay 2

  let noDisplay lcd =
    lcd.displayControl <- lcd.displayControl land (lnot lcd_displayon);
    command lcd (lcd_displaycontrol lor lcd.displayControl)

  let display lcd =
    lcd.displayControl <- lcd.displayControl lor lcd_displayon;
    command lcd (lcd_displaycontrol lor lcd.displayControl)

  let noCursor lcd =
    lcd.displayControl <- lcd.displayControl land (lnot lcd_cursoron);
    command lcd (lcd_displaycontrol lor lcd.displayControl)

  let cursor lcd =
    lcd.displayControl <- lcd.displayControl lor lcd_cursoron;
    command lcd (lcd_displaycontrol lor lcd.displayControl)

  let noBlink lcd =
    lcd.displayControl <- lcd.displayControl land (lnot lcd_blinkon);
    command lcd (lcd_displaycontrol lor lcd.displayControl)

  let blink lcd =
    lcd.displayControl <- lcd.displayControl lor lcd_blinkon;
    command lcd (lcd_displaycontrol lor lcd.displayControl)

  let leftToRight lcd =
    lcd.displayMode <- lcd.displayMode lor lcd_entryleft;
    command lcd (lcd_entrymodeset lor lcd.displayMode)

  let rightToLeft lcd =
    lcd.displayMode <- lcd.displayMode land (lnot lcd_entryleft);
    command lcd (lcd_entrymodeset lor lcd.displayMode)

  let autoscroll lcd =
    lcd.displayMode <- lcd.displayMode lor lcd_entryshiftincrement;
    command lcd (lcd_entrymodeset lor lcd.displayMode)

  let noAutoscroll lcd =
    lcd.displayMode <- lcd.displayMode land (lnot lcd_entryshiftincrement);
    command lcd (lcd_entrymodeset lor lcd.displayMode)

  let setRowOffsets lcd r0 r1 r2 r3 = lcd.rowOffsets <- [|r0;r1;r2;r3|]

  let lcdBegin lcd c l =
    if l > 1 then lcd.displayFunction <- lcd.displayFunction lor lcd_2line;
    lcd.numLines <- l;

    setRowOffsets lcd 0x00 0x40 (0x00 + c) (0x40 + c);

    (* Set output mode for the pins *)
    W.pin_mode lcd.rsPin OUTPUT;
    W.pin_mode lcd.enablePin OUTPUT;
    Array.iter (fun p -> W.pin_mode p OUTPUT) lcd.dpins;

    delay 50;

    W.digital_write lcd.rsPin LOW;
    W.digital_write lcd.enablePin LOW;

    if (lcd.displayFunction land lcd_8bitmode) = 0 then begin
      write4bits lcd 0x03;
      delay 5;
      write4bits lcd 0x03;
      delay 5;
      write4bits lcd 0x03;
      delay 1;
      write4bits lcd 0x02;
    end
    else begin
      command lcd (lcd_functionset lor lcd.displayFunction);
      delay 5;
      command lcd (lcd_functionset lor lcd.displayFunction);
      delay 1;
      command lcd (lcd_functionset lor lcd.displayFunction);
    end;

    command lcd (lcd_functionset lor lcd.displayFunction);

    (* Turn the display on *)
    lcd.displayControl <- lcd_displayon lor lcd_cursoroff lor lcd_blinkoff;
    display lcd;

    (* Clear the display *)
    clear lcd;

    (* Set entry mode *)
    lcd.displayMode <- lcd_entryleft lor lcd_entryshiftdecrement;
    command lcd (lcd_entrymodeset lor lcd.displayMode)

  let create4bitmode rs enable d0 d1 d2 d3 = let lcd = {
      is4bitmode = true;
      rsPin = rs;
      enablePin = enable;
      dpins = [|d0;d1;d2;d3|];
      displayFunction = lcd_4bitmode lor lcd_1line lor lcd_5x8dots;
      displayMode = 0;
      displayControl = 0;
      numLines = 0;
      rowOffsets = [||];
    } in lcdBegin lcd 16 1; lcd

  let create8bitmode rs enable d0 d1 d2 d3 d4 d5 d6 d7 =
    let lcd = {
      is4bitmode = false;
      rsPin = rs;
      enablePin = enable;
      dpins = [|d0;d1;d2;d3;d4;d5;d6;d7|];
      displayFunction =lcd_8bitmode lor lcd_1line lor lcd_5x8dots;
      displayMode = 0;
      displayControl = 0;
      numLines = 0;
      rowOffsets = [||];
    } in lcdBegin lcd 16 1; lcd

  let print lcd s =
    String.iter (fun c -> write lcd (int_of_char c)) s

  let scrollDisplayLeft lcd =
    command lcd (lcd_cursorshift lor lcd_displaymove lor lcd_moveleft)

  let scrollDisplayRight lcd =
    command lcd (lcd_cursorshift lor lcd_displaymove lor lcd_moveright)

  let setCursor lcd c r =
    command lcd (lcd_setddramaddr lor (c + lcd.rowOffsets.(r)))

  let home lcd =
    command lcd lcd_returnhome;
    delay 2

  let createChar lcd loc data =
    let location = loc land 0x7 in
    command lcd (lcd_setcgramaddr lor (location lsl 3));
    Array.iter (fun c -> write lcd c) data;
end
