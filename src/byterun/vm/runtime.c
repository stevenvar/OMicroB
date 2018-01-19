/* Entry point including the whole runtime */

#ifdef __PC__
#include <stdio.h>
#endif

#include "array.c"
#include "compare.c"
#include "debug.c"
#include "fail.c"
#include "float.c"
#include "gc.c"
#include "interp.c"
#include "obj.c"
#include "oo.c"
#include "str.c"

#include "../prims/prims.h"
#include "../prims/omc-bindings.c"

#ifdef __AVR__
#include "../avr/avrlib.c"
#else
#include "../simul/simul.c"
#include "../simul/shared.c"
#include "../simul/sf-regs.c"
#endif
