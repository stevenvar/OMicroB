type b_bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7
type c_bit = C0 | C1 | C2 | C3 | C4 | C5 | C6 | C7
type d_bit = D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7
type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPI2x | SPSR1 | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPIF
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7
type 'a register =
    PORTB : b_bit register
  | PORTC : c_bit register
  | PORTD : d_bit register
  | DDRB : b_bit register
  | DDRC : c_bit register
  | DDRD : d_bit register
  | PINB : b_bit register
  | PINC : c_bit register
  | PIND : d_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spdr_bit register
type yes
type no
type 'a analog_pin = YES : yes analog_pin | NO : no analog_pin
type 'a pwm_pin = YES : yes pwm_pin | NO : no pwm_pin
type ('a,'b,'c) pin =
  | PIN0  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN1  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN2  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN3  : (d_bit register, no analog_pin, yes pwm_pin) pin
  | PIN4  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN5  : (d_bit register, no analog_pin, yes pwm_pin) pin
  | PIN6  : (d_bit register, no analog_pin, yes pwm_pin) pin
  | PIN7  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN8  : (b_bit register, no analog_pin, no pwm_pin) pin
  | PIN9  : (b_bit register, no analog_pin, yes pwm_pin) pin
  | PIN10 : (b_bit register, no analog_pin, yes pwm_pin) pin
  | PIN11 : (b_bit register, no analog_pin, yes pwm_pin) pin
  | PIN12 : (b_bit register, no analog_pin, no pwm_pin) pin
  | PIN13 : (b_bit register, no analog_pin, no pwm_pin) pin
  | MISO  : (b_bit register, no analog_pin, no pwm_pin) pin
  | SCK   : (b_bit register, no analog_pin, no pwm_pin) pin
  | MOSI  : (b_bit register, no analog_pin, no pwm_pin) pin
  | SS    : (b_bit register, no analog_pin, no pwm_pin) pin
  | PINA0 : (c_bit register, yes analog_pin, no pwm_pin) pin
  | PINA1 : (c_bit register, yes analog_pin, no pwm_pin) pin
  | PINA2 : (c_bit register, yes analog_pin, no pwm_pin) pin
  | PINA3 : (c_bit register, yes analog_pin, no pwm_pin) pin
  | PINA4 : (c_bit register, yes analog_pin, no pwm_pin) pin
  | PINA5 : (c_bit register, yes analog_pin, no pwm_pin) pin
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
module Serial :
  sig
    external init : unit -> unit = "caml_avr_serial_init" [@@noalloc]
    external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
    external write : char -> unit = "caml_avr_serial_write" [@@noalloc]
    val write_string : string -> unit
    val write_int : int -> unit
  end
