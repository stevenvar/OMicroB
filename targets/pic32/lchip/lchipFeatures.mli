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



type 'a register = ..

type 'a register +=
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





type ad1con1_param = DONE_ | SAMP_ | ASAM_ | CLRASAM_ | SSRC_0 |
                     SSRC_1 | SSRC_2 | SSRC_3 | SSRC_7 | FORM_0 |
                    FORM_1 | FORM_2 | FORM_3 | FORM_4 | 
                    FORM_5 | FORM_6 | FORM_7 | SIDL_ | ON_ 

type ad1con2_param = ALTS_ | BUFM_ | SMPI_0 | SMPI_1 | SMPI_2 |
                     SMPI_3 | SMPI_4 | SMPI_5 | SMPI_6 | SMPI_7 |
                     SMPI_8 | SMPI_9 | SMPI_10 | SMPI_11 | SMPI_12 |
                     SMPI_13 | SMPI_14 | SMPI_15 | BUFS_ | CSCNA_ | 
                     OFFCAL_ | VCFG_0 | VCFG_1 | VCFG_2 | VCFG_3 |
                     VCFG_4 | VCFG_5 | VCFG_6 | VCFG_7


type ad1con3_param = ADRC_ | SAMC_15


type ad1cssl_param = CSSL_0 
      | CSSL_1 
      | CSSL_2 
      | CSSL_3 
      | CSSL_4 
      | CSSL_5 
      | CSSL_6 
      | CSSL_7 
      | CSSL_8 
      | CSSL_9 
      | CSSL_10 
      | CSSL_11 
      | CSSL_12 
      | CSSL_13 
      | CSSL_14 
      | CSSL_15 

type adc_chan = CH0SA_0   
  | CH0SA_1   
  | CH0SA_2   
  | CH0SA_3   
  | CH0SA_4   
  | CH0SA_5   
  | CH0SA_6   
  | CH0SA_7   
  | CH0SA_8   
  | CH0SA_9   
  | CH0SA_10   
  | CH0SA_11   
  | CH0SA_12   
  | CH0SA_13   
  | CH0SA_14   
  | CH0SA_15   
  | CH0NA_0  
  | CH0NA_1  
  | CH0SB_0   
  | CH0SB_1   
  | CH0SB_2   
  | CH0SB_3   
  | CH0SB_4   
  | CH0SB_5   
  | CH0SB_6   
  | CH0SB_7   
  | CH0SB_8   
  | CH0SB_9   
  | CH0SB_10   
  | CH0SB_11   
  | CH0SB_12   
  | CH0SB_13   
  | CH0SB_14   
  | CH0SB_15   
  | CH0NB_0  
  | CH0NB_1  



type ad1con1_bit = DONE | SAMP | ASAM | CON13 | CLRASAM | 
                   SSRC1 | SSRC2 | SSRC3 | FORM1 | FORM2 | 
                   FORM3 | CON111 | CON112 | SIDL | CON114 | ON

type ad1con2_bit = ALTS | BUFM | SMPI1 | SMPI2 | SMPI3 | SMPI4 |
                   CON26 | BUFS | CON28 | CON29 | CSCNA | 
                   CON211 | OFFCAL | VCFG1 | VCFG2 | VCFG3

type ad1con3_bit = ADCS1 | ADCS2 | ADCS3 | ADCS4 | ADCS5 |
                   ADCS6 | ADCS7 | ADCS8 | SAMC1 | SAMC2 | 
                   SAMC3 | SAMC4 | SAMC5 | CON313 | CON314 | ADRC

type ad1chs_bit = CHS0 | CHS1 | CHS2 | CHS3 | CHS4 | CHS5 | 
                  CHS6 | CHS7 | CHS8 | CHS9 | CHS10 | CHS11 | 
                  CHS12 | CHS13 | CHS14 | CHS15 | CH0SA1 | 
                  CH0SA2 | CH0SA3 | CH0SA4 | CHS20 | CHS21 | CHS22 | 
                  CH0NA | CH0SB1 | CH0SB2 | CH0SB3 | CH0SB4 |
                  CHS28 | CHS29 | CHS30 | CH0NB

type ad1pcfg_bit = PCFG0 | PCFG1 | PCFG2 | PCFG3 | PCFG4 | PCFG5 | 
                   PCFG6 | PCFG7 | PCFG8 | PCFG9 | PCFG10 | 
                   PCFG11 | PCFG12 | PCFG13 | PCFG14 | PCFG15

type ad1cssl_bit = CSSL0 | CSSL1 | CSSL2 | CSSL3 | CSSL4 | CSSL5 | 
                   CSSL6 | CSSL7 | CSSL8 | CSSL9 | CSSL10 | CSSL11 | 
                   CSSL12 | CSSL13 | CSSL14 | CSSL15

type adc1buf0_bit = ADC1BUF0



type 'a register +=
  | AD1CON1 : ad1con1_bit register
  | AD1CON2 : ad1con2_bit register
  | AD1CON3 : ad1con3_bit register
  | AD1CHS : ad1chs_bit register 
  | AD1PCFG : ad1pcfg_bit register
  | AD1CSSL : ad1cssl_bit register
  | ADC1BUF0 : adc1buf0_bit register

include Pic32Features
  with type 'a register := 'a register
  with type ('a, 'b, 'c, 'd)pin := ('a, 'b, 'c, 'd)pin
  with type ad1con1_param := ad1con1_param
  with type ad1con2_param := ad1con2_param
  with type ad1con3_param := ad1con3_param
  with type ad1cssl_param := ad1cssl_param
  with type adc_chan := adc_chan