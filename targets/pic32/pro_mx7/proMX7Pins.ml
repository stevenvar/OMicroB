open Pic32

(* Lchip is based on a 32MX795F512L microcontroller that has 7 ports: A, B, C, D, E, F and G *)

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
type trisd_bit = TD0 | TD1 | TD2 | TD3 | TD4 | TD5 | TD6 | TD7 |
                 TD8 | TD9 | TD10 | TD11 | TD12 | TD13 | TD14 | TD15
type trise_bit = TE0 | TE1 | TE2 | TE3 | TE4 | TE5 | TE6 | TE7 |
                 TE8 | TE9 | TE10 | TE11 | TE12 | TE13 | TE14 | TE15
type trisf_bit = TF0 | TF1 | TF2 | TF3 | TF4 | TF5 | TF6 | TF7 |
                 TF8 | TF9 | TF10 | TF11 | TF12 | TF13 | TF14 | TF15
type trisg_bit = TG0 | TG1 | TG2 | TG3 | TG4 | TG5 | TG6 | TG7 |
                 TG8 | TG9 | TG10 | TG11 | TG12 | TG13 | TG14 | TG15

type porta_bit = PA0 | PA1 | PA2 | PA3 | PA4 | PA5 | PA6 | PA7 |
                 PA8 | PA9 | PA10 | PA11 | PA12 | PA13 | PA14 | PA15
type portb_bit = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7 |
                 PB8 | PB9 | PB10 | PB11 | PB12 | PB13 | PB14 | PB15
type portc_bit = PC0 | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 | PC7 |
                 PC8 | PC9 | PC10 | PC11 | PC12 | PC13 | PC14 | PC15
type portd_bit = PD0 | PD1 | PD2 | PD3 | PD4 | PD5 | PD6 | PD7 |
                 PD8 | PD9 | PD10 | PD11 | PD12 | PD13 | PD14 | PD15
type porte_bit = PE0 | PE1 | PE2 | PE3 | PE4 | PE5 | PE6 | PE7 | 
                 PE8 | PE9 | PE10 | PE11 | PE12 | PE13 | PE14 | PE15
type portf_bit = PF0 | PF1 | PF2 | PF3 | PF4 | PF5 | PF6 | PF7 | 
                 PF8 | PF9 | PF10 | PF11 | PF12 | PF13 | PF14 | PF15
type portg_bit = PG0 | PG1 | PG2 | PG3 | PG4 | PG5 | PG6 | PG7 | 
                 PG8 | PG9 | PG10 | PG11 | PG12 | PG13 | PG14 | PG15

type lata_bit = LA0 | LA1 | LA2 | LA3 | LA4 | LA5 | LA6 | LA7 |
                LA8 | LA9 | LA10 | LA11 | LA12 | LA13 | LA14 | LA15
type latb_bit = LB0 | LB1 | LB2 | LB3 | LB4 | LB5 | LB6 | LB7 |
                LB8 | LB9 | LB10 | LB11 | LB12 | LB13 | LB14 | LB15
type latc_bit = LC0 | LC1 | LC2 | LC3 | LC4 | LC5 | LC6 | LC7 |
                LC8 | LC9 | LC10 | LC11 | LC12 | LC13 | LC14 | LC15
type latd_bit = LD0 | LD1 | LD2 | LD3 | LD4 | LD5 | LD6 | LD7 | 
                LD8 | LD9 | LD10 | LD11 | LD12 | LD13 | LD14 | LD15
type late_bit = LE0 | LE1 | LE2 | LE3 | LE4 | LE5 | LE6 | LE7 | 
                LE8 | LE9 | LE10 | LE11 | LE12 | LE13 | LE14 | LE15
type latf_bit = LF0 | LF1 | LF2 | LF3 | LF4 | LF5 | LF6 | LF7 |
                LF8 | LF9 | LF10 | LF11 | LF12 | LF13 | LF14 | LF15
type latg_bit = LG0 | LG1 | LG2 | LG3 | LG4 | LG5 | LG6 | LG7 |
                LG8 | LG9 | LG10 | LG11 | LG12 | LG13 | LG14 | LG15


