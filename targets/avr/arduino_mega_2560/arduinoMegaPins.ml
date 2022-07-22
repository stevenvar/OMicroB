type register =
  | PORTA | PORTB | PORTC | PORTD | PORTE | PORTF | PORTG | PORTH | PORTJ | PORTK | PORTL
  | DDRA | DDRB | DDRC | DDRD | DDRE | DDRF | DDRG | DDRH | DDRJ | DDRK | DDRL
  | PINA | PINB | PINC | PIND | PINE | PINF | PING | PINH | PINJ | PINK | PINL
  | SPCR | SPSR | SPDR

type bit = BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5 | BIT6 | BIT7

type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN1  : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN2  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN4  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN7  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN8  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN12 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN13 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN14 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN15 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN16 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN17 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN18 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN19 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN20 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN21 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN22 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN23 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN24 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN25 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN26 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN27 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN28 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN29 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN30 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN31 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN32 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN33 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN34 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN35 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN36 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN37 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN38 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN39 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN40 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN41 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN42 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN43 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN44 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN45 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN46 : [< `DREAD | `DWRITE | `PWM | `SIMUL ] pin
  | PIN47 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN48 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN49 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN50 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN51 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN52 : [< `DREAD | `DWRITE | `SIMUL ] pin
  | PIN53 : [< `DREAD | `DWRITE | `SIMUL ] pin
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
  | PINA6 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA7 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA8 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA9 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA10 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA11 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA12 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA13 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA14 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin
  | PINA15 : [< `DREAD | `DWRITE | `AREAD | `SIMUL ] pin

let nb_pins = 100

let port_of_pin : type a. a pin -> register =
  function
  | PIN0 -> PORTE
  | PIN1 -> PORTE
  | PIN2 -> PORTE
  | PIN3 -> PORTE
  | PIN4 -> PORTG
  | PIN5 -> PORTE
  | PIN6 -> PORTH
  | PIN7 -> PORTH
  | PIN8 -> PORTH
  | PIN9 -> PORTH
  | PIN10 -> PORTB
  | PIN11 -> PORTB
  | PIN12 -> PORTB
  | PIN13 -> PORTB
  | PIN14 -> PORTJ
  | PIN15 -> PORTJ
  | PIN16 -> PORTH
  | PIN17 -> PORTH
  | PIN18 -> PORTD
  | PIN19 -> PORTD
  | PIN20 -> PORTD
  | PIN21 -> PORTD
  | PIN22 -> PORTA
  | PIN23 -> PORTA
  | PIN24 -> PORTA
  | PIN25 -> PORTA
  | PIN26 -> PORTA
  | PIN27 -> PORTA
  | PIN28 -> PORTA
  | PIN29 -> PORTA
  | PIN30 -> PORTC
  | PIN31 -> PORTC
  | PIN32 -> PORTC
  | PIN33 -> PORTC
  | PIN34 -> PORTC
  | PIN35 -> PORTC
  | PIN36 -> PORTC
  | PIN37 -> PORTC
  | PIN38 -> PORTD
  | PIN39 -> PORTG
  | PIN40 -> PORTG
  | PIN41 -> PORTG
  | PIN42 -> PORTL
  | PIN43 -> PORTL
  | PIN44 -> PORTL
  | PIN45 -> PORTL
  | PIN46 -> PORTL
  | PIN47 -> PORTL
  | PIN48 -> PORTL
  | PIN49 -> PORTL
  | PIN50 -> PORTB
  | PIN51 -> PORTB
  | PIN52 -> PORTB
  | PIN53 -> PORTB
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
  | PINA6 -> PORTF
  | PINA7 -> PORTF
  | PINA8 -> PORTK
  | PINA9 -> PORTK
  | PINA10 -> PORTK
  | PINA11 -> PORTK
  | PINA12 -> PORTK
  | PINA13 -> PORTK
  | PINA14 -> PORTK
  | PINA15 -> PORTK
let register_of_pin = port_of_pin

