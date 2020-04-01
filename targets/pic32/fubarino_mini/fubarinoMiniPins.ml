open Pic32

(* Fubarino Mini is based on a 32MX250F128D microcontroller that has 3 ports: A, B and C *)

(* TRISx, PORTx and LATx registers specification: 
   TRISx, PORTx and LATx registers are 32 bit-registers, however, only bits 0 to 15 are 
   accessible for R/W operations; the remainder is reserved.
*)

type trisa_bit = TA0 | TA1 | TA2 | TA3 | TA4 | TA5 | TA6 | TA7 | 
                 TA8 | TA9 | TA10 | TA11 | TA12 | TA13 | TA14 | TA15 
type trisb_bit = TB0 | TB1 | TB2 | TB3 | TB4 | TB5 | TB6 | TB7 |  
                 TB8 | TB9 | TB10 | TB11 | TB12 | TB13 | TB14 | TB15 
type trisc_bit = TC0 | TC1 | TC2 | TC3 | TC4 | TC5 | TC6 | TC7 |
                 TC8 | TC9 | TC10 | TC11 | TC12 | TC13 | TC14 | TC15

type porta_bit = PA0 | PA1 | PA2 | PA3 | PA4 | PA5 | PA6 | PA7 |
                 PA8 | PA9 | PA10 | PA11 | PA12 | PA13 | PA14 | PA15
type portb_bit = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7 |
                 PB8 | PB9 | PB10 | PB11 | PB12 | PB13 | PB14 | PB15
type portc_bit = PC0 | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 | PC7 |
                 PC8 | PC9 | PC10 | PC11 | PC12 | PC13 | PC14 | PC15

type lata_bit = LA0 | LA1 | LA2 | LA3 | LA4 | LA5 | LA6 | LA7 |
                LA8 | LA9 | LA10 | LA11 | LA12 | LA13 | LA14 | LA15
type latb_bit = LB0 | LB1 | LB2 | LB3 | LB4 | LB5 | LB6 | LB7 |
                LB8 | LB9 | LB10 | LB11 | LB12 | LB13 | LB14 | LB15
type latc_bit = LC0 | LC1 | LC2 | LC3 | LC4 | LC5 | LC6 | LC7 |
                LC8 | LC9 | LC10 | LC11 | LC12 | LC13 | LC14 | LC15

type 'a register =
  | LATA : lata_bit register 
  | LATB : latb_bit register
  | LATC : latc_bit register
  | TRISA : trisa_bit register
  | TRISB : trisb_bit register
  | TRISC : trisc_bit register
  | PORTA : porta_bit register
  | PORTB : portb_bit register
  | PORTC : portc_bit register


type ('a,'b,'c,'d) pin =
  | PIN1 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN2 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN3 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN4 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN5 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN8 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN9 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN11 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN12 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN13 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN14 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN15 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN19 : (lata_bit register, trisa_bit register, porta_bit register, yes analog_pin) pin
  | PIN20 : (lata_bit register, trisa_bit register, porta_bit register, yes analog_pin) pin
  | PIN21 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN22 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN23 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN24 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN25 : (latc_bit register, trisc_bit register, portc_bit register, yes analog_pin) pin
  | PIN26 : (latc_bit register, trisc_bit register, portc_bit register, yes analog_pin) pin
  | PIN27 : (latc_bit register, trisc_bit register, portc_bit register, yes analog_pin) pin
  | PIN30 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN31 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN32 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN33 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN34 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN35 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN36 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN37 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN38 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN41 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN43 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN44 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin

