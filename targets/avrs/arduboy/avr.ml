type portb_bit = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7
type portc_bit = PC0 | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 | PC7
type portd_bit = PD0 | PD1 | PD2 | PD3 | PD4 | PD5 | PD6 | PD7
type porte_bit = PE0 | PE1 | PE2 | PE3 | PE4 | PE5 | PE6 | PE7
type portf_bit = PF0 | PF1 | PF2 | PF3 | PF4 | PF5 | PF6 | PF7

type ddrb_bit = DB0 | DB1 | DB2 | DB3 | DB4 | DB5 | DB6 | DB7
type ddrc_bit = DC0 | DC1 | DC2 | DC3 | DC4 | DC5 | DC6 | DC7
type ddrd_bit = DD0 | DD1 | DD2 | DD3 | DD4 | DD5 | DD6 | DD7
type ddre_bit = DE0 | DE1 | DE2 | DE3 | DE4 | DE5 | DE6 | DE7
type ddrf_bit = DF0 | DF1 | DF2 | DF3 | DF4 | DF5 | DF6 | DF7

type pinb_bit = IB0 | IB1 | IB2 | IB3 | IB4 | IB5 | IB6 | IB7
type pinc_bit = IC0 | IC1 | IC2 | IC3 | IC4 | IC5 | IC6 | IC7
type pind_bit = ID0 | ID1 | ID2 | ID3 | ID4 | ID5 | ID6 | ID7
type pine_bit = IE0 | IE1 | IE2 | IE3 | IE4 | IE5 | IE6 | IE7
type pinf_bit = IF0 | IF1 | IF2 | IF3 | IF4 | IF5 | IF6 | IF7

type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPI2x | SPSR1 | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPIF
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7

type 'a register =
  | PORTB : portb_bit register
  | PORTC : portc_bit register
  | PORTD : portd_bit register
  | PORTE : porte_bit register
  | PORTF : portf_bit register
  | DDRB : ddrb_bit register
  | DDRC : ddrc_bit register
  | DDRD : ddrd_bit register
  | DDRE : ddre_bit register
  | DDRF : ddrf_bit register
  | PINB : pinb_bit register
  | PINC : pinc_bit register
  | PIND : pind_bit register
  | PINE : pine_bit register
  | PINF : pinf_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register


type yes
type no
type 'a analog_pin =
  | YES : yes analog_pin
  | NO : no analog_pin

type ('a,'b,'c,'d) pin =
  | PIN0  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN1  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN2  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN3  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN4  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN5  : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN6  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN7  : (porte_bit register, ddre_bit register, pine_bit register, no analog_pin) pin
  | PIN8  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN9  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN10 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN11 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN12 : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN13 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | MISO  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | SCK   : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | MOSI  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | SS    : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PINA0 : (portf_bit register, ddrf_bit register, pinf_bit register, no analog_pin) pin
  | PINA1 : (portf_bit register, ddrf_bit register, pinf_bit register, no analog_pin) pin
  | PINA2 : (portf_bit register, ddrf_bit register, pinf_bit register, no analog_pin) pin
  | PINA3 : (portf_bit register, ddrf_bit register, pinf_bit register, no analog_pin) pin
  | PINA4 : (portf_bit register, ddrf_bit register, pinf_bit register, no analog_pin) pin
  | PINA5 : (portf_bit register, ddrf_bit register, pinf_bit register, no analog_pin) pin

type mode = INPUT | OUTPUT | INPUT_PULLUP

type level = LOW | HIGH

let port_of_pin : type a b c d. (a register,b register, c register, d analog_pin) pin -> a register =
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

let ddr_of_pin : type a b c d. (a register , b register, c register, d analog_pin) pin -> b register=
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


let input_of_pin : type a b c d. (a register , b register, c register, d analog_pin) pin -> c register=
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

let port_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> a =
  function
  | PIN0 -> PD2
  | PIN1 -> PD3
  | PIN2 -> PD1
  | PIN3 -> PD0
  | PIN4 -> PD4
  | PIN5 -> PC6
  | PIN6 -> PD7
  | PIN7 -> PE6
  | PIN8 -> PB4
  | PIN9 -> PB5
  | PIN10 -> PB6
  | PIN11 -> PB7
  | PIN12 -> PD6
  | PIN13 -> PC7
  | MISO -> PB3
  | SCK -> PB1
  | MOSI -> PB2
  | SS -> PB0
  | PINA0 -> PF7
  | PINA1 -> PF6
  | PINA2 -> PF5
  | PINA3 -> PF4
  | PINA4 -> PF1
  | PINA5 -> PF0


let ddr_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b =
  function
  | PIN0 -> DD2
  | PIN1 -> DD3
  | PIN2 -> DD1
  | PIN3 -> DD0
  | PIN4 -> DD4
  | PIN5 -> DC6
  | PIN6 -> DD7
  | PIN7 -> DE6
  | PIN8 -> DB4
  | PIN9 -> DB5
  | PIN10 -> DB6
  | PIN11 -> DB7
  | PIN12 -> DD6
  | PIN13 -> DC7
  | MISO -> DB3
  | SCK -> DB1
  | MOSI -> DB2
  | SS -> DB0
  | PINA0 -> DF7
  | PINA1 -> DF6
  | PINA2 -> DF5
  | PINA3 -> DF4
  | PINA4 -> DF1
  | PINA5 -> DF0


let input_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c =
  function
  | PIN0 -> ID2
  | PIN1 -> ID3
  | PIN2 -> ID1
  | PIN3 -> ID0
  | PIN4 -> ID4
  | PIN5 -> IC6
  | PIN6 -> ID7
  | PIN7 -> IE6
  | PIN8 -> IB4
  | PIN9 -> IB5
  | PIN10 -> IB6
  | PIN11 -> IB7
  | PIN12 -> ID6
  | PIN13 -> IC7
  | MISO -> IB3
  | SCK -> IB1
  | MOSI -> IB2
  | SS -> IB0
  | PINA0 -> IF7
  | PINA1 -> IF6
  | PINA2 -> IF5
  | PINA3 -> IF4
  | PINA4 -> IF1
  | PINA5 -> IF0


external write_register : 'a register -> int -> unit = "caml_avr_write_register" [@@noalloc]
external read_register : 'a register -> int = "caml_avr_read_register" [@@noalloc]
external set_bit : 'a register -> 'a -> unit = "caml_avr_set_bit" [@@noalloc]
external clear_bit : 'a register -> 'a -> unit = "caml_avr_clear_bit" [@@noalloc]
external read_bit : 'a register -> 'a -> bool = "caml_avr_read_bit" [@@noalloc]
external delay : int -> unit = "caml_avr_delay" [@@noalloc]
external millis : unit -> int = "caml_avr_millis" [@@noalloc]

let bool_of_level = function LOW -> false | HIGH -> true
let level_of_bool = function false -> LOW | true -> HIGH

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
  let ibit = input_bit_of_pin p in
  match read_bit input ibit with
  | true -> HIGH
  | false -> LOW


module Serial = struct

  external init: unit -> unit = "caml_avr_serial_init" [@@noalloc]
  external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
  external write : char -> unit = "caml_avr_serial_write" [@@noalloc]

  let write_string s =
    String.iter write s

  let write_int n =
    write_string (string_of_int n)

end
