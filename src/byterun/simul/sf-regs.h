
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
int avr_random(int max);
int avr_millis();
void avr_delay(int ms);

void avr_adc_init();
uint16_t avr_analog_read(uint8_t ch);

void avr_serial_init();
char avr_serial_read();
void avr_serial_write(char c);

void microbit_print_string(char *str);
void microbit_print_int(int i);
void microbit_write_pixel(int x, int y, int l);
void microbit_print_image(char *str);
void microbit_clear_screen();
int microbit_button_is_pressed(int b);
void microbit_pin_mode(int p, int m);
void microbit_digital_write(int p, int l);
int microbit_digital_read(int p);
void microbit_analog_write(int p, int l);
int microbit_analog_read(int p);
void microbit_delay(int ms);
int microbit_millis();
void microbit_serial_write_char(char c);
char microbit_serial_read_char();
int microbit_accelerometer_x();
int microbit_accelerometer_y();
int microbit_accelerometer_z();
int microbit_accelerometer_pitch();
int microbit_accelerometer_roll();
void microbit_compass_calibrate();
int microbit_compass_heading();
void microbit_radio_init();
void microbit_radio_send(char *s);
const char *microbit_radio_recv();
void microbit_i2c_init();
void microbit_i2c_write(int a, const char *buf, int l);
int microbit_i2c_read(int a, char *buf);
void microbit_spi_init();
char microbit_spi_transmit(char c);

#endif