let ddr_of_pin : type a. a pin -> register=
  function
  | PIN0 -> DDRE
  | PIN1 -> DDRE
  | PIN2 -> DDRE
  | PIN3 -> DDRE
  | PIN4 -> DDRG
  | PIN5 -> DDRE
  | PIN6 -> DDRH
  | PIN7 -> DDRH
  | PIN8 -> DDRH
  | PIN9 -> DDRH
  | PIN10 -> DDRB
  | PIN11 -> DDRB
  | PIN12 -> DDRB
  | PIN13 -> DDRB
  | PIN14 -> DDRJ
  | PIN15 -> DDRJ
  | PIN16 -> DDRH
  | PIN17 -> DDRH
  | PIN18 -> DDRD
  | PIN19 -> DDRD
  | PIN20 -> DDRD
  | PIN21 -> DDRD
  | PIN22 -> DDRA
  | PIN23 -> DDRA
  | PIN24 -> DDRA
  | PIN25 -> DDRA
  | PIN26 -> DDRA
  | PIN27 -> DDRA
  | PIN28 -> DDRA
  | PIN29 -> DDRA
  | PIN30 -> DDRC
  | PIN31 -> DDRC
  | PIN32 -> DDRC
  | PIN33 -> DDRC
  | PIN34 -> DDRC
  | PIN35 -> DDRC
  | PIN36 -> DDRC
  | PIN37 -> DDRC
  | PIN38 -> DDRD
  | PIN39 -> DDRG
  | PIN40 -> DDRG
  | PIN41 -> DDRG
  | PIN42 -> DDRL
  | PIN43 -> DDRL
  | PIN44 -> DDRL
  | PIN45 -> DDRL
  | PIN46 -> DDRL
  | PIN47 -> DDRL
  | PIN48 -> DDRL
  | PIN49 -> DDRL
  | PIN50 -> DDRB
  | PIN51 -> DDRB
  | PIN52 -> DDRB
  | PIN53 -> DDRB
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
  | PINA6 -> DDRF
  | PINA7 -> DDRF
  | PINA8 -> DDRK
  | PINA9 -> DDRK
  | PINA10 -> DDRK
  | PINA11 -> DDRK
  | PINA12 -> DDRK
  | PINA13 -> DDRK
  | PINA14 -> DDRK
  | PINA15 -> DDRK

let input_of_pin : type a. a pin -> register=
  function
  | PIN0 -> PINE
  | PIN1 -> PINE
  | PIN2 -> PINE
  | PIN3 -> PINE
  | PIN4 -> PING
  | PIN5 -> PINE
  | PIN6 -> PINH
  | PIN7 -> PINH
  | PIN8 -> PINH
  | PIN9 -> PINH
  | PIN10 -> PINB
  | PIN11 -> PINB
  | PIN12 -> PINB
  | PIN13 -> PINB
  | PIN14 -> PINJ
  | PIN15 -> PINJ
  | PIN16 -> PINH
  | PIN17 -> PINH
  | PIN18 -> PIND
  | PIN19 -> PIND
  | PIN20 -> PIND
  | PIN21 -> PIND
  | PIN22 -> PINA
  | PIN23 -> PINA
  | PIN24 -> PINA
  | PIN25 -> PINA
  | PIN26 -> PINA
  | PIN27 -> PINA
  | PIN28 -> PINA
  | PIN29 -> PINA
  | PIN30 -> PINC
  | PIN31 -> PINC
  | PIN32 -> PINC
  | PIN33 -> PINC
  | PIN34 -> PINC
  | PIN35 -> PINC
  | PIN36 -> PINC
  | PIN37 -> PINC
  | PIN38 -> PIND
  | PIN39 -> PING
  | PIN40 -> PING
  | PIN41 -> PING
  | PIN42 -> PINL
  | PIN43 -> PINL
  | PIN44 -> PINL
  | PIN45 -> PINL
  | PIN46 -> PINL
  | PIN47 -> PINL
  | PIN48 -> PINL
  | PIN49 -> PINL
  | PIN50 -> PINB
  | PIN51 -> PINB
  | PIN52 -> PINB
  | PIN53 -> PINB
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
  | PINA6 -> PINF
  | PINA7 -> PINF
  | PINA8 -> PINK
  | PINA9 -> PINK
  | PINA10 -> PINK
  | PINA11 -> PINK
  | PINA12 -> PINK
  | PINA13 -> PINK
  | PINA14 -> PINK
  | PINA15 -> PINK

