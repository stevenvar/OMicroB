open Pic32

 let set_pin_analog pin =
  match pin with
    | PIN25 -> clear_bit_adc AD1PCFG PCFG0
    | PIN24 -> clear_bit_adc AD1PCFG PCFG1
    | PIN23 -> clear_bit_adc AD1PCFG PCFG2
    | PIN22 -> clear_bit_adc AD1PCFG PCFG3
    | PIN21 -> clear_bit_adc AD1PCFG PCFG4
    | PIN20 -> clear_bit_adc AD1PCFG PCFG5
    | PIN26 -> clear_bit_adc AD1PCFG PCFG6
    | PIN27 -> clear_bit_adc AD1PCFG PCFG7
    | PIN32 -> clear_bit_adc AD1PCFG PCFG8
    | PIN33 -> clear_bit_adc AD1PCFG PCFG9
    | PIN34 -> clear_bit_adc AD1PCFG PCFG10
    | PIN35 -> clear_bit_adc AD1PCFG PCFG11
    | PIN41 -> clear_bit_adc AD1PCFG PCFG12
    | PIN42 -> clear_bit_adc AD1PCFG PCFG13
    | PIN43 -> clear_bit_adc AD1PCFG PCFG14
    | PIN44 -> clear_bit_adc AD1PCFG PCFG15


let _ =
  
  (* Initialisation du system et des interruptions *)
  init_system ();
  init_interrupts 0;

  (* Configuration du module ADC *)
  close_adc10 ();
  set_chan_adc10 CH0NA_0;
  set_pin_analog PIN25;
  set_pin_analog PIN24;
  set_pin_analog PIN21;

  ad1cssl_set [CSSL_0; CSSL_1; CSSL_4];
  ad1con3_set [ADRC_; SAMC_15];
  ad1con2_set [CSCNA_; SMPI_2];
  ad1con1_set [ON_; FORM_0; SSRC_7; ASAM_];



  enable_adc10 ();
  wait_int_flag_ad1 ();

  (* Configuration des pins régissant les LEDs *)

  pin_mode PIN78 OUTPUT;
  pin_mode PIN82 OUTPUT;

  (* Initialisation du module UART 1 *)

  let u = UART1 in 
  let u1mode = umode_of_uart u in
    let brgh = brgh_bit_of_uart u in
      clear_bit_uart u1mode brgh;
    let ubrg = ubrg_of_uart u in 
      write_register_uart ubrg 9600;

    let stsel = stsel_bit_of_uart u in
      clear_bit_uart u1mode stsel ;
    let pdsel1 = pdsel_bit1_of_uart u in
    let pdsel2 = pdsel_bit2_of_uart u in
      clear_bit_uart u1mode pdsel1; 
      clear_bit_uart u1mode pdsel2;
  
  let u1sta = usta_of_uart u in 
    let utxen = utxen_bit_of_uart u in 
    let urxen = urxen_bit_of_uart u in 
      set_bit_uart u1sta utxen;
      set_bit_uart u1sta urxen;
  
  let on = on_bit_of_uart u in 
    set_bit_uart u1mode on;

    disable_tx_int_ec_uart u;
    disable_rx_int_ec_uart u;
    disable_err_int_ec_uart u;
    disable_tx_int_fs_uart u;
    disable_rx_int_fs_uart u;
    disable_err_int_fs_uart u;
    set_priority_int_uart u 4;
    set_subpriority_int_uart u 1;
    
    enable_rx_int_ec_uart u;

 

  (* Programme *)
 
  let readadc = read_adc10 2 in

    let an_pic1_min = 697.5 in
    let an_pic1_max = 852.5 in
    let an_pic2_min = 930.0 in
    let an_pic2_max = 1136.666666667 in
    let cond1 u = an_pic1_min <= u && u <= an_pic1_max in
    let cond2 u = an_pic2_min <= u && u <= an_pic2_max in
    let convvalue = float_of_int readadc in
    let pic_id () = 
      if cond1 convvalue == true
      then 1
      else if cond2 convvalue == true
      then 2
      else 0
    in

    if pic_id () == 0 (* MCU 1 (celui à gauche) *)
    then 
      triggerWrite 12
   
    else if pic_id () == 1
    then

      triggerWrite 6
    else 
      ()

   