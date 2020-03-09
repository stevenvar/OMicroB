
void init_system() {
  printf("Init system\n");
}

void init_interrupts(uint8_t mode) {
  printf("Init interrupts\n");
}


void wait_int_flag_ad1() {
  printf("Wait int flag ad1\n");
}

void enable_int_adc() {
  printf("Enabling ADC interrupt\n");
}

void disable_int_adc() {
  printf("Disabling ADC interrupt\n");
}

uint16_t read_adc10(int index) {
  printf("ReadADC10(%d)\n", index);
  return 0;
}









/***************************************************/
/************* TIMERS ******************************/


void enable_int_timer(uint8_t timer) {
  printf("Enabling interrupt for timer %d\n", timer+1);
}

void disable_int_timer(uint8_t timer) {
  printf("Disabling interrupt for timer %d\n", timer+1);
}

void set_priority_int_timer(uint8_t timer, uint8_t priority) {
  printf("Setting priority %d for timer %d\n", priority, timer+1);
}

void set_subpriority_int_timer(uint8_t timer, uint8_t subpriority) {
  printf("Setting subpriority %d for timer %d\n", subpriority, timer+1);
}

void configure_int_timer(uint8_t timer, uint8_t priority, uint8_t subpriority) {
  printf("Configuring timer %d with priority %d and subpriority %d\n", timer+1, priority, subpriority);
  set_priority_int_timer(timer, priority);
  set_subpriority_int_timer(timer, subpriority);
  enable_int_timer(timer); 
}




/***************************************************/






void enable_tx_int_ec_uart(uint8_t uart) {
  printf("Enabling TX interrupt enable control for UART %d\n", uart+1);
}

void disable_tx_int_ec_uart(uint8_t uart) {
  printf("Disabling TX interrupt enable control for UART %d\n", uart+1);
}

void enable_rx_int_ec_uart(uint8_t uart) {
  printf("Enabling RX interrupt enable control for UART %d\n", uart+1);
}

void disable_rx_int_ec_uart(uint8_t uart) {
  printf("Disabling RX interrupt enable control for UART %d\n", uart+1);
}

void enable_err_int_ec_uart(uint8_t uart) {
  printf("Enabling error interrupt enable control for UART %d\n", uart+1);
}

void disable_err_int_ec_uart(uint8_t uart) {
  printf("Disabling error interrupt enable control for UART %d\n", uart+1);
}

void enable_tx_int_fs_uart(uint8_t uart) {
  printf("Enabling TX interrupt flag status for UART %d\n", uart+1);
}

void disable_tx_int_fs_uart(uint8_t uart) {
  printf("Disabling TX interrupt flag status for UART %d\n", uart+1);
}

void enable_rx_int_fs_uart(uint8_t uart) {
  printf("Enabling RX interrupt flag status for UART %d\n", uart+1);
}

void disable_rx_int_fs_uart(uint8_t uart) {
  printf("Disabling RX interrupt flag status for UART %d\n", uart+1);
}

void enable_err_int_fs_uart(uint8_t uart) {
  printf("Enabling error interrupt flag status for UART %d\n", uart+1);
}

void disable_err_int_fs_uart(uint8_t uart) {
  printf("Disabling error interrupt flag status for UART %d\n", uart+1);
}

void set_priority_int_uart(uint8_t uart, uint8_t priority) {
  printf("Setting priority %d for UART %d\n", priority, uart+1);
}

void set_subpriority_int_uart(uint8_t uart, uint8_t subpriority) {
  printf("Setting subpriority %d for UART %d\n", subpriority, uart+1);
}






void set_bit_timer(uint8_t reg, uint8_t bit) {
  // printf("set_bit_timer(%d, %d)\n", Int_val(reg), Int_val(bit));
  printf("set_bit_timer(%d, %d)\n", (int) reg, (int)bit);
}

void clear_bit_timer(uint8_t reg, uint8_t bit) {
    // printf("clear_bit_timer(%d, %d)\n", Int_val(reg), Int_val(bit));
   printf("clear_bit_timer(%d, %d)\n", (int) reg, (int)bit);
}

bool read_bit_timer(uint8_t reg, uint8_t bit) {
  return true;
}

void write_register_timer(uint8_t reg, uint8_t val) {
  printf("write_register_timer(%d, %d)\n", (int) reg, (int)val);
}

uint32_t read_register_timer(uint8_t reg) {
  return 0;
}





void set_bit_uart(uint8_t reg, uint8_t bit) {
  // printf("set_bit_uart(%d, %d)\n", Int_val(reg), Int_val(bit));
  printf("set_bit_uart(%d, %d)\n", (int) reg, (int)bit);
}

void clear_bit_uart(uint8_t reg, uint8_t bit) {
    // printf("clear_bit_uart(%d, %d)\n", Int_val(reg), Int_val(bit));
   printf("clear_bit_uart(%d, %d)\n", (int) reg, (int)bit);
}

bool read_bit_uart(uint8_t reg, uint8_t bit) {
  return true;
}

void write_register_uart(uint8_t reg, uint8_t val) {
  printf("write_register_uart(%d, %d)\n", (int) reg, (int)val);
}

uint32_t read_register_uart(uint8_t reg) {
  return 0;
}





void set_bit_adc(uint8_t reg, uint8_t bit) {
  // printf("set_bit_adc(%d, %d)\n", Int_val(reg), Int_val(bit));
  printf("set_bit_adc(%d, %d)\n", (int) reg, (int)bit);
}

void clear_bit_adc(uint8_t reg, uint8_t bit) {
    // printf("clear_bit_adc(%d, %d)\n", Int_val(reg), Int_val(bit));
   printf("clear_bit_adc(%d, %d)\n", (int) reg, (int)bit);
}

bool read_bit_adc(uint8_t reg, uint8_t bit) {
  return true;
}

void write_register_adc(uint8_t reg, uint8_t val) {
  printf("write_register_adc(%d, %d)\n", (int) reg, (int)val);
}

uint32_t read_register_adc(uint8_t reg) {
  return 0;
}