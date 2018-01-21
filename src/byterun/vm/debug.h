#ifndef __DEBUG_H__
#define __DEBUG_H__

#if defined(DEBUG) && defined(__PC__)
#define TRACE(msg) printf(msg "\n")
#else
#define TRACE(msg)
#endif

void print_heap(void);
void print_global(void);
void print_stack(void);

#endif
