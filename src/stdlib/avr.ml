type porta_bit = PA0 | PA1 | PA2 | PA3 | PA4 | PA5 | PA6 | PA7
type portb_bit = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7
type portc_bit = PC0 | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 | PC7
type portd_bit = PD0 | PD1 | PD2 | PD3 | PD4 | PD5 | PD6 | PD7
type porte_bit = PE0 | PE1 | PE2 | PE3 | PE4 | PE5 | PE6 | PE7
type portf_bit = PF0 | PF1 | PF2 | PF3 | PF4 | PF5 | PF6 | PF7

type ddra_bit = DA0 | DA1 | DA2 | DA3 | DA4 | DA5 | DA6 | DA7
type ddrb_bit = DB0 | DB1 | DB2 | DB3 | DB4 | DB5 | DB6 | DB7
type ddrc_bit = DC0 | DC1 | DC2 | DC3 | DC4 | DC5 | DC6 | DC7
type ddrd_bit = DD0 | DD1 | DD2 | DD3 | DD4 | DD5 | DD6 | DD7
type ddre_bit = DE0 | DE1 | DE2 | DE3 | DE4 | DE5 | DE6 | DE7
type ddrf_bit = DF0 | DF1 | DF2 | DF3 | DF4 | DF5 | DF6 | DF7

type pina_bit = IA0 | IA1 | IA2 | IA3 | IA4 | IA5 | IA6 | IA7
type pinb_bit = IB0 | IB1 | IB2 | IB3 | IB4 | IB5 | IB6 | IB7
type pinc_bit = IC0 | IC1 | IC2 | IC3 | IC4 | IC5 | IC6 | IC7
type pind_bit = ID0 | ID1 | ID2 | ID3 | ID4 | ID5 | ID6 | ID7
type pine_bit = IE0 | IE1 | IE2 | IE3 | IE4 | IE5 | IE6 | IE7
type pinf_bit = IF0 | IF1 | IF2 | IF3 | IF4 | IF5 | IF6 | IF7

type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPIF | WCOL | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPI2x
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7

type 'a register =
  | PORTA : porta_bit register
  | PORTB : portb_bit register
  | PORTC : portc_bit register
  | PORTD : portd_bit register
  | PORTE : porte_bit register
  | PORTF : portf_bit register
  | DDRA : ddra_bit register
  | DDRB : ddrb_bit register
  | DDRC : ddrc_bit register
  | DDRD : ddrd_bit register
  | DDRE : ddre_bit register
  | DDRF : ddrf_bit register
  | PINA : pina_bit register
  | PINB : pinb_bit register
  | PINC : pinc_bit register
  | PIND : pind_bit register
  | PINE : pine_bit register
  | PINF : pinf_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register

type ('a,'b) pin =
  | PIN0 : (portd_bit register, ddrd_bit register) pin
  | PIN1 : (portd_bit register, ddrd_bit register) pin
  | PIN2 : (portd_bit register, ddrd_bit register) pin
  | PIN3 : (portd_bit register, ddrd_bit register) pin
  | PIN4 : (portd_bit register, ddrd_bit register) pin
  | PIN5 : (portc_bit register, ddrc_bit register) pin
  | PIN6 : (portd_bit register, ddrd_bit register) pin
  | PIN7 : (porte_bit register, ddre_bit register) pin
  | PIN8 : (portb_bit register, ddrb_bit register) pin
  | PIN9 : (portb_bit register, ddrb_bit register) pin
  | PIN10 : (portb_bit register, ddrb_bit register) pin
  | PIN11 : (portb_bit register, ddrb_bit register) pin
  | PIN12 : (portd_bit register, ddrd_bit register) pin
  | PIN13 : (portc_bit register, ddrc_bit register) pin

type mode = INPUT | OUTPUT

let port_of_pin : type a b . (a register,b register) pin -> a register =
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


let ddr_of_pin : type a b. (a register , b register) pin -> b register=
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

let port_bit_of_pin : type a b. (a register, b register) pin -> a =
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


let ddr_bit_of_pin : type a b. (a register, b register) pin -> b =
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

external write_register : 'a register -> int -> unit = "caml_avr_write_register"
external read_register : 'a register -> int = "caml_avr_read_register"
external set_bit : 'a register -> 'a -> unit = "caml_avr_set_bit"
external clear_bit : 'a register -> 'a -> unit = "caml_avr_clear_bit"
external read_bit : 'a register -> 'a -> bool = "caml_avr_read_bit"

let pin_mode p m =
  let bit = ddr_bit_of_pin p in
  let ddr = ddr_of_pin p in
  match m with
  | OUTPUT -> set_bit ddr bit
  | INPUT -> clear_bit ddr bit

let digital_write p b =
  let port = port_of_pin p in
  let bit = port_bit_of_pin p in
  match b with
  | true -> set_bit port bit
  | false -> clear_bit port bit
