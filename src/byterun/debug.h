

/* assertions en mode DEBUG */
extern int failed_assert (char *, char *, int);

#ifdef DEBUG
#define DEBUGassert(x) \
  ((x) ? (void) 0 : failed_assert ( #x , __FILE__, __LINE__))

#else
#define DEBUGassert(x) ((void) 0)
#endif

/* à définir une valeur par défaut pour des champs non initialisés 
 * à voir s'il faut en réserver une ou cela peut aussi se recouvrir
 */
#ifdef DEBUG
#define DEBUGclear(result, wosize) do{ \
  int32_t DEBUG_i; \
  for (DEBUG_i = 0; DEBUG_i < (wosize); ++ DEBUG_i){ \
    Field ((result), DEBUG_i) = uninit_val; \
  } \
}while(0)
#else
#define DEBUGclear(result, wosize)
#endif
