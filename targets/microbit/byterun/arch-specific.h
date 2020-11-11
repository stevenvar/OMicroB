#include <stdio.h>
#include <inttypes.h>

#ifndef __ARCH_SPECIFIC__
#define __ARCH_SPECIFIC__

#define PROGMEM

/******************************************************************************/
/* Blocks */

#define Flash_field(val, i) (Flash_block_val(val)[i])
#define Flash_string_field(val, i) (((uint8_t *) Flash_block_val(val))[i])

#endif
