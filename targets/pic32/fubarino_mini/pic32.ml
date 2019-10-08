type level = HIGH | LOW
type _level = level

type mode = INPUT | OUTPUT
type _mode = mode

type bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7  
         | B8 | B9 | B10 | B11 | B12 | B13 | B14 | B15 
         | B16 | B17 | B18 | B19 | B20 | B21 | B22 | B23 
         | B24 | B25 | B26 | B27 | B28 | B29 | B30 | B31

type register = TRISA | TRISB | TRISC 
              | LATA | LATB | LATC 
              | PORTA | PORTB | PORTC 

external write_register : register -> int -> unit = "caml_pic32_write_register" [@@noalloc]
external read_register : register -> int = "caml_pic32_read_register" [@@noalloc]
external set_bit : register -> bit -> unit = "caml_pic32_set_bit" [@@noalloc]
external clear_bit : register -> bit -> unit = "caml_pic32_clear_bit" [@@noalloc]
external read_bit : register -> bit -> bool = "caml_pic32_read_bit" [@@noalloc]
external delay : int -> unit = "caml_pic32_delay" [@@noalloc]


  type pin = PIN0 | PIN1 | PIN2 | PIN3 | PIN4 | PIN5 | PIN6 | PIN7
           | PIN8 | PIN9 | PIN10 | PIN11 | PIN12 | PIN13 | PIN14
           | PIN15 | PIN16 | PIN17 | PIN18 | PIN19 | PIN20 | PIN21
           | PIN22 | PIN23 | PIN24 | PIN25 | PIN26 | PIN27 | PIN28
           | PIN29 | PIN30 | PIN31 | PIN32

  type _pin = pin

  let port_of_pin = function
    | PIN0 -> PORTB
    | PIN1 -> PORTA
    | PIN2 -> PORTA
    | PIN3 -> PORTB
    | PIN4 -> PORTB
    | PIN5 -> PORTA
    | PIN6 -> PORTA
    | PIN7 -> PORTB
    | PIN8 -> PORTB
    | PIN9 -> PORTB
    | PIN10 -> PORTB
    | PIN11 -> PORTC
    | PIN12 -> PORTC
    | PIN13 -> PORTC
    | PIN14 -> PORTA
    | PIN15 -> PORTA
    | PIN16 -> PORTA
    | PIN17 -> PORTB
    | PIN18 -> PORTA
    | PIN19 -> PORTA
    | PIN20 -> PORTC
    | PIN21 -> PORTC
    | PIN22 -> PORTC
    | PIN23 -> PORTB
    | PIN24 -> PORTB
    | PIN25 -> PORTB
    | PIN26 -> PORTB
    | PIN27 -> PORTC
    | PIN28 -> PORTC
    | PIN29 -> PORTC
    | PIN30 -> PORTC
    | PIN31 -> PORTB
    | PIN32 -> PORTB

  let lat_of_pin = function
    | PIN0 -> LATB
    | PIN1 -> LATA
    | PIN2 -> LATA
    | PIN3 -> LATB
    | PIN4 -> LATB
    | PIN5 -> LATA
    | PIN6 -> LATA
    | PIN7 -> LATB
    | PIN8 -> LATB
    | PIN9 -> LATB
    | PIN10 -> LATB
    | PIN11 -> LATC
    | PIN12 -> LATC
    | PIN13 -> LATC
    | PIN14 -> LATA
    | PIN15 -> LATA
    | PIN16 -> LATA
    | PIN17 -> LATB
    | PIN18 -> LATA
    | PIN19 -> LATA
    | PIN20 -> LATC
    | PIN21 -> LATC
    | PIN22 -> LATC
    | PIN23 -> LATB
    | PIN24 -> LATB
    | PIN25 -> LATB
    | PIN26 -> LATB
    | PIN27 -> LATC
    | PIN28 -> LATC
    | PIN29 -> LATC
    | PIN30 -> LATC
    | PIN31 -> LATB
    | PIN32 -> LATB


  let tris_of_pin = function
    | PIN0 -> TRISB
    | PIN1 -> TRISA
    | PIN2 -> TRISA
    | PIN3 -> TRISB
    | PIN4 -> TRISB
    | PIN5 -> TRISA
    | PIN6 -> TRISA
    | PIN7 -> TRISB
    | PIN8 -> TRISB
    | PIN9 -> TRISB
    | PIN10 -> TRISB
    | PIN11 -> TRISC
    | PIN12 -> TRISC
    | PIN13 -> TRISC
    | PIN14 -> TRISA
    | PIN15 -> TRISA
    | PIN16 -> TRISA
    | PIN17 -> TRISB
    | PIN18 -> TRISA
    | PIN19 -> TRISA
    | PIN20 -> TRISC
    | PIN21 -> TRISC
    | PIN22 -> TRISC
    | PIN23 -> TRISB
    | PIN24 -> TRISB
    | PIN25 -> TRISB
    | PIN26 -> TRISB
    | PIN27 -> TRISC
    | PIN28 -> TRISC
    | PIN29 -> TRISC
    | PIN30 -> TRISC
    | PIN31 -> TRISB
    | PIN32 -> TRISB

  let bit_of_pin = function
    | PIN0 -> B13
    | PIN1 -> B10
    | PIN2 -> B7
    | PIN3 -> B14
    | PIN4 -> B15
    | PIN5 -> B0
    | PIN6 -> B1
    | PIN7 -> B0
    | PIN8 -> B1
    | PIN9 -> B2
    | PIN10 -> B3
    | PIN11 -> B0
    | PIN12 -> B1
    | PIN13 -> B2
    | PIN14 -> B2
    | PIN15 -> B3
    | PIN16 -> B8
    | PIN17 -> B4
    | PIN18 -> B4
    | PIN19 -> B9
    | PIN20 -> B3
    | PIN21 -> B4
    | PIN22 -> B5
    | PIN23 -> B5
    | PIN24 -> B7
    | PIN25 -> B8
    | PIN26 -> B9
    | PIN27 -> B6
    | PIN28 -> B7
    | PIN29 -> B8
    | PIN30 -> B9
    | PIN31 -> B10
    | PIN32 -> B11

  let pin_mode p m =
    let tris = tris_of_pin p in 
    let bit = bit_of_pin p in
    match m with
      | OUTPUT -> clear_bit tris bit
      | INPUT -> set_bit tris bit

  let digital_write p l = 
    let lat = lat_of_pin p in 
    let bit = bit_of_pin p in
    match l with
      | HIGH -> set_bit lat bit
      | LOW -> clear_bit lat bit

  let digital_read p =
    let port = port_of_pin p in 
    let bit = bit_of_pin p in 
    match read_bit port bit with
    | true -> HIGH
    | false -> LOW



