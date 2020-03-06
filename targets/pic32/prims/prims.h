/* C-interface between:                             */
/*   -> prims/bindings.c                            */
/*   -> simul/sf-regs.c | pic32/pic32lib.c          */

#ifndef PRIMS_H_PIC32
#define PRIMS_H_PIC32





void init_system();
void init_interrupts(uint8_t mode);
void wait_int_flag_ad1();
uint16_t read_adc10(int index);
void enable_int_adc();
void disable_int_adc();

void enable_int_timer(uint8_t timer);
void disable_int_timer(uint8_t timer);
void set_priority_int_timer(uint8_t timer, uint8_t priority);
void set_subpriority_int_timer(uint8_t timer, uint8_t subpriority);
void configure_int_timer(uint8_t timer, uint8_t priority, uint8_t subpriority);

void enable_tx_int_ec_uart(uint8_t uart);
void disable_tx_int_ec_uart(uint8_t uart);
void enable_rx_int_ec_uart(uint8_t uart);
void disable_rx_int_ec_uart(uint8_t uart);
void enable_err_int_ec_uart(uint8_t uart);
void disable_err_int_ec_uart(uint8_t uart);
void enable_tx_int_fs_uart(uint8_t uart);
void disable_tx_int_fs_uart(uint8_t uart);
void enable_rx_int_fs_uart(uint8_t uart);
void disable_rx_int_fs_uart(uint8_t uart);
void enable_err_int_fs_uart(uint8_t uart);
void disable_err_int_fs_uart(uint8_t uart);

void set_priority_int_uart(uint8_t uart, uint8_t priority);
void set_subpriority_int_uart(uint8_t uart, uint8_t subpriority);



#endif
