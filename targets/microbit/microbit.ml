(*******************************************************************************)
(*                                                                             *)
(*                           Microbit library                                  *)
(*                                                                             *)
(*                    Basile Pesin, Sorbonne Université                        *)
(*******************************************************************************)

type level = LOW | HIGH
type _level = level

type button = A | B

type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN1  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN2  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN4  : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM | `BUTTON_A ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN7  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN8  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM | `AREAD ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM | `BUTTON_B ] pin
  | PIN12 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN13 : [< `DREAD | `DWRITE | `PWM | `SCK ] pin
  | PIN14 : [< `DREAD | `DWRITE | `PWM | `MISO ] pin
  | PIN15 : [< `DREAD | `DWRITE | `PWM | `MOSI ] pin
  | PIN16 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN19 : [< `DREAD | `DWRITE | `PWM | `SCL ] pin
  | PIN20 : [< `DREAD | `DWRITE | `PWM | `SDA ] pin
type 'a _pin = 'a pin

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

external pin_mode: 'a pin -> mode -> unit = "caml_microbit_pin_mode" [@@noalloc]

external digital_write: [ `DWRITE ] pin -> level -> unit = "caml_microbit_digital_write" [@@noalloc]

external digital_read: [ `DREAD ] pin -> level = "caml_microbit_digital_read" [@@noalloc]

external unsafe_analog_write: [ `PWM ] pin -> int -> unit = "caml_microbit_analog_write" [@@noalloc]

let analog_write p l =
  if (l < 0 || l >= 1024) then invalid_arg "analog_write: value should be between 0 and 1024";
  unsafe_analog_write p l

external analog_read: [ `AREAD ] pin -> int = "caml_microbit_analog_read" [@@noalloc]

external delay: int -> unit = "caml_delay" [@@noalloc]

external millis : unit -> int = "caml_millis" [@@noalloc]

module Screen = struct
  let init () = ()
  external print_string: string -> unit = "caml_microbit_print_string" [@@noalloc]
  let print_int i =
    print_string (string_of_int i)
  external clear_screen: unit -> unit = "caml_microbit_clear_screen" [@@noalloc]
  external unsafe_set_pixel: int -> int -> bool -> unit = "caml_microbit_write_pixel" [@@noalloc]

  let print_newline () = ()

  let set_pixel x y l =
    if x < 0 || x > 4 || y < 0 || y > 4 then invalid_arg "write_pixel";
    unsafe_set_pixel x y l

  let print_image i =
    if (List.length i) <> 5 then invalid_arg "print_image";
    List.iteri (fun y l ->
        if List.length l <> 5 then invalid_arg "print_image";
        List.iteri (fun x l -> set_pixel x y l) l) i
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

module Accelerometer = struct
  external x: unit -> int = "caml_microbit_accelerometer_x" [@@noalloc]
  external y: unit -> int = "caml_microbit_accelerometer_y" [@@noalloc]
  external z: unit -> int = "caml_microbit_accelerometer_z" [@@noalloc]
end

(* module Compass = struct *)
(*   external calibrate: unit -> unit = "caml_microbit_compass_calibrate" [@@noalloc] *)
(*   external heading: unit -> int = "caml_microbit_compass_heading" [@@noalloc] *)
(* end *)

module Radio = struct
  external unsafe_send: string -> unit = "caml_microbit_radio_send"
  let send s =
    if(String.length s > 32) then invalid_arg "Radio.send";
    unsafe_send s

  external recv: unit -> string = "caml_microbit_radio_recv"
end

module MCUConnection = struct
  type 'a pin = 'a _pin
  type mode = _mode
  type level = _level
  let low = LOW
  let high = HIGH
  let input_mode = INPUT
  let output_mode = OUTPUT
  let digital_read = digital_read
  let digital_write = digital_write
  let analog_read = analog_read
  let analog_write = analog_write
  let pin_mode = pin_mode
  let delay = delay
  let millis = millis
end

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
