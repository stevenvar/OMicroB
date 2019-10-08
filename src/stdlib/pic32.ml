(* type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
         | PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
         | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21
         | PIN22 | PIN23 | PIN24 | PIN25 | PIN26 | PIN27 | PIN28
         | PIN29 | PIN30 | PIN31 | PIN32
         | MISO | SCK | MOSI | SS
         | PINA0 | PINA1 | PINA2 | PINA3 | PINA4 | PINA5 | PINA6
         | PINA7 | PINA8 | PINA9 | PINA10 | PINA11 | PINA12
type _pin = pin

type mode = INPUT | OUTPUT | INPUT_PULLUP
type _mode = mode

type level = LOW | HIGH
type _level = level

external pin_mode: pin -> mode -> unit = "caml_pic32_pin_mode" [@@noalloc]
external digital_write: pin -> level -> unit = "caml_pic32_digital_write" [@@noalloc]
external digital_read: pin -> level = "caml_pic32_digital_read" [@@noalloc]
external unsafe_analog_write: pin -> int -> unit = "caml_pic32_analog_write" [@@noalloc]

let analog_write p l =
  if (l < 0 || l >= 1024) then invalid_arg "analog_write: value should be between 0 and 1023";
  unsafe_analog_write p l

external unsafe_analog_read: pin -> int = "caml_pic32_analog_read" [@@noalloc]

let analog_read p =
  if (p <> PINA0 && p <> PINA1 && p <> PINA2 && p <> PINA3 && p <> PINA4 && p <> PINA5 && p <> PINA6 &&
      p <> PINA7 && p <> PINA8 && p <> PINA9 && p <> PINA10 && p <> PINA11 && p <> PINA12) then invalid_arg "analog_write: only pin PINA0 to PINA12 are supported";
  unsafe_analog_read p

external delay: int -> unit = "caml_pic32_delay" [@@noalloc]
external millis: unit -> int = "caml_pic32_millis" [@@noalloc]

external _init: unit -> unit = "caml_pic32_init" [@@noalloc]
external schedule_task: unit -> unit = "caml_pic32_schedule_task" [@@noalloc]

module Serial = struct
  external init: unit -> unit = "caml_pic32_serial_init" [@@noalloc]

  external write_char: char -> unit = "caml_pic32_serial_write_char" [@@noalloc]
  let write s = String.iter write_char s

  external read_char: unit -> char = "caml_pic32_serial_read_char" [@@noalloc]
  let read () =
    let s = ref ""
    and c = ref (read_char ()) in
    while((int_of_char !c) <> 0) do
      s := (!s^(String.make 1 !c));
      c := (read_char ())
    done;
    if(String.length !s > 0) then String.sub !s 0 ((String.length !s)-1) else ""
end

module MCUConnection = struct
  type pin = _pin
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
end *)
