#include <xc.h>
#include <p32xxxx.h>
//#include <plib.h>

#define SYS_FREQ                80000000L


// #define COUNTS_PER_MICRO_SEC ((SYS_FREQ/2L/1000000L))



/*****************************************************************************/
volatile uint32_t *get_reg_addr(uint8_t reg) {

  /* I/O ports module registers */
  if (reg == 0)  return &LATA;
  if (reg == 1)  return &LATB;
  if (reg == 2)  return &LATC;
  if (reg == 3)  return &LATD;
  if (reg == 4)  return &LATE;
  if (reg == 5)  return &LATF;
  if (reg == 6)  return &LATG;
  if (reg == 7)  return &TRISA;
  if (reg == 8)  return &TRISB;
  if (reg == 9)  return &TRISC;
  if (reg == 10) return &TRISD;
  if (reg == 11) return &TRISE;
  if (reg == 12) return &TRISF;
  if (reg == 13) return &TRISG;
  if (reg == 14) return &PORTA;
  if (reg == 15) return &PORTB;
  if (reg == 16) return &PORTC;
  if (reg == 17) return &PORTD;
  if (reg == 18) return &PORTE;
  if (reg == 19) return &PORTF;
  if (reg == 20) return &PORTG;
  return NULL;
}



volatile uint32_t *get_reg_addr_uart(uint8_t reg) {
  if (reg == 0) return &U1MODE;
  if (reg == 1) return &U2MODE;
  if (reg == 2) return &U3MODE;
  if (reg == 3) return &U4MODE;
  if (reg == 4) return &U5MODE;
  if (reg == 5) return &U6MODE;
  if (reg == 6) return &U1STA;
  if (reg == 7) return &U2STA;
  if (reg == 8) return &U3STA;
  if (reg == 9) return &U4STA;
  if (reg == 10) return &U5STA;
  if (reg == 11) return &U6STA;
  if (reg == 12) return &U1TXREG; 
  if (reg == 13) return &U2TXREG;
  if (reg == 14) return &U3TXREG;
  if (reg == 15) return &U4TXREG;
  if (reg == 16) return &U5TXREG;
  if (reg == 17) return &U6TXREG;
  if (reg == 18) return &U1RXREG;
  if (reg == 19) return &U2RXREG;
  if (reg == 20) return &U3RXREG;
  if (reg == 21) return &U4RXREG;
  if (reg == 22) return &U5RXREG;
  if (reg == 23) return &U6RXREG;
  if (reg == 24) return &U1BRG;
  if (reg == 25) return &U2BRG;
  if (reg == 26) return &U3BRG;
  if (reg == 27) return &U4BRG;
  if (reg == 28) return &U5BRG;
  if (reg == 29) return &U6BRG;

  return NULL;
}

volatile uint32_t *get_reg_addr_timer(uint8_t reg) {
  if (reg == 0) return &T1CON;
  if (reg == 1) return &T2CON;
  if (reg == 2) return &T3CON;
  if (reg == 3) return &T4CON;
  if (reg == 4) return &T5CON;
  if (reg == 5) return &TMR1;
  if (reg == 6) return &TMR2;
  if (reg == 7) return &TMR3;
  if (reg == 8) return &TMR4;
  if (reg == 9) return &TMR5;
  if (reg == 10) return &PR1;
  if (reg == 11) return &PR2;
  if (reg == 12) return &PR3;
  if (reg == 13) return &PR4;
  if (reg == 14) return &PR5;

  return NULL;
}


volatile uint32_t *get_reg_addr_adc(uint8_t reg) {
  if (reg == 0) return &AD1CON1;
  if (reg == 1) return &AD1CON2;
  if (reg == 2) return &AD1CON3;
  if (reg == 3) return &AD1CHS;
  if (reg == 4) return &AD1PCFG;
  if (reg == 5) return &AD1CSSL;
  if (reg == 6) return &ADC1BUF0;
}

/*****************************************************************************/

void set_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) |= ((uint8_t) 1 << bit);
}

void clear_bit(uint8_t reg, uint8_t bit) {
  *(get_reg_addr(reg)) &= ~((uint8_t) 1 << bit);
}

bool read_bit(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr(reg)) & ((uint8_t) 1 << bit);
}

