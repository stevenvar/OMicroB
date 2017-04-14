
#include <stdint.h>

#define GC_white (0 << 8)
#define GC_black (1 << 8)

extern void gc(int32_t);

/*
#define Color_hd(hd) (((hd) & GC_black))
#define Color_hp(hp) (Color_hd (Hd_hp (hp)))
#define Color_val(val) (Color_hd (Hd_val (val)))
*/

#define Is_white_hd(hd) (Color_hd (hd) == GC_white)
#define Is_black_hd(hd) (Color_hd (hd) == GC_black)

#define Whitehd_hd(hd) (((hd)  & ~GC_black)/*| GC_white*/)
#define Blackhd_hd(hd) (((hd)/*& ~GC_black*/)| GC_black)

/* voir  [values.h] et prendre 1 bit de couleur. */
#define Make_header(wosize, tag)                                       \
      (/*Assert ((wosize) <= Max_wosize),*/                                   \
       ((header_t) (((header_t) (wosize) << 10)                               \
                    + (GC_white)					\
                    + (tag_t) (tag)))                                         \
      )

/* est-ce vraiment utile ? */
#define Max_gc_wosize 256

/* macro générale d'allocation d'un bloc */

#define Alloc_small(result, wosize, tag) do{    DEBUGassert ((wosize) >= 1);  \
                                          DEBUGassert ((tag_t) (tag) < 256);  \
                                 DEBUGassert ((wosize) <= Max_gc_wosize);     \
  if (heap_ptr + wosize > heap_end){                                          \
    gc(wosize);						                      \
  }                                                                           \
  Hd_hp (heap_ptr) = Make_header ((wosize), (tag));                           \ 
  (result) =  Val_hp(heap_ptr);                                               \
  heap_ptr += wosize; 						             \           
  DEBUGclear ((result), (wosize));                                           \
}while(0)


