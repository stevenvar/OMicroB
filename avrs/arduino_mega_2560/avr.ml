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
type 'a analog_pin =
  | YES : yes analog_pin
  | NO : no analog_pin
type 'a pwm_pin =
  | YES : yes pwm_pin
  | NO : no pwm_pin

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

let port_of_pin : type a b c. (a register, b analog_pin, c pwm_pin) pin -> a register =
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

let ddr_of_pin : type a b c. (a register , b analog_pin, c pwm_pin) pin -> a register=
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


let input_of_pin : type a b c. (a register , b analog_pin, c pwm_pin) pin -> a register=
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

let bit_of_pin : type a b c. (a register, b analog_pin, c pwm_pin) pin -> a =
  function
  | PIN0 -> E0
  | PIN1 -> E1
  | PIN2 -> E4
  | PIN3 -> E5
  | PIN4 -> G5
  | PIN5 -> E3
  | PIN6 -> H3
  | PIN7 -> H4
  | PIN8 -> H5
  | PIN9 -> H6
  | PIN10 -> B4
  | PIN11 -> B5
  | PIN12 -> B6
  | PIN13 -> B7
  | PIN14 -> J1
  | PIN15 -> J0
  | PIN16 -> H1
  | PIN17 -> H0
  | PIN18 -> D3
  | PIN19 -> D2
  | PIN20 -> D1
  | PIN21 -> D0
  | PIN22 -> A0
  | PIN23 -> A1
  | PIN24 -> A2
  | PIN25 -> A3
  | PIN26 -> A4
  | PIN27 -> A5
  | PIN28 -> A6
  | PIN29 -> A7
  | PIN30 -> C7
  | PIN31 -> C6
  | PIN32 -> C5
  | PIN33 -> C4
  | PIN34 -> C3
  | PIN35 -> C2
  | PIN36 -> C1
  | PIN37 -> C0
  | PIN38 -> D7
  | PIN39 -> G2
  | PIN40 -> G1
  | PIN41 -> G0
  | PIN42 -> L7
  | PIN43 -> L6
  | PIN44 -> L5
  | PIN45 -> L4
  | PIN46 -> L3
  | PIN47 -> L2
  | PIN48 -> L1
  | PIN49 -> L0
  | MISO -> B3
  | SCK -> B1
  | MOSI -> B2
  | SS -> B0
  | PINA0 -> F0
  | PINA1 -> F1
  | PINA2 -> F2
  | PINA3 -> F3
  | PINA4 -> F4
  | PINA5 -> F5
  | PINA6 -> F6
  | PINA7 -> F7
  | PINA8 -> K0
  | PINA9 -> K1
  | PINA10 -> K2
  | PINA11 -> K3
  | PINA12 -> K4
  | PINA13 -> K5
  | PINA14 -> K6
  | PINA15 -> K7

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

external adc_init : unit -> unit = "caml_avr_adc_init"

external avr_analog_read : int -> int = "caml_avr_analog_read"


let channel_of_pin : type a b. (a register , yes analog_pin, b pwm_pin) pin -> int = function
  | PINA0 -> 0
  | PINA1 -> 1
  | PINA2 -> 2
  | PINA3 -> 3
  | PINA4 -> 4
  | PINA5 -> 5
  | PINA6 -> 6
  | PINA7 -> 7
  | PINA8 -> 8
  | PINA9 -> 9
  | PINA10 -> 10
  | PINA11 -> 11
  | PINA12 -> 12
  | PINA13 -> 13
  | PINA14 -> 14
  | PINA15 -> 15

let analog_read p =
  let channel = channel_of_pin p in
  avr_analog_read channel


module Serial = struct

  external init: unit -> unit = "caml_avr_serial_init" [@@noalloc]
  external read : unit -> char = "caml_avr_serial_read" [@@noalloc]
  external write : char -> unit = "caml_avr_serial_write" [@@noalloc]

  let write_string s =
    String.iter write s

  let write_int n =
    write_string (string_of_int n)

end
