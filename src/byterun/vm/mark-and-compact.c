#include <string.h>
#include "values.h"
#include "fail.h"
#include "gc.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Initalization of heap pointers */

val_t *heap_ptr;
val_t *heap_end;

void gc_init(void) {
  heap_ptr = ocaml_heap + OCAML_HEAP_INITIAL_WOSIZE;
  heap_end = ocaml_heap + OCAML_HEAP_WOSIZE;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* GC: marking algorithm */

/* Mark a block as alive (with a Black color mark) and          */
/* all blocks reachable from it, directy or indirectly.         */
/* The parameter p is a pointer to the last field of the block. */
/* The entire header of the block should be the value heap+2.   */
static void mark_block(val_t *p) {
  val_t v = *p;
  while (v != Color_black) {                           /* Did go back to the root block header?   */
    if (Color_hd(v) == Color_black) {                  /* Did go back to another block header?    */
      val_t *old_p = Block_val(v ^ Color_black);
      header_t old_h = *old_p;
      if (Color_hd(old_h) == Color_red) {
        val_t *inf_p = p + Wosize_hd(old_h);           /* Pointer to infix header location        */
        *p = *inf_p ^ Color_red;                       /* Restore the (blacken) header of block   */
        *inf_p = old_h;                                /* Restore the infix header                */
        *old_p = Val_block(inf_p + 1);                 /* Restore the forward pointer             */
        p = old_p - 1;                                 /* Return to the backward block            */
      } else {
        *p = old_h;                                    /* Restore the header                      */
        *old_p = Val_block(p + 1);                     /* Restore the forward pointer             */
        p = old_p - 1;                                 /* Return to the backward block            */
      }
      
    } else if (Is_in_heap(v)) {
      header_t h = Hd_val(v);
      tag_t tag = Tag_hd(h);
      if (tag == Infix_tag) {                          /* Is infix?                               */
        val_t *pstart = Block_val(v)-Wosize_hd(h)-1;   /* Pointer to the beginning of the block   */
        header_t hstart = *pstart;                     /* Main header of the block                */
        if (Color_hd(hstart) == Color_white) {         /* Not already marked as alive?            */
          *p = h;                                      /* Store the (red) infix header            */
          Hd_val(v) = hstart | Color_brown;            /* Store the (brown) header of block       */
          *pstart = Val_block(p) | Color_black;        /* Store the (blacken) back pointer        */
          p = pstart + Wosize_hd(hstart);              /* Jump to the end of the block            */
        } else {
          p --;                                        /* Already marked -> go back one field     */
        }
      } else if (tag < No_scan_tag &&                  /* Is this block scannable?                */
                 Color_hd(h) == Color_white) {         /* Is this block non-already scanned?      */
        *p = h | Color_black;                          /* Store the (blacken) header              */
        Hd_val(v) = Val_block(p) | Color_black;        /* Store the (blacken) backward pointer    */
        p = &Field(v, Wosize_hd(h) - 1);               /* Go to the forward block                 */
      } else {
        p --;                                          /* Go back one field in the current block  */
      }

    } else {
      p --;                                            /* Go back one field in the current block  */
    }

    v = *p;
  }
}

/***/

/* Mark as alive all blocks reachable (directly or indirectly) from the given root. */
static void mark_root(val_t v) {
  if (Is_in_heap(v)) {
    header_t h = Hd_val(v);
    if (Color_hd(h) == Color_white) {                   /* Is this block not already scanned?                        */
      if (Tag_hd(h) < No_scan_tag) {                    /* Is this block scannable?                                  */
        Hd_val(v) = Color_black;                        /* Set root header to a unique unaligned value               */
        mark_block(&Field(v, Wosize_hd(h) - 1));
      }
      Hd_val(v) = h | Color_black;                      /* Restore the (blacken) root header                         */
    }
  }
}

/***/

/* Mark all living blocks reachable from roots. */
static void mark_roots(void) {
  val_t *p, *end;
  mark_root(acc);
  end = ocaml_stack + OCAML_STACK_WOSIZE;
  for (p = sp; p < end; p ++) {
    mark_root(*p);
  }
  end = ocaml_global_data + OCAML_GLOBDATA_NUMBER;
  for (p = ocaml_global_data; p < end; p ++) {
    mark_root(*p);
  }
}

/******************************************************************************/
/* GC: compaction routines */

/* Set tag=String and color=White to all dead block headers. */
/* Merge consecutive dead blocks in a unique White string.   */
/* Switch color of living blocks to White.                   */
static void wipe_dead_blocks() {
  val_t *p = ocaml_heap;
  header_t h = *p;
  while (p < heap_ptr) {                           /* Loop over the whole heap in block order */
    if (Color_hd(h) == Color_white) {              /* Is this block dead?                     */
      mlsize_t size = Wosize_hd(h);                /* Stringify, whiten and merge dead blocks */
      val_t *start = p;
      p += size + 1;
      while (p < heap_ptr && Color_hd((h = *p)) == Color_white) {
        p += Wosize_hd(h) + 1;                     /* Skip the dead block                     */
      }
      *start = Make_header(p - start - 1, String_tag, Color_white);
    } else {
      *p = h ^ Color_black;                        /* Switch color to White                   */
      p += Wosize_hd(h) + 1;                       /* Jump to the next block                  */
      h = *p;
    }
  }
}

/***/

/* If (*p) is a pointer to a block, permute (*p) and (Hd_val_val(*p)) */
/* Redden the moved header and blacken the written header.            */
static void reverse_pointer(val_t *p) {
  val_t v = *p;
  if (Is_in_heap(v)) {                       /* Is v point to heap?    */
    *p = Hd_val(v) | Color_red;              /* Yes -> reverse pointer */
    Hd_val(v) = Val_block(p) | Color_black;
  }
}

/***/

/* Reverse all roots that are pointers to blocks. */
static void reverse_root_pointers(void) {
  val_t *p, *end;
  reverse_pointer(&acc);
  end = ocaml_stack + OCAML_STACK_WOSIZE;
  for (p = sp; p < end; p ++) {
    reverse_pointer(p);
  }
  end = ocaml_global_data + OCAML_GLOBDATA_NUMBER;
  for (p = ocaml_global_data; p < end; p ++) {
    reverse_pointer(p);
  }
}

/***/

/* Reverse all fields of living blocks that are pointers to other blocks. */
static void reverse_heap_pointers(void) {
  val_t *p = ocaml_heap;
  while (p < heap_ptr) {                                 /* Loop over the whole heap in block order                   */
    header_t h = *p;
    while ((Color_hd(h) & Color_black) == Color_black) { /* Skip the reverse pointer list to find the original header */
      h = *Block_val(h & ~Color_brown);
    }
    if (Tag_hd(h) < No_scan_tag) {                       /* Should this block be scanned?                             */
      val_t *end = p + Wosize_hd(h) + 1;
      for (p ++; p < end; p ++) {                        /* Yes -> loop over the block in field order                 */
        reverse_pointer(p);                              /* Reverse field (if pointer to heap)                        */
      }
    } else {
      p += Wosize_hd(h) + 1;                             /* No -> jump to the next block                              */
    }
  }
}

/***/

/* Virtually allocate blocks.                         */
/* Update fields of living blocks with new addresses. */
/* Update by the way roots with new addresses.        */
/* Restore headers of living blocks.                  */
static void update_pointers(void) {
  val_t *p = ocaml_heap;
  val_t *alloc_pos = ocaml_heap;                  /* Initialize a "virtual allocation pointer"                                       */
  while (p < heap_ptr) {                          /* Loop over the whole heap in block order                                         */
    val_t v = *p;
    if (Color_hd(v) == Color_black) {             /* Is the header contains a reversed pointer (equivalent to "is the block alive")? */
      do {                                        /* Loop over the reversed pointer list                                             */
        v ^= Color_black;
        val_t next = *Block_val(v) & ~Color_red;
        *Block_val(v) = Val_block(alloc_pos + 1); /* Write the pointer to the destination of the block                               */
        v = next;
      } while (Color_hd(v) == Color_black);
      *p = v;                                     /* Restore the White original header                                               */
      mlsize_t size = Wosize_hd(v) + 1;
      if (Tag_hd(v) == Closure_tag) {             /* Is this block a closure?                                                        */
        val_t *end = p + size;
        mlsize_t i = 2;
        for (p ++; p < end; p ++, i ++) {         /* Loop over fields and restore pointers to destination infix sub-block            */
          val_t v = *p;
          if (Color_hd(v) == Color_black) {       /* Is an infix location?                                                           */
            do {                                  /* Loop over the reversed pointer list                                             */
              v ^= Color_black;                   /* Restore pointers to this infix block                                            */
              val_t next = *Block_val(v) & ~Color_red;
              *Block_val(v) = Val_block(alloc_pos + i);
              v = next;
            } while (Color_hd(v) == Color_black);
            *p = v | Color_red;                   /* Restore the Red original infix header                                           */
          }
        }
      } else {
        p += size;                                /* Jump to the next block                                                          */
      }
      alloc_pos += size;                          /* Update the virtual allocation pointer                                           */
    } else {
      *p = v | Color_black;
      p += Wosize_hd(v) + 1;                      /* Jump to the next block                                                          */
    }
  }
}

/***/

/* Compact living blocks to the begining of the heap. */
static void compact_blocks(void) {
  val_t *p = ocaml_heap;
  val_t *alloc_pos = ocaml_heap;                    /* Initialize an "allocation pointer"      */
  while (p < heap_ptr) {                            /* Loop over the whole heap in block order */
    header_t h = *p;
    mlsize_t size = Wosize_hd(h) + 1;
    if (Color_hd(h) == Color_white) {               /* Is this block alive?                    */
      memmove(alloc_pos, p, size * sizeof(val_t));  /* Move block                              */
      alloc_pos += size;                            /* Update the allocation pointer           */
    }
    p += size;                                      /* Jump to the next block                  */
  }
  heap_ptr = alloc_pos;                             /* Update heap_ptr                         */
}

/******************************************************************************/
/* GC: main function */

void mark_and_compact(void) {
  mark_roots();
  wipe_dead_blocks();
  reverse_root_pointers();
  reverse_heap_pointers();
  update_pointers();
  compact_blocks();
}

void gc(mlsize_t wosize) {
#if defined(__PC__) && defined(DEBUG)
  printf("#################### MARK & COMPACT ####################\n");
#endif
  mark_and_compact();
  if (heap_ptr + (wosize + 1) > heap_end) {
    #ifdef __PC__
    printf("HEAP OVERFLOW\n");
    #endif 
    caml_out_of_memory();
  }
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
