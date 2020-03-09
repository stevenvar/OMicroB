open Pic32

(* Even though there are unused bits or bits that could be represented 
   with a single name (e.g. TCKPS), we assume all bits so that, thanks 
   to the enumeration, each bit position respects the specification. 
   Effectively used bits have their name respecting the datasheet
   (e.g. TxTCS -- TCS bit on TIMER x). Otherwise, the TxCONy naming 
   rule is used to defined unused bits. *)

type txcon_param = ON_ | SIDL_ | TGATE_ | T32_ | TCS_ | TSYNC_ |
                   TWDIS_ | TWIP_ | PS_1_1 | PS_1_2 | PS_1_4 | 
                   PS_1_8 | PS_1_16 | PS_1_32 | PS_1_64 | PS_1_256


type t1con_bit = T1C0N0 | T1TCS | T1TSYNC | T1CON3 | T1TCKPS1 | 
                 T1TCKPS2 | T1CON6 | T1TGATE | T1CON8 | T1CON9 |
                 T1CON10 | T1TWIP | T1TWDIS | T1SIDL | T1CON14 | T1ON
type t2con_bit = T2C0N0 | T2TCS | T2CON2 | T2T32 | T2TCKPS1 | 
                 T2TCKPS2 | T2TCKPS3 | T2TGATE | T2CON8 | T2CON9 |   
                 T2CON10 | T2CON11 | T2CON12 | T2SIDL | T2CON14 | T2ON
type t3con_bit = T3CON0 | T3TCS | T3CON2 | T3CON3 | T3TCKPS1 | 
                 T3TCKPS2 | T3TCKPS3 | T3TGATE | T3CON8 | T3CON9 |   
                 T3CON10 | T3CON11 | T3CON12 | T3SIDL | T3CON14 | T3ON
type t4con_bit = T4CON0 | T4TCS | T4CON2 | T4T32 | T4TCKPS1 | 
                 T4TCKPS2 | T4TCKPS3 | T4TGATE | T4CON8 | T4CON9 |   
                 T4CON10 | T4CON11 | T4CON12 | T4SIDL | T4CON14 | T4ON
type t5con_bit = T5CON0 | T5TCS | T5CON2 | T5CON3 | T5TCKPS1 | 
                 T5TCKPS2 | T5TCKPS3 | T5TGATE | T5CON8 | T5CON9 |   
                 T5CON10 | T5CON11 | T5CON12 | T5SIDL | T5CON14 | T5ON


(* The following registers need not to be programmed bit per bit. 
   However, for consistency for the moment, we'll pretend there 
   is at least one bit for it to fit in the register type *)

type tmr1_bit = TMR10
type tmr2_bit = TMR20
type tmr3_bit = TMR30
type tmr4_bit = TMR40
type tmr5_bit = TMR50

type pr1_bit = PR10
type pr2_bit = PR20
type pr3_bit = PR30
type pr4_bit = PR40
type pr5_bit = PR50


type 'a register =
  | T1CON : t1con_bit register
  | T2CON : t2con_bit register
  | T3CON : t3con_bit register
  | T4CON : t4con_bit register
  | T5CON : t5con_bit register
  | TMR1 : tmr1_bit register
  | TMR2 : tmr2_bit register
  | TMR3 : tmr3_bit register
  | TMR4 : tmr4_bit register
  | TMR5 : tmr5_bit register
  | PR1 : pr1_bit register
  | PR2 : pr2_bit register
  | PR3 : pr3_bit register
  | PR4 : pr4_bit register
  | PR5 : pr5_bit register


(* Manipulating timers include having the need to access so dedicated bits in interrupt registers *)
type ('a,'b,'c) timer =
  | TIMER1 : (t1con_bit register, tmr1_bit register, pr1_bit register) timer
  | TIMER2 : (t2con_bit register, tmr2_bit register, pr2_bit register) timer
  | TIMER3 : (t3con_bit register, tmr3_bit register, pr3_bit register) timer
  | TIMER4 : (t4con_bit register, tmr4_bit register, pr4_bit register) timer
  | TIMER5 : (t5con_bit register, tmr5_bit register, pr5_bit register) timer


include Pic32Timers
  with type ('a, 'b, 'c)timer := ('a, 'b, 'c)timer
  with type 'a register := 'a register
  with type txcon_param := txcon_param