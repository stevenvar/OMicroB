(* open Pic32 *)

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
   However, for tconsistency for the moment, we'll pretend there 
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


let tcon_of_timer : type a b c. (a register, b register, c register) timer -> a register=
  function 
  | TIMER1 -> T1CON
  | TIMER2 -> T2CON
  | TIMER3 -> T3CON
  | TIMER4 -> T4CON
  | TIMER5 -> T5CON

let tmr_of_timer : type a b c. (a register, b register, c register) timer -> b register =
  function
  | TIMER1 -> TMR1
  | TIMER2 -> TMR2
  | TIMER3 -> TMR3
  | TIMER4 -> TMR4
  | TIMER5 -> TMR5

let pr_of_timer : type a b c. (a register, b register, c register) timer -> c register =
  function
  | TIMER1 -> PR1
  | TIMER2 -> PR2
  | TIMER3 -> PR3
  | TIMER4 -> PR4
  | TIMER5 -> PR5



let on_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1ON
  | TIMER2 -> T2ON
  | TIMER3 -> T3ON
  | TIMER4 -> T4ON
  | TIMER5 -> T5ON

let sidl_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1SIDL
  | TIMER2 -> T2SIDL
  | TIMER3 -> T3SIDL
  | TIMER4 -> T4SIDL
  | TIMER5 -> T5SIDL

let tgate_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1TGATE
  | TIMER2 -> T2TGATE
  | TIMER3 -> T3TGATE
  | TIMER4 -> T4TGATE
  | TIMER5 -> T5TGATE
  
(* TCKPS bit is spread on 3 bits, how do we represend that ? 
   Since these functions are bitwise, for the moment I am making 
   a distinct function for each bit *)
let tckps_bit1_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1TCKPS1
  | TIMER2 -> T2TCKPS1
  | TIMER3 -> T3TCKPS1
  | TIMER4 -> T4TCKPS1
  | TIMER5 -> T5TCKPS1

let tckps_bit2_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1TCKPS2
  | TIMER2 -> T2TCKPS2
  | TIMER3 -> T3TCKPS2
  | TIMER4 -> T4TCKPS2
  | TIMER5 -> T5TCKPS2

let tckps_bit3_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER2 -> T2TCKPS3
  | TIMER3 -> T3TCKPS3
  | TIMER4 -> T4TCKPS3
  | TIMER5 -> T5TCKPS3
  | TIMER1 -> T1CON6 
  (* Timer 1 does not use this bit but for the sake of proper typing in ocaml we specify this  *)



let t32_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER2 -> T2T32
  | TIMER4 -> T4T32
  | TIMER1 -> T1CON3
  | TIMER3 -> T3CON3
  | TIMER5 -> T5CON3

let tcs_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1TCS
  | TIMER2 -> T2TCS
  | TIMER3 -> T3TCS
  | TIMER4 -> T4TCS
  | TIMER5 -> T5TCS

let twip_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1TWIP
  | TIMER2 -> T2CON11
  | TIMER3 -> T3CON11
  | TIMER4 -> T4CON11
  | TIMER5 -> T5CON11

let twdis_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1TWDIS
  | TIMER2 -> T2CON12
  | TIMER3 -> T3CON12
  | TIMER4 -> T4CON12
  | TIMER5 -> T5CON12

let tsync_bit_of_timer : type a b c. (a register, b register, c register) timer -> a =
  function
  | TIMER1 -> T1TSYNC
  | TIMER2 -> T2CON2
  | TIMER3 -> T3CON2
  | TIMER4 -> T4CON2
  | TIMER5 -> T5CON2


external write_register_timer : 'a register -> int -> unit = "caml_write_register" [@@noalloc]
external read_register_timer : 'a register -> int = "caml_read_register_timer" [@@noalloc]
external set_bit_timer : 'a register -> 'a -> unit = "caml_set_bit_timer" [@@noalloc]
external clear_bit_timer : 'a register -> 'a -> unit = "caml_clear_bit_timer" [@@noalloc]
external read_bit_timer : 'a register -> 'a -> bool = "caml_read_bit_timer" [@@noalloc]

