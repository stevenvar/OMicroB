/* Entry point including the whole runtime */

#ifdef __PC__
#include <stdio.h>
#endif

#include "array.c"
#include "compare.c"
#include "debug.c"
#include "fail.c"
#include "float.c"
#include "interp.c"
#include "obj.c"
#include "oo.c"
#include "str.c"
#include "sys.c"
#include "gc.c"
#include "hash.c"
#include "int32.c"
#include "int64.c"

#if defined(OCAML_GC_MARK_AND_COMPACT)
#include "mark-and-compact.c"
#elif defined(OCAML_GC_STOP_AND_COPY)
#include "stop-and-copy.c"
#else
#error "Unknown garbage collector to use, please define OCAML_GC_MARK_AND_COMPACT or OCAML_GC_STOP_AND_COPY"
#endif

#ifdef __PC__
 #include <unistd.h>
#endif

#include "../prims/prims.h"
#include "../prims/bindings.c"
#include "../stdlib/random.c"
#include "../stdlib/trace.c"
#include "../stdlib/delay.c"

#ifdef __AVR__
#include "../avr/avrlib.c"
#else
#include "../simul/simul.c"
#include "../simul/shared.c"
#include "../simul/sf-regs.c"
#endif
