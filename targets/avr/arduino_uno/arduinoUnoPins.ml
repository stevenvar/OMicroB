type register =
  | PORTB | PORTC | PORTD
  | DDRB | DDRC | DDRD
  | PINB | PINC | PIND
  | SPCR | SPSR | SPDR

let nb_registers = 6

type bit = BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5 | BIT6 | BIT7

type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN1  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN2  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN4  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN7  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN8  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN12 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN13 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | MISO  : [< `MISO ] pin
  | SCK   : [< `SCK ] pin
  | MOSI  : [< `MOSI ] pin
  | SS    : [< `SS ] pin
  | PINA0 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA1 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA2 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA3 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA4 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA5 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin

let nb_pins = 28

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
let register_of_pin = port_of_pin

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
let bit_of_pin = port_bit_of_pin

(** Simulation *)

let spdr = SPDR

exception Invalid_argument of string

external raise : exn -> 'a = "%raise"

let invalid_arg s =
  raise (Invalid_argument s)

exception Pin_of_string of string

let pin_of_string : string -> [ `SIMUL ] pin = function
  | "PIN0" -> PIN0
  | "PIN1" -> PIN1
  | "PIN2" -> PIN2
  | "PIN3" -> PIN3
  | "PIN4" -> PIN4
  | "PIN5" -> PIN5
  | "PIN6" -> PIN6
  | "PIN7" -> PIN7
  | "PIN8" -> PIN8
  | "PIN9" -> PIN9
  | "PIN10" -> PIN10
  | "PIN11" -> PIN11
  | "PIN12" -> PIN12
  | "PIN13" -> PIN13
  | "PINA0" -> PINA0
  | "PINA1" -> PINA1
  | "PINA2" -> PINA2
  | "PINA3" -> PINA3
  | "PINA4" -> PINA4
  | "PINA5" -> PINA5
  | s -> raise (Pin_of_string s)

let name_of_pin : [ `SIMUL ] pin -> string = function
  | PIN0 -> "PIN0/RX0"
  | PIN1 -> "PIN1/TX0"
  | PIN2 -> "PIN2"
  | PIN3 -> "PIN3/PWM"
  | PIN4 -> "PIN4"
  | PIN5 -> "PIN5"
  | PIN6 -> "PIN6"
  | PIN7 -> "PIN7"
  | PIN8 -> "PIN8"
  | PIN9 -> "PIN9/PWM"
  | PIN10 -> "PIN10/PWM"
  | PIN11 -> "PIN11/PWM"
  | PIN12 -> "PIN12"
  | PIN13 -> "PIN13"
  | PINA0 -> "A0"
  | PINA1 -> "A1"
  | PINA2 -> "A2"
  | PINA3 -> "A3"
  | PINA4 -> "A4"
  | PINA5 -> "A5"

let register_of_char = function
  | 'B' -> PORTB
  | 'C' -> PORTC
  | 'D' -> PORTD
  | _ -> invalid_arg "register_of_char"

let char_of_register = function
  | PORTB -> 'B'
  | PORTC -> 'C'
  | PORTD -> 'D'
  | _ -> invalid_arg "char_of_register"

let index_of_register = function
  | PORTB -> 0
  | PORTC -> 1
  | PORTD -> 2
  | _ -> invalid_arg "index_of_register"

let register_of_index = function
  | 0 -> PORTB
  | 1 -> PORTC
  | 2 -> PORTD
  | _ -> invalid_arg "register_of_index"

let index_of_bit = function
  | BIT0 -> 0
  | BIT1 -> 1
  | BIT2 -> 2
  | BIT3 -> 3
  | BIT4 -> 4
  | BIT5 -> 5
  | BIT6 -> 6
  | BIT7 -> 7

let bit_of_index = function
  | 0 -> BIT0
  | 1 -> BIT1
  | 2 -> BIT2
  | 3 -> BIT3
  | 4 -> BIT4
  | 5 -> BIT5
  | 6 -> BIT6
  | 7 -> BIT7
  | _ -> invalid_arg "bit_of_index"

exception Pin_of_register_bit of register * bit