external enable_int_timer : 
  ('a register, 'b register, 'c register) timer -> unit = "caml_enable_int_timer" [@@noalloc]
external disable_int_timer : 
  ('a register, 'b register, 'c register) timer -> unit = "caml_disable_int_timer" [@@noalloc]
external set_priority_int_timer : 
  ('a register, 'b register, 'c register) timer -> int -> unit = "caml_set_priority_int_timer" [@@noalloc]
external set_subpriority_int_timer : 
  ('a register, 'b register, 'c register) timer -> int -> unit = "caml_set_subpriority_int_timer" [@@noalloc]
external configure_int_timer : 
  ('a register, 'b register, 'c register) timer -> int -> int -> unit = "caml_configure_int_timer" [@@noalloc]


(****** Functions for reading and writing registers *******)
  
(* For timer 1 only *)

let t1con_set params =
  (* let tcon = tcon_of_timer TIMER1 in
  let on = on_bit_of_timer TIMER1 in
  let ps1 = tckps_bit1_of_timer TIMER1 in
  let ps2 = tckps_bit2_of_timer TIMER1 in
  let tcs = tcs_bit_of_timer TIMER1 in 
  let tgate = tgate_bit_of_timer TIMER1 in 
  let sidl = sidl_bit_of_timer TIMER1 in 
  let twdis = twdis_bit_of_timer TIMER1 in 
  let twip = twip_bit_of_timer TIMER1 in
  let tsync = tsync_bit_of_timer TIMER1 in *)

  let tckps_set n = 
    match n with 
      | 1 -> clear_bit_timer T1CON T1TCKPS1; clear_bit_timer T1CON T1TCKPS2
      | 8 -> set_bit_timer T1CON T1TCKPS1
      | 64 -> set_bit_timer T1CON T1TCKPS2
      | 256 -> set_bit_timer T1CON T1TCKPS1; set_bit_timer T1CON T1TCKPS2
      | _ -> ()
  in

  let set_bits param = 
    match param with 
      | ON_ -> set_bit_timer T1CON T1ON
      | SIDL_ -> set_bit_timer T1CON T1SIDL
      | TGATE_ -> set_bit_timer T1CON T1TGATE
      | TCS_ -> set_bit_timer T1CON T1TCS
      | TSYNC_ -> set_bit_timer T1CON T1TSYNC
      | TWDIS_ -> set_bit_timer T1CON T1TWDIS
      | TWIP_ -> set_bit_timer T1CON T1TWIP
      | PS_1_1 -> tckps_set 1
      | PS_1_8 -> tckps_set 8
      | PS_1_64 -> tckps_set 64 
      | PS_1_256 -> tckps_set 256
      | T32_ -> ()
      | PS_1_2 -> ()
      | PS_1_4 -> ()
      | PS_1_16 -> ()
      | PS_1_32 -> ()
  in 
  
  write_register_timer T1CON 0; (* set to POR state before enabling bits according to params *)
  List.iter set_bits params


(* For timer 2 to 5 *)
 
let txcon_set t params =
  let tcon = tcon_of_timer t in
  let on = on_bit_of_timer t in
  let ps1 = tckps_bit1_of_timer t in
  let ps2 = tckps_bit2_of_timer t in
  let ps3 = tckps_bit3_of_timer t in
  let tcs = tcs_bit_of_timer t in 
  let tgate = tgate_bit_of_timer t in 
  let sidl = sidl_bit_of_timer t in 
  let t32 = t32_bit_of_timer t in

  let tckps_set n = 
    match n with 
      | 1 -> clear_bit_timer tcon ps1; clear_bit_timer tcon ps2; clear_bit_timer tcon ps3
      | 2 -> set_bit_timer tcon ps1 
      | 4 -> set_bit_timer tcon ps2
      | 8 -> set_bit_timer tcon ps1; set_bit_timer tcon ps2
      | 16 -> set_bit_timer tcon ps3
      | 32 -> set_bit_timer tcon ps1; set_bit_timer tcon ps3
      | 64 -> set_bit_timer tcon ps2; set_bit_timer tcon ps3
      | 256 -> set_bit_timer tcon ps1; set_bit_timer tcon ps2; set_bit_timer tcon ps3 
      | _ -> ()
  in

  let set_bits param = 
    match param with 
      | ON_ -> set_bit_timer tcon on
      | SIDL_ -> set_bit_timer tcon sidl
      | TGATE_ -> set_bit_timer tcon tgate
      | T32_ -> set_bit_timer tcon t32
      | TCS_ -> set_bit_timer tcon tcs
      | PS_1_1 -> tckps_set 1
      | PS_1_2 -> tckps_set 2
      | PS_1_4 -> tckps_set 4
      | PS_1_8 -> tckps_set 8
      | PS_1_16 -> tckps_set 16 
      | PS_1_32 -> tckps_set 32
      | PS_1_64 -> tckps_set 64 
      | PS_1_256 -> tckps_set 256
      | TSYNC_ -> ()
      | TWDIS_ -> ()
      | TWIP_ -> ()
  in 
  
  write_register_timer tcon 0; (* set to POR state before enabling bits according to params *)
  List.iter set_bits params


(***** Library for manipulating timers *****)

let read_timer t = 
  let tmr = tmr_of_timer t in
    read_register_timer tmr 

let write_timer t v =
  let tmr = tmr_of_timer t in 
    write_register_timer tmr v

let read_period_timer t = 
  let pr = pr_of_timer t in 
    read_register_timer pr

let write_period_timer t v = 
  let pr = pr_of_timer t in
    write_register_timer pr v

(* let open_timer t params period =
  write_timer t 0;
  write_period_timer t period;
  match t with
  | TIMER1 -> t1con_set params
  | _ -> txcon_set t params *)

let close_timer t =
  disable_int_timer t;
  let tcon = tcon_of_timer t in
    write_register_timer tcon 0


