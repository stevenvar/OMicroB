type a_bit = A0 | A1 | A2 | A3 | A4 | A5 | A6 | A7
type b_bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7
type c_bit = C0 | C1 | C2 | C3 | C4 | C5 | C6 | C7
type d_bit = D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7
type e_bit = E0 | E1 | E2 | E3 | E4 | E5 | E6 | E7
type f_bit = F0 | F1 | F2 | F3 | F4 | F5 | F6 | F7
type g_bit = G0 | G1 | G2 | G3 | G4 | G5 | G6 | G7
type h_bit = H0 | H1 | H2 | H3 | H4 | H5 | H6 | H7
type j_bit = J0 | J1 | J2 | J3 | J4 | J5 | J6 | J7
type l_bit = L0 | L1 | L2 | L3 | L4 | L5 | L6 | L7
type k_bit = K0 | K1 | K2 | K3 | K4 | K5 | K6 | K7
type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPI2x | SPSR1 | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPIF
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7
type 'a register =
  | PORTA : a_bit register
  | PORTB : b_bit register
  | PORTC : c_bit register
  | PORTD : d_bit register
  | PORTE : e_bit register
  | PORTF : f_bit register
  | PORTG : g_bit register
  | PORTH : h_bit register
  | PORTJ : j_bit register
  | PORTK : k_bit register
  | PORTL : l_bit register
  | DDRA : a_bit register
  | DDRB : b_bit register
  | DDRC : c_bit register
  | DDRD : d_bit register
  | DDRE : e_bit register
  | DDRF : f_bit register
  | DDRG : g_bit register
  | DDRH : h_bit register
  | DDRJ : j_bit register
  | DDRK : k_bit register
  | DDRL : l_bit register
  | PINA : a_bit register
  | PINB : b_bit register
  | PINC : c_bit register
  | PIND : d_bit register
  | PINE : e_bit register
  | PINF : f_bit register
  | PING : g_bit register
  | PINH : h_bit register
  | PINJ : j_bit register
  | PINK : k_bit register
  | PINL : l_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register
type yes
type no
type 'a analog_pin = YES : yes analog_pin | NO : no analog_pin
type 'a pwm_pin = YES : yes pwm_pin | NO : no pwm_pin
type ('a,'b,'c) pin =
  | PIN0  : (e_bit register, no analog_pin, no pwm_pin) pin
  | PIN1  : (e_bit register, no analog_pin, no pwm_pin) pin
  | PIN2  : (e_bit register, no analog_pin, yes pwm_pin) pin
  | PIN3  : (e_bit register, no analog_pin, yes pwm_pin) pin
  | PIN4  : (g_bit register, no analog_pin, yes pwm_pin) pin
  | PIN5  : (e_bit register, no analog_pin, yes pwm_pin) pin
  | PIN6  : (h_bit register, no analog_pin, yes pwm_pin) pin
  | PIN7  : (h_bit register, no analog_pin, yes pwm_pin) pin
  | PIN8  : (h_bit register, no analog_pin, yes pwm_pin) pin
  | PIN9  : (h_bit register, no analog_pin, yes pwm_pin) pin
  | PIN10 : (b_bit register, no analog_pin, yes pwm_pin) pin
  | PIN11 : (b_bit register, no analog_pin, yes pwm_pin) pin
  | PIN12 : (b_bit register, no analog_pin, yes pwm_pin) pin
  | PIN13 : (b_bit register, no analog_pin, yes pwm_pin) pin
  | PIN14 : (j_bit register, no analog_pin, no pwm_pin) pin
  | PIN15 : (j_bit register, no analog_pin, no pwm_pin) pin
  | PIN16 : (h_bit register, no analog_pin, no pwm_pin) pin
  | PIN17 : (h_bit register, no analog_pin, no pwm_pin) pin
  | PIN18 : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN19 : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN20 : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN21 : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN22 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN23 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN24 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN25 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN26 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN27 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN28 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN29 : (a_bit register, no analog_pin, no pwm_pin) pin
  | PIN30 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN31 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN32 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN33 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN34 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN35 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN36 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN37 : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN38 : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN39 : (g_bit register, no analog_pin, no pwm_pin) pin
  | PIN40 : (g_bit register, no analog_pin, no pwm_pin) pin
  | PIN41 : (g_bit register, no analog_pin, no pwm_pin) pin
  | PIN42 : (l_bit register, no analog_pin, no pwm_pin) pin
  | PIN43 : (l_bit register, no analog_pin, no pwm_pin) pin
  | PIN44 : (l_bit register, no analog_pin, yes pwm_pin) pin
  | PIN45 : (l_bit register, no analog_pin, yes pwm_pin) pin
  | PIN46 : (l_bit register, no analog_pin, yes pwm_pin) pin
  | PIN47 : (l_bit register, no analog_pin, no pwm_pin) pin
  | PIN48 : (l_bit register, no analog_pin, no pwm_pin) pin
  | PIN49 : (l_bit register, no analog_pin, no pwm_pin) pin
  | MISO  : (b_bit register, no analog_pin, no pwm_pin) pin
  | SCK   : (b_bit register, no analog_pin, no pwm_pin) pin
  | MOSI  : (b_bit register, no analog_pin, no pwm_pin) pin
  | SS    : (b_bit register, no analog_pin, no pwm_pin) pin
  | PINA0 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA1 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA2 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA3 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA4 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA5 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA6 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA7 : (f_bit register, yes analog_pin, no pwm_pin) pin
  | PINA8 : (k_bit register, yes analog_pin, no pwm_pin) pin
  | PINA9 : (k_bit register, yes analog_pin, no pwm_pin) pin
  | PINA10 : (k_bit register, yes analog_pin, no pwm_pin) pin
  | PINA11 : (k_bit register, yes analog_pin, no pwm_pin) pin
  | PINA12 : (k_bit register, yes analog_pin, no pwm_pin) pin
  | PINA13 : (k_bit register, yes analog_pin, no pwm_pin) pin
  | PINA14 : (k_bit register, yes analog_pin, no pwm_pin) pin
  | PINA15 : (k_bit register, yes analog_pin, no pwm_pin) pin
type mode = INPUT | OUTPUT | INPUT_PULLUP
type level = LOW | HIGH
val port_of_pin :
  ('a register, 'b analog_pin, 'c pwm_pin) pin -> 'a register
val ddr_of_pin :
  ('a register, 'b analog_pin, 'c pwm_pin) pin -> 'a register
val input_of_pin :
  ('a register, 'b analog_pin, 'c pwm_pin) pin -> 'a register
val bit_of_pin :
  ('a register, 'b analog_pin, 'c pwm_pin) pin -> 'a
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
  ('a register, 'b analog_pin, 'c pwm_pin) pin -> mode -> unit
val digital_write :
  ('a register, 'b analog_pin, 'c pwm_pin) pin -> level -> unit
val digital_read :
  ('a register, 'b analog_pin, 'c pwm_pin) pin -> level
external adc_init : unit -> unit = "caml_avr_adc_init"
external avr_analog_read : int -> int = "caml_avr_analog_read"
val channel_of_pin :
  ('a register, yes analog_pin, 'b pwm_pin) pin -> int
val analog_read :
  ('a register, yes analog_pin, 'b pwm_pin) pin -> int
module Serial :
  sig
    external init : unit -> unit = "caml_avr_serial_init" [@@noalloc]
    external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
    external write : char -> unit = "caml_avr_serial_write" [@@noalloc]
    val write_string : string -> unit
    val write_int : int -> unit
  end