let port_bit_of_pin : type a. a pin -> bit =
  function
  | PIN0 -> BIT0
  | PIN1 -> BIT1
  | PIN2 -> BIT4
  | PIN3 -> BIT5
  | PIN4 -> BIT5
  | PIN5 -> BIT3
  | PIN6 -> BIT3
  | PIN7 -> BIT4
  | PIN8 -> BIT5
  | PIN9 -> BIT6
  | PIN10 -> BIT4
  | PIN11 -> BIT5
  | PIN12 -> BIT6
  | PIN13 -> BIT7
  | PIN14 -> BIT1
  | PIN15 -> BIT0
  | PIN16 -> BIT1
  | PIN17 -> BIT0
  | PIN18 -> BIT3
  | PIN19 -> BIT2
  | PIN20 -> BIT1
  | PIN21 -> BIT0
  | PIN22 -> BIT0
  | PIN23 -> BIT1
  | PIN24 -> BIT2
  | PIN25 -> BIT3
  | PIN26 -> BIT4
  | PIN27 -> BIT5
  | PIN28 -> BIT6
  | PIN29 -> BIT7
  | PIN30 -> BIT7
  | PIN31 -> BIT6
  | PIN32 -> BIT5
  | PIN33 -> BIT4
  | PIN34 -> BIT3
  | PIN35 -> BIT2
  | PIN36 -> BIT1
  | PIN37 -> BIT0
  | PIN38 -> BIT7
  | PIN39 -> BIT2
  | PIN40 -> BIT1
  | PIN41 -> BIT0
  | PIN42 -> BIT7
  | PIN43 -> BIT6
  | PIN44 -> BIT5
  | PIN45 -> BIT4
  | PIN46 -> BIT3
  | PIN47 -> BIT2
  | PIN48 -> BIT1
  | PIN49 -> BIT0
  | PIN50 -> BIT3
  | PIN51 -> BIT2
  | PIN52 -> BIT1
  | PIN53 -> BIT0
  | MISO -> BIT3
  | SCK -> BIT1
  | MOSI -> BIT2
  | SS -> BIT0
  | PINA0 -> BIT0
  | PINA1 -> BIT1
  | PINA2 -> BIT2
  | PINA3 -> BIT3
  | PINA4 -> BIT4
  | PINA5 -> BIT5
  | PINA6 -> BIT6
  | PINA7 -> BIT7
  | PINA8 -> BIT0
  | PINA9 -> BIT1
  | PINA10 -> BIT2
  | PINA11 -> BIT3
  | PINA12 -> BIT4
  | PINA13 -> BIT5
  | PINA14 -> BIT6
  | PINA15 -> BIT7

let ddr_bit_of_pin : type a. a pin -> bit = port_bit_of_pin
let input_bit_of_pin : type a. a pin -> bit = port_bit_of_pin

(** Simulation *)

let spdr = SPDR

let bit_of_pin = port_bit_of_pin

let nb_registers = 14

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
  | "PINA6" -> PINA6
  | "PINA7" -> PINA7
  | "PINA8" -> PINA8
  | "PINA9" -> PINA9
  | "PINA10" -> PINA10
  | "PINA11" -> PINA11
  | "PINA12" -> PINA12
  | "PINA13" -> PINA13
  | "PINA14" -> PINA14
  | "PINA15" -> PINA15
  | s -> raise (Pin_of_string s)

