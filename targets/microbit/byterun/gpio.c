#include "hardware.h"

int microbit_button_is_pressed(int b) {
  if(b == 0) return gpio_in(BUTTON_A) == 0;
  return gpio_in(BUTTON_B) == 0;
}
