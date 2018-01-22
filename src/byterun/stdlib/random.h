#ifndef RANDOM_H
#define RANDOM_H

#include <stdint.h>
#include <stdbool.h>

void     random_init(int32_t n);
uint32_t random_bits(uint32_t bound);
bool     random_bool(void);

#endif