let name_of_pin : [ `SIMUL ] pin -> string = function
  | PIN0 -> "PIN0/RXO"
  | PIN1 -> "PIN1/TX0"
  | PIN2 -> "PIN2/PWM"
  | PIN3 -> "PIN3/PWM"
  | PIN4 -> "PIN4/PWM"
  | PIN5 -> "PIN5/PWM"
  | PIN6 -> "PIN6/PWM"
  | PIN7 -> "PIN7/PWM"
  | PIN8 -> "PIN8/PWM"
  | PIN9 -> "PIN9/PWM"
  | PIN10 -> "PIN10/PWM"
  | PIN11 -> "PIN11/PWM"
  | PIN12 -> "PIN12/PWM"
  | PIN13 -> "PIN13/PWM"
  | PIN14 -> "PIN14/TX3"
  | PIN15 -> "PIN15/RX3"
  | PIN16 -> "PIN16"
  | PIN17 -> "PIN17"
  | PIN18 -> "PIN18/TX1"
  | PIN19 -> "PIN19/RX1"
  | PIN20 -> "PIN20/SDA"
  | PIN21 -> "PIN21/SCL"
  | PIN22 -> "PIN22"
  | PIN23 -> "PIN23"
  | PIN24 -> "PIN24"
  | PIN25 -> "PIN25"
  | PIN26 -> "PIN26"
  | PIN27 -> "PIN27"
  | PIN28 -> "PIN28"
  | PIN29 -> "PIN29"
  | PIN30 -> "PIN30"
  | PIN31 -> "PIN31"
  | PIN32 -> "PIN32"
  | PIN33 -> "PIN33"
  | PIN34 -> "PIN34"
  | PIN35 -> "PIN35"
  | PIN36 -> "PIN36"
  | PIN37 -> "PIN37"
  | PIN38 -> "PIN38"
  | PIN39 -> "PIN39"
  | PIN40 -> "PIN40"
  | PIN41 -> "PIN41"
  | PIN42 -> "PIN42"
  | PIN43 -> "PIN43"
  | PIN44 -> "PIN44/PWM"
  | PIN45 -> "PIN45/PWM"
  | PIN46 -> "PIN46/PWM"
  | PIN47 -> "PIN47"
  | PIN48 -> "PIN48"
  | PIN49 -> "PIN49"
  | PIN50 -> "PIN50/MISO"
  | PIN51 -> "PIN51/MOSI"
  | PIN52 -> "PIN52/SCK"
  | PIN53 -> "PIN53/SS"

  | PINA0 -> "A0"
  | PINA1 -> "A1"
  | PINA2 -> "A2"
  | PINA3 -> "A3"
  | PINA4 -> "A4"
  | PINA5 -> "A5"
  | PINA6 -> "A6"
  | PINA7 -> "A7"
  | PINA8 -> "A8"
  | PINA9 -> "A9"
  | PINA10 -> "A10"
  | PINA12 -> "A12"
  | PINA11 -> "A11"
  | PINA13 -> "A13"
  | PINA14 -> "A14"
  | PINA15 -> "A15"


let register_of_char = function
  | 'A' -> PORTA
  | 'B' -> PORTB
  | 'C' -> PORTC
  | 'D' -> PORTD
  | 'E' -> PORTE
  | 'F' -> PORTF
  | 'G' -> PORTG
  | 'H' -> PORTH
  | 'J' -> PORTJ
  | 'K' -> PORTK
  | 'L' -> PORTL
  | _ -> invalid_arg "register_of_char"

let char_of_register = function
  | PORTA -> 'A'
  | PORTB -> 'B'
  | PORTC -> 'C'
  | PORTD -> 'D'
  | PORTE -> 'E'
  | PORTF -> 'F'
  | PORTG -> 'G'
  | PORTH -> 'H'
  | PORTJ -> 'J'
  | PORTK -> 'K'
  | PORTL -> 'L'
  | _ -> invalid_arg "char_of_register"

let index_of_register = function
  | PORTA -> 0
  | PORTB -> 1
  | PORTC -> 2
  | PORTD -> 3
  | PORTE -> 4
  | PORTF -> 5
  | PORTG -> 6
  | PORTH -> 7
  | PORTJ -> 8
  | PORTK -> 9
  | PORTL -> 10
  | _ -> invalid_arg "index_of_register"

let register_of_index = function
  | 0 -> PORTA
  | 1 -> PORTB
  | 2 -> PORTC
  | 3 -> PORTD
  | 4 -> PORTE
  | 5 -> PORTF
  | 6 -> PORTG
  | 7 -> PORTH
  | 8 -> PORTJ
  | 9 -> PORTK
  | 10 -> PORTL
  | _ -> invalid_arg "index_of_register"

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
  | (PORTE, BIT0) -> PIN0
  | (PORTE, BIT1) -> PIN1
  | (PORTE, BIT4) -> PIN2
  | (PORTE, BIT5) -> PIN3
  | (PORTG, BIT5) -> PIN4
  | (PORTE, BIT3) -> PIN5
  | (PORTH, BIT3) -> PIN6
  | (PORTH, BIT4) -> PIN7
  | (PORTH, BIT5) -> PIN8
  | (PORTH, BIT6) -> PIN9
  | (PORTB, BIT4) -> PIN10
  | (PORTB, BIT5) -> PIN11
  | (PORTB, BIT6) -> PIN12
  | (PORTB, BIT7) -> PIN13
  | (PORTJ, BIT1) -> PIN14
  | (PORTJ, BIT0) -> PIN15
  | (PORTH, BIT1) -> PIN16
  | (PORTH, BIT0) -> PIN17
  | (PORTD, BIT3) -> PIN18
  | (PORTD, BIT2) -> PIN19
  | (PORTD, BIT1) -> PIN20
  | (PORTD, BIT0) -> PIN21
  | (PORTA, BIT0) -> PIN22
  | (PORTA, BIT1) -> PIN23
  | (PORTA, BIT2) -> PIN24
  | (PORTA, BIT3) -> PIN25
  | (PORTA, BIT4) -> PIN26
  | (PORTA, BIT5) -> PIN27
  | (PORTA, BIT6) -> PIN28
  | (PORTA, BIT7) -> PIN29
  | (PORTC, BIT7) -> PIN30
  | (PORTC, BIT6) -> PIN31
  | (PORTC, BIT5) -> PIN32
  | (PORTC, BIT4) -> PIN33
  | (PORTC, BIT3) -> PIN34
  | (PORTC, BIT2) -> PIN35
  | (PORTC, BIT1) -> PIN36
  | (PORTC, BIT0) -> PIN37
  | (PORTD, BIT7) -> PIN38
  | (PORTG, BIT2) -> PIN39
  | (PORTG, BIT1) -> PIN40
  | (PORTG, BIT0) -> PIN41
  | (PORTL, BIT7) -> PIN42
  | (PORTL, BIT6) -> PIN43
  | (PORTL, BIT5) -> PIN44
  | (PORTL, BIT4) -> PIN45
  | (PORTL, BIT3) -> PIN46
  | (PORTL, BIT2) -> PIN47
  | (PORTL, BIT1) -> PIN48
  | (PORTL, BIT0) -> PIN49
  | (PORTB, BIT3) -> PIN50
  | (PORTB, BIT2) -> PIN51
  | (PORTB, BIT1) -> PIN52
  | (PORTB, BIT0) -> PIN53
  | (PORTF, BIT0) -> PINA0
  | (PORTF, BIT1) -> PINA1
  | (PORTF, BIT2) -> PINA2
  | (PORTF, BIT3) -> PINA3
  | (PORTF, BIT4) -> PINA4
  | (PORTF, BIT5) -> PINA5
  | (PORTF, BIT6) -> PINA6
  | (PORTF, BIT7) -> PINA7
  | (PORTK, BIT0) -> PINA8
  | (PORTK, BIT1) -> PINA9
  | (PORTK, BIT2) -> PINA10
  | (PORTK, BIT3) -> PINA11
  | (PORTK, BIT4) -> PINA12
  | (PORTK, BIT5) -> PINA13
  | (PORTK, BIT6) -> PINA14
  | (PORTK, BIT7) -> PINA15
  | _ -> raise (Pin_of_register_bit (register, bit))

(* Physical placement on the microcontroler *)

let num_of_pin : [ `SIMUL ] pin -> int = function
  | PIN0 -> 1
  | PIN1 -> 2
  | PIN2 -> 5
  | PIN3 -> 6
  | PIN4 -> 0
  | PIN5 -> 4
  | PIN6 -> 14
  | PIN7 -> 15
  | PIN8 -> 16
  | PIN9 -> 17
  | PIN10 -> 22
  | PIN11 -> 23
  | PIN12 -> 24
  | PIN13 -> 25
  | PIN14 -> 63
  | PIN15 -> 62
  | PIN16 -> 12
  | PIN17 -> 11
  | PIN18 -> 45
  | PIN19 -> 44
  | PIN20 -> 43
  | PIN21 -> 42
  | PIN22 -> 77
  | PIN23 -> 76
  | PIN24 -> 75
  | PIN25 -> 74
  | PIN26 -> 73
  | PIN27 -> 72
  | PIN28 -> 71
  | PIN29 -> 70
  | PIN30 -> 59
  | PIN31 -> 58
  | PIN32 -> 57
  | PIN33 -> 56
  | PIN34 -> 55
  | PIN35 -> 54
  | PIN36 -> 53
  | PIN37 -> 52
  | PIN38 -> 49
  | PIN39 -> 69
  | PIN40 -> 51
  | PIN41 -> 50
  | PIN42 -> 41
  | PIN43 -> 40
  | PIN44 -> 39
  | PIN45 -> 38
  | PIN46 -> 37
  | PIN47 -> 36
  | PIN48 -> 35
  | PIN49 -> 34
  | PIN50 -> 21
  | PIN51 -> 20
  | PIN52 -> 19
  | PIN53 -> 18
  | PINA0 -> 96
  | PINA1 -> 95
  | PINA2 -> 94
  | PINA3 -> 93
  | PINA4 -> 92
  | PINA5 -> 91
  | PINA6 -> 90
  | PINA7 -> 89
  | PINA8 -> 88
  | PINA9 -> 87
  | PINA10 -> 86
  | PINA11 -> 85
  | PINA12 -> 84
  | PINA13 -> 83
  | PINA14 -> 82
  | PINA15 -> 81