let lat_of_pin : type a b c d. (a register,b register,c register,d analog_pin) pin -> a register =
    function
    | PIN1 -> LATB
    | PIN2 -> LATC
    | PIN3 -> LATC
    | PIN4 -> LATC
    | PIN5 -> LATC
    | PIN8 -> LATB
    | PIN9 -> LATB
    | PIN11 -> LATB
    | PIN12 -> LATA
    | PIN13 -> LATA
    | PIN14 -> LATB
    | PIN15 -> LATB
    | PIN19 -> LATA
    | PIN20 -> LATA
    | PIN21 -> LATB
    | PIN22 -> LATB
    | PIN23 -> LATB
    | PIN24 -> LATB
    | PIN25 -> LATC
    | PIN26 -> LATC
    | PIN27 -> LATC
    | PIN30 -> LATA
    | PIN31 -> LATA
    | PIN32 -> LATA
    | PIN33 -> LATB
    | PIN34 -> LATA
    | PIN35 -> LATA
    | PIN36 -> LATC
    | PIN37 -> LATC
    | PIN38 -> LATC
    | PIN41 -> LATB
    | PIN43 -> LATB
    | PIN44 -> LATB

  let tris_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b register =
       function
    | PIN1 -> TRISB
    | PIN2 -> TRISC
    | PIN3 -> TRISC
    | PIN4 -> TRISC
    | PIN5 -> TRISC
    | PIN8 -> TRISB
    | PIN9 -> TRISB
    | PIN11 -> TRISB
    | PIN12 -> TRISA
    | PIN13 -> TRISA
    | PIN14 -> TRISB
    | PIN15 -> TRISB
    | PIN19 -> TRISA
    | PIN20 -> TRISA
    | PIN21 -> TRISB
    | PIN22 -> TRISB
    | PIN23 -> TRISB
    | PIN24 -> TRISB
    | PIN25 -> TRISC
    | PIN26 -> TRISC
    | PIN27 -> TRISC
    | PIN30 -> TRISA
    | PIN31 -> TRISA
    | PIN32 -> TRISA
    | PIN33 -> TRISB
    | PIN34 -> TRISA
    | PIN35 -> TRISA
    | PIN36 -> TRISC
    | PIN37 -> TRISC
    | PIN38 -> TRISC
    | PIN41 -> TRISB
    | PIN43 -> TRISB
    | PIN44 -> TRISB



  let port_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c register = 
    function
    | PIN1 -> PORTB
    | PIN2 -> PORTC
    | PIN3 -> PORTC
    | PIN4 -> PORTC
    | PIN5 -> PORTC
    | PIN8 -> PORTB
    | PIN9 -> PORTB
    | PIN11 -> PORTB
    | PIN12 -> PORTA
    | PIN13 -> PORTA
    | PIN14 -> PORTB
    | PIN15 -> PORTB
    | PIN19 -> PORTA
    | PIN20 -> PORTA
    | PIN21 -> PORTB
    | PIN22 -> PORTB
    | PIN23 -> PORTB
    | PIN24 -> PORTB
    | PIN25 -> PORTC
    | PIN26 -> PORTC
    | PIN27 -> PORTC
    | PIN30 -> PORTA
    | PIN31 -> PORTA
    | PIN32 -> PORTA
    | PIN33 -> PORTB
    | PIN34 -> PORTA
    | PIN35 -> PORTA
    | PIN36 -> PORTC
    | PIN37 -> PORTC
    | PIN38 -> PORTC
    | PIN41 -> PORTB
    | PIN43 -> PORTB
    | PIN44 -> PORTB



  let lat_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> a =
    function 
    | PIN1 -> LB9
    | PIN2 -> LC6
    | PIN3 -> LC7
    | PIN4 -> LC8
    | PIN5 -> LC9
    | PIN8 -> LB10
    | PIN9 -> LB11
    | PIN11 -> LB13
    | PIN12 -> LA10
    | PIN13 -> LA7
    | PIN14 -> LB14
    | PIN15 -> LB15
    | PIN19 -> LA0
    | PIN20 -> LA1
    | PIN21 -> LB0
    | PIN22 -> LB1
    | PIN23 -> LB2
    | PIN24 -> LB3
    | PIN25 -> LC0
    | PIN26 -> LC1
    | PIN27 -> LC2
    | PIN30 -> LA2
    | PIN31 -> LA3
    | PIN32 -> LA8
    | PIN33 -> LB4
    | PIN34 -> LA4
    | PIN35 -> LA9
    | PIN36 -> LC3
    | PIN37 -> LC4
    | PIN38 -> LC5
    | PIN41 -> LB5
    | PIN43 -> LB7
    | PIN44 -> LB8



  
  let tris_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b =
    function 
    | PIN1 -> TB9
    | PIN2 -> TC6
    | PIN3 -> TC7
    | PIN4 -> TC8
    | PIN5 -> TC9
    | PIN8 -> TB10
    | PIN9 -> TB11
    | PIN11 -> TB13
    | PIN12 -> TA10
    | PIN13 -> TA7
    | PIN14 -> TB14
    | PIN15 -> TB15
    | PIN19 -> TA0
    | PIN20 -> TA1
    | PIN21 -> TB0
    | PIN22 -> TB1
    | PIN23 -> TB2
    | PIN24 -> TB3
    | PIN25 -> TC0
    | PIN26 -> TC1
    | PIN27 -> TC2
    | PIN30 -> TA2
    | PIN31 -> TA3
    | PIN32 -> TA8
    | PIN33 -> TB4
    | PIN34 -> TA4
    | PIN35 -> TA9
    | PIN36 -> TC3
    | PIN37 -> TC4
    | PIN38 -> TC5
    | PIN41 -> TB5
    | PIN43 -> TB7
    | PIN44 -> TB8



  let port_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c =
    function 
    | PIN1 -> PB9
    | PIN2 -> PC6
    | PIN3 -> PC7
    | PIN4 -> PC8
    | PIN5 -> PC9
    | PIN8 -> PB10
    | PIN9 -> PB11
    | PIN11 -> PB13
    | PIN12 -> PA10
    | PIN13 -> PA7
    | PIN14 -> PB14
    | PIN15 -> PB15
    | PIN19 -> PA0
    | PIN20 -> PA1
    | PIN21 -> PB0
    | PIN22 -> PB1
    | PIN23 -> PB2
    | PIN24 -> PB3
    | PIN25 -> PC0
    | PIN26 -> PC1
    | PIN27 -> PC2
    | PIN30 -> PA2
    | PIN31 -> PA3
    | PIN32 -> PA8
    | PIN33 -> PB4
    | PIN34 -> PA4
    | PIN35 -> PA9
    | PIN36 -> PC3
    | PIN37 -> PC4
    | PIN38 -> PC5
    | PIN41 -> PB5
    | PIN43 -> PB7
    | PIN44 -> PB8



external write_register : 'a register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register : 'a register -> int = "caml_read_register" [@@noalloc]
external set_bit : 'a register -> 'a -> unit = "caml_set_bit" [@@noalloc]
external clear_bit : 'a register -> 'a -> unit = "caml_clear_bit" [@@noalloc]
external read_bit : 'a register -> 'a -> bool = "caml_read_bit" [@@noalloc]


let pin_mode p m =
  let tris = tris_of_pin p in 
  let bit = tris_bit_of_pin p in
  match m with
    | OUTPUT -> clear_bit tris bit
    | INPUT -> set_bit tris bit

let digital_write p l = 
  let lat = lat_of_pin p in 
  let bit = lat_bit_of_pin p in
  match l with
    | HIGH -> set_bit lat bit
    | LOW -> clear_bit lat bit

let digital_read p =
  let port = port_of_pin p in 
  let bit = port_bit_of_pin p in 
  match read_bit port bit with
  | true -> HIGH
  | false -> LOW
