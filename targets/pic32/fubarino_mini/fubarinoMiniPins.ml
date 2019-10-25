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
    LATA : lata_bit register 
  | LATB : latb_bit register
  | LATC : latc_bit register
  | TRISA : trisa_bit register
  | TRISB : trisb_bit register
  | TRISC : trisc_bit register
  | PORTA : porta_bit register
  | PORTB : portb_bit register
  | PORTC : portc_bit register


(* 32MX250F128D has 32 I/O pins available. 
   The following pin naming convention stricly follows that which is specified in the Fubarino Mini 
   reference manual (http://ww1.microchip.com/downloads/en/devicedoc/FubarinoMiniUserRefManual.pdf); 
   the pin naming convention corresponds to 'Arduino pins' instead of the low-level pin naming 
   convention available in the official 32MX250F128D datasheet 
   (http://ww1.microchip.com/downloads/en/DeviceDoc/PIC32MX1XX2XX%20283644-PIN_Datasheet_DS60001168L.pdf)
*)

type ('a,'b,'c,'d) pin =
  | PIN0 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN1 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN2 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN3 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN4 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN5 : (lata_bit register, trisa_bit register, porta_bit register, yes analog_pin) pin
  | PIN6 : (lata_bit register, trisa_bit register, porta_bit register, yes analog_pin) pin
  | PIN7 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN8 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN9 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN10 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN11 : (latc_bit register, trisc_bit register, portc_bit register, yes analog_pin) pin
  | PIN12 : (latc_bit register, trisc_bit register, portc_bit register, yes analog_pin) pin
  | PIN13 : (latc_bit register, trisc_bit register, portc_bit register, yes analog_pin) pin
  | PIN14 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN15 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN16 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN17 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN18 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN19 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN20 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN21 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN22 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN23 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN24 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN25 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN26 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN27 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN28 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN29 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN30 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN31 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin
  | PIN32 : (latb_bit register, trisb_bit register, portb_bit register, no analog_pin) pin


let lat_of_pin : type a b c d. (a register,b register,c register,d analog_pin) pin -> a register =
    function
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

  let tris_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b register =
       function
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


  let port_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c register = 
    function
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


  let lat_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> a =
    function 
    | PIN0 -> LB13
    | PIN1 -> LA10
    | PIN2 -> LA7
    | PIN3 -> LB14
    | PIN4 -> LB15
    | PIN5 -> LA0
    | PIN6 -> LA1
    | PIN7 -> LB0
    | PIN8 -> LB1
    | PIN9 -> LB2
    | PIN10 -> LB3
    | PIN11 -> LC0
    | PIN12 -> LC1
    | PIN13 -> LC2
    | PIN14 -> LA2
    | PIN15 -> LA3
    | PIN16 -> LA8
    | PIN17 -> LB4
    | PIN18 -> LA4
    | PIN19 -> LA9
    | PIN20 -> LC3
    | PIN21 -> LC4
    | PIN22 -> LC5
    | PIN23 -> LB5
    | PIN24 -> LB7
    | PIN25 -> LB8
    | PIN26 -> LB9
    | PIN27 -> LC6
    | PIN28 -> LC7
    | PIN29 -> LC8
    | PIN30 -> LC9
    | PIN31 -> LB10
    | PIN32 -> LB11


  
  let tris_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b =
    function 
    | PIN0 -> TB13
    | PIN1 -> TA10
    | PIN2 -> TA7
    | PIN3 -> TB14
    | PIN4 -> TB15
    | PIN5 -> TA0
    | PIN6 -> TA1
    | PIN7 -> TB0
    | PIN8 -> TB1
    | PIN9 -> TB2
    | PIN10 -> TB3
    | PIN11 -> TC0
    | PIN12 -> TC1
    | PIN13 -> TC2
    | PIN14 -> TA2
    | PIN15 -> TA3
    | PIN16 -> TA8
    | PIN17 -> TB4
    | PIN18 -> TA4
    | PIN19 -> TA9
    | PIN20 -> TC3
    | PIN21 -> TC4
    | PIN22 -> TC5
    | PIN23 -> TB5
    | PIN24 -> TB7
    | PIN25 -> TB8
    | PIN26 -> TB9
    | PIN27 -> TC6
    | PIN28 -> TC7
    | PIN29 -> TC8
    | PIN30 -> TC9
    | PIN31 -> TB10
    | PIN32 -> TB11


  let port_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c =
    function 
    | PIN0 -> PB13
    | PIN1 -> PA10
    | PIN2 -> PA7
    | PIN3 -> PB14
    | PIN4 -> PB15
    | PIN5 -> PA0
    | PIN6 -> PA1
    | PIN7 -> PB0
    | PIN8 -> PB1
    | PIN9 -> PB2
    | PIN10 -> PB3
    | PIN11 -> PC0
    | PIN12 -> PC1
    | PIN13 -> PC2
    | PIN14 -> PA2
    | PIN15 -> PA3
    | PIN16 -> PA8
    | PIN17 -> PB4
    | PIN18 -> PA4
    | PIN19 -> PA9
    | PIN20 -> PC3
    | PIN21 -> PC4
    | PIN22 -> PC5
    | PIN23 -> PB5
    | PIN24 -> PB7
    | PIN25 -> PB8
    | PIN26 -> PB9
    | PIN27 -> PC6
    | PIN28 -> PC7
    | PIN29 -> PC8
    | PIN30 -> PC9
    | PIN31 -> PB10
    | PIN32 -> PB11


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
