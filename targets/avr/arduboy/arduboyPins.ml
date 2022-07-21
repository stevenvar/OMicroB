type register =
  | PORTB | PORTC | PORTD | PORTE | PORTF
  | DDRB | DDRC | DDRD | DDRE | DDRF
  | PINB | PINC | PIND | PINE | PINF
  | SPCR | SPSR | SPDR

let nb_registers = 8

type bit = BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5 | BIT6 | BIT7

type 'a pin =
  | PIN0  : [< `SIMUL ] pin
  | PIN1  : [< `SIMUL ] pin
  | PIN2  : [< `CART_CS | `SIMUL ] pin
  | PIN3  : [< `SIMUL ] pin
  | PIN4  : [< `OLED_DC | `DWRITE | `SIMUL ] pin
  | PIN5  : [< `SPEAKER_PLUS | `SIMUL ] pin
  | PIN6  : [< `OLED_RST | `DWRITE | `SIMUL ] pin
  | PIN7  : [< `BUTTON_A | `DREAD | `SIMUL ] pin
  | PIN8  : [< `BUTTON_B | `DREAD | `SIMUL ] pin
  | PIN9  : [< `LED_BLUE | `DWRITE | `SIMUL ] pin
  | PIN10 : [< `LED_RED | `DWRITE | `SIMUL ] pin
  | PIN12 : [< `OLED_CS | `DWRITE | `SIMUL ] pin
  | PIN11 : [< `LED_GREEN | `DWRITE | `SIMUL ] pin
  | PIN13 : [< `SPEAKER_MINUS | `SIMUL ] pin
  | MISO  : [< `MISO ] pin
  | SCK   : [< `SCK ] pin
  | MOSI  : [< `MOSI ] pin
  | SS    : [< `SS ] pin
  | PINA0 : [< `BUTTON_UP | `DREAD | `SIMUL ] pin
  | PINA1 : [< `BUTTON_RIGHT | `DREAD | `SIMUL ] pin
  | PINA2 : [< `BUTTON_LEFT | `DREAD | `SIMUL ] pin
  | PINA3 : [< `BUTTON_DOWN | `DREAD | `SIMUL ] pin
  | PINA4 : [< `SIMUL ] pin
  | PINA5 : [< `SIMUL ] pin

let nb_pins = 44

let port_of_pin : type a. a pin -> register =
  function
  | PIN0 -> PORTD
  | PIN1 -> PORTD
  | PIN2 -> PORTD
  | PIN3 -> PORTD
  | PIN4 -> PORTD
  | PIN5 -> PORTC
  | PIN6 -> PORTD
  | PIN7 -> PORTE
  | PIN8 -> PORTB
  | PIN9 -> PORTB
  | PIN10 -> PORTB
  | PIN11 -> PORTB
  | PIN12 -> PORTD
  | PIN13 -> PORTC
  | MISO -> PORTB
  | SCK -> PORTB
  | MOSI -> PORTB
  | SS -> PORTB
  | PINA0 -> PORTF
  | PINA1 -> PORTF
  | PINA2 -> PORTF
  | PINA3 -> PORTF
  | PINA4 -> PORTF
  | PINA5 -> PORTF
let register_of_pin = port_of_pin

let ddr_of_pin : type a. a pin -> register =
  function
  | PIN0 -> DDRD
  | PIN1 -> DDRD
  | PIN2 -> DDRD
  | PIN3 -> DDRD
  | PIN4 -> DDRD
  | PIN5 -> DDRC
  | PIN6 -> DDRD
  | PIN7 -> DDRE
  | PIN8 -> DDRB
  | PIN9 -> DDRB
  | PIN10 -> DDRB
  | PIN11 -> DDRB
  | PIN12 -> DDRD
  | PIN13 -> DDRC
  | MISO -> DDRB
  | SCK -> DDRB
  | MOSI -> DDRB
  | SS -> DDRB
  | PINA0 -> DDRF
  | PINA1 -> DDRF
  | PINA2 -> DDRF
  | PINA3 -> DDRF
  | PINA4 -> DDRF
  | PINA5 -> DDRF

let input_of_pin : type a. a pin -> register =
  function
  | PIN0 -> PIND
  | PIN1 -> PIND
  | PIN2 -> PIND
  | PIN3 -> PIND
  | PIN4 -> PIND
  | PIN5 -> PINC
  | PIN6 -> PIND
  | PIN7 -> PINE
  | PIN8 -> PINB
  | PIN9 -> PINB
  | PIN10 -> PINB
  | PIN11 -> PINB
  | PIN12 -> PIND
  | PIN13 -> PINC
  | MISO -> PINB
  | SCK -> PINB
  | MOSI -> PINB
  | SS -> PINB
  | PINA0 -> PINF
  | PINA1 -> PINF
  | PINA2 -> PINF
  | PINA3 -> PINF
  | PINA4 -> PINF
  | PINA5 -> PINF

let port_bit_of_pin : type a. a pin -> bit =
  function
  | PIN0 -> BIT2
  | PIN1 -> BIT3
  | PIN2 -> BIT1
  | PIN3 -> BIT0
  | PIN4 -> BIT4
  | PIN5 -> BIT6
  | PIN6 -> BIT7
  | PIN7 -> BIT6
  | PIN8 -> BIT4
  | PIN9 -> BIT5
  | PIN10 -> BIT6
  | PIN11 -> BIT7
  | PIN12 -> BIT6
  | PIN13 -> BIT7
  | MISO -> BIT3
  | SCK -> BIT1
  | MOSI -> BIT2
  | SS -> BIT0
  | PINA0 -> BIT7
  | PINA1 -> BIT6
  | PINA2 -> BIT5
  | PINA3 -> BIT4
  | PINA4 -> BIT1
  | PINA5 -> BIT0

let ddr_bit_of_pin : type a. a pin -> bit = port_bit_of_pin
let input_bit_of_pin : type a. a pin -> bit = port_bit_of_pin
let bit_of_pin = port_bit_of_pin

(** Simulation *)

let spdr = SPDR

exception Invalid_argument of string

external raise : exn -> 'a = "%raise"

let invalid_arg s =
  raise (Invalid_argument s)

let pin_of_string : _ -> [ `SIMUL ] pin = function
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
  | _ -> invalid_arg "pin_of_string"

