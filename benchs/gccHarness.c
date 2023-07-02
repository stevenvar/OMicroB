#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>

struct timeval tv;

int millis() {
    gettimeofday(&tv, NULL);
    return ((tv.tv_sec * 1000000 + tv.tv_usec) / 1000);
}
