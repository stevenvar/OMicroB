/* lib.c */
/* Copyright (c) 2018 J. M. Spivey */

#include "lib.h"
#include "hardware.h"

#define NMAX 16                 /* Max digits in a printed number */

/* utoa -- convert unsigned to decimal or hex */
static char *utoa(unsigned x, unsigned base, char *nbuf)
{
    char *p = &nbuf[NMAX];
    const char *hex = "0123456789abcdef";

    *--p = '\0';
    do {
        *--p = hex[x % base];
        x = x / base;
    } while (x != 0);
     
    return p;
}

/* itoa -- convert signed integer to decimal */
static char *itoa(int v, char *nbuf)
{
    if (v >= 0)
        return utoa(v, 10, nbuf);
    else {
        char *p = utoa(-v, 10, nbuf);
        *--p = '-';
        return p;
    }
}

/* atoi -- convert decimal string to integer */
int atoi(const char *p)
{
    unsigned x = 0;
    int minus = 0;

    if (*p == '-') {
        minus = 1; p++;
    }

    while (*p >= '0' && *p <= '9')
        x = 10 * x + (*p++ - '0');

    if (minus)
        return -x;
    else
        return x;
}

/* xtou -- convert hex string to unsigned */
unsigned xtou(const char *p)
{
    unsigned x = 0;

    for (;;) {
        if (*p >= '0' && *p <= '9')
            x = (x << 4) + (*p++ - '0');
        else if (*p >= 'a' && *p <= 'f')
            x = (x << 4) + (*p++ - 'a' + 10);
        else if (*p >= 'A' && *p <= 'F')
            x = (x << 4) + (*p++ - 'A' + 10);
        else
            break;
    }

    return x;
}


/* FORMATTED OUTPUT */

/* The functions defined here provide a version of printf that calls a
client-supplied function print_buf to output characters, a thread-safe
version of sprintf, and a skeleton do_print that calls a supplied
function on each output character.  The print_buf interface is
potentially the most efficient, because printf buffers characters
internally and passes them to print_buf 16 at a time, reducing context
switches if print_buf sends messages to a device driver process.

The three public functions share a common skeleton _do_print that
takes as parameters a "putc-function" and a pointer q that is passed
to the function with each character.  Different putc-functions and
different interpretations of the pointer q are needed for different
applications. */


/* do_string -- output or buffer each character of a string */
static void do_string(void (*putc)(void *, char), void *q, char *str)
{
    for (char *p = str; *p != '\0'; p++)
        putc(q, *p);
}

/* _do_print -- the guts of printf */
static void _do_print(void (*putc)(void *, char), void *q,
                      const char *fmt, va_list va) {
    int x;
    char nbuf[NMAX];

    for (const char *p = fmt; *p != 0; p++) {
        if (*p == '%' && *(p+1) != '\0') {
            switch (*++p) {
            case 'c':
                putc(q, va_arg(va, int));
                break;
            case 'd':
                do_string(putc, q, itoa(va_arg(va, int), nbuf));
                break;
            case 's':
                do_string(putc, q, va_arg(va, char *));
                break;
            case 'u':
                do_string(putc, q, utoa(va_arg(va, unsigned), 10, nbuf));
                break;
            case 'x':
                x = va_arg(va, unsigned);
                if (x == 0)
                    putc(q, '0');
                else {
                    putc(q, '0'); putc(q, 'x');
                    do_string(putc, q, utoa(x, 16, nbuf));
                }
                break;
            default:
                putc(q, *p);
                break;
            }
        } else {
            putc(q, *p);
        }
    }
}     

/* f_printc -- putc-function that calls q as a function */
static void f_printc(void *q, char c)
{
    void (*f)(char) = (void (*)(char)) q;
    f(c);
}

/* f_storec -- putc-function that uses q as a character pointer */
void f_storec(void *q, char c)
{
    char **p = (char**) q;
    *(*p)++ = c;
}

/* do_print -- public skeleton for printf */
void do_print(void (*putc)(char), const char *fmt, va_list va)
{
    _do_print(f_printc, (void *) putc, fmt, va);
}

/* sprintf -- print to a character array */
int sprintf(const char *buf, const char *fmt, ...)
{
    /* Note the usual problem with buffer overflow */
    char *p = buf;
    va_list va;
    va_start(va, fmt);
    _do_print(f_storec, (void *) &p, fmt, va);
    va_end(va);
    *p++ = '\0';
    return (p - buf);
}

/* printf's internal buffer complicates the behaviour of the 'chaos'
example: don't be tempted to make the buffer bigger, or all chaos will
be removed!  Clients not running under micro:bian see no benefit from
the buffering because there print_buf is usually implemented by
repeated calls to serial_putc. */

/* print_buf -- must be provided by client */
extern void print_buf(char *buf, int n);

#define NBUF 16

/* struct buffer -- buffer for use by printf */
struct buffer {
    char buf[NBUF];             /* Characters in the buffer */
    int nbuf;                   /* Number of characters */
};
    
/* flush -- flush a buffer by calling print_buf */
static void flush(struct buffer *b)
{
    print_buf(b->buf, b->nbuf);
    b->nbuf = 0;
}

/* f_bufferc -- putc-function that stores characters in a buffer */
static void f_bufferc(void *q, char c)
{
    struct buffer *b = q;
    if (b->nbuf == NBUF) flush(b);
    b->buf[b->nbuf++] = c;
}

/* printf -- print using client-supplied print_buf */
void printf(const char *fmt, ...)
{
    va_list va;
    struct buffer b;
    b.nbuf = 0;
    va_start(va, fmt);
    _do_print(f_bufferc, &b, fmt, va);
    va_end(va);
    flush(&b);
}
