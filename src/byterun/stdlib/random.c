#include <stdint.h>
#include <stdbool.h>
#include "random.h"

static uint32_t random_n0 = 0x46FE2EC5;
static uint32_t random_n1 = 0x8E2A8B3C;
static uint32_t random_n2 = 0x48868F0D;

static void random_turn(void) {
  uint32_t sum = random_n0 + random_n2;
  random_n2 = random_n1;
  random_n1 = random_n0;
  random_n0 = sum;
}

void random_init(int32_t n) {
  random_n0 = (uint32_t) n ^ 0x4CC642b4;
  random_n1 = 0x07f8f8e7;
  random_n2 = 0x0b2044b6;
}

uint32_t random_bits(uint32_t bound) {
  uint32_t tmp;
  do {
    random_turn();
    tmp = random_n0 % bound;
  } while (random_n0 - tmp > 0x3FFFFFFF - bound + 1);
  return tmp;
}

bool random_bool(void) {
  random_turn();
  return random_n0 | 1;
}
