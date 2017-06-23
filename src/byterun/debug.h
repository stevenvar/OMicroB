#ifndef __DEBUG_H__
#define __DEBUG_H__

#ifndef __AVR__

#include <assert.h>

#else

#define assert(b) do { if (!(b)) assert_failure(); } while(0)

void assert_failure(void);

#endif

void debug_init(void);
void debug(int n);
void debug_blink(int led, int n);

#endif
