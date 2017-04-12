
include <stdint.h>

int failed_assert (char * expr, char * file, int line) {
  fprintf (stderr, "file %s; line %d ### Assertion failed: %s\n",
           file, line, expr);
  fflush (stderr);
  exit(100);
  return(1);
}
