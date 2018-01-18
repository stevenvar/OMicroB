#define OUTPUT 1
#define HIGH 1
#define LOW 0

#include <stdio.h>

void pinMode(int pin, int mode);

void digitalWrite(int pin, int val);
int  digitalRead(int pin);

void delay(int millis);
int  millis(void);
