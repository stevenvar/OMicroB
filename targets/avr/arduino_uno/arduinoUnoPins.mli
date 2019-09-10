open Avr

type portb_bit = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7
type portc_bit = PC0 | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 | PC7
type portd_bit = PD0 | PD1 | PD2 | PD3 | PD4 | PD5 | PD6 | PD7
type ddrb_bit = DB0 | DB1 | DB2 | DB3 | DB4 | DB5 | DB6 | DB7
type ddrc_bit = DC0 | DC1 | DC2 | DC3 | DC4 | DC5 | DC6 | DC7
type ddrd_bit = DD0 | DD1 | DD2 | DD3 | DD4 | DD5 | DD6 | DD7
type pinb_bit = IB0 | IB1 | IB2 | IB3 | IB4 | IB5 | IB6 | IB7
type pinc_bit = IC0 | IC1 | IC2 | IC3 | IC4 | IC5 | IC6 | IC7
type pind_bit = ID0 | ID1 | ID2 | ID3 | ID4 | ID5 | ID6 | ID7
type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPI2x | SPSR1 | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPIF
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7
type 'a register =
  | PORTB : portb_bit register
  | PORTC : portc_bit register
  | PORTD : portd_bit register
  | DDRB : ddrb_bit register
  | DDRC : ddrc_bit register
  | DDRD : ddrd_bit register
  | PINB : pinb_bit register
  | PINC : pinc_bit register
  | PIND : pind_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register
type ('a,'b,'c,'d) pin =
  | PIN0  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN1  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN2  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN3  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN4  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN5  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN6  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN7  : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN8  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN9  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN10 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN11 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN12 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN13 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | MISO  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | SCK   : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | MOSI  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | SS    : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PINA0 : (portc_bit register, ddrc_bit register, pinc_bit register, yes analog_pin) pin
  | PINA1 : (portc_bit register, ddrc_bit register, pinc_bit register, yes analog_pin) pin
  | PINA2 : (portc_bit register, ddrc_bit register, pinc_bit register, yes analog_pin) pin
  | PINA3 : (portc_bit register, ddrc_bit register, pinc_bit register, yes analog_pin) pin
  | PINA4 : (portc_bit register, ddrc_bit register, pinc_bit register, yes analog_pin) pin
  | PINA5 : (portc_bit register, ddrc_bit register, pinc_bit register, yes analog_pin) pin
include AvrPins
  with type 'a register := 'a register
  with type ('a, 'b, 'c, 'd)pin := ('a, 'b, 'c, 'd)pin
