(*******************************************************************************)
(*                                                                             *)
(*                           Microbit library                                  *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type level = LOW | HIGH
type _level = level

type button = A | B

type pin = PIN0 | PIN1 | PIN2 | PIN8 | PIN12 | PIN16
type _pin = pin

type mode = INPUT | OUTPUT
type _mode = mode

external button_is_pressed: button -> bool = "caml_microbit_button_is_pressed" [@@noalloc]

module ButtonA = struct
  let init () = ()
  let is_on () = button_is_pressed A
end

module ButtonB = struct
  let init () = ()
  let is_on () = button_is_pressed B
end

external pin_mode: pin -> mode -> unit = "caml_microbit_pin_mode" [@@noalloc]

external digital_write: pin -> level -> unit = "caml_microbit_digital_write" [@@noalloc]

external unsafe_digital_read: pin -> bool = "caml_microbit_digital_read" [@@noalloc]

let digital_read p =
  match unsafe_digital_read p with
  | true -> HIGH
  | false -> LOW

external unsafe_analog_write: pin -> int -> unit = "caml_microbit_analog_write" [@@noalloc]

let analog_write p l =
  if (l < 0 || l > 1024) then invalid_arg "analog_write: value should be between 0 and 1024";
  if (p <> PIN0 && p <> PIN1 && p <> PIN2)
  then invalid_arg "analog_write: only pins 0, 1, 2, 3, 4 and 10 are supported";
  unsafe_analog_write p l

external unsafe_analog_read: pin -> int = "caml_microbit_analog_read" [@@noalloc]

let analog_read p =
  if (p <> PIN0 && p <> PIN1 && p <> PIN2)
  then invalid_arg "analog_write: only pins 0, 1, 2, 3, 4 and 10 are supported";
  unsafe_analog_read p

external delay: int -> unit = "caml_delay" [@@noalloc]

external millis : unit -> int = "caml_millis" [@@noalloc]

module Screen = struct
  let init () = ()
  external print_string: string -> unit = "caml_microbit_print_string" [@@noalloc]
  let print_int i =
    print_string (string_of_int i)
  external clear_screen: unit -> unit = "caml_microbit_clear_screen" [@@noalloc]
  external unsafe_print_image: bytes -> unit = "caml_microbit_print_image" [@@noalloc]
  external unsafe_set_pixel: int -> int -> bool -> unit = "caml_microbit_write_pixel" [@@noalloc]

  let print_newline () = ()

  let print_image i =
    if (List.length i) <> 5 then invalid_arg "print_image";
    let b = Bytes.concat (Bytes.create 0) (List.rev (List.rev_map (fun r ->
        if (List.length r) <> 5 then invalid_arg "print_image";
        Bytes.init 5 (fun i -> if (List.nth r i) then Char.chr 255 else Char.chr 0)) i)) in
    unsafe_print_image b

  let set_pixel x y l =
    if x < 0 || x > 4 || y < 0 || y > 4 then invalid_arg "write_pixel";
    unsafe_set_pixel x y l
end

module Serial = struct
  let init () = ()
  external write_char: char -> unit = "caml_microbit_serial_write" [@@noalloc]
  let write s = String.iter write_char s

  external read_char: unit -> char = "caml_microbit_serial_read" [@@noalloc]
  let read () =
    let s = ref ""
    and c = ref (read_char ()) in
    s := (!s^(String.make 1 !c));
    while((int_of_char !c) <> 0 && !c <> '\n' && !c <> '\r') do
      c := (read_char ());
      s := (!s^(String.make 1 !c))
    done; String.sub !s 0 (String.length !s - 1)
end

(* module Accelerometer = struct
 *   external x: unit -> int = "caml_microbit_accelerometer_x" [@@noalloc]
 *   external y: unit -> int = "caml_microbit_accelerometer_y" [@@noalloc]
 *   external z: unit -> int = "caml_microbit_accelerometer_z" [@@noalloc]
 *   external pitch: unit -> int = "caml_microbit_accelerometer_pitch" [@@noalloc]
 *   external roll: unit -> int = "caml_microbit_accelerometer_roll" [@@noalloc]
 * end
 * 
 * module Compass = struct
 *   external calibrate: unit -> unit = "caml_microbit_compass_calibrate" [@@noalloc]
 *   external heading: unit -> int = "caml_microbit_compass_heading" [@@noalloc]
 * end
 * 
 * module Radio = struct
 *   external init: unit -> unit = "caml_microbit_radio_init"
 * 
 *   external unsafe_send: string -> unit = "caml_microbit_radio_send"
 *   let send s =
 *     if(String.length s > 32) then invalid_arg "Radio.send";
 *     unsafe_send s
 * 
 *   external recv: unit -> string = "caml_microbit_radio_recv"
 * end *)

(* module MCUConnection = struct
 *   type pin = _pin
 *   type mode = _mode
 *   type level = _level
 *   let low = LOW
 *   let high = HIGH
 *   let input_mode = INPUT
 *   let output_mode = OUTPUT
 *   let digital_read = digital_read
 *   let digital_write = digital_write
 *   let analog_read = analog_read
 *   let analog_write = analog_write
 *   let pin_mode = pin_mode
 *   let delay = delay
 *   let millis = millis
 * end *)

(* module I2C(A: sig val address: int end) = struct
 *   external init: unit -> unit = "caml_microbit_i2c_init"
 * 
 *   external unsafe_write: int -> bytes -> unit = "caml_microbit_i2c_write"
 *   let write by = unsafe_write A.address by
 * 
 *   external unsafe_read: int -> bytes = "caml_microbit_i2c_read"
 *   let read () = unsafe_read A.address
 * end *)

(* module MakeSPIMaster(SC: sig val slavePin: pin end) = struct
 *   external init_master: unit -> unit = "caml_microbit_spi_init_master"
 * 
 *   let init () =
 *     digital_write SC.slavePin HIGH;
 *     init_master ()
 * 
 *   external transmit_master: char -> char = "caml_microbit_spi_transmit" [@@noalloc]
 * 
 *   let transmit c =
 *     digital_write SC.slavePin LOW;
 *     let r = transmit_master c in
 *     digital_write SC.slavePin HIGH;
 *     r
 * end *)
