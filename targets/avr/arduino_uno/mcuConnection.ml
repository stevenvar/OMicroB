open Avr

include ArduinoUnoPins

external write_register : register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register : register -> int = "caml_read_register" [@@noalloc]
external set_bit : register -> 'a -> unit = "caml_set_bit" [@@noalloc]
external clear_bit : register -> 'a -> unit = "caml_clear_bit" [@@noalloc]
external read_bit : register -> 'a -> bool = "caml_read_bit" [@@noalloc]
external avr_analog_read : analog_channel -> int = "caml_avr_analog_read" [@@noalloc]

let pin_mode p m =
  let port = port_of_pin p in
  let bit = port_bit_of_pin p in
  let ddr_bit = ddr_bit_of_pin p in
  let ddr = ddr_of_pin p in
  match m with
  | OUTPUT ->
    set_bit ddr ddr_bit
  | INPUT ->
    clear_bit ddr ddr_bit;
    clear_bit port bit
  | INPUT_PULLUP ->
    clear_bit ddr ddr_bit;
    set_bit port bit

let digital_write p b =
  let port = port_of_pin p in
  let bit = port_bit_of_pin p in
  match b with
  | HIGH -> set_bit port bit
  | LOW -> clear_bit port bit

let digital_read p =
  let input = input_of_pin p in
  let bit = input_bit_of_pin p in
  match read_bit input bit with
  | true -> HIGH
  | false -> LOW

let analog_read (p: [ `AREAD ] pin) =
  avr_analog_read (analog_of_pin p)

external do_pin_change_callback : register -> bit -> (unit -> unit) -> unit = "caml_avr_pin_change_callback"

let pin_change_callback p closure =
  let input = input_of_pin p in
  let bit = input_bit_of_pin p in
  do_pin_change_callback input bit closure

type 'a _pin = 'a pin
type _mode = mode
type _level = level
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
  let analog_write _ _ = failwith "Not implemented"
  let pin_mode = pin_mode
  let delay = delay
  let millis = millis
end
