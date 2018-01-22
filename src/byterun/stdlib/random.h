#ifndef RANDOM_H
#define RANDOM_H

#include <stdint.h>
#include <stdbool.h>

void    random_init(int32_t n);
int32_t random_bits(int32_t bound);
bool    random_bool(void);

#endif
