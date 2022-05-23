#include "hardware.h"
#include "microbian.h"

int pad_of_pin(int pin) {
  switch(pin) {
    case 0: return PAD0;
    case 1: return PAD1;
    case 2: return PAD2;
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
