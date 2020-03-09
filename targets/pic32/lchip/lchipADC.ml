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


type 'a register =
  | AD1CON1 : ad1con1_bit register 
  | AD1CON2 : ad1con2_bit register
  | AD1CON3 : ad1con3_bit register
  | AD1CHS : ad1chs_bit register 
  | AD1PCFG : ad1pcfg_bit register
  | AD1CSSL : ad1cssl_bit register
  | ADC1BUF0 : adc1buf0_bit register

external write_register_adc : 'a register -> int -> unit = "caml_write_register_adc" [@@noalloc]
external read_register_adc : 'a register -> int = "caml_read_register_adc" [@@noalloc]
external set_bit_adc : 'a register -> 'a -> unit = "caml_set_bit_adc" [@@noalloc]
external clear_bit_adc : 'a register -> 'a -> unit = "caml_clear_bit_adc" [@@noalloc]
external read_bit_adc : 'a register -> 'a -> bool = "caml_read_bit_adc" [@@noalloc]

external enable_int_adc : unit -> unit = "caml_enable_int_adc" [@@noalloc]
external disable_int_adc : unit -> unit = "caml_disable_int_adc" [@@noalloc]



let ad1con1_set params = 
  let ssrc_set n =
    match n with 
      | 0 -> clear_bit_adc AD1CON1 SSRC1; clear_bit_adc AD1CON1 SSRC2; clear_bit_adc AD1CON1 SSRC3
      | 1 -> set_bit_adc AD1CON1 SSRC1; clear_bit_adc AD1CON1 SSRC2; clear_bit_adc AD1CON1 SSRC3
      | 2 -> clear_bit_adc AD1CON1 SSRC1; set_bit_adc AD1CON1 SSRC2; clear_bit_adc AD1CON1 SSRC3
      | 3 -> set_bit_adc AD1CON1 SSRC1; set_bit_adc AD1CON1 SSRC2; clear_bit_adc AD1CON1 SSRC3
      | 7 -> set_bit_adc AD1CON1 SSRC1; set_bit_adc AD1CON1 SSRC2; set_bit_adc AD1CON1 SSRC3
      | _ -> () 
  
  in 
  let form_set n =
    match n with 
    | 0 -> clear_bit_adc AD1CON1 FORM1; clear_bit_adc AD1CON1 FORM2; clear_bit_adc AD1CON1 FORM3
    | 1 -> set_bit_adc AD1CON1 FORM1; clear_bit_adc AD1CON1 FORM2; clear_bit_adc AD1CON1 FORM3
    | 2 -> clear_bit_adc AD1CON1 FORM1; set_bit_adc AD1CON1 FORM2; clear_bit_adc AD1CON1 FORM3
    | 3 -> set_bit_adc AD1CON1 FORM1; set_bit_adc AD1CON1 FORM2; clear_bit_adc AD1CON1 FORM3
    | 4 -> clear_bit_adc AD1CON1 FORM1; clear_bit_adc AD1CON1 FORM2; set_bit_adc AD1CON1 FORM3
    | 5 -> set_bit_adc AD1CON1 FORM1; clear_bit_adc AD1CON1 FORM2; set_bit_adc AD1CON1 FORM3
    | 6 -> clear_bit_adc AD1CON1 FORM1; set_bit_adc AD1CON1 FORM2; set_bit_adc AD1CON1 FORM3
    | 7 -> set_bit_adc AD1CON1 FORM1; set_bit_adc AD1CON1 FORM2; set_bit_adc AD1CON1 FORM3
    | _ -> ()
  in

  let set_bits param =
  match param with 
    | DONE_ -> set_bit_adc AD1CON1 DONE
    | SAMP_ -> set_bit_adc AD1CON1 SAMP
    | ASAM_ -> set_bit_adc AD1CON1 ASAM
    | CLRASAM_ -> set_bit_adc AD1CON1 CLRASAM
    | SSRC_0 -> ssrc_set 0
    | SSRC_1 -> ssrc_set 1
    | SSRC_2 -> ssrc_set 2
    | SSRC_3 -> ssrc_set 3
    | SSRC_7 -> ssrc_set 7
    | FORM_0 -> form_set 0
    | FORM_1 -> form_set 1
    | FORM_2 -> form_set 2
    | FORM_3 -> form_set 3
    | FORM_4 -> form_set 4
    | FORM_5 -> form_set 5
    | FORM_6 -> form_set 6
    | FORM_7 -> form_set 7
    | SIDL_ -> set_bit_adc AD1CON1 SIDL
    | ON_ -> set_bit_adc AD1CON1 ON 


  in 
  write_register_adc AD1CON1 0;
  List.iter set_bits params


