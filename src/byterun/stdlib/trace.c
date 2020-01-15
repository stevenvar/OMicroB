#include <stdio.h>
#include <stdint.h>
#include "trace.h"

void debug_trace_open(void) {
  printf("TRACE: ");
}

void debug_trace_char(char c) {
  printf("%c", c);
}

void debug_trace_close(void) {
  printf("\n");
}

void debug_trace_int(long i) {
  printf("TRACE: %ld\n", i);
}
