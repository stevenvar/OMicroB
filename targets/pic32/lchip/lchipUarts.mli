open Pic32

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


(* UxTXREG and UxRXREG are used to store transiting values, therefore
   the first 8 bits are used to store data. However, the 9th bit
   is specific. We therefore assume the specification of the first 8 bits
   so that the enumeration of TX8 respects that of the datasheet *)

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


include Pic32Uarts
  with type 'a register := 'a register
  with type ('a, 'b, 'c, 'd, 'e) uart := ('a, 'b, 'c, 'd, 'e) uart
  with type uxmode_param := uxmode_param
  with type uxsta_param := uxsta_param