void write_register(uint8_t reg, uint8_t val) {
  *(get_reg_addr(reg)) = val;
}

uint8_t read_register(uint8_t reg) {
  return *(get_reg_addr(reg));
}






void set_bit_adc(uint8_t reg, uint8_t bit) {
  *(get_reg_addr_adc(reg)) |= ((uint8_t) 1 << bit);
}

void clear_bit_adc(uint8_t reg, uint8_t bit) {
  *(get_reg_addr_adc(reg)) &= ~((uint8_t) 1 << bit);
}

bool read_bit_adc(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr_adc(reg)) & ((uint8_t) 1 << bit);
}

void write_register_adc(uint8_t reg, uint8_t val) {
  *(get_reg_addr_adc(reg)) = val;
}

uint32_t read_register_adc(uint8_t reg) {
  return *(get_reg_addr_adc(reg));
}



void set_bit_timer(uint8_t reg, uint8_t bit) {
  *(get_reg_addr_timer(reg)) |= ((uint8_t) 1 << bit);
}

void clear_bit_timer(uint8_t reg, uint8_t bit) {
  *(get_reg_addr_timer(reg)) &= ~((uint8_t) 1 << bit);
}

bool read_bit_timer(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr_timer(reg)) & ((uint8_t) 1 << bit);
}

void write_register_timer(uint8_t reg, uint8_t val) {
  *(get_reg_addr_timer(reg)) = val;
}

uint32_t read_register_timer(uint8_t reg) {
  return *(get_reg_addr_timer(reg));
}


void set_bit_uart(uint8_t reg, uint8_t bit) {
  *(get_reg_addr_uart(reg)) |= ((uint8_t) 1 << bit);
}

void clear_bit_uart(uint8_t reg, uint8_t bit) {
  *(get_reg_addr_uart(reg)) &= ~((uint8_t) 1 << bit);
}

bool read_bit_uart(uint8_t reg, uint8_t bit) {
  return *(get_reg_addr_uart(reg)) & ((uint8_t) 1 << bit);
}

void write_register_uart(uint8_t reg, uint8_t val) {
  *(get_reg_addr_uart(reg)) = val;
}

uint32_t read_register_uart(uint8_t reg) {
  return *(get_reg_addr_uart(reg));
}




int millis() {
  int time_ticks, time_ms;

  time_ticks = _CP0_GET_COUNT();
  time_ms = (int)((time_ticks * 2.0) / (SYS_FREQ / 1000));

  return time_ms;
}

void delay(int ms) {
  int begin;
  
  begin = millis();
  while ((millis() - begin) < ms);
}


/*****************************************************************************/

// void __attribute__ ((nomips16)) CheKseg0CacheOn() {
// 	register unsigned long tmp;
// 	asm("mfc0 %0,$16,0" :  "=r"(tmp));
// 	tmp = (tmp & ~7) | 3;
// 	asm("mtc0 %0,$16,0" :: "r" (tmp));
// }

// void __attribute__((nomips16))  INTRestoreInterrupts(unsigned int status) {
//     if(status & 0x00000001)
//         asm volatile("ei");
//     else
//         asm volatile("di");
// }

// unsigned int __attribute__((nomips16)) INTDisableInterrupts(void) {
//     unsigned int status = 0;
//     asm volatile("di    %0" : "=r"(status));

//     return status;
// }

// unsigned int __attribute__((nomips16))  INTEnableInterrupts(void) {
//     unsigned int status = 0;
//     asm volatile("ei    %0" : "=r"(status));

//     return status;
// }

// void __attribute__ ((nomips16)) INTConfigureSystem(uint8_t mode) {
//     unsigned int val;

//     // set the CP0 cause IV bit high
//     asm volatile("mfc0   %0,$13" : "=r"(val));
//     val |= 0x00800000;
//     asm volatile("mtc0   %0,$13" : "+r"(val));

//     if(mode == 0) // INT_SYSTEM_CONFIG_MULT_VECTOR
//         INTCONSET = _INTCON_MVEC_MASK;
//     else
//         INTCONCLR = _INTCON_MVEC_MASK;
// }




void init_system() {
  // SYSTEMConfig(SYS_FREQ, SYS_CFG_WAIT_STATES | SYS_CFG_PB_BUS);
}