let ad1con2_set params =
  let smpi_set n = 
    match n with
    | 0 -> clear_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 1 -> set_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 2 -> clear_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 3 -> set_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 4 -> clear_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 5 -> set_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 6 -> clear_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 7 -> set_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; clear_bit_adc AD1CON2 SMPI4
    | 8 -> clear_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | 9 -> set_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | 10 -> clear_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | 11 -> set_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; clear_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | 12 -> clear_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | 13 -> set_bit_adc AD1CON2 SMPI1; clear_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | 14 -> clear_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | 15 -> set_bit_adc AD1CON2 SMPI1; set_bit_adc AD1CON2 SMPI2; set_bit_adc AD1CON2 SMPI3; set_bit_adc AD1CON2 SMPI4
    | _ -> ()
 
  in
  let vcfg_set n = 
    match n with 
    | 0 -> clear_bit_adc AD1CON2 VCFG1; clear_bit_adc AD1CON2 VCFG2; clear_bit_adc AD1CON2 VCFG3
    | 1 -> set_bit_adc AD1CON2 VCFG1; clear_bit_adc AD1CON2 VCFG2; clear_bit_adc AD1CON2 VCFG3
    | 2 -> clear_bit_adc AD1CON2 VCFG1; set_bit_adc AD1CON2 VCFG2; clear_bit_adc AD1CON2 VCFG3
    | 3 -> set_bit_adc AD1CON2 VCFG1; set_bit_adc AD1CON2 VCFG2; clear_bit_adc AD1CON2 VCFG3
    | 4 -> clear_bit_adc AD1CON2 VCFG1; clear_bit_adc AD1CON2 VCFG2; set_bit_adc AD1CON2 VCFG3
    (* | 5 -> set_bit_adc AD1CON2 VCFG1; clear_bit_adc AD1CON2 VCFG2; set_bit_adc AD1CON2 VCFG3
    | 6 -> clear_bit_adc AD1CON2 VCFG1; set_bit_adc AD1CON2 VCFG2; set_bit_adc AD1CON2 VCFG3
    | 7 -> set_bit_adc AD1CON2 VCFG1; set_bit_adc AD1CON2 VCFG2; set_bit_adc AD1CON2 VCFG3 *)
    | _ -> ()

  in 
  let set_bits param = 
    match param with 
      | ALTS_ -> set_bit_adc AD1CON2 ALTS
      | BUFM_ -> set_bit_adc AD1CON2 BUFM
      | SMPI_0 -> smpi_set 0
      | SMPI_1 -> smpi_set 1
      | SMPI_2 -> smpi_set 2
      | SMPI_3 -> smpi_set 3
      | SMPI_4 -> smpi_set 4
      | SMPI_5 -> smpi_set 5
      | SMPI_6 -> smpi_set 6
      | SMPI_7 -> smpi_set 7
      | SMPI_8 -> smpi_set 8 
      | SMPI_9 -> smpi_set 9
      | SMPI_10 -> smpi_set 10
      | SMPI_11 -> smpi_set 11
      | SMPI_12 -> smpi_set 12
      | SMPI_13 -> smpi_set 13
      | SMPI_14 -> smpi_set 14
      | SMPI_15 -> smpi_set 15
      | BUFS_ -> set_bit_adc AD1CON2 BUFS
      | CSCNA_ -> set_bit_adc AD1CON2 CSCNA
      | OFFCAL_ -> set_bit_adc AD1CON2 OFFCAL
      | VCFG_0 -> vcfg_set 0
      | VCFG_1 -> vcfg_set 1
      | VCFG_2 -> vcfg_set 2
      | VCFG_3 -> vcfg_set 3
      | VCFG_4 -> vcfg_set 4
      (* Beyond VCFG_4 to VCFG_7, it results into the same config. 
         Perhaps find a way to shorten this configuration so that 
         there is no need to specify them all *)
      | VCFG_5 -> vcfg_set 4
      | VCFG_6 -> vcfg_set 4
      | VCFG_7 -> vcfg_set 4


  in 
  write_register_adc AD1CON2 0;
  List.iter set_bits params


