open Avr

type register =
  | PORTA | PORTB | PORTC | PORTD | PORTE | PORTF | PORTG | PORTH | PORTJ | PORTK | PORTL
  | DDRA | DDRB | DDRC | DDRD | DDRE | DDRF | DDRG | DDRH | DDRJ | DDRK | DDRL
  | PINA | PINB | PINC | PIND | PINE | PINF | PING | PINH | PINJ | PINK | PINL
  | SPCR | SPSR | SPDR

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

external write_register : register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register : register -> int = "caml_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_read_bit" [@@noalloc]

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