let pin_of_num : int -> [ `SIMUL ] pin option = function
  | 1 -> Some PIN0
  | 2 -> Some PIN1
  | 5 -> Some PIN2
  | 6 -> Some PIN3
  | 0 -> Some PIN4
  | 4 -> Some PIN5
  | 14 -> Some PIN6
  | 15 -> Some PIN7
  | 16 -> Some PIN8
  | 17 -> Some PIN9
  | 22 -> Some PIN10
  | 23 -> Some PIN11
  | 24 -> Some PIN12
  | 25 -> Some PIN13
  | 63 -> Some PIN14
  | 62 -> Some PIN15
  | 12 -> Some PIN16
  | 11 -> Some PIN17
  | 45 -> Some PIN18
  | 44 -> Some PIN19
  | 43 -> Some PIN20
  | 42 -> Some PIN21
  | 77 -> Some PIN22
  | 76 -> Some PIN23
  | 75 -> Some PIN24
  | 74 -> Some PIN25
  | 73 -> Some PIN26
  | 72 -> Some PIN27
  | 71 -> Some PIN28
  | 70 -> Some PIN29
  | 59 -> Some PIN30
  | 58 -> Some PIN31
  | 57 -> Some PIN32
  | 56 -> Some PIN33
  | 55 -> Some PIN34
  | 54 -> Some PIN35
  | 53 -> Some PIN36
  | 52 -> Some PIN37
  | 49 -> Some PIN38
  | 69 -> Some PIN39
  | 51 -> Some PIN40
  | 50 -> Some PIN41
  | 41 -> Some PIN42
  | 40 -> Some PIN43
  | 39 -> Some PIN44
  | 38 -> Some PIN45
  | 37 -> Some PIN46
  | 36 -> Some PIN47
  | 35 -> Some PIN48
  | 34 -> Some PIN49
  | 21 -> Some PIN50
  | 20 -> Some PIN51
  | 19 -> Some PIN52
  | 18 -> Some PIN53
  | 96 -> Some PINA0
  | 95 -> Some PINA1
  | 94 -> Some PINA2
  | 93 -> Some PINA3
  | 92 -> Some PINA4
  | 91 -> Some PINA5
  | 90 -> Some PINA6
  | 89 -> Some PINA7
  | 88 -> Some PINA8
  | 87 -> Some PINA9
  | 86 -> Some PINA10
  | 85 -> Some PINA11
  | 84 -> Some PINA12
  | 83 -> Some PINA13
  | 82 -> Some PINA14
  | 81 -> Some PINA15
  | _ -> None

(* Analog *)

type analog_channel =
  | AN0
  | AN1
  | AN2
  | AN3
  | AN4
  | AN5
  | AN6
  | AN7
  | AN8
  | AN9
  | AN10
  | AN11
  | AN12
  | AN13
  | AN14
  | AN15

let analog_of_pin : [> `AREAD ] pin -> analog_channel = function
  | PINA0 -> AN0
  | PINA1 -> AN1
  | PINA2 -> AN2
  | PINA3 -> AN3
  | PINA4 -> AN4
  | PINA5 -> AN5
  | PINA6 -> AN6
  | PINA7 -> AN7
  | PINA8 -> AN8
  | PINA9 -> AN9
  | PINA10 -> AN10
  | PINA11 -> AN11
  | PINA12 -> AN12
  | PINA13 -> AN13
  | PINA14 -> AN14
  | PINA15 -> AN15

