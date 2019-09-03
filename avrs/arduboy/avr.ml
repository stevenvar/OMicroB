type b_bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7
type c_bit = C0 | C1 | C2 | C3 | C4 | C5 | C6 | C7
type d_bit = D0 | D1 | D2 | D3 | D4 | D5 | D6 | D7
type e_bit = E0 | E1 | E2 | E3 | E4 | E5 | E6 | E7
type f_bit = F0 | F1 | F2 | F3 | F4 | F5 | F6 | F7

type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPI2x | SPSR1 | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPIF
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7

type 'a register =
  | PORTB : b_bit register
  | PORTC : c_bit register
  | PORTD : d_bit register
  | PORTE : e_bit register
  | PORTF : f_bit register
  | DDRB : b_bit register
  | DDRC : c_bit register
  | DDRD : d_bit register
  | DDRE : e_bit register
  | DDRF : f_bit register
  | PINB : b_bit register
  | PINC : c_bit register
  | PIND : d_bit register
  | PINE : e_bit register
  | PINF : f_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register


type yes
type no
type 'a analog_pin =
  | YES : yes analog_pin
  | NO : no analog_pin

type 'a pwm_pin =
  | YES : yes pwm_pin
  | NO : no pwm_pin

type ('a,'b,'c) pin =
  | PIN0  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN1  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN2  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN3  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN4  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN5  : (c_bit register, no analog_pin, no pwm_pin) pin
  | PIN6  : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN7  : (e_bit register, no analog_pin, no pwm_pin) pin
  | PIN8  : (b_bit register, no analog_pin, no pwm_pin) pin
  | PIN9  : (b_bit register, no analog_pin, no pwm_pin) pin
  | PIN10 : (b_bit register, no analog_pin, no pwm_pin) pin
  | PIN11 : (b_bit register, no analog_pin, no pwm_pin) pin
  | PIN12 : (d_bit register, no analog_pin, no pwm_pin) pin
  | PIN13 : (c_bit register, no analog_pin, no pwm_pin) pin
  | MISO  : (b_bit register, no analog_pin, no pwm_pin) pin
  | SCK   : (b_bit register, no analog_pin, no pwm_pin) pin
  | MOSI  : (b_bit register, no analog_pin, no pwm_pin) pin
  | SS    : (b_bit register, no analog_pin, no pwm_pin) pin
  | PINA0 : (f_bit register, no analog_pin, no pwm_pin) pin
  | PINA1 : (f_bit register, no analog_pin, no pwm_pin) pin
  | PINA2 : (f_bit register, no analog_pin, no pwm_pin) pin
  | PINA3 : (f_bit register, no analog_pin, no pwm_pin) pin
  | PINA4 : (f_bit register, no analog_pin, no pwm_pin) pin
  | PINA5 : (f_bit register, no analog_pin, no pwm_pin) pin

type mode = INPUT | OUTPUT | INPUT_PULLUP

type level = LOW | HIGH

let port_of_pin : type a b c. (a register, b analog_pin, c pwm_pin) pin -> a register =
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

let ddr_of_pin : type a b c. (a register , b analog_pin, c pwm_pin) pin -> a register=
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


let input_of_pin : type a b c. (a register , b analog_pin, c pwm_pin) pin -> a register=
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

let bit_of_pin : type a b c. (a register, b analog_pin, c pwm_pin) pin -> a =
  function
  | PIN0 -> D2
  | PIN1 -> D3
  | PIN2 -> D1
  | PIN3 -> D0
  | PIN4 -> D4
  | PIN5 -> C6
  | PIN6 -> D7
  | PIN7 -> E6
  | PIN8 -> B4
  | PIN9 -> B5
  | PIN10 -> B6
  | PIN11 -> B7
  | PIN12 -> D6
  | PIN13 -> C7
  | MISO -> B3
  | SCK -> B1
  | MOSI -> B2
  | SS -> B0
  | PINA0 -> F7
  | PINA1 -> F6
  | PINA2 -> F5
  | PINA3 -> F4
  | PINA4 -> F1
  | PINA5 -> F0

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
  let bit = bit_of_pin p in
  let ddr = ddr_of_pin p in
  match m with
  | OUTPUT ->
    set_bit ddr bit
  | INPUT ->
    clear_bit ddr bit;
    clear_bit port bit
  | INPUT_PULLUP ->
    clear_bit ddr bit;
    set_bit port bit

let digital_write p b =
  let port = port_of_pin p in
  let bit = bit_of_pin p in
  match b with
  | HIGH -> set_bit port bit
  | LOW -> clear_bit port bit

let digital_read p =
  let input = input_of_pin p in
  let ibit = bit_of_pin p in
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
