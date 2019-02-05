type porta_bit = PA0 | PA1 | PA2 | PA3 | PA4 | PA5 | PA6 | PA7
type portb_bit = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7
type portc_bit = PC0 | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 | PC7
type portd_bit = PD0 | PD1 | PD2 | PD3 | PD4 | PD5 | PD6 | PD7
type porte_bit = PE0 | PE1 | PE2 | PE3 | PE4 | PE5 | PE6 | PE7
type portf_bit = PF0 | PF1 | PF2 | PF3 | PF4 | PF5 | PF6 | PF7
type portg_bit = PG0 | PG1 | PG2 | PG3 | PG4 | PG5 | PG6 | PG7
type porth_bit = PH0 | PH1 | PH2 | PH3 | PH4 | PH5 | PH6 | PH7
type portj_bit = PJ0 | PJ1 | PJ2 | PJ3 | PJ4 | PJ5 | PJ6 | PJ7
type portl_bit = PL0 | PL1 | PL2 | PL3 | PL4 | PL5 | PL6 | PL7
type portk_bit = PK0 | PK1 | PK2 | PK3 | PK4 | PK5 | PK6 | PK7
type ddra_bit = DA0 | DA1 | DA2 | DA3 | DA4 | DA5 | DA6 | DA7
type ddrb_bit = DB0 | DB1 | DB2 | DB3 | DB4 | DB5 | DB6 | DB7
type ddrc_bit = DC0 | DC1 | DC2 | DC3 | DC4 | DC5 | DC6 | DC7
type ddrd_bit = DD0 | DD1 | DD2 | DD3 | DD4 | DD5 | DD6 | DD7
type ddre_bit = DE0 | DE1 | DE2 | DE3 | DE4 | DE5 | DE6 | DE7
type ddrf_bit = DF0 | DF1 | DF2 | DF3 | DF4 | DF5 | DF6 | DF7
type ddrg_bit = DG0 | DG1 | DG2 | DG3 | DG4 | DG5 | DG6 | DG7
type ddrh_bit = DH0 | DH1 | DH2 | DH3 | DH4 | DH5 | DH6 | DH7
type ddrj_bit = DJ0 | DJ1 | DJ2 | DJ3 | DJ4 | DJ5 | DJ6 | DJ7
type ddrl_bit = DL0 | DL1 | DL2 | DL3 | DL4 | DL5 | DL6 | DL7
type ddrk_bit = DK0 | DK1 | DK2 | DK3 | DK4 | DK5 | DK6 | DK7
type pina_bit = IA0 | IA1 | IA2 | IA3 | IA4 | IA5 | IA6 | IA7
type pinb_bit = IB0 | IB1 | IB2 | IB3 | IB4 | IB5 | IB6 | IB7
type pinc_bit = IC0 | IC1 | IC2 | IC3 | IC4 | IC5 | IC6 | IC7
type pind_bit = ID0 | ID1 | ID2 | ID3 | ID4 | ID5 | ID6 | ID7
type pine_bit = IE0 | IE1 | IE2 | IE3 | IE4 | IE5 | IE6 | IE7
type pinf_bit = IF0 | IF1 | IF2 | IF3 | IF4 | IF5 | IF6 | IF7
type ping_bit = IG0 | IG1 | IG2 | IG3 | IG4 | IG5 | IG6 | IG7
type pinh_bit = IH0 | IH1 | IH2 | IH3 | IH4 | IH5 | IH6 | IH7
type pinj_bit = IJ0 | IJ1 | IJ2 | IJ3 | IJ4 | IJ5 | IJ6 | IJ7
type pinl_bit = IL0 | IL1 | IL2 | IL3 | IL4 | IL5 | IL6 | IL7
type pink_bit = IK0 | IK1 | IK2 | IK3 | IK4 | IK5 | IK6 | IK7
type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPI2x | SPSR1 | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPIF
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7
type 'a register =
    PORTA : porta_bit register
  | PORTB : portb_bit register
  | PORTC : portc_bit register
  | PORTD : portd_bit register
  | PORTE : porte_bit register
  | PORTF : portf_bit register
  | PORTG : portg_bit register
  | PORTH : porth_bit register
  | PORTJ : portj_bit register
  | PORTK : portk_bit register
  | PORTL : portl_bit register
  | DDRA : ddra_bit register
  | DDRB : ddrb_bit register
  | DDRC : ddrc_bit register
  | DDRD : ddrd_bit register
  | DDRE : ddre_bit register
  | DDRF : ddrf_bit register
  | DDRG : ddrg_bit register
  | DDRH : ddrh_bit register
  | DDRJ : ddrj_bit register
  | DDRK : ddrk_bit register
  | DDRL : ddrl_bit register
  | PINA : pina_bit register
  | PINB : pinb_bit register
  | PINC : pinc_bit register
  | PIND : pind_bit register
  | PINE : pine_bit register
  | PINF : pinf_bit register
  | PING : ping_bit register
  | PINH : pinh_bit register
  | PINJ : pinj_bit register
  | PINK : pink_bit register
  | PINL : pinl_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register
