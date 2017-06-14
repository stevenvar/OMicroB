#include "debug.h"

#ifndef __AVR__

#include <stdio.h>
#include "simul.h"

void debug_init(void) {}

void debug(int n) {
  printf("debug(%d)\n", n);
}

#else

#include <Arduino.h>

void debug_init(void) {
  Serial.begin(9600);
}

void debug(int n) {
  Serial.print("debug(");
  Serial.print(n);
  Serial.println(")");
}

void assert_failure(void) {
  int i, led = 13;
  while (1) {
    pinMode(led, OUTPUT);
    digitalWrite(led, LOW);
    delay(1000);
    for (i = 0; i < 3; i ++) {
      digitalWrite(led, HIGH);
      delay(200);
      digitalWrite(led, LOW);
      delay(200);
    }
    delay(1000);
  }
}

#endif