type 'a register =
  | LATA : lata_bit register 
  | LATB : latb_bit register
  | LATC : latc_bit register
  | LATD : latd_bit register
  | LATE : late_bit register
  | LATF : latf_bit register
  | LATG : latg_bit register
  | TRISA : trisa_bit register
  | TRISB : trisb_bit register
  | TRISC : trisc_bit register
  | TRISD : trisd_bit register
  | TRISE : trise_bit register
  | TRISF : trisf_bit register
  | TRISG : trisg_bit register
  | PORTA : porta_bit register
  | PORTB : portb_bit register
  | PORTC : portc_bit register
  | PORTD : portd_bit register
  | PORTE : porte_bit register
  | PORTF : portf_bit register
  | PORTG : portg_bit register



(* 32MX795F512L has 83 I/O pins available. 
   The following pin naming convention stricly follows that which is specified in the official datasheet
   (http://ww1.microchip.com/downloads/en/devicedoc/61156g.pdf) on page 17. Therefore, certain pin numbers
    might seem to be missing, but that is because these are not I/O pins (e.g., PIN2, PIN30 or PIN31).
*)

type ('a,'b,'c,'d) pin =
  | PIN1 : (latg_bit register, trisg_bit register, portg_bit register, no analog_pin) pin
  | PIN3 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN4 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN5 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN6 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN7 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN8 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN9 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN10 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN11 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN12 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN14 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN17 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN18 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN19 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN20 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN21 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN22 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN23 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN24 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN25 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN26 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN27 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN28 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN29 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN32 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN33 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN34 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN35 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN38 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN39 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN40 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN41 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN42 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN43 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN44 : (latb_bit register, trisb_bit register, portb_bit register, yes analog_pin) pin
  | PIN47 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN48 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN49 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN50 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN51 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN52 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN53 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN56 : (latg_bit register, trisg_bit register, portg_bit register, no analog_pin) pin
  | PIN57 : (latg_bit register, trisg_bit register, portg_bit register, no analog_pin) pin
  | PIN58 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN59 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN60 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN61 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN63 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN64 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN66 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN67 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN68 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN69 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN70 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN71 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN72 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN73 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN74 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN76 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN77 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN78 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN79 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN80 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN81 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN82 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN83 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN84 : (latd_bit register, trisd_bit register, portd_bit register, no analog_pin) pin
  | PIN87 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN88 : (latf_bit register, trisf_bit register, portf_bit register, no analog_pin) pin
  | PIN89 : (latg_bit register, trisg_bit register, portg_bit register, no analog_pin) pin
  | PIN90 : (latc_bit register, trisc_bit register, portc_bit register, no analog_pin) pin
  | PIN91 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN92 : (lata_bit register, trisa_bit register, porta_bit register, no analog_pin) pin
  | PIN93 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN94 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN95 : (latg_bit register, trisg_bit register, portg_bit register, no analog_pin) pin
  | PIN96 : (latg_bit register, trisg_bit register, portg_bit register, no analog_pin) pin
  | PIN97 : (latg_bit register, trisg_bit register, portg_bit register, no analog_pin) pin
  | PIN98 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN99 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin
  | PIN100 : (late_bit register, trise_bit register, porte_bit register, no analog_pin) pin


let lat_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> a register = 
    function
    | PIN1 -> LATG
    | PIN3 -> LATE
    | PIN4 -> LATE
    | PIN5 -> LATE
    | PIN6 -> LATC
    | PIN7 -> LATC
    | PIN8 -> LATC
    | PIN9 -> LATC
    | PIN10 -> LATC
    | PIN11 -> LATC
    | PIN12 -> LATC
    | PIN14 -> LATC
    | PIN17 -> LATA
    | PIN18 -> LATE
    | PIN19 -> LATE
    | PIN20 -> LATB
    | PIN21 -> LATB
    | PIN22 -> LATB
    | PIN23 -> LATB
    | PIN24 -> LATB
    | PIN25 -> LATB
    | PIN26 -> LATB
    | PIN27 -> LATB
    | PIN28 -> LATA
    | PIN29 -> LATA
    | PIN32 -> LATB
    | PIN33 -> LATB
    | PIN34 -> LATB
    | PIN35 -> LATB
    | PIN38 -> LATA
    | PIN39 -> LATF
    | PIN40 -> LATF
    | PIN41 -> LATB
    | PIN42 -> LATB
    | PIN43 -> LATB
    | PIN44 -> LATB
    | PIN47 -> LATD
    | PIN48 -> LATD
    | PIN49 -> LATF
    | PIN50 -> LATF
    | PIN51 -> LATF
    | PIN52 -> LATF
    | PIN53 -> LATF
    | PIN56 -> LATG
    | PIN57 -> LATG
    | PIN58 -> LATA
    | PIN59 -> LATA
    | PIN60 -> LATA
    | PIN61 -> LATA
    | PIN63 -> LATC
    | PIN64 -> LATC
    | PIN66 -> LATA
    | PIN67 -> LATA
    | PIN68 -> LATD
    | PIN69 -> LATD
    | PIN70 -> LATD
    | PIN71 -> LATD
    | PIN72 -> LATD
    | PIN73 -> LATC
    | PIN74 -> LATC
    | PIN76 -> LATD
    | PIN77 -> LATD
    | PIN78 -> LATD
    | PIN79 -> LATD
    | PIN80 -> LATD
    | PIN81 -> LATD
    | PIN82 -> LATD
    | PIN83 -> LATD
    | PIN84 -> LATD
    | PIN87 -> LATF
    | PIN88 -> LATF
    | PIN89 -> LATG
    | PIN90 -> LATC
    | PIN91 -> LATA
    | PIN92 -> LATA
    | PIN93 -> LATE
    | PIN94 -> LATE
    | PIN95 -> LATG
    | PIN96 -> LATG
    | PIN97 -> LATG
    | PIN98 -> LATE
    | PIN99 -> LATE
    | PIN100 -> LATE

let tris_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b register = 
    function
    | PIN1 -> TRISG
    | PIN3 -> TRISE
    | PIN4 -> TRISE
    | PIN5 -> TRISE
    | PIN6 -> TRISC
    | PIN7 -> TRISC
    | PIN8 -> TRISC
    | PIN9 -> TRISC
    | PIN10 -> TRISC
    | PIN11 -> TRISC
    | PIN12 -> TRISC
    | PIN14 -> TRISC
    | PIN17 -> TRISA
    | PIN18 -> TRISE
    | PIN19 -> TRISE
    | PIN20 -> TRISB
    | PIN21 -> TRISB
    | PIN22 -> TRISB
    | PIN23 -> TRISB
    | PIN24 -> TRISB
    | PIN25 -> TRISB
    | PIN26 -> TRISB
    | PIN27 -> TRISB
    | PIN28 -> TRISA
    | PIN29 -> TRISA
    | PIN32 -> TRISB
    | PIN33 -> TRISB
    | PIN34 -> TRISB
    | PIN35 -> TRISB
    | PIN38 -> TRISA
    | PIN39 -> TRISF
    | PIN40 -> TRISF
    | PIN41 -> TRISB
    | PIN42 -> TRISB
    | PIN43 -> TRISB
    | PIN44 -> TRISB
    | PIN47 -> TRISD
    | PIN48 -> TRISD
    | PIN49 -> TRISF
    | PIN50 -> TRISF
    | PIN51 -> TRISF
    | PIN52 -> TRISF
    | PIN53 -> TRISF
    | PIN56 -> TRISG
    | PIN57 -> TRISG
    | PIN58 -> TRISA
    | PIN59 -> TRISA
    | PIN60 -> TRISA
    | PIN61 -> TRISA
    | PIN63 -> TRISC
    | PIN64 -> TRISC
    | PIN66 -> TRISA
    | PIN67 -> TRISA
    | PIN68 -> TRISD
    | PIN69 -> TRISD
    | PIN70 -> TRISD
    | PIN71 -> TRISD
    | PIN72 -> TRISD
    | PIN73 -> TRISC
    | PIN74 -> TRISC
    | PIN76 -> TRISD
    | PIN77 -> TRISD
    | PIN78 -> TRISD
    | PIN79 -> TRISD
    | PIN80 -> TRISD
    | PIN81 -> TRISD
    | PIN82 -> TRISD
    | PIN83 -> TRISD
    | PIN84 -> TRISD
    | PIN87 -> TRISF
    | PIN88 -> TRISF
    | PIN89 -> TRISG
    | PIN90 -> TRISC
    | PIN91 -> TRISA
    | PIN92 -> TRISA
    | PIN93 -> TRISE
    | PIN94 -> TRISE
    | PIN95 -> TRISG
    | PIN96 -> TRISG
    | PIN97 -> TRISG
    | PIN98 -> TRISE
    | PIN99 -> TRISE
    | PIN100 -> TRISE

let port_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c register = 
    function
    | PIN1 -> PORTG
    | PIN3 -> PORTE
    | PIN4 -> PORTE
    | PIN5 -> PORTE
    | PIN6 -> PORTC
    | PIN7 -> PORTC
    | PIN8 -> PORTC
    | PIN9 -> PORTC
    | PIN10 -> PORTC
    | PIN11 -> PORTC
    | PIN12 -> PORTC
    | PIN14 -> PORTC
    | PIN17 -> PORTA
    | PIN18 -> PORTE
    | PIN19 -> PORTE
    | PIN20 -> PORTB
    | PIN21 -> PORTB
    | PIN22 -> PORTB
    | PIN23 -> PORTB
    | PIN24 -> PORTB
    | PIN25 -> PORTB
    | PIN26 -> PORTB
    | PIN27 -> PORTB
    | PIN28 -> PORTA
    | PIN29 -> PORTA
    | PIN32 -> PORTB
    | PIN33 -> PORTB
    | PIN34 -> PORTB
    | PIN35 -> PORTB
    | PIN38 -> PORTA
    | PIN39 -> PORTF
    | PIN40 -> PORTF
    | PIN41 -> PORTB
    | PIN42 -> PORTB
    | PIN43 -> PORTB
    | PIN44 -> PORTB
    | PIN47 -> PORTD
    | PIN48 -> PORTD
    | PIN49 -> PORTF
    | PIN50 -> PORTF
    | PIN51 -> PORTF
    | PIN52 -> PORTF
    | PIN53 -> PORTF
    | PIN56 -> PORTG
    | PIN57 -> PORTG
    | PIN58 -> PORTA
    | PIN59 -> PORTA
    | PIN60 -> PORTA
    | PIN61 -> PORTA
    | PIN63 -> PORTC
    | PIN64 -> PORTC
    | PIN66 -> PORTA
    | PIN67 -> PORTA
    | PIN68 -> PORTD
    | PIN69 -> PORTD
    | PIN70 -> PORTD
    | PIN71 -> PORTD
    | PIN72 -> PORTD
    | PIN73 -> PORTC
    | PIN74 -> PORTC
    | PIN76 -> PORTD
    | PIN77 -> PORTD
    | PIN78 -> PORTD
    | PIN79 -> PORTD
    | PIN80 -> PORTD
    | PIN81 -> PORTD
    | PIN82 -> PORTD
    | PIN83 -> PORTD
    | PIN84 -> PORTD
    | PIN87 -> PORTF
    | PIN88 -> PORTF
    | PIN89 -> PORTG
    | PIN90 -> PORTC
    | PIN91 -> PORTA
    | PIN92 -> PORTA
    | PIN93 -> PORTE
    | PIN94 -> PORTE
    | PIN95 -> PORTG
    | PIN96 -> PORTG
    | PIN97 -> PORTG
    | PIN98 -> PORTE
    | PIN99 -> PORTE
    | PIN100 -> PORTE


let lat_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> a =
    function 
    | PIN1 -> LG5
    | PIN3 -> LE5
    | PIN4 -> LE6
    | PIN5 -> LE7
    | PIN6 -> LC1
    | PIN7 -> LC2
    | PIN8 -> LC3
    | PIN9 -> LC4
    | PIN10 -> LC6
    | PIN11 -> LC7
    | PIN12 -> LC8
    | PIN14 -> LC9
    | PIN17 -> LA0
    | PIN18 -> LE8
    | PIN19 -> LE9
    | PIN20 -> LB5
    | PIN21 -> LB4
    | PIN22 -> LB3
    | PIN23 -> LB2
    | PIN24 -> LB1
    | PIN25 -> LB0
    | PIN26 -> LB6
    | PIN27 -> LB7
    | PIN28 -> LA9
    | PIN29 -> LA10
    | PIN32 -> LB8
    | PIN33 -> LB9
    | PIN34 -> LB10
    | PIN35 -> LB11
    | PIN38 -> LA1
    | PIN39 -> LF13
    | PIN40 -> LF12
    | PIN41 -> LB12
    | PIN42 -> LB13
    | PIN43 -> LB14
    | PIN44 -> LB15
    | PIN47 -> LD14
    | PIN48 -> LD15
    | PIN49 -> LF4
    | PIN50 -> LF5
    | PIN51 -> LF3
    | PIN52 -> LF2
    | PIN53 -> LF8
    | PIN56 -> LG3
    | PIN57 -> LG2
    | PIN58 -> LA2
    | PIN59 -> LA3
    | PIN60 -> LA4
    | PIN61 -> LA5
    | PIN63 -> LC12
    | PIN64 -> LC15
    | PIN66 -> LA14
    | PIN67 -> LA15
    | PIN68 -> LD8
    | PIN69 -> LD9
    | PIN70 -> LD10
    | PIN71 -> LD11
    | PIN72 -> LD0
    | PIN73 -> LC13
    | PIN74 -> LC14
    | PIN76 -> LD1
    | PIN77 -> LD2
    | PIN78 -> LD3
    | PIN79 -> LD12
    | PIN80 -> LD13
    | PIN81 -> LD4
    | PIN82 -> LD5
    | PIN83 -> LD6
    | PIN84 -> LD7
    | PIN87 -> LF0
    | PIN88 -> LF1
    | PIN89 -> LG1
    | PIN90 -> LC0
    | PIN91 -> LA6
    | PIN92 -> LA7
    | PIN93 -> LE0
    | PIN94 -> LE1
    | PIN95 -> LG14
    | PIN96 -> LG12
    | PIN97 -> LG13
    | PIN98 -> LE2
    | PIN99 -> LE3
    | PIN100 -> LE4

let tris_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b =
    function    
    | PIN1 -> TG5
    | PIN3 -> TE5
    | PIN4 -> TE6
    | PIN5 -> TE7
    | PIN6 -> TC1
    | PIN7 -> TC2
    | PIN8 -> TC3
    | PIN9 -> TC4
    | PIN10 -> TC6
    | PIN11 -> TC7
    | PIN12 -> TC8
    | PIN14 -> TC9
    | PIN17 -> TA0
    | PIN18 -> TE8
    | PIN19 -> TE9
    | PIN20 -> TB5
    | PIN21 -> TB4
    | PIN22 -> TB3
    | PIN23 -> TB2
    | PIN24 -> TB1
    | PIN25 -> TB0
    | PIN26 -> TB6
    | PIN27 -> TB7
    | PIN28 -> TA9
    | PIN29 -> TA10
    | PIN32 -> TB8
    | PIN33 -> TB9
    | PIN34 -> TB10
    | PIN35 -> TB11
    | PIN38 -> TA1
    | PIN39 -> TF13
    | PIN40 -> TF12
    | PIN41 -> TB12
    | PIN42 -> TB13
    | PIN43 -> TB14
    | PIN44 -> TB15
    | PIN47 -> TD14
    | PIN48 -> TD15
    | PIN49 -> TF4
    | PIN50 -> TF5
    | PIN51 -> TF3
    | PIN52 -> TF2
    | PIN53 -> TF8
    | PIN56 -> TG3
    | PIN57 -> TG2
    | PIN58 -> TA2
    | PIN59 -> TA3
    | PIN60 -> TA4
    | PIN61 -> TA5
    | PIN63 -> TC12
    | PIN64 -> TC15
    | PIN66 -> TA14
    | PIN67 -> TA15
    | PIN68 -> TD8
    | PIN69 -> TD9
    | PIN70 -> TD10
    | PIN71 -> TD11
    | PIN72 -> TD0
    | PIN73 -> TC13
    | PIN74 -> TC14
    | PIN76 -> TD1
    | PIN77 -> TD2
    | PIN78 -> TD3
    | PIN79 -> TD12
    | PIN80 -> TD13
    | PIN81 -> TD4
    | PIN82 -> TD5
    | PIN83 -> TD6
    | PIN84 -> TD7
    | PIN87 -> TF0
    | PIN88 -> TF1
    | PIN89 -> TG1
    | PIN90 -> TC0
    | PIN91 -> TA6
    | PIN92 -> TA7
    | PIN93 -> TE0
    | PIN94 -> TE1
    | PIN95 -> TG14
    | PIN96 -> TG12
    | PIN97 -> TG13
    | PIN98 -> TE2
    | PIN99 -> TE3
    | PIN100 -> TE4

let port_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c =
    function 
    | PIN1 -> PG5
    | PIN3 -> PE5
    | PIN4 -> PE6
    | PIN5 -> PE7
    | PIN6 -> PC1
    | PIN7 -> PC2
    | PIN8 -> PC3
    | PIN9 -> PC4
    | PIN10 -> PC6
    | PIN11 -> PC7
    | PIN12 -> PC8
    | PIN14 -> PC9
    | PIN17 -> PA0
    | PIN18 -> PE8
    | PIN19 -> PE9
    | PIN20 -> PB5
    | PIN21 -> PB4
    | PIN22 -> PB3
    | PIN23 -> PB2
    | PIN24 -> PB1
    | PIN25 -> PB0
    | PIN26 -> PB6
    | PIN27 -> PB7
    | PIN28 -> PA9
    | PIN29 -> PA10
    | PIN32 -> PB8
    | PIN33 -> PB9
    | PIN34 -> PB10
    | PIN35 -> PB11
    | PIN38 -> PA1
    | PIN39 -> PF13
    | PIN40 -> PF12
    | PIN41 -> PB12
    | PIN42 -> PB13
    | PIN43 -> PB14
    | PIN44 -> PB15
    | PIN47 -> PD14
    | PIN48 -> PD15
    | PIN49 -> PF4
    | PIN50 -> PF5
    | PIN51 -> PF3
    | PIN52 -> PF2
    | PIN53 -> PF8
    | PIN56 -> PG3
    | PIN57 -> PG2
    | PIN58 -> PA2
    | PIN59 -> PA3
    | PIN60 -> PA4
    | PIN61 -> PA5
    | PIN63 -> PC12
    | PIN64 -> PC15
    | PIN66 -> PA14
    | PIN67 -> PA15
    | PIN68 -> PD8
    | PIN69 -> PD9
    | PIN70 -> PD10
    | PIN71 -> PD11
    | PIN72 -> PD0
    | PIN73 -> PC13
    | PIN74 -> PC14
    | PIN76 -> PD1
    | PIN77 -> PD2
    | PIN78 -> PD3
    | PIN79 -> PD12
    | PIN80 -> PD13
    | PIN81 -> PD4
    | PIN82 -> PD5
    | PIN83 -> PD6
    | PIN84 -> PD7
    | PIN87 -> PF0
    | PIN88 -> PF1
    | PIN89 -> PG1
    | PIN90 -> PC0
    | PIN91 -> PA6
    | PIN92 -> PA7
    | PIN93 -> PE0
    | PIN94 -> PE1
    | PIN95 -> PG14
    | PIN96 -> PG12
    | PIN97 -> PG13
    | PIN98 -> PE2
    | PIN99 -> PE3
    | PIN100 -> PE4

      

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

