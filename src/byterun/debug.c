#include "debug.h"

#if !defined(__AVR__) && !defined(__PC__)

#include <stdio.h>
#include "simul.h"

void debug_init(void) {}

void debug(int n) {
  printf("debug(%d)\n", n);
}

void debug_blink(int led, int n) {
  printf("debug_blink(%d, %d)\n", led, n);
}

#else

#ifdef __AVR__

#include <Arduino.h>

void debug_init(void) {
  Serial.begin(57600);
}

void debug(int n) {
  Serial.print("debug(");
  Serial.print(n);
  Serial.println(")");
}

void debug_blink(int led, int n) {
  int i;
  pinMode(led, OUTPUT);
  digitalWrite(led, HIGH);
  delay(1000);
  for (i = 0; i < n; i ++) {
    digitalWrite(led, LOW);
    delay(300);
    digitalWrite(led, HIGH);
    delay(300);
  }
  delay(1000);
}

void assert_failure(void) {
  int i, led = 17;
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

#ifdef __PC__

void debug_init(void) {}

void debug(int n) {
  printf("debug(%d)\n", n);
}

void debug_blink(int led, int n) {
  printf("debug_blink(%d, %d)\n", led, n);
}
#endif

#endif
