(*******************************************************************************)
(*                                                                             *)
(*                  Generic PIC32 pin communication library                    *)
(*                                                                             *)
(*******************************************************************************)

type level = HIGH | LOW
type mode = INPUT | OUTPUT

type yes
type no
type 'a analog_pin = YES : yes analog_pin | NO : no analog_pin

module type Pic32Pins = sig
  type ('a, 'b, 'c, 'd) pin
  type 'a register
  val lat_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a register
  val tris_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b register
  val port_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c register
  val lat_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'a
  val tris_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'b
  val port_bit_of_pin :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> 'c
  val pin_mode : 
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> mode -> unit
  val digital_write :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> level -> unit
  val digital_read :
    ('a register, 'b register, 'c register, 'd analog_pin) pin -> level
  val write_register : 'a register -> int -> unit
  val read_register : 'a register -> int 
  val set_bit : 'a register -> 'a -> unit
  val clear_bit : 'a register -> 'a -> unit
  val read_bit : 'a register -> 'a -> bool
end



module type Pic32Timers = sig
  type ('a, 'b, 'c) timer
  type 'a register
  type txcon_param 

  val tcon_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a register
  val tmr_of_timer : 
    ('a register, 'b register, 'c register) timer -> 'b register
  val pr_of_timer : 
    ('a register, 'b register, 'c register) timer -> 'c register
  val on_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val sidl_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val tgate_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val tckps_bit1_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val tckps_bit2_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val tckps_bit3_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val t32_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val tcs_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val twip_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val twdis_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 
  val tsync_bit_of_timer :
    ('a register, 'b register, 'c register) timer -> 'a 

  val write_register_timer : 'a register -> int -> unit
  val read_register_timer : 'a register -> int 
  val set_bit_timer : 'a register -> 'a -> unit
  val clear_bit_timer : 'a register -> 'a -> unit
  val read_bit_timer : 'a register -> 'a -> bool 

  val enable_int_timer : 
    ('a register, 'b register, 'c register) timer -> unit 
  val disable_int_timer : 
    ('a register, 'b register, 'c register) timer -> unit 
  val set_priority_int_timer : 
    ('a register, 'b register, 'c register) timer -> int -> unit 
  val set_subpriority_int_timer : 
    ('a register, 'b register, 'c register) timer -> int -> unit 
  val configure_int_timer : 
    ('a register, 'b register, 'c register) timer -> int -> int -> unit 

  val t1con_set : 
    txcon_param list -> unit
  val txcon_set : 
    ('a register, 'b register, 'c register) timer -> txcon_param list -> unit


  val read_timer : 
    ('a register, 'b register, 'c register) timer -> int
  val write_timer : 
    ('a register, 'b register, 'c register) timer -> int -> unit 
  val read_period_timer : 
    ('a register, 'b register, 'c register) timer -> int
  val write_period_timer : 
    ('a register, 'b register, 'c register) timer -> int -> unit
  (* val open_timer : 
    ('a register, 'b register, 'c register) timer -> txcon_param list -> int -> unit *)
  val close_timer : 
    ('a register, 'b register, 'c register) timer -> unit
end


module type Pic32Uarts = sig
  type ('a, 'b, 'c, 'd, 'e) uart
  type 'a register
  type uxmode_param
  type uxsta_param

  val umode_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a register
  val usta_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b register
  val utxreg_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'c register
  val urxreg_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'd register
  val ubrg_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'e register

  val stsel_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val pdsel_bit1_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val pdsel_bit2_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val brgh_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val rxinv_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a 
  val abaud_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val lpback_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val wake_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val uen_bit1_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val uen_bit2_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val rtsmd_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val iren_bit_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val sidl_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a
  val on_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'a

  val urxda_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val oerr_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val ferr_bit_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val perr_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val ridle_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val adden_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val urxisel_bit1_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val urxisel_bit2_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val trmt_bit_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val utxbf_bit_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val utxen_bit_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val utxbrk_bit_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val urxen_bit_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val utxinv_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val utxisel_bit1_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val utxisel_bit2_of_uart :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b
  val adm_en_bit_of_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> 'b

  val write_register_uart : 'a register -> int -> unit
  val read_register_uart : 'a register -> int 
  val set_bit_uart : 'a register -> 'a -> unit
  val clear_bit_uart : 'a register -> 'a -> unit
  val read_bit_uart : 'a register -> 'a -> bool

  val enable_tx_int_ec_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit 
  val disable_tx_int_ec_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit 
  val enable_rx_int_ec_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit 
  val disable_rx_int_ec_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit
  val enable_err_int_ec_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit 
  val disable_err_int_ec_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit
  val enable_tx_int_fs_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit
  val disable_tx_int_fs_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit
  val enable_rx_int_fs_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit 
  val disable_rx_int_fs_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit
  val enable_err_int_fs_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit
  val disable_err_int_fs_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> unit
  val set_priority_int_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int -> unit 
  val set_subpriority_int_uart : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int -> unit


  val uxsta_set :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> uxsta_param list -> unit

  val uxmode_set :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> uxmode_param list -> unit

  val read_tx_reg : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int
  val write_tx_reg : 
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int -> unit
  val read_rx_reg :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int
  val write_rx_reg :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int -> unit
  val read_baud_rate :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int
  val write_baud_rate :
    ('a register, 'b register, 'c register, 'd register, 'e register) uart -> int -> unit 
end


module type Pic32ADC = sig
  type 'a register
  type ad1con1_param
  type ad1con2_param
  type ad1con3_param
  type ad1cssl_param
  type adc_chan

  val write_register_adc : 'a register -> int -> unit
  val read_register_adc : 'a register -> int 
  val set_bit_adc : 'a register -> 'a -> unit
  val clear_bit_adc : 'a register -> 'a -> unit
  val read_bit_adc : 'a register -> 'a -> bool


  val ad1con1_set : ad1con1_param list -> unit
  val ad1con2_set : ad1con2_param list -> unit
  val ad1con3_set : ad1con3_param list -> unit
  val ad1cssl_set : ad1cssl_param list -> unit 

  val enable_adc10 : unit -> unit 
  val close_adc10 : unit -> unit 
  val set_chan_adc10 : adc_chan -> unit

  val enable_int_adc : unit -> unit 
  val disable_int_adc : unit -> unit
end 

val delay : int -> unit 
val init_system : unit -> unit 
val init_interrupts : int -> unit 
val wait_int_flag_ad1 : unit -> unit
val read_adc10 : int -> int