let ad1con3_set params =
  let samc_set n =
    match n with
    (* Just specifying what is necessary for lchip for the moment *)
    | 15 -> set_bit_adc AD1CON3 SAMC1; set_bit_adc AD1CON3 SAMC2; set_bit_adc AD1CON3 SAMC3; set_bit_adc AD1CON3 SAMC4; clear_bit_adc AD1CON3 SAMC5
    | _ -> ()
  in

  let set_bits param =
    match param with
      | ADRC_ -> set_bit_adc AD1CON3 ADRC
      (* | SAMC_0 -> samc_set 0
      | SAMC_1 -> samc_set 1
      | SAMC_2 -> samc_set 2
      | SAMC_3 -> samc_set 3
      | SAMC_4 -> samc_set 4
      | SAMC_5 -> samc_set 5
      | SAMC_6 -> samc_set 6
      | SAMC_7 -> samc_set 7
      | SAMC_8 -> samc_set 8
      | SAMC_9 -> samc_set 9
      | SAMC_10 -> samc_set 10
      | SAMC_11 -> samc_set 11
      | SAMC_12 -> samc_set 12
      | SAMC_13 -> samc_set 13
      | SAMC_14 -> samc_set 14 *)
      | SAMC_15 -> samc_set 15
      (* | SAMC_16 -> samc_set 16
      | SAMC_17 -> samc_set 17
      | SAMC_18 -> samc_set 18
      | SAMC_19 -> samc_set 19
      | SAMC_20 -> samc_set 20
      | SAMC_21 -> samc_set 21
      | SAMC_22 -> samc_set 22
      | SAMC_23 -> samc_set 23
      | SAMC_24 -> samc_set 24
      | SAMC_25 -> samc_set 25
      | SAMC_26 -> samc_set 26
      | SAMC_27 -> samc_set 27
      | SAMC_28 -> samc_set 28
      | SAMC_29 -> samc_set 29
      | SAMC_30 -> samc_set 30
      | SAMC_31 -> samc_set 31 *)
      (* For the moment, I am not integrating the 
         support for ADCS bits. In the Lchip app, 
         ADRC is set to 1 which resuluts into ADCS 
         not being used anyway. *)

  in write_register_adc AD1CON3 0;
  List.iter set_bits params


let ad1cssl_set params = 
  let set_bits param = 
    match param with 
      | CSSL_0 -> set_bit_adc AD1CSSL CSSL0
      | CSSL_1 -> set_bit_adc AD1CSSL CSSL1
      | CSSL_2 -> set_bit_adc AD1CSSL CSSL2
      | CSSL_3 -> set_bit_adc AD1CSSL CSSL3
      | CSSL_4 -> set_bit_adc AD1CSSL CSSL4
      | CSSL_5 -> set_bit_adc AD1CSSL CSSL5
      | CSSL_6 -> set_bit_adc AD1CSSL CSSL6
      | CSSL_7 -> set_bit_adc AD1CSSL CSSL7
      | CSSL_8 -> set_bit_adc AD1CSSL CSSL8
      | CSSL_9 -> set_bit_adc AD1CSSL CSSL9
      | CSSL_10 -> set_bit_adc AD1CSSL CSSL10
      | CSSL_11 -> set_bit_adc AD1CSSL CSSL11
      | CSSL_12 -> set_bit_adc AD1CSSL CSSL12
      | CSSL_13 -> set_bit_adc AD1CSSL CSSL13
      | CSSL_14 -> set_bit_adc AD1CSSL CSSL14
      | CSSL_15 -> set_bit_adc AD1CSSL CSSL15

  in write_register_adc AD1CSSL 0;
  List.iter set_bits params
 

let enable_adc10 () =
  set_bit_adc AD1CON1 ON

let close_adc10 () = 
  disable_int_adc ();
  clear_bit_adc AD1CON1 ON


let set_chan_adc10 v = 
  match v with 
  | CH0SA_0 -> clear_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_1 -> set_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_2 -> clear_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_3 -> set_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_4 -> clear_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_5 -> set_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_6 -> clear_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_7 -> set_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; clear_bit_adc AD1CHS CH0SA4
  | CH0SA_8 -> clear_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0SA_9 -> set_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0SA_10 -> clear_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0SA_11 -> set_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; clear_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0SA_12 -> clear_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0SA_13 -> set_bit_adc AD1CHS CH0SA1; clear_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0SA_14 -> clear_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0SA_15 -> set_bit_adc AD1CHS CH0SA1; set_bit_adc AD1CHS CH0SA2; set_bit_adc AD1CHS CH0SA3; set_bit_adc AD1CHS CH0SA4
  | CH0NA_0 -> clear_bit_adc AD1CHS CH0NA
  | CH0NA_1 -> set_bit_adc AD1CHS CH0NA
  | CH0SB_0 -> clear_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_1 -> set_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_2 -> clear_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_3 -> set_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_4 -> clear_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_5 -> set_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_6 -> clear_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_7 -> set_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; clear_bit_adc AD1CHS CH0SB4
  | CH0SB_8 -> clear_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0SB_9 -> set_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0SB_10 -> clear_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0SB_11 -> set_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; clear_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0SB_12 -> clear_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0SB_13 -> set_bit_adc AD1CHS CH0SB1; clear_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0SB_14 -> clear_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0SB_15 -> set_bit_adc AD1CHS CH0SB1; set_bit_adc AD1CHS CH0SB2; set_bit_adc AD1CHS CH0SB3; set_bit_adc AD1CHS CH0SB4
  | CH0NB_0 -> clear_bit_adc AD1CHS CH0NB
  | CH0NB_1 -> set_bit_adc AD1CHS CH0NB


