(* open Pic32 *)

type uxmode_param = ON_ 
      | SIDL_ 
      | IREN_ 
      | RTSMD_ 
      | UEN_0 
      | UEN_1 
      | UEN_2 
      | UEN_3 
      | WAKE_ 
      | LPBACK_ 
      | ABAUD_ 
      | RXINV_ 
      | BRGH_ 
      | PDSEL_0 
      | PDSEL_1 
      | PDSEL_2 
      | PDSEL_3 
      | STSEL_ 

type uxsta_param = ADM_EN_ 
      | UTXISEL_0 
      | UTXISEL_1 
      | UTXISEL_2 
      | UTXISEL_3 
      | UTXINV_ 
      | URXEN_ 
      | UTXBRK_ 
      | UTXEN_ 
      | UTXBF_ 
      | TRMT_ 
      | URXISEL_0 
      | URXISEL_1 
      | URXISEL_2 
      | URXISEL_3 
      | ADDEN_ 
      | RIDLE_ 
      | PERR_ 
      | FERR_ 
      | OERR_ 
      | URXDA_ 

type u1mode_bit = U1STSEL | U1PDSEL1 | U1PDSEL2 | U1BRGH | U1RXINV | 
                  U1ABAUD | U1LPBACK | U1WAKE | U1UEN1 | U1UEN2 | 
                  U1MODE10 | U1RTSMD | U1IREN | U1SIDL | U1MODE14 | U1ON

type u2mode_bit = U2STSEL | U2PDSEL1 | U2PDSEL2 | U2BRGH | U2RXINV | 
                  U2ABAUD | U2LPBACK | U2WAKE | U2UEN1 | U2UEN2 | 
                  U2MODE10 | U2RTSMD | U2IREN | U2SIDL | U2MODE14 | U2ON

type u3mode_bit = U3STSEL | U3PDSEL1 | U3PDSEL2 | U3BRGH | U3RXINV | 
                  U3ABAUD | U3LPBACK | U3WAKE | U3UEN1 | U3UEN2 | 
                  U3MODE10 | U3RTSMD | U3IREN | U3SIDL | U3MODE14 | U3ON

type u4mode_bit = U4STSEL | U4PDSEL1 | U4PDSEL2 | U4BRGH | U4RXINV | 
                  U4ABAUD | U4LPBACK | U4WAKE | U4MODE8 | U4MODE9 | 
                  U4MODE10 | U4MODE11 | U4IREN | U4SIDL | U4MODE14 | U4ON

type u5mode_bit = U5STSEL | U5PDSEL1 | U5PDSEL2 | U5BRGH | U5RXINV | 
                  U5ABAUD | U5LPBACK | U5WAKE | U5MODE8 | U5MODE9 | 
                  U5MODE10 | U5MODE11 | U5IREN | U5SIDL | U5MODE14 | U5ON

type u6mode_bit = U6STSEL | U6PDSEL1 | U6PDSEL2 | U6BRGH | U6RXINV | 
                  U6ABAUD | U6LPBACK | U6WAKE | U6MODE8 | U6MODE9 | 
                  U6MODE10 | U6MODE11 | U6IREN | U6SIDL | U6MODE14 | U6ON


type u1sta_bit = U1URXDA | U1OERR | U1FERR | U1PERR | U1RIDLE | 
                 U1ADDEN | U1URXISEL1 | U1URXISEL2 | U1TRMT | U1UTXBF | 
                 U1UTXEN | U1UTXBRK | U1URXEN | U1UTXINV | U1UTXISEL1 | 
                 U1UTXISEL2 | U1ADDR1 | U1ADDR2 | U1ADDR3 | U1ADDR4 | 
                 U1ADDR5 | U1ADDR6 | U1ADDR7 | U1ADDR8 | U1ADM_EN 
                 
