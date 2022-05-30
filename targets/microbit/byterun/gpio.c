#include "hardware.h"
#include "microbian.h"

int pad_of_pin(int pin) {
  switch(pin) {
  case  0: return PAD0;
  case  1: return PAD1;
  case  2: return PAD2;
  case  3: return PAD3;
  case  4: return PAD4;
  case  5: return PAD5;
  case  6: return PAD6;
  case  7: return PAD7;
  case  8: return PAD8;
  case  9: return PAD9;
  case 10: return PAD10;
  case 11: return PAD11;
  case 12: return PAD12;
  case 13: return PAD13;
  case 14: return PAD14;
  case 15: return PAD15;
  case 16: return PAD16;
  case 19: return PAD19;
  case 20: return PAD20;
  default: return 0;
  }
}

int microbit_button_is_pressed(int b) {
  if(b == 0) return gpio_in(BUTTON_A) == 0;
  return gpio_in(BUTTON_B) == 0;
}

void microbit_pin_mode(int pin, int mode) {
  gpio_dir(pad_of_pin(pin), mode);
  if(mode == 0) gpio_connect(pad_of_pin(pin));
}

void microbit_digital_write(int pin, int level) {
  gpio_out(pad_of_pin(pin), level);
}

int microbit_digital_read(int pin) {
  return gpio_in(pad_of_pin(pin));
}