type ('a, 'b, 'c) pin =
    PIN0 : (porte_bit register, ddre_bit register, pine_bit register) pin
  | PIN1 : (porte_bit register, ddre_bit register, pine_bit register) pin
  | PIN2 : (porte_bit register, ddre_bit register, pine_bit register) pin
  | PIN3 : (porte_bit register, ddre_bit register, pine_bit register) pin
  | PIN4 : (portg_bit register, ddrg_bit register, ping_bit register) pin
  | PIN5 : (porte_bit register, ddre_bit register, pine_bit register) pin
  | PIN6 : (porth_bit register, ddrh_bit register, pinh_bit register) pin
  | PIN7 : (porth_bit register, ddrh_bit register, pinh_bit register) pin
  | PIN8 : (porth_bit register, ddrh_bit register, pinh_bit register) pin
  | PIN9 : (porth_bit register, ddrh_bit register, pinh_bit register) pin
  | PIN10 : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | PIN11 : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | PIN12 : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | PIN13 : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | PIN14 : (portj_bit register, ddrj_bit register, pinj_bit register) pin
  | PIN15 : (portj_bit register, ddrj_bit register, pinj_bit register) pin
  | PIN16 : (porth_bit register, ddrh_bit register, pinh_bit register) pin
  | PIN17 : (porth_bit register, ddrh_bit register, pinh_bit register) pin
  | PIN18 : (portd_bit register, ddrd_bit register, pind_bit register) pin
  | PIN19 : (portd_bit register, ddrd_bit register, pind_bit register) pin
  | PIN20 : (portd_bit register, ddrd_bit register, pind_bit register) pin
  | PIN21 : (portd_bit register, ddrd_bit register, pind_bit register) pin
  | PIN22 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN23 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN24 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN25 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN26 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN27 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN28 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN29 : (porta_bit register, ddra_bit register, pina_bit register) pin
  | PIN30 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN31 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN32 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN33 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN34 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN35 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN36 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN37 : (portc_bit register, ddrc_bit register, pinc_bit register) pin
  | PIN38 : (portd_bit register, ddrd_bit register, pind_bit register) pin
  | PIN39 : (portg_bit register, ddrg_bit register, ping_bit register) pin
  | PIN40 : (portg_bit register, ddrg_bit register, ping_bit register) pin
  | PIN41 : (portg_bit register, ddrg_bit register, ping_bit register) pin
  | PIN42 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | PIN43 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | PIN44 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | PIN45 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | PIN46 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | PIN47 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | PIN48 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | PIN49 : (portl_bit register, ddrl_bit register, pinl_bit register) pin
  | MISO : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | SCK : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | MOSI : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | SS : (portb_bit register, ddrb_bit register, pinb_bit register) pin
  | PINA0 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA1 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA2 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA3 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA4 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA5 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA6 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA7 : (portf_bit register, ddrf_bit register, pinf_bit register) pin
  | PINA8 : (portk_bit register, ddrk_bit register, pink_bit register) pin
  | PINA9 : (portk_bit register, ddrk_bit register, pink_bit register) pin
  | PINA10 : (portk_bit register, ddrk_bit register, pink_bit register) pin
  | PINA11 : (portk_bit register, ddrk_bit register, pink_bit register) pin
  | PINA12 : (portk_bit register, ddrk_bit register, pink_bit register) pin
  | PINA13 : (portk_bit register, ddrk_bit register, pink_bit register) pin
  | PINA14 : (portk_bit register, ddrk_bit register, pink_bit register) pin
  | PINA15 : (portk_bit register, ddrk_bit register, pink_bit register) pin
type mode = INPUT | OUTPUT | INPUT_PULLUP
type level = LOW | HIGH
val port_of_pin : ('a register, 'b register, 'c register) pin -> 'a register
val ddr_of_pin : ('a register, 'b register, 'c register) pin -> 'b register
val input_of_pin : ('a register, 'b register, 'c register) pin -> 'c register
val port_bit_of_pin : ('a register, 'b register, 'c register) pin -> 'a
val ddr_bit_of_pin : ('a register, 'b register, 'c register) pin -> 'b
val input_bit_of_pin : ('a register, 'b register, 'c register) pin -> 'c
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
val pin_mode : ('a register, 'b register, 'c register) pin -> mode -> unit
val digital_write :
  ('a register, 'b register, 'c register) pin -> level -> unit
val digital_read : ('a register, 'b register, 'c register) pin -> level
module Serial :
  sig
    external init : unit -> unit = "caml_avr_serial_init" [@@noalloc]
    external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
    external write : char -> unit = "caml_avr_serial_write" [@@noalloc]
  end