let name_of_pin : [ `SIMUL ] pin -> string = function
  | PIN0 -> "PIN0/RX0"
  | PIN1 -> "PIN1/TX0"
  | PIN2 -> "PIN2"
  | PIN3 -> "PIN3"
  | PIN4 -> "PIN4"
  | PIN5 -> "PIN5"
  | PIN6 -> "PIN6"
  | PIN7 -> "PIN7"
  | PIN8 -> "PIN8"
  | PIN9 -> "PIN9"
  | PIN10 -> "PIN10"
  | PIN11 -> "PIN11"
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
  | 'E' -> PORTE
  | 'F' -> PORTF
  | _ -> invalid_arg "register_of_char"

let char_of_register = function
  | PORTB -> 'B'
  | PORTC -> 'C'
  | PORTD -> 'D'
  | PORTE -> 'E'
  | PORTF -> 'F'
  | _ -> invalid_arg "char_of_register"

let index_of_register = function
  | PORTB -> 0
  | PORTC -> 1
  | PORTD -> 2
  | PORTE -> 3
  | PORTF -> 4
  | _ -> invalid_arg "index_of_register"

let register_of_index = function
  | 0 -> PORTB
  | 1 -> PORTC
  | 2 -> PORTD
  | 3 -> PORTE
  | 4 -> PORTF
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

let pin_of_register_bit register bit : [ `SIMUL ] pin =
  match register, bit with
  | (PORTD, BIT2) -> PIN0
  | (PORTD, BIT3) -> PIN1
  | (PORTD, BIT1) -> PIN2
  | (PORTD, BIT0) -> PIN3
  | (PORTD, BIT4) -> PIN4
  | (PORTC, BIT6) -> PIN5
  | (PORTD, BIT7) -> PIN6
  | (PORTE, BIT6) -> PIN7
  | (PORTB, BIT4) -> PIN8
  | (PORTB, BIT5) -> PIN9
  | (PORTB, BIT6) -> PIN10
  | (PORTB, BIT7) -> PIN11
  | (PORTD, BIT6) -> PIN12
  | (PORTC, BIT7) -> PIN13
  | (PORTF, BIT7) -> PINA0
  | (PORTF, BIT6) -> PINA1
  | (PORTF, BIT5) -> PINA2
  | (PORTF, BIT4) -> PINA3
  | (PORTF, BIT1) -> PINA4
  | (PORTF, BIT0) -> PINA5
  | _ -> invalid_arg "pin_of_register_bit"

(* Physical placement on the microcontroler *)

let num_of_pin : [ `SIMUL ] pin -> int = function
  | PIN0 -> 19
  | PIN1 -> 20
  | PIN2 -> 18
  | PIN3 -> 17
  | PIN4 -> 24
  | PIN5 -> 30
  | PIN6 -> 26
  | PIN7 -> 0
  | PIN8 -> 27
  | PIN9 -> 28
  | PIN10 -> 29
  | PIN11 -> 11
  | PIN12 -> 25
  | PIN13 -> 31
  | PINA0 -> 35
  | PINA1 -> 36
  | PINA2 -> 37
  | PINA3 -> 38
  | PINA4 -> 39
  | PINA5 -> 40

let pin_of_num = function
  | 19 -> Some PIN0
  | 20 -> Some PIN1
  | 18 -> Some PIN2
  | 17 -> Some PIN3
  | 24 -> Some PIN4
  | 30 -> Some PIN5
  | 26 -> Some PIN6
  | 0 -> Some PIN7
  | 27 -> Some PIN8
  | 28 -> Some PIN9
  | 29 -> Some PIN10
  | 11 -> Some PIN11
  | 25 -> Some PIN12
  | 31 -> Some PIN13
  | 35 -> Some PINA0
  | 36 -> Some PINA1
  | 37 -> Some PINA2
  | 38 -> Some PINA3
  | 39 -> Some PINA4
  | 40 -> Some PINA5
  | _ -> None
