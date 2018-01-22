#ifdef __PC__
#include <stdio.h>
#endif

#include "trace.h"

void debug_trace(const char *msg) {
  #ifdef __PC__
  printf("TRACE: %s\n", msg);
  #endif
}

void debug_tracei(long i) {
  #ifdef __PC__
  printf("TRACE: %ld\n", i);
  #endif
}
