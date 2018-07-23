#ifndef __AVR__
#include <stdio.h>
#endif

#include <stdint.h>
#include "trace.h"

void debug_trace_open(void) {
#ifndef __AVR__
  printf("TRACE: ");
#endif
}

void debug_trace_char(char c) {
#ifndef __AVR__
  printf("%c", c);
#endif
}

void debug_trace_close(void) {
#ifndef __AVR__
  printf("\n");
#endif
}

void debug_trace_int(long i) {
#ifndef __AVR__
  printf("TRACE: %ld\n", i);
#endif
}
