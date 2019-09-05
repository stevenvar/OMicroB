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
    PORTB : portb_bit register
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
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN6 :
      (portd_bit register, ddrd_bit register, pind_bit register,
       no analog_pin)
      pin
  | PIN7 :
      (portd_bit register, ddrd_bit register, pind_bit register,
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
      (portb_bit register, ddrb_bit register, pinb_bit register,
       no analog_pin)
      pin
  | PIN13 :
      (portb_bit register, ddrb_bit register, pinb_bit register,
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
      (portc_bit register, ddrc_bit register, pinc_bit register,
       yes analog_pin)
      pin
  | PINA1 :
      (portc_bit register, ddrc_bit register, pinc_bit register,
       yes analog_pin)
      pin
  | PINA2 :
      (portc_bit register, ddrc_bit register, pinc_bit register,
       yes analog_pin)
      pin
  | PINA3 :
      (portc_bit register, ddrc_bit register, pinc_bit register,
       yes analog_pin)
      pin
  | PINA4 :
      (portc_bit register, ddrc_bit register, pinc_bit register,
       yes analog_pin)
      pin
  | PINA5 :
      (portc_bit register, ddrc_bit register, pinc_bit register,
       yes analog_pin)
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
external millis : unit -> int = "caml_avr_millis" [@@noalloc]
val bool_of_level : level -> bool
val level_of_bool : bool -> level
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