type u2sta_bit = U2URXDA | U2OERR | U2FERR | U2PERR | U2RIDLE | 
                 U2ADDEN | U2URXISEL1 | U2URXISEL2 | U2TRMT | U2UTXBF | 
                 U2UTXEN | U2UTXBRK | U2URXEN | U2UTXINV | U2UTXISEL1 | 
                 U2UTXISEL2 | U2ADDR1 | U2ADDR2 | U2ADDR3 | U2ADDR4 | 
                 U2ADDR5 | U2ADDR6 | U2ADDR7 | U2ADDR8 | U2ADM_EN 

type u3sta_bit = U3URXDA | U3OERR | U3FERR | U3PERR | U3RIDLE | 
                 U3ADDEN | U3URXISEL1 | U3URXISEL2 | U3TRMT | U3UTXBF | 
                 U3UTXEN | U3UTXBRK | U3URXEN | U3UTXINV | U3UTXISEL1 | 
                 U3UTXISEL2 | U3ADDR1 | U3ADDR2 | U3ADDR3 | U3ADDR4 | 
                 U3ADDR5 | U3ADDR6 | U3ADDR7 | U3ADDR8 | U3ADM_EN          

type u4sta_bit = U4URXDA | U4OERR | U4FERR | U4PERR | U4RIDLE | 
                 U4ADDEN | U4URXISEL1 | U4URXISEL2 | U4TRMT | U4UTXBF | 
                 U4UTXEN | U4UTXBRK | U4URXEN | U4UTXINV | U4UTXISEL1 | 
                 U4UTXISEL2 | U4ADDR1 | U4ADDR2 | U4ADDR3 | U4ADDR4 | 
                 U4ADDR5 | U4ADDR6 | U4ADDR7 | U4ADDR8 | U4ADM_EN 

type u5sta_bit = U5URXDA | U5OERR | U5FERR | U5PERR | U5RIDLE | 
                 U5ADDEN | U5URXISEL1 | U5URXISEL2 | U5TRMT | U5UTXBF | 
                 U5UTXEN | U5UTXBRK | U5URXEN | U5UTXINV | U5UTXISEL1 | 
                 U5UTXISEL2 | U5ADDR1 | U5ADDR2 | U5ADDR3 | U5ADDR4 | 
                 U5ADDR5 | U5ADDR6 | U5ADDR7 | U5ADDR8 | U5ADM_EN 

type u6sta_bit = U6URXDA | U6OERR | U6FERR | U6PERR | U6RIDLE | 
                 U6ADDEN | U6URXISEL1 | U6URXISEL2 | U6TRMT | U6UTXBF | 
                 U6UTXEN | U6UTXBRK | U6URXEN | U6UTXINV | U6UTXISEL1 | 
                 U6UTXISEL2 | U6ADDR1 | U6ADDR2 | U6ADDR3 | U6ADDR4 | 
                 U6ADDR5 | U6ADDR6 | U6ADDR7 | U6ADDR8 | U6ADM_EN 


(* UxTXREG and UxRXREG are used to store transiting values. 
  Bit type is declared for the sake of consistency *)

type u1txreg_bit = U1TX8
type u2txreg_bit = U2TX8
type u3txreg_bit = U3TX8
type u4txreg_bit = U4TX8
type u5txreg_bit = U5TX8
type u6txreg_bit = U6TX8

type u1rxreg_bit = U1RX8
type u2rxreg_bit = U2RX8
type u3rxreg_bit = U3RX8
type u4rxreg_bit = U4RX8
type u5rxreg_bit = U5RX8
type u6rxreg_bit = U6RX8

(* UxBRG also just stores a value on the first 15 bits, and has 
   no specific bits to R/W from/to. We still declare the bit type 
   for the sake of consistency *)

type u1brg_bit = U1BRG0
type u2brg_bit = U2BRG0
type u3brg_bit = U3BRG0
type u4brg_bit = U4BRG0
type u5brg_bit = U5BRG0
type u6brg_bit = U6BRG0

