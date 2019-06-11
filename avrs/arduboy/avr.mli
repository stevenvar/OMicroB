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
    PORTB : portb_bit register
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
type 'a analog_pin = YES : yes analog_pin | NO : no analog_pin
type ('a, 'b, 'c, 'd) pin =
    PIN0 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN1 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN2 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN3 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN4 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN5 :
      (portc_bit register, ddrc_bit register, pinc_bit register,
       no analog_pin)
      pin
  | PIN6 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN7 :
      (porte_bit register, ddre_bit register, pine_bit register,
       no analog_pin)
      pin
  | PIN8 :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | PIN9 :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | PIN10 :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | PIN11 :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | PIN12 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN13 :
      (portc_bit register, ddrc_bit register, pinc_bit register,
       no analog_pin)
      pin
  | MISO :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | SCK :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | MOSI :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | SS :
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | PINA0 :
      (portf_bit register, ddrf_bit register, pinf_bit register,
       no analog_pin)
      pin
  | PINA1 :
      (portf_bit register, ddrf_bit register, pinf_bit register,
       no analog_pin)
      pin
  | PINA2 :
      (portf_bit register, ddrf_bit register, pinf_bit register,
       no analog_pin)
      pin
  | PINA3 :
      (portf_bit register, ddrf_bit register, pinf_bit register,
       no analog_pin)
      pin
  | PINA4 :
      (portf_bit register, ddrf_bit register, pinf_bit register,
       no analog_pin)
      pin
  | PINA5 :
      (portf_bit register, ddrf_bit register, pinf_bit register,
       no analog_pin)
      pin
type mode = INPUT | OUTPUT | INPUT_PULLUP
type level = LOW | HIGH
val port_of_pin :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a register
val ddr_of_pin :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b register
val input_of_pin :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c register
val port_bit_of_pin :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a
val ddr_bit_of_pin :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b
val input_bit_of_pin :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c
external write_register : 'a register -> int -> unit
  = "caml_avr_write_register" [@@noalloc]
external read_register : 'a register -> int = "caml_avr_read_register"
  [@@noalloc]
external set_bit : 'a register -> 'a -> unit = "caml_avr_set_bit" [@@noalloc]
external clear_bit : 'a register -> 'a -> unit = "caml_avr_clear_bit"
  [@@noalloc]
external read_bit : 'a register -> 'a -> bool = "caml_avr_read_bit"
  [@@noalloc]
external delay : int -> unit = "caml_avr_delay" [@@noalloc]
val pin_mode :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> mode -> unit
val digital_write :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> level -> unit
val digital_read :
  ('a register, 'b register, 'c register, 'd analog_pin) pin -> level
module Serial :
  sig
    external init : unit -> unit = "caml_avr_serial_init" [@@noalloc]
    external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
    external write : char -> unit = "caml_avr_serial_write" [@@noalloc]
    val write_string : string -> unit
    val write_int : int -> unit
  end
