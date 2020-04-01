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

include Pic32Pins
  with type 'a register := 'a register
  with type ('a, 'b, 'c, 'd)pin := ('a, 'b, 'c, 'd)pin