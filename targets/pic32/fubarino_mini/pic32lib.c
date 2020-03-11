#include <xc.h>
#include <p32xxxx.h>
//#include <plib.h>


#define SYS_FREQ                80000000L
// #define COUNTS_PER_MICRO_SEC ((SYS_FREQ/2L/1000000L))

/*****************************************************************************/
volatile unsigned int *get_reg_addr(uint8_t reg) {
  if (reg == 0) return &LATA;
  if (reg == 1) return &LATB;
  if (reg == 2) return &LATC;
  if (reg == 3) return &TRISA;
  if (reg == 4) return &TRISB;
  if (reg == 5) return &TRISC;
  if (reg == 6) return &PORTA;
  if (reg == 7) return &PORTB;
  if (reg == 8) return &PORTC;
  return NULL;
}


volatile uint32_t *get_reg_addr_uart(uint8_t reg) {
  return NULL;
}

volatile uint32_t *get_reg_addr_timer(uint8_t reg) {
  return NULL;
}


volatile uint32_t *get_reg_addr_adc(uint8_t reg) {
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
  // SYSTEMConfig(SYS_FREQ, SYS_CFG_WAIT_STATES | SYS_CFG_PB_BUS);
}

void init_interrupts(uint8_t mode) {
  // INTConfigureSystem(mode);
  // INTEnableInterrupts();
}




void enable_int_timer(uint8_t timer) {
}

void disable_int_timer(uint8_t timer) {
}

void set_priority_int_timer(uint8_t timer, uint8_t priority) {
}

void set_subpriority_int_timer(uint8_t timer, uint8_t subpriority) {
}

void configure_int_timer(uint8_t timer, uint8_t priority, uint8_t subpriority) {
  set_priority_int_timer(timer, priority);
  set_subpriority_int_timer(timer, subpriority);
  enable_int_timer(timer); 
}



// /*****************************************************************************/




void enable_tx_int_ec_uart(uint8_t uart) {
}

void disable_tx_int_ec_uart(uint8_t uart) {
}

void enable_rx_int_ec_uart(uint8_t uart) {
}

void disable_rx_int_ec_uart(uint8_t uart) {
}

void enable_err_int_ec_uart(uint8_t uart) {
}

void disable_err_int_ec_uart(uint8_t uart) {
}



void enable_tx_int_fs_uart(uint8_t uart) {
}

void disable_tx_int_fs_uart(uint8_t uart) {
}

void enable_rx_int_fs_uart(uint8_t uart) {
}

void disable_rx_int_fs_uart(uint8_t uart) {
}

void enable_err_int_fs_uart(uint8_t uart) {
}


void disable_err_int_fs_uart(uint8_t uart) {
}



void set_priority_int_uart(uint8_t uart, uint8_t priority) {
}

void set_subpriority_int_uart(uint8_t uart, uint8_t subpriority) {
}


void wait_int_flag_ad1() {
}

uint16_t read_adc10(int index) {
  return 0;
}

void disable_int_adc() {
}

void enable_int_adc() {
}
