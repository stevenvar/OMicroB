#include "values.h"

/******************************************************************************/

#ifndef __AVR__

#define OUTPUT 0
#define HIGH 1
#define LOW 0

#include <stdio.h>
#include <time.h>

void pinMode(int pin, int mode) {
  printf("pinMode(%d, %d)\n", pin, mode);
}

void digitalWrite(int pin, int val) {
  printf("digitalWrite(%d, %d)\n", pin, val);
}

void delay(int millis) {
  struct timespec req, rem;
  req.tv_sec = (millis / 1000);
  req.tv_nsec = (millis - (req.tv_sec)) * 1000000;
  printf("delay(%d)\n", millis);
  nanosleep(&req, &rem);
}

#endif

/******************************************************************************/

val_t led_blink(val_t unit) {
  int led = 13;
  pinMode(led, OUTPUT);
  while (1) {
    digitalWrite(led, HIGH);
    delay(1000);
    digitalWrite(led, LOW);
    delay(1000);
  }
  return Val_unit;
}
 
/******************************************************************************/
