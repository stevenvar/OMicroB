open Avr

type register =
  | PORTB | PORTC | PORTD
  | DDRB | DDRC | DDRD
  | PINB | PINC | PIND
  | SPCR | SPSR | SPDR
type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE ] pin
  | PIN1  : [< `DREAD | `DWRITE ] pin
  | PIN2  : [< `DREAD | `DWRITE ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN4  : [< `DREAD | `DWRITE ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN7  : [< `DREAD | `DWRITE ] pin
  | PIN8  : [< `DREAD | `DWRITE ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN12 : [< `DREAD | `DWRITE ] pin
  | PIN13 : [< `DREAD | `DWRITE ] pin
  | MISO  : [< `MISO ] pin
  | SCK   : [< `SCK ] pin
  | MOSI  : [< `MOSI ] pin
  | SS    : [< `SS ] pin
  | PINA0 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA1 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA2 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA3 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA4 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA5 : [< `DREAD | `DWRITE | `AREAD ] pin

let port_of_pin : type a. a pin -> register =
  function
  | PIN0 -> PORTD
  | PIN1 -> PORTD
  | PIN2 -> PORTD
  | PIN3 -> PORTD
  | PIN4 -> PORTD
  | PIN5 -> PORTD
  | PIN6 -> PORTD
  | PIN7 -> PORTD
  | PIN8 -> PORTB
  | PIN9 -> PORTB
  | PIN10 -> PORTB
  | PIN11 -> PORTB
  | PIN12 -> PORTB
  | PIN13 -> PORTB
  | MISO -> PORTB
  | SCK -> PORTB
  | MOSI -> PORTB
  | SS -> PORTB
  | PINA0 -> PORTC
  | PINA1 -> PORTC
  | PINA2 -> PORTC
  | PINA3 -> PORTC
  | PINA4 -> PORTC
  | PINA5 -> PORTC

let ddr_of_pin : type a. a pin -> register=
  function
  | PIN0 -> DDRD
  | PIN1 -> DDRD
  | PIN2 -> DDRD
  | PIN3 -> DDRD
  | PIN4 -> DDRD
  | PIN5 -> DDRD
  | PIN6 -> DDRD
  | PIN7 -> DDRD
  | PIN8 -> DDRB
  | PIN9 -> DDRB
  | PIN10 -> DDRB
  | PIN11 -> DDRB
  | PIN12 -> DDRB
  | PIN13 -> DDRB
  | MISO -> DDRB
  | SCK -> DDRB
  | MOSI -> DDRB
  | SS -> DDRB
  | PINA0 -> DDRC
  | PINA1 -> DDRC
  | PINA2 -> DDRC
  | PINA3 -> DDRC
  | PINA4 -> DDRC
  | PINA5 -> DDRC

let input_of_pin : type a. a pin -> register=
  function
  | PIN0 -> PIND
  | PIN1 -> PIND
  | PIN2 -> PIND
  | PIN3 -> PIND
  | PIN4 -> PIND
  | PIN5 -> PIND
  | PIN6 -> PIND
  | PIN7 -> PIND
  | PIN8 -> PINB
  | PIN9 -> PINB
  | PIN10 -> PINB
  | PIN11 -> PINB
  | PIN12 -> PINB
  | PIN13 -> PINB
  | MISO -> PINB
  | SCK -> PINB
  | MOSI -> PINB
  | SS -> PINB
  | PINA0 -> PINC
  | PINA1 -> PINC
  | PINA2 -> PINC
  | PINA3 -> PINC
  | PINA4 -> PINC
  | PINA5 -> PINC

let port_bit_of_pin : type a. a pin -> bit =
  function
  | PIN0 -> BIT0
  | PIN1 -> BIT1
  | PIN2 -> BIT2
  | PIN3 -> BIT3
  | PIN4 -> BIT4
  | PIN5 -> BIT5
  | PIN6 -> BIT6
  | PIN7 -> BIT7
  | PIN8 -> BIT0
  | PIN9 -> BIT1
  | PIN10 -> BIT2
  | PIN11 -> BIT3
  | PIN12 -> BIT4
  | PIN13 -> BIT5
  | MISO -> BIT4
  | SCK -> BIT5
  | MOSI -> BIT3
  | SS -> BIT0
  | PINA0 -> BIT0
  | PINA1 -> BIT1
  | PINA2 -> BIT2
  | PINA3 -> BIT3
  | PINA4 -> BIT4
  | PINA5 -> BIT5

let ddr_bit_of_pin : type a. a pin -> bit = port_bit_of_pin
let input_bit_of_pin : type a. a pin -> bit = port_bit_of_pin

external write_register : register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register : register -> int = "caml_read_register" [@@noalloc]
external set_bit : register -> 'a -> unit = "caml_set_bit" [@@noalloc]
external clear_bit : register -> 'a -> unit = "caml_clear_bit" [@@noalloc]
external read_bit : register -> 'a -> bool = "caml_read_bit" [@@noalloc]
external avr_analog_read : int -> int = "caml_avr_analog_read" [@@noalloc]

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

let channel_of_pin (p: [ `AREAD] pin) =
  match p with
  | PINA0 -> 0
  | PINA1 -> 1
  | PINA2 -> 2
  | PINA3 -> 3
  | PINA4 -> 4
  | PINA5 -> 5

let analog_read (p: [ `AREAD ] pin) =
  avr_analog_read (channel_of_pin p)

external do_pin_change_callback : register -> bit -> (unit -> unit) -> unit = "caml_avr_pin_change_callback"

let pin_change_callback p closure =
  let input = input_of_pin p in
  let bit = input_bit_of_pin p in
  do_pin_change_callback input bit closure