void init_interrupts(uint8_t mode) {
  // INTConfigureSystem(mode);
  // INTEnableInterrupts();
}




void enable_int_timer(uint8_t timer) {
  if (timer == 0) { // TIMER1
    IEC0CLR = _IEC0_T1IE_MASK;
    IEC0SET = 1 << _IEC0_T1IE_POSITION;
  }
  if (timer == 1) { // TIMER2
    IEC0CLR = _IEC0_T2IE_MASK;
    IEC0SET = 1 << _IEC0_T2IE_POSITION;
  }
  if (timer == 2) { // TIMER3
    IEC0CLR = _IEC0_T3IE_MASK;
    IEC0SET = 1 << _IEC0_T3IE_POSITION;
  }
  if (timer == 3) { // TIMER4
    IEC0CLR = _IEC0_T4IE_MASK;
    IEC0SET = 1 << _IEC0_T4IE_POSITION;
  }
  if (timer == 4) { // TIMER5
    IEC0CLR = _IEC0_T5IE_MASK;
    IEC0SET = 1 << _IEC0_T5IE_POSITION;
  }
}

void disable_int_timer(uint8_t timer) {
  if (timer == 0) { // TIMER1
    IEC0CLR = _IEC0_T1IE_MASK;
    // IEC0SET = 0 << _IEC0_T1IE_POSITION;
  }
  if (timer == 1) { // TIMER2
    IEC0CLR = _IEC0_T2IE_MASK;
    // IEC0SET = 0 << _IEC0_T2IE_POSITION;
  }
  if (timer == 2) { // TIMER3
    IEC0CLR = _IEC0_T3IE_MASK;
    // IEC0SET = 0 << _IEC0_T3IE_POSITION;
  }
  if (timer == 3) { // TIMER4
    IEC0CLR = _IEC0_T4IE_MASK;
    // IEC0SET = 0 << _IEC0_T4IE_POSITION;
  }
  if (timer == 4) { // TIMER5
    IEC0CLR = _IEC0_T5IE_MASK;
    // IEC0SET = 0 << _IEC0_T5IE_POSITION;
  }
}

void set_priority_int_timer(uint8_t timer, uint8_t priority) {
  if (timer == 0) { // TIMER1
    IPC1CLR = _IPC1_T1IP_MASK;
    IPC1SET = priority << _IPC1_T1IP_POSITION;
  }
  if (timer == 1) { // TIMER2
    IPC2CLR = _IPC2_T2IP_MASK;
    IPC2SET = priority << _IPC2_T2IP_POSITION;
  }
  if (timer == 2) { // TIMER3
    IPC3CLR = _IPC3_T3IP_MASK;
    IPC3SET = priority << _IPC3_T3IP_POSITION;
  }
  if (timer == 3) { // TIMER4
    IPC4CLR = _IPC4_T4IP_MASK;
    IPC4SET = priority << _IPC4_T4IP_POSITION;
  }
  if (timer == 4) { // TIMER5
    IPC5CLR = _IPC5_T5IP_MASK;
    IPC5SET = priority << _IPC5_T5IP_POSITION;
  }
}

void set_subpriority_int_timer(uint8_t timer, uint8_t subpriority) {
  if (timer == 0) { // TIMER1
    IPC1CLR = _IPC1_T1IS_MASK;
    IPC1SET = subpriority << _IPC1_T1IS_POSITION;   
  }
  if (timer == 1) { // TIMER2
    IPC2CLR = _IPC2_T2IS_MASK;
    IPC2SET = subpriority << _IPC2_T2IS_POSITION;   
  }
  if (timer == 2) { // TIMER3
    IPC3CLR = _IPC3_T3IS_MASK;
    IPC3SET = subpriority << _IPC3_T3IS_POSITION;   
  }
  if (timer == 3) { // TIMER4
    IPC4CLR = _IPC4_T4IS_MASK;
    IPC4SET = subpriority << _IPC4_T4IS_POSITION;   
  }
  if (timer == 4) { // TIMER5
    IPC5CLR = _IPC5_T5IS_MASK;
    IPC5SET = subpriority << _IPC5_T5IS_POSITION;   
  }
}

