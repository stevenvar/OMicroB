open Pic32

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


include Pic32ADC
  with type 'a register := 'a register
  with type ad1con1_param := ad1con1_param
  with type ad1con2_param := ad1con2_param
  with type ad1con3_param := ad1con3_param
  with type ad1cssl_param := ad1cssl_param
  with type adc_chan := adc_chan