let pin_of_register_bit register bit : [ `SIMUL ] pin =
  match register, bit with
  | (PORTD, BIT0) -> PIN0
  | (PORTD, BIT1) -> PIN1
  | (PORTD, BIT2) -> PIN2
  | (PORTD, BIT3) -> PIN3
  | (PORTD, BIT4) -> PIN4
  | (PORTD, BIT5) -> PIN5
  | (PORTD, BIT6) -> PIN6
  | (PORTD, BIT7) -> PIN7
  | (PORTB, BIT0) -> PIN8
  | (PORTB, BIT1) -> PIN9
  | (PORTB, BIT2) -> PIN10
  | (PORTB, BIT3) -> PIN11
  | (PORTB, BIT4) -> PIN12
  | (PORTB, BIT5) -> PIN13
  | (PORTC, BIT0) -> PINA0
  | (PORTC, BIT1) -> PINA1
  | (PORTC, BIT2) -> PINA2
  | (PORTC, BIT3) -> PINA3
  | (PORTC, BIT4) -> PINA4
  | (PORTC, BIT5) -> PINA5
  | _ -> raise (Pin_of_register_bit (register, bit))

(* Physical placement on the microcontroler *)

let num_of_pin : [ `SIMUL ] pin -> int = function
  | PIN0 -> 1
  | PIN1 -> 2
  | PIN2 -> 3
  | PIN3 -> 4
  | PIN4 -> 5
  | PIN5 -> 10
  | PIN6 -> 11
  | PIN7 -> 12
  | PIN8 -> 13
  | PIN9 -> 14
  | PIN10 -> 15
  | PIN11 -> 16
  | PIN12 -> 17
  | PIN13 -> 18
  | PINA0 -> 22
  | PINA1 -> 23
  | PINA2 -> 24
  | PINA3 -> 25
  | PINA4 -> 26
  | PINA5 -> 27

let pin_of_num : int -> [ `SIMUL ] pin option = function
  | 1 -> Some PIN0
  | 2 -> Some PIN1
  | 3 -> Some PIN2
  | 4 -> Some PIN3
  | 5 -> Some PIN4
  | 10 -> Some PIN5
  | 11 -> Some PIN6
  | 12 -> Some PIN7
  | 13 -> Some PIN8
  | 14 -> Some PIN9
  | 15 -> Some PIN10
  | 16 -> Some PIN11
  | 17 -> Some PIN12
  | 18 -> Some PIN13
  | 22 -> Some PINA0
  | 23 -> Some PINA1
  | 24 -> Some PINA2
  | 25 -> Some PINA3
  | 26 -> Some PINA4
  | 27 -> Some PINA5
  | _ -> None

(* Analog *)

type analog_channel =
  | AN0
  | AN1
  | AN2
  | AN3
  | AN4
  | AN5

let analog_of_pin : [> `AREAD ] pin -> analog_channel = function
  | PINA0 -> AN0
  | PINA1 -> AN1
  | PINA2 -> AN2
  | PINA3 -> AN3
  | PINA4 -> AN4
  | PINA5 -> AN5

let pin_of_analog : analog_channel -> [< `AREAD | `SIMUL ] pin = function
  | AN0 -> PINA0
  | AN1 -> PINA1
  | AN2 -> PINA2
  | AN3 -> PINA3
  | AN4 -> PINA4
  | AN5 -> PINA5

let int_of_analog = function
  | AN0 -> 0
  | AN1 -> 1
  | AN2 -> 2
  | AN3 -> 3
  | AN4 -> 4
  | AN5 -> 5

let analog_of_int = function
  | 0 -> AN0
  | 1 -> AN1
  | 2 -> AN2
  | 3 -> AN3
  | 4 -> AN4
  | 5 -> AN5
  | _ -> invalid_arg "analog_of_int"

let analog_pin_of_string : string -> [ `AREAD | `SIMUL ] pin = function
  | "PINA0" -> PINA0
  | "PINA1" -> PINA1
  | "PINA2" -> PINA2
  | "PINA3" -> PINA3
  | "PINA4" -> PINA4
  | "PINA5" -> PINA5
  | _ -> invalid_arg "analog_pin_of_string"
