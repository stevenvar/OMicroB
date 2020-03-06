#include <xc.h>
#include <p32xxxx.h>
//#include <plib.h>

#define SYS_FREQ 80000000L
// #define COUNTS_PER_MICRO_SEC ((SYS_FREQ/2L/1000000L))



/*****************************************************************************/
volatile uint32_t *get_reg_addr(uint8_t reg) {
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

  if (reg == 21) return &AD1CON1;
  if (reg == 22) return &AD1CON2;
  if (reg == 23) return &AD1CON3;
  if (reg == 24) return &AD1CHS;
  if (reg == 25) return &AD1PCFG;
  if (reg == 26) return &AD1CSSL;
  if (reg == 27) return &ADC1BUF0;

  if (reg == 28) return &U1MODE;
  if (reg == 29) return &U2MODE;
  if (reg == 30) return &U3MODE;
  if (reg == 31) return &U4MODE;
  if (reg == 32) return &U5MODE;
  if (reg == 33) return &U6MODE;
  if (reg == 34) return &U1STA;
  if (reg == 35) return &U2STA;
  if (reg == 36) return &U3STA;
  if (reg == 37) return &U4STA;
  if (reg == 38) return &U5STA;
  if (reg == 39) return &U6STA;
  if (reg == 40) return &U1TXREG; 
  if (reg == 41) return &U2TXREG;
  if (reg == 42) return &U3TXREG;
  if (reg == 43) return &U4TXREG;
  if (reg == 44) return &U5TXREG;
  if (reg == 45) return &U6TXREG;
  if (reg == 46) return &U1RXREG;
  if (reg == 47) return &U2RXREG;
  if (reg == 48) return &U3RXREG;
  if (reg == 49) return &U4RXREG;
  if (reg == 50) return &U5RXREG;
  if (reg == 51) return &U6RXREG;
  if (reg == 52) return &U1BRG;
  if (reg == 53) return &U2BRG;
  if (reg == 54) return &U3BRG;
  if (reg == 55) return &U4BRG;
  if (reg == 56) return &U5BRG;
  if (reg == 57) return &U6BRG;

  if (reg == 58) return &T1CON;
  if (reg == 59) return &T2CON;
  if (reg == 60) return &T3CON;
  if (reg == 61) return &T4CON;
  if (reg == 62) return &T5CON;
  if (reg == 63) return &TMR1;
  if (reg == 64) return &TMR2;
  if (reg == 65) return &TMR3;
  if (reg == 66) return &TMR4;
  if (reg == 67) return &TMR5;
  if (reg == 68) return &PR1;
  if (reg == 69) return &PR2;
  if (reg == 70) return &PR3;
  if (reg == 71) return &PR4;
  if (reg == 72) return &PR5;
  return NULL;
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


int millis() {
  uint32_t time_ticks, time_ms;

  time_ticks = _CP0_GET_COUNT();
  time_ms = (uint32_t)((time_ticks * 2.0) / (SYS_FREQ / 1000));

  return time_ms;
}

void delay(int ms) {
  uint32_t begin;
  
  begin = millis();
  while ((millis() - begin) < (uint32_t) ms);
}




void init_system() {
  SYSTEMConfig(SYS_FREQ, SYS_CFG_WAIT_STATES | SYS_CFG_PB_BUS);
}

void init_interrupts(uint8_t mode) {
  INTConfigureSystem(mode);
  INTEnableInterrupts();
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