void configure_int_timer(uint8_t timer, uint8_t priority, uint8_t subpriority) {
  if (timer == 0) { // TIMER1
    IFS0CLR = _IFS0_T1IF_MASK;
  }
  if (timer == 1) { // TIMER2
    IFS0CLR = _IFS0_T2IF_MASK;
  }
  if (timer == 2) { // TIMER3
    IFS0CLR = _IFS0_T3IF_MASK; 
  }
  if (timer == 3) { // TIMER4
    IFS0CLR = _IFS0_T4IF_MASK;
  }
  if (timer == 4) { // TIMER5
    IFS0CLR = _IFS0_T5IF_MASK;
  }
  set_priority_int_timer(timer, priority);
  set_subpriority_int_timer(timer, subpriority);
  enable_int_timer(timer); 
}



// /*****************************************************************************/




void enable_tx_int_ec_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IEC0SET = _IEC0_U1TXIE_MASK;
  }
  if (uart == 1) { // UART 2
    IEC1SET = _IEC1_U2TXIE_MASK;
  }  
  if (uart == 2) { // UART 3 
    IEC1SET = _IEC1_U3TXIE_MASK;
  }
  if (uart == 3) { // UART 4
    IEC2SET = _IEC2_U4TXIE_MASK;
  }
  if (uart == 4) { // UART 5
    IEC2SET = _IEC2_U5TXIE_MASK;
  }
  if (uart == 5) { // UART 6
    IEC2SET = _IEC2_U6TXIE_MASK;
  }
}

void disable_tx_int_ec_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IEC0CLR = _IEC0_U1TXIE_MASK;
  }
  if (uart == 1) { // UART 2
    IEC1CLR = _IEC1_U2TXIE_MASK;
  }  
  if (uart == 2) { // UART 3 
    IEC1CLR = _IEC1_U3TXIE_MASK;
  }
  if (uart == 3) { // UART 4
    IEC2CLR = _IEC2_U4TXIE_MASK;
  }
  if (uart == 4) { // UART 5
    IEC2CLR = _IEC2_U5TXIE_MASK;
  }
  if (uart == 5) { // UART 6
    IEC2CLR = _IEC2_U6TXIE_MASK;
  }
}

void enable_rx_int_ec_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IEC0SET = _IEC0_U1RXIE_MASK;
  }
  if (uart == 1) { // UART 2
    IEC1SET = _IEC1_U2RXIE_MASK;
  }  
  if (uart == 2) { // UART 3 
    IEC1SET = _IEC1_U3RXIE_MASK;
  }
  if (uart == 3) { // UART 4
    IEC2SET = _IEC2_U4RXIE_MASK;
  }
  if (uart == 4) { // UART 5
    IEC2SET = _IEC2_U5RXIE_MASK;
  }
  if (uart == 5) {
    IEC2SET = _IEC2_U6RXIE_MASK;
  }
}

void disable_rx_int_ec_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IEC0CLR = _IEC0_U1RXIE_MASK;
  }
  if (uart == 1) { // UART 2
    IEC1CLR = _IEC1_U2RXIE_MASK;
  }  
  if (uart == 2) { // UART 3 
    IEC1CLR = _IEC1_U3RXIE_MASK;
  }
  if (uart == 3) { // UART 4
    IEC2CLR = _IEC2_U4RXIE_MASK;
  }
  if (uart == 4) { // UART 5
    IEC2CLR = _IEC2_U5RXIE_MASK;
  }
  if (uart == 5) {
    IEC2CLR = _IEC2_U6RXIE_MASK;
  }
}

void enable_err_int_ec_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IEC0SET = _IEC0_U1EIE_MASK;
  }
  if (uart == 1) { // UART 2
    IEC1SET = _IEC1_U2EIE_MASK;
  }  
  if (uart == 2) { // UART 3 
    IEC1SET = _IEC1_U3EIE_MASK;
  }
  if (uart == 3) { // UART 4
    IEC2SET = _IEC2_U4EIE_MASK;
  }
  if (uart == 4) { // UART 5
    IEC2SET = _IEC2_U5EIE_MASK;
  }
  if (uart == 5) {
    IEC2SET = _IEC2_U6EIE_MASK;
  }
}

