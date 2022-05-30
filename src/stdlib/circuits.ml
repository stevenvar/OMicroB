(*******************************************************************************)
(*                                                                             *)
(*                  Generic circuit representation library                     *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

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

module type Sensor = sig
  val is_on: unit -> bool
end

module type Actuator = sig
  val on: unit -> unit
  val off: unit -> unit
end

(*******************************************************************************)

module type Led = sig
  val init: unit -> unit
  val on: unit -> unit
  val off: unit -> unit
end

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

module MakeLed(LC: LedConnection): Led = struct
  let init () = LC.pin_mode LC.connectedPin LC.output_mode
  let on () = LC.digital_write LC.connectedPin LC.high
  let off () = LC.digital_write LC.connectedPin LC.low
end

(*******************************************************************************)

module type Button = sig
  val init: unit -> unit
  val is_on: unit -> bool
end

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

module MakeButton(BC: ButtonConnection): Button = struct
  let init () = BC.pin_mode BC.connectedPin BC.input_mode
  let is_on () =
    if (BC.digital_read BC.connectedPin) = BC.high then true else false
end

(*******************************************************************************)

module type ClockConnection = sig
  val millis: unit -> int
  val period: int
end

module MakeClock(C: ClockConnection) = struct
  let is_on () = if (C.millis () mod C.period) < C.period/2 then true else false
end

(*******************************************************************************)

module type AnalogInConnection = sig
  type 'a pin
  type mode
  val input_mode: mode
  val pin_mode: 'a pin -> mode -> unit
  val analog_read: [ `AREAD ] pin -> int
  val connectedPin: [ `AREAD ] pin
end

module type AnalogSensor = sig
  val init: unit -> unit
  val level: unit -> int
end

module MakeAnalogSensor(AC: AnalogInConnection) = struct
  let init () = AC.pin_mode AC.connectedPin AC.input_mode
  let level () = AC.analog_read AC.connectedPin
end

(*******************************************************************************)

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

module type RGBLed = sig
  val init: unit -> unit
  val set_color: int -> int -> int -> unit
end

module MakeRGBLed(RLC: RGBLedConnection) = struct
  let init () =
    RLC.pin_mode RLC.redPin RLC.output_mode;
    RLC.pin_mode RLC.greenPin RLC.output_mode;
    RLC.pin_mode RLC.bluePin RLC.output_mode

  let set_color r g b =
    RLC.analog_write RLC.redPin (r*4);
    RLC.analog_write RLC.greenPin (g*4);
    RLC.analog_write RLC.bluePin (b*4)
end

(*******************************************************************************)

module And(SL: Sensor)(SR: Sensor) = struct
  let is_on () = SL.is_on () && SR.is_on ()
end

module Or(SL: Sensor)(SR: Sensor) = struct
  let is_on () = SL.is_on () || SR.is_on ()
end

module Not(S: Sensor) = struct
  let is_on () = not (S.is_on ())
end

(*******************************************************************************)

module MultiAct(AL: Actuator)(AR: Actuator) = struct
  let on () = AL.on (); AR.on ()
  let off () = AL.off (); AR.off ()
end

(*******************************************************************************)

module type Circuit = sig
  val update: unit -> unit
end

module Connect(S: Sensor)(A: Actuator) = struct
  let update () = if S.is_on () then A.on () else A.off ()
end

(*******************************************************************************)

module type I2C = sig
  val init: unit -> unit
  val read: unit -> bytes
  val write: bytes -> unit
end

(*******************************************************************************)

module type SPI = sig
  val init: unit -> unit
  val transmit: char -> char
end

(*******************************************************************************)

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
(* Port of the LiquidCrystal library in OCaml (for OMicroB) *)
(* Original lib : https://github.com/arduino-libraries/LiquidCrystal *)

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

module MakeLCD(L: LCDConnection) = struct
  let lcd_cleardisplay = 0x01
  (* and lcd_returnhome = 0x02 *)
  and lcd_entrymodeset = 0x04
  and lcd_displaycontrol = 0x08
  and lcd_cursorshift = 0x10
  and lcd_functionset = 0x20
  and lcd_setcgramaddr = 0x40
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
  let lcd_moveright = 0x04
  and lcd_moveleft = 0x00

  (* Flags for function set *)
  let lcd_4bitmode = 0x00
  and lcd_2line = 0x08
  (* and lcd_1line = 0x00 *)
  (* and lcd_5x10dots = 0x04 *)
  and lcd_5x8dots = 0x00

  let cursorLine = ref 0
  let cursorColumn = ref 0

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

  (**************************** Char creation and display ************************)

  let create_char loc l =
    if (loc > 7) then invalid_arg "create_char: i";
    if (List.length l > 8) then invalid_arg "create_char: l";
    let vals = List.rev_map (fun l ->
        if (List.length l <> 5) then invalid_arg "create_char: l";
        List.fold_left (fun a v -> (a lsl 1) + (if v = true then 1 else 0)) 0 l
      ) (List.rev l) in
    command (lcd_setcgramaddr lor (loc lsl 3));
    List.iter (fun c -> write c) (vals@(List.init (8 - (List.length vals)) (fun _ -> 0)))

  let print_char loc = write loc; cursorColumn := !cursorColumn + 1

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

  let print_string s = String.iter (fun c -> write (int_of_char c)) s;
    cursorColumn := !cursorColumn + (String.length s)

  let print_int i = print_string (string_of_int i)

  let print_newline () =
    if !cursorLine > 0 then clear_screen ();
    cursorLine := (!cursorLine + 1) mod 2;
    command (lcd_setddramaddr lor if (!cursorLine = 0) then 0x00 else 0x40);
    cursorColumn := 0

  let print_image img =
    create_char 0 img;
    (* The commands below are necessary for some reason *)
    command (lcd_cursorshift lor lcd_moveleft); command (lcd_cursorshift lor lcd_moveright);
    for _ = !cursorColumn to 7 do command (lcd_cursorshift lor lcd_moveleft) done;
    tracei !cursorColumn;
    for _ = 8 to !cursorColumn-1 do command (lcd_cursorshift lor lcd_moveright) done;
    print_char 0

  let set_pixel _ _ _ = ()
end

(*******************************************************************************)
(** Port of the Adafruit SSD_1306 library in OCaml (for OMicroB) *)
(** Original lib : https://github.com/adafruit/Adafruit_SSD1306 *)

module MakeSSD1306(I2C: I2C) = struct
  let screen = Bytes.make 1025 (char_of_int 0)

  let command c =
    let b = Bytes.make ((Array.length c) + 1) (char_of_int 0) in
    for i = 1 to (Array.length c) do Bytes.set b i (char_of_int (c.(i-1))) done;
    I2C.write b

  let set_pos col page =
    command [|0xB0 lor page|];
    let c1 = col land 0x0F and c2 = col lsr 4 in
    command [|0x00 lor c1|]; command [|0x10 lor c2|]

  let draw_screen () =
    set_pos 0 0;
    I2C.write screen

  let clear_screen () =
    Bytes.fill screen 1 ((Bytes.length screen) - 1) (char_of_int 0);
    draw_screen ()

  let init () =
    I2C.init ();
    List.iter command [
      [|0xAE|]; (* DISPLAYOFF *)
      [|0xD5; 0x80|]; (* SETDISPLAYCLOCKDIV *)
      [|0xA8|]; (* SETMULTIPLEX *)
      [|63|]; (* height - 1 *)
      [|0xD3; 0x00|]; (* SETDISPLAYOFFSET *)
      [|0x40; 0x0|]; (* SETSTARTLINE *)
      [|0x8D; 0x14|]; (* CHARGEPUMP *)
      [|0x20; 0x00|]; (* MEMORYMODE *)
      [|0x21; 0; 127|];
      [|0x22; 0; 63|];
      [|0xA0 lor 0x1|]; (* SEGREMAP *)
      [|0xC8|]; (* COMSCANDEC *)
      [|0xDA; 0x12|]; (* SETCOMPINS *)
      [|0x81|]; (* SETCONTRAST *)
      [|0xD9; 0xF1|]; (* SETPRECHARGE *)
      [|0xDB; 0x40|]; (* SETVCOMDETECT *)
      [|0xA4|];
      [|0xA6|]; (* DISPLAYALLON_RESUME *)
      [|0x2E|]; (* DEACTIVATE_SCROLL *)
      [|0xAF|] (* DISPLAYON *)
    ];
    Bytes.set screen 0 (char_of_int 0x40);
    clear_screen ()

  let bytes_to_write = Bytes.make 2 (char_of_int 0x40)

  let set_pixel x y color =
    let page = y / 8 and shift_p = y mod 8 in
    let ind = (x + page * 128) + 1 in
    let b = if color
      then (int_of_char (Bytes.get screen ind)) lor (1 lsl shift_p)
      else (int_of_char (Bytes.get screen ind)) land (lnot (1 lsl shift_p)) in
    Bytes.set screen ind (char_of_int b);
    set_pos x page;
    Bytes.set bytes_to_write 1 (char_of_int b);
    I2C.write bytes_to_write

  let print_image _ = failwith "Not yet implemented"

  let print_newline () = failwith "Not yet implemented"

  let print_string _ = failwith "Not yet implemented"

  let print_int _ = failwith "Not yet implemented"
end