let pin_of_analog : analog_channel -> [< `AREAD | `SIMUL ] pin = function
  | AN0 -> PINA0
  | AN1 -> PINA1
  | AN2 -> PINA2
  | AN3 -> PINA3
  | AN4 -> PINA4
  | AN5 -> PINA5
  | AN6 -> PINA6
  | AN7 -> PINA7
  | AN8 -> PINA8
  | AN9 -> PINA9
  | AN10 -> PINA10
  | AN11 -> PINA11
  | AN12 -> PINA12
  | AN13 -> PINA13
  | AN14 -> PINA14
  | AN15 -> PINA15

let int_of_analog = function
  | AN0 -> 0
  | AN1 -> 1
  | AN2 -> 2
  | AN3 -> 3
  | AN4 -> 4
  | AN5 -> 5
  | AN6 -> 6
  | AN7 -> 7
  | AN8 -> 8
  | AN9 -> 9
  | AN10 -> 10
  | AN11 -> 11
  | AN12 -> 12
  | AN13 -> 13
  | AN14 -> 14
  | AN15 -> 15

let analog_of_int = function
  | 0 -> AN0
  | 1 -> AN1
  | 2 -> AN2
  | 3 -> AN3
  | 4 -> AN4
  | 5 -> AN5
  | 6 -> AN6
  | 7 -> AN7
  | 8 -> AN8
  | 9 -> AN9
  | 10 -> AN10
  | 11 -> AN11
  | 12 -> AN12
  | 13 -> AN13
  | 14 -> AN14
  | 15 -> AN15
  | _ -> invalid_arg "analog_of_int"

let analog_pin_of_string : string -> [ `AREAD | `SIMUL ] pin = function
  | "PINA0" -> PINA0
  | "PINA1" -> PINA1
  | "PINA2" -> PINA2
  | "PINA3" -> PINA3
  | "PINA4" -> PINA4
  | "PINA5" -> PINA5
  | "PINA6" -> PINA6
  | "PINA7" -> PINA7
  | "PINA8" -> PINA8
  | "PINA9" -> PINA9
  | "PINA10" -> PINA10
  | "PINA11" -> PINA11
  | "PINA12" -> PINA12
  | "PINA13" -> PINA13
  | "PINA14" -> PINA14
  | "PINA15" -> PINA15
  | _ -> invalid_arg "analog_pin_of_string"