void disable_err_int_ec_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IEC0CLR = _IEC0_U1EIE_MASK;
  }
  if (uart == 1) { // UART 2
    IEC1CLR = _IEC1_U2EIE_MASK;
  }  
  if (uart == 2) { // UART 3 
    IEC1CLR = _IEC1_U3EIE_MASK;
  }
  if (uart == 3) { // UART 4
    IEC2CLR = _IEC2_U4EIE_MASK;
  }
  if (uart == 4) { // UART 5
    IEC2CLR = _IEC2_U5EIE_MASK;
  }
  if (uart == 5) {
    IEC2CLR = _IEC2_U6EIE_MASK;
  }
}



void enable_tx_int_fs_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IFS0SET = _IFS0_U1TXIF_MASK;
  }
  if (uart == 1) { // UART 2
    IFS1SET = _IFS1_U2TXIF_MASK;
  }  
  if (uart == 2) { // UART 3 
    IFS1SET = _IFS1_U3TXIF_MASK;
  }
  if (uart == 3) { // UART 4
    IFS2SET = _IFS2_U4TXIF_MASK;
  }
  if (uart == 4) { // UART 5
    IFS2SET = _IFS2_U5TXIF_MASK;
  }
  if (uart == 5) { // UART 6
    IFS2SET = _IFS2_U6TXIF_MASK;
  }
}

void disable_tx_int_fs_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IFS0CLR = _IFS0_U1TXIF_MASK;
  }
  if (uart == 1) { // UART 2
    IFS1CLR = _IFS1_U2TXIF_MASK;
  }  
  if (uart == 2) { // UART 3 
    IFS1CLR = _IFS1_U3TXIF_MASK;
  }
  if (uart == 3) { // UART 4
    IFS2CLR = _IFS2_U4TXIF_MASK;
  }
  if (uart == 4) { // UART 5
    IFS2CLR = _IFS2_U5TXIF_MASK;
  }
  if (uart == 5) { // UART 6
    IFS2CLR = _IFS2_U6TXIF_MASK;
  }
}

void enable_rx_int_fs_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IFS0SET = _IFS0_U1RXIF_MASK;
  }
  if (uart == 1) { // UART 2
    IFS1SET = _IFS1_U2RXIF_MASK;
  }  
  if (uart == 2) { // UART 3 
    IFS1SET = _IFS1_U3RXIF_MASK;
  }
  if (uart == 3) { // UART 4
    IFS2SET = _IFS2_U4RXIF_MASK;
  }
  if (uart == 4) { // UART 5
    IFS2SET = _IFS2_U5RXIF_MASK;
  }
  if (uart == 5) {
    IFS2SET = _IFS2_U6RXIF_MASK;
  }
}

void disable_rx_int_fs_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IFS0CLR = _IFS0_U1RXIF_MASK;
  }
  if (uart == 1) { // UART 2
    IFS1CLR = _IFS1_U2RXIF_MASK;
  }  
  if (uart == 2) { // UART 3 
    IFS1CLR = _IFS1_U3RXIF_MASK;
  }
  if (uart == 3) { // UART 4
    IFS2CLR = _IFS2_U4RXIF_MASK;
  }
  if (uart == 4) { // UART 5
    IFS2CLR = _IFS2_U5RXIF_MASK;
  }
  if (uart == 5) {
    IFS2CLR = _IFS2_U6RXIF_MASK;
  }
}

void enable_err_int_fs_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IFS0SET = _IFS0_U1EIF_MASK;
  }
  if (uart == 1) { // UART 2
    IFS1SET = _IFS1_U2EIF_MASK;
  }  
  if (uart == 2) { // UART 3 
    IFS1SET = _IFS1_U3EIF_MASK;
  }
  if (uart == 3) { // UART 4
    IFS2SET = _IFS2_U4EIF_MASK;
  }
  if (uart == 4) { // UART 5
    IFS2SET = _IFS2_U5EIF_MASK;
  }
  if (uart == 5) { // UART 6
    IFS2SET = _IFS2_U6EIF_MASK;
  }
}


