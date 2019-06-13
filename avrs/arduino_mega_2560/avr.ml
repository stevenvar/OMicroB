type porta_bit = PA0 | PA1 | PA2 | PA3 | PA4 | PA5 | PA6 | PA7
type portb_bit = PB0 | PB1 | PB2 | PB3 | PB4 | PB5 | PB6 | PB7
type portc_bit = PC0 | PC1 | PC2 | PC3 | PC4 | PC5 | PC6 | PC7
type portd_bit = PD0 | PD1 | PD2 | PD3 | PD4 | PD5 | PD6 | PD7
type porte_bit = PE0 | PE1 | PE2 | PE3 | PE4 | PE5 | PE6 | PE7
type portf_bit = PF0 | PF1 | PF2 | PF3 | PF4 | PF5 | PF6 | PF7
type portg_bit = PG0 | PG1 | PG2 | PG3 | PG4 | PG5 | PG6 | PG7
type porth_bit = PH0 | PH1 | PH2 | PH3 | PH4 | PH5 | PH6 | PH7
type portj_bit = PJ0 | PJ1 | PJ2 | PJ3 | PJ4 | PJ5 | PJ6 | PJ7
type portl_bit = PL0 | PL1 | PL2 | PL3 | PL4 | PL5 | PL6 | PL7
type portk_bit = PK0 | PK1 | PK2 | PK3 | PK4 | PK5 | PK6 | PK7

type ddra_bit = DA0 | DA1 | DA2 | DA3 | DA4 | DA5 | DA6 | DA7
type ddrb_bit = DB0 | DB1 | DB2 | DB3 | DB4 | DB5 | DB6 | DB7
type ddrc_bit = DC0 | DC1 | DC2 | DC3 | DC4 | DC5 | DC6 | DC7
type ddrd_bit = DD0 | DD1 | DD2 | DD3 | DD4 | DD5 | DD6 | DD7
type ddre_bit = DE0 | DE1 | DE2 | DE3 | DE4 | DE5 | DE6 | DE7
type ddrf_bit = DF0 | DF1 | DF2 | DF3 | DF4 | DF5 | DF6 | DF7
type ddrg_bit = DG0 | DG1 | DG2 | DG3 | DG4 | DG5 | DG6 | DG7
type ddrh_bit = DH0 | DH1 | DH2 | DH3 | DH4 | DH5 | DH6 | DH7
type ddrj_bit = DJ0 | DJ1 | DJ2 | DJ3 | DJ4 | DJ5 | DJ6 | DJ7
type ddrl_bit = DL0 | DL1 | DL2 | DL3 | DL4 | DL5 | DL6 | DL7
type ddrk_bit = DK0 | DK1 | DK2 | DK3 | DK4 | DK5 | DK6 | DK7

type pina_bit = IA0 | IA1 | IA2 | IA3 | IA4 | IA5 | IA6 | IA7
type pinb_bit = IB0 | IB1 | IB2 | IB3 | IB4 | IB5 | IB6 | IB7
type pinc_bit = IC0 | IC1 | IC2 | IC3 | IC4 | IC5 | IC6 | IC7
type pind_bit = ID0 | ID1 | ID2 | ID3 | ID4 | ID5 | ID6 | ID7
type pine_bit = IE0 | IE1 | IE2 | IE3 | IE4 | IE5 | IE6 | IE7
type pinf_bit = IF0 | IF1 | IF2 | IF3 | IF4 | IF5 | IF6 | IF7
type ping_bit = IG0 | IG1 | IG2 | IG3 | IG4 | IG5 | IG6 | IG7
type pinh_bit = IH0 | IH1 | IH2 | IH3 | IH4 | IH5 | IH6 | IH7
type pinj_bit = IJ0 | IJ1 | IJ2 | IJ3 | IJ4 | IJ5 | IJ6 | IJ7
type pinl_bit = IL0 | IL1 | IL2 | IL3 | IL4 | IL5 | IL6 | IL7
type pink_bit = IK0 | IK1 | IK2 | IK3 | IK4 | IK5 | IK6 | IK7

type spcr_bit = SPR0 | SPR1 | CPHA | CPOL | MSTR | DORD | SPE | SPIE
type spsr_bit = SPI2x | SPSR1 | SPSR2 | SPSR3 | SPSR4 | SPSR5 | SPSR6 | SPIF
type spdr_bit = SPDR0 | SPDR1 | SPDR2 | SPDR3 | SPDR4 | SPDR5 | SPDR6 | SPDR7