type 'a register =
  | U1MODE : u1mode_bit register
  | U2MODE : u2mode_bit register
  | U3MODE : u3mode_bit register
  | U4MODE : u4mode_bit register
  | U5MODE : u5mode_bit register
  | U6MODE : u6mode_bit register
  | U1STA : u1sta_bit register
  | U2STA : u2sta_bit register
  | U3STA : u3sta_bit register
  | U4STA : u4sta_bit register
  | U5STA : u5sta_bit register
  | U6STA : u6sta_bit register 
  | U1TXREG : u1txreg_bit register
  | U2TXREG : u2txreg_bit register
  | U3TXREG : u3txreg_bit register
  | U4TXREG : u4txreg_bit register
  | U5TXREG : u5txreg_bit register
  | U6TXREG : u6txreg_bit register
  | U1RXREG : u1rxreg_bit register
  | U2RXREG : u2rxreg_bit register
  | U3RXREG : u3rxreg_bit register
  | U4RXREG : u4rxreg_bit register
  | U5RXREG : u5rxreg_bit register
  | U6RXREG : u6rxreg_bit register
  | U1BRG : u1brg_bit register
  | U2BRG : u2brg_bit register
  | U3BRG : u3brg_bit register
  | U4BRG : u4brg_bit register
  | U5BRG : u5brg_bit register
  | U6BRG : u6brg_bit register


