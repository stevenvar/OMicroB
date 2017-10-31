/* Implementation of Arduino primitives for simulation purpose on a computer */

#ifdef __AVR__

#else

#ifdef __PIC18F

#else

#ifdef __PC__

#else

/******************************************************************************/

#include <stdio.h>
#include <time.h>
#include <sys/time.h>
#include <sys/resource.h>

#include "simul.h"

/******************************************************************************/

void pinMode(int pin, int mode) {
  printf("pinMode(%d, %d)\n", pin, mode);
}

void digitalWrite(int pin, int val) {
  printf("digitalWrite(%d, %d)\n", pin, val);
}

int digitalRead(int pin) {
  printf("digitalRead(%d)\n", pin);
  return 0;
}

void delay(int millis) {
  struct timespec req, rem;
  printf("delay(%d)\n", millis);
  req.tv_sec = millis / 1000;
  req.tv_nsec = 1000000 * (millis - 1000 * req.tv_sec);
  nanosleep(&req, &rem);
}

int millis(void) {
  struct rusage ru;
  getrusage(RUSAGE_SELF, &ru);
  return ru.ru_utime.tv_sec * 1000 + ru.ru_utime.tv_usec;
}

val_t caml_write_reg (val_t pin,val_t v){
  return 0;
}

val_t caml_set_bit(val_t pin){
  return 0;
}

val_t caml_clear_bit(val_t pin){
  return 0;
}

/******************************************************************************/

#endif
#endif
#endif
