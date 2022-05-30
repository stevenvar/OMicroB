/* Copyright 2022 Basile Pesin */

/* Software implementation of Pulse Width Modulation */

#include "microbian.h"
#include "hardware.h"

static int PWM_TASK;

static int pwm_channels[NB_PWM_CHANNELS] = { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 };

static void pwm_task(int dummy) {
  while(1) {
    int mic = timer_micros();
    for(int i = 0; i < NB_PWM_CHANNELS; i++) {
      if(pwm_channels[i] != -1) {
        microbit_digital_write(i, (mic % 1024) < pwm_channels[i]);
      }
    }
  }
}

void microbit_analog_write(int pin, int l) {
  pwm_channels[pin] = l;
}

void pwm_init(void) {
  PWM_TASK = start("PWM", pwm_task, 0, 256);
}