type 'a register =
  | PORTA : porta_bit register
  | PORTB : portb_bit register
  | PORTC : portc_bit register
  | PORTD : portd_bit register
  | PORTE : porte_bit register
  | PORTF : portf_bit register
  | PORTG : portg_bit register
  | PORTH : porth_bit register
  | PORTJ : portj_bit register
  | PORTK : portk_bit register
  | PORTL : portl_bit register
  | DDRA : ddra_bit register
  | DDRB : ddrb_bit register
  | DDRC : ddrc_bit register
  | DDRD : ddrd_bit register
  | DDRE : ddre_bit register
  | DDRF : ddrf_bit register
  | DDRG : ddrg_bit register
  | DDRH : ddrh_bit register
  | DDRJ : ddrj_bit register
  | DDRK : ddrk_bit register
  | DDRL : ddrl_bit register
  | PINA : pina_bit register
  | PINB : pinb_bit register
  | PINC : pinc_bit register
  | PIND : pind_bit register
  | PINE : pine_bit register
  | PINF : pinf_bit register
  | PING : ping_bit register
  | PINH : pinh_bit register
  | PINJ : pinj_bit register
  | PINK : pink_bit register
  | PINL : pinl_bit register
  | SPCR : spcr_bit register
  | SPSR : spsr_bit register
  | SPDR : spsr_bit register

type yes
type no
type 'a analog_pin =
  | YES : yes analog_pin
  | NO : no analog_pin

type ('a,'b,'c,'d) pin =
  | PIN0  : (porte_bit register, ddre_bit register, pine_bit register, no analog_pin) pin
  | PIN1  : (porte_bit register, ddre_bit register, pine_bit register, no analog_pin) pin
  | PIN2  : (porte_bit register, ddre_bit register, pine_bit register, no analog_pin) pin
  | PIN3  : (porte_bit register, ddre_bit register, pine_bit register, no analog_pin) pin
  | PIN4  : (portg_bit register, ddrg_bit register, ping_bit register, no analog_pin) pin
  | PIN5  : (porte_bit register, ddre_bit register, pine_bit register, no analog_pin) pin
  | PIN6  : (porth_bit register, ddrh_bit register, pinh_bit register, no analog_pin) pin
  | PIN7  : (porth_bit register, ddrh_bit register, pinh_bit register, no analog_pin) pin
  | PIN8  : (porth_bit register, ddrh_bit register, pinh_bit register, no analog_pin) pin
  | PIN9  : (porth_bit register, ddrh_bit register, pinh_bit register, no analog_pin) pin
  | PIN10 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN11 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN12 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN13 : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PIN14 : (portj_bit register, ddrj_bit register, pinj_bit register, no analog_pin) pin
  | PIN15 : (portj_bit register, ddrj_bit register, pinj_bit register, no analog_pin) pin
  | PIN16 : (porth_bit register, ddrh_bit register, pinh_bit register, no analog_pin) pin
  | PIN17 : (porth_bit register, ddrh_bit register, pinh_bit register, no analog_pin) pin
  | PIN18 : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN19 : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN20 : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN21 : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN22 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN23 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN24 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN25 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN26 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN27 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN28 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN29 : (porta_bit register, ddra_bit register, pina_bit register, no analog_pin) pin
  | PIN30 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN31 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN32 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN33 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN34 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN35 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN36 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN37 : (portc_bit register, ddrc_bit register, pinc_bit register, no analog_pin) pin
  | PIN38 : (portd_bit register, ddrd_bit register, pind_bit register, no analog_pin) pin
  | PIN39 : (portg_bit register, ddrg_bit register, ping_bit register, no analog_pin) pin
  | PIN40 : (portg_bit register, ddrg_bit register, ping_bit register, no analog_pin) pin
  | PIN41 : (portg_bit register, ddrg_bit register, ping_bit register, no analog_pin) pin
  | PIN42 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | PIN43 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | PIN44 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | PIN45 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | PIN46 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | PIN47 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | PIN48 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | PIN49 : (portl_bit register, ddrl_bit register, pinl_bit register, no analog_pin) pin
  | MISO  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | SCK   : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | MOSI  : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | SS    : (portb_bit register, ddrb_bit register, pinb_bit register, no analog_pin) pin
  | PINA0 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA1 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA2 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA3 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA4 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA5 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA6 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA7 : (portf_bit register, ddrf_bit register, pinf_bit register, yes analog_pin) pin
  | PINA8 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin
  | PINA9 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin
  | PINA10 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin
  | PINA11 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin
  | PINA12 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin
  | PINA13 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin
  | PINA14 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin
  | PINA15 : (portk_bit register, ddrk_bit register, pink_bit register, yes analog_pin) pin

