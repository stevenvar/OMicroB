
#ifndef CAML_GC_H
#define CAML_GC_H

#include <stdint.h>

#define GC_white (0 << 8)
#define GC_black (1 << 8)


#define Color_hd(hd) (((hd) & GC_black))
#define Color_hp(hp) (Color_hd (Hd_hp (hp)))
#define Color_val(val) (Color_hd (Hd_val (val)))

#define Is_white_hd(hd) (Color_hd (hd) == GC_white)
#define Is_black_hd(hd) (Color_hd (hd) == GC_black)

#define Whitehd_hd(hd) (((hd)  & ~GC_black)/*| GC_white*/)
#define Blackhd_hd(hd) (((hd)/*& ~GC_black*/)| GC_black)

/* voir  [values.h] et prendre 1 bit de couleur. */
#define Make_header(wosize, tag, color)                                       \
      (/*Assert ((wosize) <= Max_wosize),*/                                   \
       ((header_t) (((header_t) (wosize) << 10)                               \
                    + (color)                                                 \
                    + (tag_t) (tag)))                                         \
      )

/* est-ce vraiment utile ? */
#define Max_gc_wosize 256

/* macro générale d'allocation d'un bloc */
#define Alloc_small(result, wosize, tag) do{    DEBUGassert ((wosize) >= 1);  \
                                          DEBUGassert ((tag_t) (tag) < 256); \
                                 DEBUGassert ((wosize) <= Max_gc_wosize);     \
   heap_ptr += Bhsize_wosize (wosize);                                        \
  if (heap_ptr > heap_end){                                                   \
    heap_ptr -= Bhsize_wosize (wosize);                                       \
    gc((int32_t)wosize);						\
    heap_ptr += Bhsize_wosize (wosize);                                       \
  }                                                                           \
  Hd_hp (heap_ptr) = Make_header ((wosize), (tag), GC_white);                 \
  (result) = Val_hp (heap_ptr);                                               \
  DEBUGclear ((result), (wosize));                                           \
}while(0)


#endif /* CAML_GC_H */
