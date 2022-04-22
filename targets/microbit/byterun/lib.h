/* lib.h */
/* Copyright (c) 2018 J. M. Spivey */

#include <stdarg.h>

#define NULL ((void *) 0)

/* do_print -- the device-independent guts of printf */
void do_print(void (*putch)(char), const char *fmt, va_list va);

/* printf -- print using putchar */
void printf(const char *fmt, ...);

/* sprintf -- print to string buffer.  Note danger of overflow! */
int sprintf(const char *buf, const char *fmt, ...);

/* atoi -- convert decimal string to int */
int atoi(const char *p);

/* xtou -- convert hex string to unsigned */
unsigned xtou(const char *p);
