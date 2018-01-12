/* Binding to arduino libraries */

#ifdef  __AVR__
#include "avr.h"
#include "avrlib.c"
#elif defined(__PC__)
#include "pclib.c"
#else
#include "simul.h"
#include "pclib.c"
#endif
