#ifndef __PGMSPACE_H_
#define __PGMSPACE_H_ 1

#include <inttypes.h>
//Program stub for creating compatibltiy with PROGMEM apps from Arduino
// neither PROGMEM or PSTR are needed for PIC32, just define them as null
#ifdef PROGMEM
#undef PROGMEM
#endif
#define PROGMEM

#ifndef PGM_P
#define PGM_P const char *
#endif

#ifdef PGM_VOID_P
#undef PGM_VOID_P
#endif
#define PGM_VOID_P void *

#ifdef PSTR
#undef PSTR
#endif
#define PSTR(s) (s)

typedef void prog_void;
typedef char prog_char;
typedef unsigned char prog_uchar;
typedef int8_t prog_int8_t;
typedef uint8_t prog_uint8_t;
typedef int16_t prog_int16_t;
typedef uint16_t prog_uint16_t;
typedef int32_t prog_int32_t;
typedef uint32_t prog_uint32_t;

#ifdef pgm_read_byte
#undef pgm_read_byte
#endif
#define pgm_read_byte(x)        (*((char *)x))

#ifdef pgm_read_byte_near
#undef pgm_read_byte_near
#endif
#define pgm_read_byte_near(x)   (*((char *)x))

#ifdef pgm_read_byte_far
#undef pgm_read_byte_far
#endif
#define pgm_read_byte_far(x)    (*((char *)x))

#ifdef pgm_read_word
#undef pgm_read_word
#endif
#define pgm_read_word(x)        (*((short *)x))

#ifdef pgm_read_word_near
#undef pgm_read_word_near
#endif
#define pgm_read_word_near(x)   (*((short *)x))

#ifdef pgm_read_word_far
#undef pgm_read_word_far
#endif
#define pgm_read_word_far(x)    (*((short *)x))

#ifdef pgm_read_dword
#undef pgm_read_dword
#endif
#define pgm_read_dword(x)        (*((int *)x))

#ifdef pgm_read_dword_near
#undef pgm_read_dword_near
#endif
#define pgm_read_dword_near(x)   (*((int *)x))

#ifdef pgm_read_dword_far
#undef pgm_read_dword_far
#endif
#define pgm_read_dword_far(x)    (*((int *)x))

#ifdef pgm_read_float
#undef pgm_read_float
#endif
#define pgm_read_float(x)       (*((float *)x))

#ifdef pgm_read_double
#undef pgm_read_double
#endif
#define pgm_read_double(x)      (*((double *)x))

#ifdef prog_void
#undef prog_void
#endif
#define prog_void const void

#ifdef prog_uchar
#undef prog_uchar
#endif
#define prog_uchar const unsigned char

#ifdef prog_int8_t
#undef prog_int8_t
#endif
#define prog_int8_t const int8_t

#ifdef prog_uint8_t
#undef prog_uint8_t
#endif
#define prog_uint8_t const uint8_t

#ifdef prog_int16_t
#undef prog_int16_t
#endif
#define prog_int16_t const int16_t

#ifdef prog_uint16_t
#undef prog_uint16_t
#endif
#define prog_uint16_t const uint16_t

#ifdef prog_int32_t
#undef prog_int32_t
#endif
#define prog_int32_t const int32_t

#ifdef prog_uint32_t
#undef prog_uint32_t
#endif
#define prog_uint32_t const uint32_t

#ifdef prog_int64_t
#undef prog_int64_t
#endif
#define prog_int64_t const int64_t

#ifdef prog_uint64_t
#undef prog_uint64_t
#endif
#define prog_uint64_t const uint64_t


#ifdef memcpy_P
#undef memcpy_P
#endif
#define memcpy_P(dest, src, num) memcpy((dest), (src), (num))

#ifdef memcpy_PF
#undef memcpy_PF
#endif
#define memcpy_PF(dest, src, num) memcpy((dest), (src), (num))

#ifdef strcat_P
#undef strcat_P
#endif
#define strcat_P(dest, src) strcat((dest), (src))

#ifdef strcat_PF
#undef strcat_PF
#endif
#define strcat_PF(dest, src) strcat((dest), (src))

#ifdef strcpy_P
#undef strcpy_P
#endif
#define strcpy_P(dest, src) strcpy((dest), (src))

#ifdef strcpy_PF
#undef strcpy_PF
#endif
#define strcpy_PF(dest, src) strcpy((dest), (src))

#ifdef strlen_P
#undef strlen_P
#endif
#define strlen_P(src) strlen((src))

#ifdef strlen_PF
#undef strlen_PF
#endif
#define strlen_PF(src) strlen((src))

#ifdef strnlen_P
#undef strnlen_P
#endif
#define strnlen_P(src, maxlen) strnlen((src), (maxlen))

#ifdef strnlen_PF
#undef strnlen_PF
#endif
#define strnlen_PF(src, maxlen) strnlen((src), (maxlen))

#ifdef strcasecmp_P
#undef strcasecmp_P
#endif
#define strcasecmp_P(stra, strb) strcasecmp((stra), (strb))