type mode = INPUT | OUTPUT | INPUT_PULLUP

type level = LOW | HIGH

let port_of_pin : type a b c d. (a register,b register, c register, d analog_pin) pin -> a register =
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

let ddr_of_pin : type a b c d. (a register , b register, c register, d analog_pin) pin -> b register=
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


let input_of_pin : type a b c d. (a register , b register, c register, d analog_pin) pin -> c register=
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

let port_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> a =
  function
  | PIN0 -> PE0
  | PIN1 -> PE1
  | PIN2 -> PE4
  | PIN3 -> PE5
  | PIN4 -> PG5
  | PIN5 -> PE3
  | PIN6 -> PH3
  | PIN7 -> PH4
  | PIN8 -> PH5
  | PIN9 -> PH6
  | PIN10 -> PB4
  | PIN11 -> PB5
  | PIN12 -> PB6
  | PIN13 -> PB7
  | PIN14 -> PJ1
  | PIN15 -> PJ0
  | PIN16 -> PH1
  | PIN17 -> PH0
  | PIN18 -> PD3
  | PIN19 -> PD2
  | PIN20 -> PD1
  | PIN21 -> PD0
  | PIN22 -> PA0
  | PIN23 -> PA1
  | PIN24 -> PA2
  | PIN25 -> PA3
  | PIN26 -> PA4
  | PIN27 -> PA5
  | PIN28 -> PA6
  | PIN29 -> PA7
  | PIN30 -> PC7
  | PIN31 -> PC6
  | PIN32 -> PC5
  | PIN33 -> PC4
  | PIN34 -> PC3
  | PIN35 -> PC2
  | PIN36 -> PC1
  | PIN37 -> PC0
  | PIN38 -> PD7
  | PIN39 -> PG2
  | PIN40 -> PG1
  | PIN41 -> PG0
  | PIN42 -> PL7
  | PIN43 -> PL6
  | PIN44 -> PL5
  | PIN45 -> PL4
  | PIN46 -> PL3
  | PIN47 -> PL2
  | PIN48 -> PL1
  | PIN49 -> PL0
  | MISO -> PB3
  | SCK -> PB1
  | MOSI -> PB2
  | SS -> PB0
  | PINA0 -> PF0
  | PINA1 -> PF1
  | PINA2 -> PF2
  | PINA3 -> PF3
  | PINA4 -> PF4
  | PINA5 -> PF5
  | PINA6 -> PF6
  | PINA7 -> PF7
  | PINA8 -> PK0
  | PINA9 -> PK1
  | PINA10 -> PK2
  | PINA11 -> PK3
  | PINA12 -> PK4
  | PINA13 -> PK5
  | PINA14 -> PK6
  | PINA15 -> PK7


let ddr_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> b =
  function
  | PIN0 -> DE0
  | PIN1 -> DE1
  | PIN2 -> DE4
  | PIN3 -> DE5
  | PIN4 -> DG5
  | PIN5 -> DE3
  | PIN6 -> DH3
  | PIN7 -> DH4
  | PIN8 -> DH5
  | PIN9 -> DH6
  | PIN10 -> DB4
  | PIN11 -> DB5
  | PIN12 -> DB6
  | PIN13 -> DB7
  | PIN14 -> DJ1
  | PIN15 -> DJ0
  | PIN16 -> DH1
  | PIN17 -> DH0
  | PIN18 -> DD3
  | PIN19 -> DD2
  | PIN20 -> DD1
  | PIN21 -> DD0
  | PIN22 -> DA0
  | PIN23 -> DA1
  | PIN24 -> DA2
  | PIN25 -> DA3
  | PIN26 -> DA4
  | PIN27 -> DA5
  | PIN28 -> DA6
  | PIN29 -> DA7
  | PIN30 -> DC7
  | PIN31 -> DC6
  | PIN32 -> DC5
  | PIN33 -> DC4
  | PIN34 -> DC3
  | PIN35 -> DC2
  | PIN36 -> DC1
  | PIN37 -> DC0
  | PIN38 -> DD7
  | PIN39 -> DG2
  | PIN40 -> DG1
  | PIN41 -> DG0
  | PIN42 -> DL7
  | PIN43 -> DL6
  | PIN44 -> DL5
  | PIN45 -> DL4
  | PIN46 -> DL3
  | PIN47 -> DL2
  | PIN48 -> DL1
  | PIN49 -> DL0
  | MISO -> DB3
  | SCK -> DB1
  | MOSI -> DB2
  | SS -> DB0
  | PINA0 -> DF0
  | PINA1 -> DF1
  | PINA2 -> DF2
  | PINA3 -> DF3
  | PINA4 -> DF4
  | PINA5 -> DF5
  | PINA6 -> DF6
  | PINA7 -> DF7
  | PINA8 -> DK0
  | PINA9 -> DK1
  | PINA10 -> DK2
  | PINA11 -> DK3
  | PINA12 -> DK4
  | PINA13 -> DK5
  | PINA14 -> DK6
  | PINA15 -> DK7



