/* Entry point including the whole runtime */

#ifdef __PC__
#include <stdio.h>
#endif

#include "values.h"
#include "debug.c"
#include "prims.c"
#include "interp.c"
#include "stdlib.c"
#include "gc.c"

#ifdef __AVR__
#include "avrlib.c"
#else
#include "simu.c"
#include "shared.c"
#include "sf_regs.c"
#endif
