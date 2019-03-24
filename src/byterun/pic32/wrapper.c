#ifndef OPT_SYSTEM_INTERNAL
#define OPT_SYSTEM_INTERNAL
#endif

#include "cores/System_Defs.h"
#include "cores/Arduino.h"

extern "C" {
extern void __use_isr_install(void);
__attribute__((section(".comment"))) void (*__use_force_isr_install)(void) = &__use_isr_install;
}
extern int main();

void setup() {
  init();
  pinMode(LED_BUILTIN, OUTPUT);
  while (true)
    loop();
}

void loop() {
  _scheduleTask();
  main();
}