let input_bit_of_pin : type a b c d. (a register, b register, c register, d analog_pin) pin -> c =
  function
  | PIN0 -> IE0
  | PIN1 -> IE1
  | PIN2 -> IE4
  | PIN3 -> IE5
  | PIN4 -> IG5
  | PIN5 -> IE3
  | PIN6 -> IH3
  | PIN7 -> IH4
  | PIN8 -> IH5
  | PIN9 -> IH6
  | PIN10 -> IB4
  | PIN11 -> IB5
  | PIN12 -> IB6
  | PIN13 -> IB7
  | PIN14 -> IJ1
  | PIN15 -> IJ0
  | PIN16 -> IH1
  | PIN17 -> IH0
  | PIN18 -> ID3
  | PIN19 -> ID2
  | PIN20 -> ID1
  | PIN21 -> ID0
  | PIN22 -> IA0
  | PIN23 -> IA1
  | PIN24 -> IA2
  | PIN25 -> IA3
  | PIN26 -> IA4
  | PIN27 -> IA5
  | PIN28 -> IA6
  | PIN29 -> IA7
  | PIN30 -> IC7
  | PIN31 -> IC6
  | PIN32 -> IC5
  | PIN33 -> IC4
  | PIN34 -> IC3
  | PIN35 -> IC2
  | PIN36 -> IC1
  | PIN37 -> IC0
  | PIN38 -> ID7
  | PIN39 -> IG2
  | PIN40 -> IG1
  | PIN41 -> IG0
  | PIN42 -> IL7
  | PIN43 -> IL6
  | PIN44 -> IL5
  | PIN45 -> IL4
  | PIN46 -> IL3
  | PIN47 -> IL2
  | PIN48 -> IL1
  | PIN49 -> IL0
  | MISO -> IB3
  | SCK -> IB1
  | MOSI -> IB2
  | SS -> IB0
  | PINA0 -> IF0
  | PINA1 -> IF1
  | PINA2 -> IF2
  | PINA3 -> IF3
  | PINA4 -> IF4
  | PINA5 -> IF5
  | PINA6 -> IF6
  | PINA7 -> IF7
  | PINA8 -> IK0
  | PINA9 -> IK1
  | PINA10 -> IK2
  | PINA11 -> IK3
  | PINA12 -> IK4
  | PINA13 -> IK5
  | PINA14 -> IK6
  | PINA15 -> IK7


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
  let bit = port_bit_of_pin p in
  let ddr_bit = ddr_bit_of_pin p in
  let ddr = ddr_of_pin p in
  match m with
  | OUTPUT ->
    set_bit ddr ddr_bit
  | INPUT ->
    clear_bit ddr ddr_bit;
    clear_bit port bit
  | INPUT_PULLUP ->
    clear_bit ddr ddr_bit;
    set_bit port bit

let digital_write p b =
  let port = port_of_pin p in
  let bit = port_bit_of_pin p in
  match b with
  | HIGH -> set_bit port bit
  | LOW -> clear_bit port bit

let digital_read p =
  let input = input_of_pin p in
  let ibit = input_bit_of_pin p in
  match read_bit input ibit with
  | true -> HIGH
  | false -> LOW

external adc_init : unit -> unit = "caml_avr_adc_init"

external avr_analog_read : int -> int = "caml_avr_analog_read"


let channel_of_pin : type a b c. (a register , b register, c register, yes analog_pin) pin -> int = function
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
