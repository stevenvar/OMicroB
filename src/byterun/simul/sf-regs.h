
#ifndef SF_REG_H
#define SF_REG_H

#include <stdint.h>
#include <stdbool.h>

void init_regs(int nb_proc, int is_slow);
void destroy_regs(void);
void dump_regs(void);
void exec_instr(char *instr, int size);

void avr_set_bit(uint8_t reg, uint8_t bit);
void avr_clear_bit(uint8_t reg, uint8_t bit);
bool avr_test_bit(uint8_t reg, uint8_t bit);
void avr_write_register(uint8_t reg, uint8_t val);
uint8_t avr_read_register(uint8_t reg);
void avr_analog_write(uint8_t pin, int val);
uint16_t avr_analog_read(uint8_t channel);
int avr_random(int max);
int avr_millis();


void avr_serial_init();
char avr_serial_read();
void avr_serial_write(char c);

void pic32_schedule_task();
void pic32_pin_mode(uint8_t p, uint8_t m);
void pic32_digital_write(uint8_t p, uint8_t l);
void lchip_digital_write_lled(uint8_t l);
void lchip_digital_write_rled(uint8_t l);
uint8_t pic32_digital_read(uint8_t p);
void pic32_analog_write(uint8_t p, int l);
int pic32_analog_read(uint8_t p);
void pic32_delay(int ms);
int pic32_millis();

void pic32_serial_init();
char pic32_serial_read();
void pic32_serial_write(char c);

#endif
