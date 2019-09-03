#include <stdio.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/pgmspace.h>
#include <util/delay.h>
#include "../prims/prims.h"

#ifndef __ARCH_SPECIFIC__
#define __ARCH_SPECIFIC__

/******************************************************************************/
/* Blocks */

#define Flash_field(val, i) (pgm_read_dword_near(Flash_block_val(val) + i))
#define Flash_string_field(val, i) ((uint8_t) pgm_read_byte_near((uint8_t *) Flash_block_val(val) + i))

#endif
