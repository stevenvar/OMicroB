open Pic32

(* Fubarino Mini is based on a 32MX250F128D mcu that has 3 ports: A, B and C *)

(* TRISx registers specification: 
   TRIS registers are 32 bit-registers, however bit 0 to 15 only are 
   accessible for R/W operation; the remainder is reserved.
*)

type trisa_bit = TA0 | TA1 | TA2 | TA3 | TA4 | TA5 | TA6 | TA7 | 
                 TA8 | TA9 | TA10 | TA11 | TA12 | TA13 | TA14 | TA15 
type trisb_bit = TB0 | TB1 | TB2 | TB3 | TB4 | TB5 | TB6 | TB7 |  
                 TB8 | TB9 | TB10 | TB11 | TB12 | TB13 | TB14 | TB15 
type trisc_bit = TC0 | TC1 | TC2 | TC3 | TC4 | TC5 | TC6 | TC7
                 TC8 | TC9 | TC10 | TC11 | TC12 | TC13 | TC14 | TC15
                