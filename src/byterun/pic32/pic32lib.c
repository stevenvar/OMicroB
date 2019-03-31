#ifndef OPT_SYSTEM_INTERNAL
#define OPT_SYSTEM_INTERNAL
#endif

#include "cores/System_Defs.h"
#include "cores/Arduino.h"

extern "C" {
extern void __use_isr_install(void);
__attribute__((section(".comment"))) void (*__use_force_isr_install)(void) = &__use_isr_install;
}

// y a pas tout
uint8_t get_pin_addr(uint8_t pin) {
  if (pin == 0) return A0;
  if (pin == 1) return PIN_LED1; // nul, à changer
  if (pin == 2) return A2;
  if (pin == 3) return A3;
  if (pin == 4) return A4;
  if (pin == 5) return A5;
  if (pin == 6) return A6;
  if (pin == 7) return A7;
  if (pin == 8) return A8;
  if (pin == 10) return A0;
  if (pin == 11) return A10;
  if (pin == 12) return A11;
  if (pin == 13) return A12;
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

void pic32_analog_write(uint8_t pin, uint8_t level) {
  analogWrite(get_pin_addr(pin), level);
}

uint8_t pic32_analog_read(uint8_t pin) {
  return analogRead(get_pin_addr(pin));
}

void pic32_delay(int ms) {
  delay(ms);
}

int pic32_millis() {
  return millis();
}
