type bit = B0 | B1 | B2 | B3 | B4 | B5 | B6 | B7  
         | B8 | B9 | B10 | B11 | B12 | B13 | B14 | B15 
         | B16 | B17 | B18 | B19 | B20 | B21 | B22 | B23 
         | B24 | B25 | B26 | B27 | B28 | B29 | B30 | B31

type register = TRISA | TRISB | TRISC | TRISD | TRISE | TRISF | TRISG
              | LATA | LATB | LATC | LATD | LATE | LATF | LATG
              | PORTA | PORTB | PORTC | PORTD | PORTE | PORTF | PORTG

type mode = INPUT | OUTPUT

type level = HIGH | LOW

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
         
val port_of_pin: pin -> register
val lat_of_pin: pin -> register
val tris_of_pin: pin -> register
val bit_of_pin: pin -> bit
val pin_mode: pin -> mode -> unit
val digital_write: pin -> level -> unit
val digital_read: pin -> level
 