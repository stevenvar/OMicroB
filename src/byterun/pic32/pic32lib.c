#ifndef OPT_SYSTEM_INTERNAL
#define OPT_SYSTEM_INTERNAL
#endif

#include "cores/System_Defs.h"
#include "cores/Arduino.h"

extern "C" {
extern void __use_isr_install(void);
__attribute__((section(".comment"))) void (*__use_force_isr_install)(void) = &__use_isr_install;
}

uint8_t get_pin_addr(uint8_t pin) {
  // normal definition
  if (pin <= 32) return pin;
  // MISO
  if (pin == 33) return MISO;
  // SCK
  if (pin == 34) return SCK;
  // MOSI
  if (pin == 35) return MOSI;
  // SS
  if (pin == 36) return SS;
  // Analog
  if (pin = 37) return A0;
  if (pin = 38) return A1;
  if (pin = 39) return A2;
  if (pin = 40) return A3;
  if (pin = 41) return A4;
  if (pin = 42) return A5;
  if (pin = 43) return A6;
  if (pin = 44) return A7;
  if (pin = 45) return A8;
  if (pin = 46) return A9;
  if (pin = 47) return A10;
  if (pin = 48) return A11;
  if (pin = 49) return A12;
}

void pic32_init() {
  init();
}

void pic32_schedule_task() {
  _scheduleTask();
}

void pic32_pin_mode(uint8_t pin, uint8_t mode) {
  pinMode(get_pin_addr(pin), mode);
}

void pic32_digital_write(uint8_t pin, uint8_t level) {
  digitalWrite(get_pin_addr(pin), level);
}

uint8_t pic32_digital_read(uint8_t pin) {
  return digitalRead(get_pin_addr(pin));
}

void pic32_analog_write(uint8_t pin, int level) {
  analogWrite(get_pin_addr(pin), level);
}

int pic32_analog_read(uint8_t pin) {
  return analogRead(get_pin_addr(pin));
}

void pic32_delay(int ms) {
  delay(ms);
}

int pic32_millis() {
  return millis();
}

void pic32_serial_init() {
  Serial.begin(9600);
}

void pic32_serial_write_char(char c) {
  Serial.write(c);
}

char pic32_serial_read_char() {
  int incoming = Serial.read();
  if (incoming == -1) return 0;
  else return (char)incoming;
}
