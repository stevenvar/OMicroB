#ifdef __PC__
#include <stdio.h>
#endif

#include <stdint.h>
#include "trace.h"

void debug_trace_open(void) {
#ifdef __PC__
  printf("TRACE: ");
#endif
}

void debug_trace_char(char c) {
#ifdef __PC__
  printf("%c", c);
#endif
}

void debug_trace_close(void) {
#ifdef __PC__
  printf("\n");
#endif
}

void debug_trace_int(long i) {
#ifdef __PC__
  printf("TRACE: %ld\n", i);
#endif
}
