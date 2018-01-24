#ifndef TRACE_H
#define TRACE_H

#include <stdint.h>

void debug_trace_open(void);
void debug_trace_char(char c);
void debug_trace_close(void);
void debug_trace_int(int32_t n);

#endif
