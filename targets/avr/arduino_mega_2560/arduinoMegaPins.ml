type register =
  | PORTA | PORTB | PORTC | PORTD | PORTE | PORTF | PORTG | PORTH | PORTJ | PORTK | PORTL
  | DDRA | DDRB | DDRC | DDRD | DDRE | DDRF | DDRG | DDRH | DDRJ | DDRK | DDRL
  | PINA | PINB | PINC | PIND | PINE | PINF | PING | PINH | PINJ | PINK | PINL
  | SPCR | SPSR | SPDR

type bit = BIT0 | BIT1 | BIT2 | BIT3 | BIT4 | BIT5 | BIT6 | BIT7

type 'a pin =
  | PIN0  : [< `DREAD | `DWRITE ] pin
  | PIN1  : [< `DREAD | `DWRITE ] pin
  | PIN2  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN3  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN4  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN5  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN6  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN7  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN8  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN9  : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN10 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN11 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN12 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN13 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN14 : [< `DREAD | `DWRITE ] pin
  | PIN15 : [< `DREAD | `DWRITE ] pin
  | PIN16 : [< `DREAD | `DWRITE ] pin
  | PIN17 : [< `DREAD | `DWRITE ] pin
  | PIN18 : [< `DREAD | `DWRITE ] pin
  | PIN19 : [< `DREAD | `DWRITE ] pin
  | PIN20 : [< `DREAD | `DWRITE ] pin
  | PIN21 : [< `DREAD | `DWRITE ] pin
  | PIN22 : [< `DREAD | `DWRITE ] pin
  | PIN23 : [< `DREAD | `DWRITE ] pin
  | PIN24 : [< `DREAD | `DWRITE ] pin
  | PIN25 : [< `DREAD | `DWRITE ] pin
  | PIN26 : [< `DREAD | `DWRITE ] pin
  | PIN27 : [< `DREAD | `DWRITE ] pin
  | PIN28 : [< `DREAD | `DWRITE ] pin
  | PIN29 : [< `DREAD | `DWRITE ] pin
  | PIN30 : [< `DREAD | `DWRITE ] pin
  | PIN31 : [< `DREAD | `DWRITE ] pin
  | PIN32 : [< `DREAD | `DWRITE ] pin
  | PIN33 : [< `DREAD | `DWRITE ] pin
  | PIN34 : [< `DREAD | `DWRITE ] pin
  | PIN35 : [< `DREAD | `DWRITE ] pin
  | PIN36 : [< `DREAD | `DWRITE ] pin
  | PIN37 : [< `DREAD | `DWRITE ] pin
  | PIN38 : [< `DREAD | `DWRITE ] pin
  | PIN39 : [< `DREAD | `DWRITE ] pin
  | PIN40 : [< `DREAD | `DWRITE ] pin
  | PIN41 : [< `DREAD | `DWRITE ] pin
  | PIN42 : [< `DREAD | `DWRITE ] pin
  | PIN43 : [< `DREAD | `DWRITE ] pin
  | PIN44 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN45 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN46 : [< `DREAD | `DWRITE | `PWM ] pin
  | PIN47 : [< `DREAD | `DWRITE ] pin
  | PIN48 : [< `DREAD | `DWRITE ] pin
  | PIN49 : [< `DREAD | `DWRITE ] pin
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
  | PINA6 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA7 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA8 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA9 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA10 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA11 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA12 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA13 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA14 : [< `DREAD | `DWRITE | `AREAD ] pin
  | PINA15 : [< `DREAD | `DWRITE | `AREAD ] pin

let nb_pins = 70

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

let pin_of_string = function
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
  | _ -> invalid_arg "TODO pin_of_string"

let name_of_pin : type a. a pin -> string = function
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
  (* | 18 -> "PIN53/SS" *)
  (* | 19 -> "PIN52/SCK" *)
  (* | 20 -> "PIN51/MOSI" *)
  (* | 21 -> "PIN50/MISO" *)
  (* | 22 -> "PIN10/PWM" *)
  (* | 23 -> "PIN11/PWM" *)
  (* | 24 -> "PIN12/PWM" *)
  (* | 25 -> "PIN13/PWM" *)


  (* | 29 -> "RESET" *)
  (* | 30 -> "VCC" *)
  (* | 31 -> "GND" *)
  (* | 32 -> "XTAL2" *)
  (* | 33 -> "XTAL1" *)
  (* | 34 -> "PIN49" *)
  (* | 35 -> "PIN48" *)
  (* | 36 -> "PIN47" *)
  (* | 37 -> "PIN46/PWM" *)
  (* | 38 -> "PIN45/PWM" *)
  (* | 39 -> "PIN44/PWM" *)
  (* | 40 -> "PIN43" *)
  (* | 41 -> "PIN42" *)
  (* | 42 -> "PIN21/SCL" *)
  (* | 43 -> "PIN20/SDA" *)
  (* | 44 -> "PIN19/RX1" *)
  (* | 45 -> "PIN18/TX1" *)

  (* | 49 -> "PIN38" *)
  (* | 50 -> "PIN41" *)
  (* | 51 -> "PIN40" *)
  (* | 52 -> "PIN37" *)
  (* | 53 -> "PIN36" *)
  (* | 54 -> "PIN35" *)
  (* | 55 -> "PIN34" *)
  (* | 56 -> "PIN33" *)
  (* | 57 -> "PIN32" *)
  (* | 58 -> "PIN31" *)
  (* | 59 -> "PIN30" *)
  (* | 60 -> "VCC" *)
  (* | 61 -> "GND" *)
  (* | 62 -> "PIN15/RX3" *)
  (* | 63 -> "PIN14/TX3" *)

  (* | 69 -> "PIN39" *)
  (* | 70 -> "PIN29" *)
  (* | 71 -> "PIN28" *)
  (* | 72 -> "PIN27" *)
  (* | 73 -> "PIN26" *)
  (* | 74 -> "PIN25" *)
  (* | 75 -> "PIN24" *)
  (* | 76 -> "PIN23" *)
  (* | 77 -> "PIN22" *)

  (* | 79 -> "VCC" *)
  (* | 80 -> "GND" *)
  (* | 81 -> "A15" *)
  (* | 82 -> "A14" *)
  (* | 83 -> "A13" *)
  (* | 84 -> "A12" *)
  (* | 85 -> "A11" *)
  (* | 86 -> "A10" *)
  (* | 87 -> "A9" *)
  (* | 88 -> "A8" *)
  (* | 89 -> "A7" *)
  (* | 90 -> "A6" *)
  (* | 91 -> "A5" *)
  (* | 92 -> "A4" *)
  (* | 93 -> "A3" *)
  (* | 94 -> "A2" *)
  (* | 95 -> "A1" *)
  (* | 96  -> "A0" *)
  (* | 97 -> "ARef" *)
  (* | 98 -> "GND" *)
  (* | 99 -> "AVcc" *)
  | _ -> ""

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

let pin_of_register_bit register bit : [ `DWRITE ] pin =
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
  | _ -> invalid_arg "pin_of_register_bit"