void disable_err_int_fs_uart(uint8_t uart) {
  if (uart == 0) { // UART 1
    IFS0CLR = _IFS0_U1EIF_MASK;
  }
  if (uart == 1) { // UART 2
    IFS1CLR = _IFS1_U2EIF_MASK;
  }  
  if (uart == 2) { // UART 3 
    IFS1CLR = _IFS1_U3EIF_MASK;
  }
  if (uart == 3) { // UART 4
    IFS2CLR = _IFS2_U4EIF_MASK;
  }
  if (uart == 4) { // UART 5
    IFS2CLR = _IFS2_U5EIF_MASK;
  }
  if (uart == 5) { // UART 6
    IFS2CLR = _IFS2_U6EIF_MASK;
  }
}



void set_priority_int_uart(uint8_t uart, uint8_t priority) {
  if (uart == 0) { // UART1
    IPC6CLR = _IPC6_U1IP_MASK;
    IPC6SET = priority << _IPC6_U1IP_POSITION;
  }
  if (uart == 1) { // UART2
    IPC8CLR = _IPC8_U2IP_MASK;
    IPC8SET = priority << _IPC8_U2IP_POSITION;
  }
  if (uart == 2) { // UART3
    IPC7CLR = _IPC7_U3IP_MASK;
    IPC7SET = priority << _IPC7_U3IP_POSITION;
  }
  if (uart == 3) { // UART4
    IPC12CLR = _IPC12_U4IP_MASK;
    IPC12SET = priority << _IPC12_U4IP_POSITION;
  }
  if (uart == 4) { // UART5
    IPC12CLR = _IPC12_U5IP_MASK;
    IPC12SET = priority << _IPC12_U5IP_POSITION;
  }
  if (uart == 5) { // UART6
    IPC12CLR = _IPC12_U6IP_MASK;
    IPC12SET = priority << _IPC12_U6IP_POSITION;
  }
}

void set_subpriority_int_uart(uint8_t uart, uint8_t subpriority) {
  if (uart == 0) { // UART1
    IPC6CLR = _IPC6_U1IS_MASK;
    IPC6SET = subpriority << _IPC6_U1IS_POSITION;
  }
  if (uart == 1) { // UART2
    IPC8CLR = _IPC8_U2IS_MASK;
    IPC8SET = subpriority << _IPC8_U2IS_POSITION;
  }
  if (uart == 2) { // UART3
    IPC7CLR = _IPC7_U3IS_MASK;
    IPC7SET = subpriority << _IPC7_U3IS_POSITION;
  }
  if (uart == 3) { // UART4
    IPC12CLR = _IPC12_U4IS_MASK;
    IPC12SET = subpriority << _IPC12_U4IS_POSITION;
  }
  if (uart == 4) { // UART5
    IPC12CLR = _IPC12_U5IS_MASK;
    IPC12SET = subpriority << _IPC12_U5IS_POSITION;
  }
  if (uart == 5) { // UART6
    IPC12CLR = _IPC12_U6IS_MASK;
    IPC12SET = subpriority << _IPC12_U6IS_POSITION;
  }
}


void wait_int_flag_ad1() {
  while(!IFS1bits.AD1IF);
}

uint16_t read_adc10(int index) {
  return *(&ADC1BUF0+((index) * 4));
}

void disable_int_adc() {
  IEC1CLR = _IEC1_AD1IE_MASK;
}

void enable_int_adc() {
  IEC1CLR = _IEC1_AD1IE_MASK;
  IEC1SET = 1 << _IEC1_AD1IE_POSITION;
}




// void __ISR(_UART1_VECTOR, IPL2AUTO) IntUart1Handler(void) {
//   if (U1STAbits.OERR) {
//     U1STACLR = _U1STA_OERR_MASK;
//     IFS0CLR = _IFS0_U1EIF_MASK;
//   }
//   if (IFS0bits.U1RXIF == 1) {
//     if (U1STAbits.URXDA == 1) {
//       UART1_Buffer = U1RXREG;
//     }
//     IFS0CLR = _IFS0_U1RXIF_MASK;
//     ToggleGreen(UART1_Buffer);
//   }
//   if (IFS0bits.U1TXIF == 1) {
//     ToggleRed(toSend1);
//     U1TXREG = toSend1;
//     IEC0CLR = _IEC0_U1TXIE_MASK;
//     IFS0CLR = _IFS0_U1TXIF_MASK;    
//   }
// }