type ('a,'b,'c,'d,'e) uart = 
  | UART1 : (u1mode_bit register, u1sta_bit register, u1txreg_bit register, u1rxreg_bit register, u1brg_bit register) uart
  | UART2 : (u2mode_bit register, u2sta_bit register, u2txreg_bit register, u2rxreg_bit register, u2brg_bit register) uart
  | UART3 : (u3mode_bit register, u3sta_bit register, u3txreg_bit register, u3rxreg_bit register, u3brg_bit register) uart
  | UART4 : (u4mode_bit register, u4sta_bit register, u4txreg_bit register, u4rxreg_bit register, u4brg_bit register) uart
  | UART5 : (u5mode_bit register, u5sta_bit register, u5txreg_bit register, u5rxreg_bit register, u5brg_bit register) uart
  | UART6 : (u6mode_bit register, u6sta_bit register, u6txreg_bit register, u6rxreg_bit register, u6brg_bit register) uart



let umode_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a register =
  function
  | UART1 -> U1MODE
  | UART2 -> U2MODE
  | UART3 -> U3MODE
  | UART4 -> U4MODE
  | UART5 -> U5MODE
  | UART6 -> U6MODE

let usta_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b register =
  function
  | UART1 -> U1STA
  | UART2 -> U2STA
  | UART3 -> U3STA
  | UART4 -> U4STA
  | UART5 -> U5STA
  | UART6 -> U6STA

let utxreg_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> c register =
  function
  | UART1 -> U1TXREG
  | UART2 -> U2TXREG
  | UART3 -> U3TXREG
  | UART4 -> U4TXREG
  | UART5 -> U5TXREG
  | UART6 -> U6TXREG

let urxreg_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> d register =
  function
  | UART1 -> U1RXREG
  | UART2 -> U2RXREG
  | UART3 -> U3RXREG
  | UART4 -> U4RXREG
  | UART5 -> U5RXREG
  | UART6 -> U6RXREG

let ubrg_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> e register =
  function
  | UART1 -> U1BRG
  | UART2 -> U2BRG
  | UART3 -> U3BRG
  | UART4 -> U4BRG
  | UART5 -> U5BRG
  | UART6 -> U6BRG



let stsel_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1STSEL
  | UART2 -> U2STSEL
  | UART3 -> U3STSEL
  | UART4 -> U4STSEL
  | UART5 -> U5STSEL
  | UART6 -> U6STSEL

let pdsel_bit1_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1PDSEL1
  | UART2 -> U2PDSEL1
  | UART3 -> U3PDSEL1
  | UART4 -> U4PDSEL1
  | UART5 -> U5PDSEL1
  | UART6 -> U6PDSEL1

let pdsel_bit2_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1PDSEL2
  | UART2 -> U2PDSEL2
  | UART3 -> U3PDSEL2
  | UART4 -> U4PDSEL2
  | UART5 -> U5PDSEL2
  | UART6 -> U6PDSEL2

let brgh_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1BRGH
  | UART2 -> U2BRGH
  | UART3 -> U3BRGH
  | UART4 -> U4BRGH
  | UART5 -> U5BRGH
  | UART6 -> U6BRGH

let rxinv_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1RXINV
  | UART2 -> U2RXINV
  | UART3 -> U3RXINV
  | UART4 -> U4RXINV
  | UART5 -> U5RXINV
  | UART6 -> U6RXINV

let abaud_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1ABAUD
  | UART2 -> U2ABAUD
  | UART3 -> U3ABAUD
  | UART4 -> U4ABAUD
  | UART5 -> U5ABAUD
  | UART6 -> U6ABAUD

let lpback_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1LPBACK
  | UART2 -> U2LPBACK
  | UART3 -> U3LPBACK
  | UART4 -> U4LPBACK
  | UART5 -> U5LPBACK
  | UART6 -> U6LPBACK

let wake_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1WAKE
  | UART2 -> U2WAKE
  | UART3 -> U3WAKE
  | UART4 -> U4WAKE
  | UART5 -> U5WAKE
  | UART6 -> U6WAKE

let uen_bit1_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1UEN1
  | UART2 -> U2UEN1
  | UART3 -> U3UEN1
  | UART4 -> U4MODE8
  | UART5 -> U5MODE8
  | UART6 -> U6MODE8

let uen_bit2_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1UEN2
  | UART2 -> U2UEN2
  | UART3 -> U3UEN2
  | UART4 -> U4MODE9
  | UART5 -> U5MODE9
  | UART6 -> U6MODE9

let rtsmd_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1RTSMD
  | UART2 -> U2RTSMD
  | UART3 -> U3RTSMD
  | UART4 -> U4MODE11
  | UART5 -> U5MODE11
  | UART6 -> U6MODE11

let iren_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1IREN
  | UART2 -> U2IREN
  | UART3 -> U3IREN
  | UART4 -> U4IREN
  | UART5 -> U5IREN
  | UART6 -> U6IREN

let sidl_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1SIDL
  | UART2 -> U2SIDL
  | UART3 -> U3SIDL
  | UART4 -> U4SIDL
  | UART5 -> U5SIDL
  | UART6 -> U6SIDL

let on_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> a =
  function
  | UART1 -> U1ON
  | UART2 -> U2ON
  | UART3 -> U3ON
  | UART4 -> U4ON
  | UART5 -> U5ON
  | UART6 -> U6ON


let urxda_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1URXDA
  | UART2 -> U2URXDA
  | UART3 -> U3URXDA
  | UART4 -> U4URXDA
  | UART5 -> U5URXDA
  | UART6 -> U6URXDA

let oerr_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1OERR
  | UART2 -> U2OERR
  | UART3 -> U3OERR
  | UART4 -> U4OERR
  | UART5 -> U5OERR
  | UART6 -> U6OERR

let ferr_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1FERR
  | UART2 -> U2FERR
  | UART3 -> U3FERR
  | UART4 -> U4FERR
  | UART5 -> U5FERR
  | UART6 -> U6FERR

let perr_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1PERR
  | UART2 -> U2PERR
  | UART3 -> U3PERR
  | UART4 -> U4PERR
  | UART5 -> U5PERR
  | UART6 -> U6PERR

let ridle_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1RIDLE
  | UART2 -> U2RIDLE
  | UART3 -> U3RIDLE
  | UART4 -> U4RIDLE
  | UART5 -> U5RIDLE
  | UART6 -> U6RIDLE

let adden_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1ADDEN
  | UART2 -> U2ADDEN
  | UART3 -> U3ADDEN
  | UART4 -> U4ADDEN
  | UART5 -> U5ADDEN
  | UART6 -> U6ADDEN

let urxisel_bit1_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1URXISEL1
  | UART2 -> U2URXISEL1
  | UART3 -> U3URXISEL1
  | UART4 -> U4URXISEL1
  | UART5 -> U5URXISEL1
  | UART6 -> U6URXISEL1

let urxisel_bit2_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1URXISEL2
  | UART2 -> U2URXISEL2
  | UART3 -> U3URXISEL2
  | UART4 -> U4URXISEL2
  | UART5 -> U5URXISEL2
  | UART6 -> U6URXISEL2

let trmt_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1TRMT
  | UART2 -> U2TRMT
  | UART3 -> U3TRMT
  | UART4 -> U4TRMT
  | UART5 -> U5TRMT
  | UART6 -> U6TRMT

let utxbf_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1UTXBF
  | UART2 -> U2UTXBF
  | UART3 -> U3UTXBF
  | UART4 -> U4UTXBF
  | UART5 -> U5UTXBF
  | UART6 -> U6UTXBF

let utxen_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1UTXEN
  | UART2 -> U2UTXEN
  | UART3 -> U3UTXEN
  | UART4 -> U4UTXEN
  | UART5 -> U5UTXEN
  | UART6 -> U6UTXEN

let utxbrk_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1UTXBRK
  | UART2 -> U2UTXBRK
  | UART3 -> U3UTXBRK
  | UART4 -> U4UTXBRK
  | UART5 -> U5UTXBRK
  | UART6 -> U6UTXBRK

let urxen_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1URXEN
  | UART2 -> U2URXEN
  | UART3 -> U3URXEN
  | UART4 -> U4URXEN
  | UART5 -> U5URXEN
  | UART6 -> U6URXEN

let utxinv_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1UTXINV
  | UART2 -> U2UTXINV
  | UART3 -> U3UTXINV
  | UART4 -> U4UTXINV
  | UART5 -> U5UTXINV
  | UART6 -> U6UTXINV

let utxisel_bit1_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1UTXISEL1
  | UART2 -> U2UTXISEL1
  | UART3 -> U3UTXISEL1
  | UART4 -> U4UTXISEL1
  | UART5 -> U5UTXISEL1
  | UART6 -> U6UTXISEL1

let utxisel_bit2_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1UTXISEL2
  | UART2 -> U2UTXISEL2
  | UART3 -> U3UTXISEL2
  | UART4 -> U4UTXISEL2
  | UART5 -> U5UTXISEL2
  | UART6 -> U6UTXISEL2


(* There is no need to define functions for ADDR<7:0>; its values are defined automatically depending on the 
   value of ADM_EN *)

let adm_en_bit_of_uart : type a b c d e. (a register, b register, c register, d register, e register) uart -> b =
  function
  | UART1 -> U1ADM_EN
  | UART2 -> U2ADM_EN
  | UART3 -> U3ADM_EN
  | UART4 -> U4ADM_EN
  | UART5 -> U5ADM_EN
  | UART6 -> U6ADM_EN



external write_register_uart : 'a register -> int -> unit = "caml_write_register_uart" [@@noalloc]
external read_register_uart : 'a register -> int = "caml_read_register_uart" [@@noalloc]
external set_bit_uart : 'a register -> 'a -> unit = "caml_set_bit_uart" [@@noalloc]
external clear_bit_uart : 'a register -> 'a -> unit = "caml_clear_bit_uart" [@@noalloc]
external read_bit_uart : 'a register -> 'a -> bool = "caml_read_bit_uart" [@@noalloc]

external enable_tx_int_ec_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_enable_tx_int_ec_uart" [@@noalloc]
external disable_tx_int_ec_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_disable_tx_int_ec_uart" [@@noalloc]
external enable_rx_int_ec_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_enable_rx_int_ec_uart" [@@noalloc]
external disable_rx_int_ec_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_disable_rx_int_ec_uart" [@@noalloc]
external enable_err_int_ec_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_enable_err_int_ec_uart" [@@noalloc]
external disable_err_int_ec_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_disable_err_int_ec_uart" [@@noalloc]

external enable_tx_int_fs_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_enable_tx_int_fs_uart" [@@noalloc]
external disable_tx_int_fs_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_disable_tx_int_fs_uart" [@@noalloc]
external enable_rx_int_fs_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_enable_rx_int_fs_uart" [@@noalloc]
external disable_rx_int_fs_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_disable_rx_int_fs_uart" [@@noalloc]
external enable_err_int_fs_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_enable_err_int_fs_uart" [@@noalloc]
external disable_err_int_fs_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit = "caml_disable_err_int_fs_uart" [@@noalloc]

external set_priority_int_uart : 
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int -> unit = "caml_set_priority_int_uart" [@@noalloc]
external set_subpriority_int_uart :
  ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int -> unit = "caml_set_subpriority_int_uart" [@@noalloc]


let uxmode_set u params = 
  let umode = umode_of_uart u in
  let stsel = stsel_bit_of_uart u in
  let pdsel1 = pdsel_bit1_of_uart u in
  let pdsel2 = pdsel_bit2_of_uart u in
  let brgh = brgh_bit_of_uart u in
  let rxinv = rxinv_bit_of_uart u in
  let abaud = abaud_bit_of_uart u in
  let lpback = lpback_bit_of_uart u in
  let wake = wake_bit_of_uart u in
  let uen1 = uen_bit1_of_uart u in
  let uen2 = uen_bit2_of_uart u in 
  let rtsmd = rtsmd_bit_of_uart u in
  let sidl = sidl_bit_of_uart u in
  let on = on_bit_of_uart u in
  let iren = iren_bit_of_uart u in

  let pdsel_set n =
    match n with
      | 0 -> clear_bit_uart umode pdsel1; clear_bit_uart umode pdsel2
      | 1 -> set_bit_uart umode pdsel1; clear_bit_uart umode pdsel2
      | 2 -> clear_bit_uart umode pdsel1; set_bit_uart umode pdsel2
      | 3 -> set_bit_uart umode pdsel1; set_bit_uart umode pdsel2
      | _ -> ()
  in 

  let uen_set n = 
    match n with 
      | 0 -> clear_bit_uart umode uen1; clear_bit_uart umode uen2
      | 1 -> set_bit_uart umode uen1; clear_bit_uart umode uen2
      | 2 -> clear_bit_uart umode uen1; set_bit_uart umode uen2
      | 3 -> set_bit_uart umode uen1; set_bit_uart umode uen2
      | _ -> ()

  in

  let set_bits param =
    match param with 
      | ON_ -> set_bit_uart umode on
      | SIDL_ -> set_bit_uart umode sidl
      | IREN_ -> set_bit_uart umode iren
      | RTSMD_ -> set_bit_uart umode rtsmd
      | UEN_0 -> uen_set 0
      | UEN_1 -> uen_set 1
      | UEN_2 -> uen_set 2
      | UEN_3 -> uen_set 3
      | WAKE_ -> set_bit_uart umode wake
      | LPBACK_ -> set_bit_uart umode lpback
      | ABAUD_ -> set_bit_uart umode abaud
      | RXINV_ -> set_bit_uart umode rxinv
      | BRGH_ -> set_bit_uart umode brgh
      | PDSEL_0 -> pdsel_set 0
      | PDSEL_1 -> pdsel_set 1
      | PDSEL_2 -> pdsel_set 2
      | PDSEL_3 -> pdsel_set 3
      | STSEL_ -> set_bit_uart umode stsel

  in

  write_register_uart umode 0; (* set to POR state *)
  List.iter set_bits params


let uxsta_set u params = 
  let sta = usta_of_uart u in
  let urxda = urxda_bit_of_uart u in 
  let oerr = oerr_bit_of_uart u in
  let ferr = ferr_bit_of_uart u in 
  let perr = perr_bit_of_uart u in
  let ridle = ridle_bit_of_uart u in
  let adden = adden_bit_of_uart u in 
  let urxisel1 = urxisel_bit1_of_uart u in
  let urxisel2 = urxisel_bit2_of_uart u in
  let trmt = trmt_bit_of_uart u in 
  let utxbf = utxbf_bit_of_uart u in 
  let utxen = utxen_bit_of_uart u in 
  let utxbrk = utxbrk_bit_of_uart u in
  let urxen = urxen_bit_of_uart u in 
  let utxinv = utxinv_bit_of_uart u in 
  let utxisel1 = utxisel_bit1_of_uart u in 
  let utxisel2 = utxisel_bit2_of_uart u in 
  let adm_en = adm_en_bit_of_uart u in

  let urxisel_set n = (* The MX795F512L features a 8-level deep FIFO UART module *)
    match n with
      | 0 -> clear_bit_uart sta urxisel1; clear_bit_uart sta urxisel2
      | 1 -> set_bit_uart sta urxisel1; clear_bit_uart sta urxisel2
      | 2 -> clear_bit_uart sta urxisel1; set_bit_uart sta urxisel2
      | 3 -> set_bit_uart sta urxisel1; set_bit_uart sta urxisel2
      | _ -> ()

  in 

  let utxisel_set n = 
    match n with
      | 0 -> clear_bit_uart sta utxisel1; clear_bit_uart sta utxisel2
      | 1 -> set_bit_uart sta utxisel1; clear_bit_uart sta utxisel2
      | 2 -> clear_bit_uart sta utxisel1; set_bit_uart sta utxisel2
      | 3 -> set_bit_uart sta utxisel1; set_bit_uart sta utxisel2
      | _ -> ()

  in 

  let set_bits param = 
    match param with 
      | ADM_EN_ -> set_bit_uart sta adm_en
      | UTXISEL_0 -> utxisel_set 0
      | UTXISEL_1 -> utxisel_set 1
      | UTXISEL_2 -> utxisel_set 2
      | UTXISEL_3 -> utxisel_set 3
      | UTXINV_ -> set_bit_uart sta utxinv
      | URXEN_ -> set_bit_uart sta urxen
      | UTXBRK_ -> set_bit_uart sta utxbrk
      | UTXEN_ -> set_bit_uart sta utxen
      | UTXBF_ -> set_bit_uart sta utxbf
      | TRMT_ -> set_bit_uart sta trmt
      | URXISEL_0 -> urxisel_set 0
      | URXISEL_1 -> urxisel_set 1
      | URXISEL_2 -> urxisel_set 2
      | URXISEL_3 -> urxisel_set 3
      | ADDEN_ -> set_bit_uart sta adden
      | RIDLE_ -> set_bit_uart sta ridle
      | PERR_ -> set_bit_uart sta perr
      | FERR_ -> set_bit_uart sta ferr
      | OERR_ -> set_bit_uart sta oerr
      | URXDA_ -> set_bit_uart sta urxda

  in

  write_register_uart sta 0; (* set to POR state *)
  List.iter set_bits params  

let read_tx_reg u =
  let utxreg = utxreg_of_uart u in 
    read_register_uart utxreg

let write_tx_reg u v =
  let utxreg = utxreg_of_uart u in
    write_register_uart utxreg v

let read_rx_reg u =
  let urxreg = urxreg_of_uart u in 
    read_register_uart urxreg

let write_rx_reg u v = 
  let urxreg = urxreg_of_uart u in 
    write_register_uart urxreg v 

let read_baud_rate u = 
  let brg = ubrg_of_uart u in 
    read_register_uart brg

let write_baud_rate u v = 
  let brg = ubrg_of_uart u in
    write_register_uart brg v