#ifdef strcasecmp_PF
#undef strcasecmp_PF
#endif
#define strcasecmp_PF(stra, strb) strcasecmp((stra), (strb))

#ifdef strcmp_P
#undef strcmp_P
#endif
#define strcmp_P(stra, strb) strcmp((stra), (strb))

#ifdef strcmp_PF
#undef strcmp_PF
#endif
#define strcmp_PF(stra, strb) strcmp((stra), (strb))

#ifdef strncmp_P
#undef strncmp_P
#endif
#define strncmp_P(stra, strb, num) strncmp((stra), (strb), (num))

#ifdef strncmp_PF
#undef strncmp_PF
#endif
#define strncmp_PF(stra, strb, num) strncmp((stra), (strb), (num))

#ifdef strncasecmp_P
#undef strncasecmp_P
#endif
#define strncasecmp_P(stra, strb, num) strncasecmp((stra), (strb), (num))

#ifdef strncasecmp_PF
#undef strncasecmp_PF
#endif
#define strncasecmp_PF(stra, strb, num) strncasecmp((stra), (strb), (num))

#ifdef strncat_P
#undef strncat_P
#endif
#define strncat_P(dest, src, num) strncat((dest), (src), (num))

#ifdef strncat_PF
#undef strncat_PF
#endif
#define strncat_PF(dest, src, num) strncat((dest), (src), (num))

#ifdef strncpy_P
#undef strncpy_P
#endif
#define strncpy_P(dest, src, num) strncpy((dest), (src), (num))

#ifdef strncpy_PF
#undef strncpy_PF
#endif
#define strncpy_PF(dest, src, num) strncpy((dest), (src), (num))

#ifdef strtok_P
#undef strtok_P
#endif
#define strtok_P(src, tok) strtok((src), (tok))

#ifdef sprintf_P
#undef sprintf_P
#endif
#define sprintf_P(...) sprintf(__VA_ARGS__)

#ifdef memcmp_P
#undef memcmp_P
#endif
#define memcmp_P(s1, s2, n) memcmp((s1), (s2), (n))

#ifdef memcmp_PF
#undef memcmp_PF
#endif
#define memcmp_PF(s1, s2, n) memcmp((s1), (s2), (n))

#ifdef memchr_P
#undef memchr_P
#endif
#define memchr_P(s, c, n) memchr((s), (c), (n))
 
#ifdef memccpy_P
#undef memccpy_P
#endif
#define memccpy_P(dest, src, c, n) memccpy((dest), (src), (c), (n))
 
#ifdef memmem_P
#undef memmem_P
#endif
#define memmem_P(haystack, haystacklen, needle, needlelen) memmem((haystack), (haystacklen), (needle), (needlelen))

#ifndef memrchr_P
#undef memrchr_P
#endif
#define memrchr_P(s, c, n) memrchr((s), (c), (n))
 
 
#ifndef strchr_P
#undef strchr_P
#endif
#define strchr_P(s, c) strchr((s), (c))
 
#ifndef strchrnul_P
#undef strchrnul_P
#endif
#define strchrnul_P(s, c) strchrnul((s), (c))
 
#ifndef strcasestr_P
#undef strcasestr_P
#endif
#define strcasestr_P(s1, s2) strcasestr((s1), (s2))
 
#ifndef strcspn_P
#undef strcspn_P
#endif
#define strcspn_P(s, reject) strcspn((s), (reject))
 
#ifndef strlcat_P
#undef strlcat_P
#endif
#define strlcat_P(dst, src, siz) strlcat((dst), (src), (siz))
 
#ifndef strlcat_PF
#undef strlcat_PF
#endif
#define strlcat_PF(dst, src, siz) strlcat((dst), (src), (siz))
 
#ifndef strlcpy_P
#undef strlcpy_P
#endif
#define strlcpy_P(dst, src, siz) strlcpy((dst), (src), (siz))
 
#ifndef strlcpy_PF
#undef strlcpy_PF
#endif
#define strlcpy_PF(dst, src, siz) strlcpy((dst), (src), (siz))
 
#ifndef strpbrk_P
#undef strpbrk_P
#endif
#define strpbrk_P(s, accept) strpbrk((s), (accept))
 
#ifndef strrchr_P
#undef strrchr_P
#endif
#define strrchr_P(src, val) strrchr((src), (val))
 
#ifndef strsep_P
#undef strsep_P
#endif
#define strsep_P(sp, delim) strsep((sp), (delim))
 
#ifndef strspn_P
#undef strspn_P
#endif
#define strspn_P(s, accept) strspn((s), (accept))
 
#ifndef strstr_P
#undef strstr_P
#endif
#define strstr_P(s1, s2) strstr((s1), (s2))
 
#ifndef strstr_PF
#undef strstr_PF
#endif
#define strstr_PF(s1, s2) strstr((s1), (s2))
 
#ifndef strtok_rP
#undef strtok_rP
#endif
#define strtok_rP(s, delim, last) strtok_r((s), (delim), (last))

#endif /* __PGMSPACE_H_ */
