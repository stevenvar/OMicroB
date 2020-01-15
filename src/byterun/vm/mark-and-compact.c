#include <string.h>
#include "values.h"
#include "fail.h"
#include "gc.h"
#include "debug.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Initalization of heap pointers */

value *heap_ptr;
value *heap_end;

void gc_init(void) {
  heap_ptr = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE;
  heap_end = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE + OCAML_DYNAMIC_HEAP_WOSIZE;
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* GC: marking algorithm */

#define UNIQUE_MARK (Val_dynamic_block(ocaml_ram_heap) | Color_black)

/* Mark a block as alive (with a Black color mark) and          */
/* all blocks reachable from it, directy or indirectly.         */
/* The parameter p is a pointer to the last field of the block. */
/* The entire header of the block should be the value heap+2.   */
static void mark_block(value *p) {
  value v = *p;
  while (v != UNIQUE_MARK) {                                  /* Did go back to the root block header?   */
    if (Is_unaligned_block(v)) {                              /* Did go back to another block header?    */
      value *old_p = Ram_block_val(v ^ Color_black);
      header_t old_h = *old_p;
      if (Color_hd(old_h) == Color_red) {
        value *inf_p = p + Wosize_hd(old_h);                  /* Pointer to infix header location        */
        *p = *inf_p ^ Color_red;                              /* Restore the (blacken) header of block   */
        *inf_p = old_h;                                       /* Restore the infix header                */
        *old_p = Val_dynamic_block(inf_p + 1);                /* Restore the forward pointer             */
        p = old_p - 1;                                        /* Return to the backward block            */
      } else {
        *p = old_h;                                           /* Restore the header                      */
        *old_p = Val_dynamic_block(p + 1);                    /* Restore the forward pointer             */
        p = old_p - 1;                                        /* Return to the backward block            */
      }

    } else if (Is_block_in_dynamic_heap(v)) {
      header_t h = Ram_hd_val(v);
      tag_t tag = Tag_hd(h);
      if (tag == Infix_tag) {                                 /* Is infix?                               */
        value *pstart = Ram_block_val(v) - Wosize_hd(h) - 1;  /* Pointer to the beginning of the block   */
        header_t hstart = *pstart;                            /* Main header of the block                */
        if (Color_hd(hstart) == Color_white) {                /* Not already marked as alive?            */
          *p = h;                                             /* Store the (red) infix header            */
          Ram_hd_val(v) = hstart | Color_brown;               /* Store the (brown) header of block       */
          *pstart = Val_dynamic_block(p) | Color_black;       /* Store the (blacken) back pointer        */
          p = pstart + Wosize_hd(hstart);                     /* Jump to the end of the block            */
        } else {
          p --;                                               /* Already marked -> go back one field     */
        }
      } else if (Color_hd(h) == Color_white) {                /* Is this block non-already scanned?      */
        if (tag < No_scan_tag) {                              /* If this block is scannable              */
          *p = h | Color_black;                               /* Store the (blacken) header              */
          Ram_hd_val(v) = Val_dynamic_block(p) | Color_black; /* Store the (blacken) backward pointer    */
          p = &Ram_field(v, Wosize_hd(h) - 1);                /* Go to the forward block                 */
        } else {                                              /* Else if this block is no-scannable      */
          Ram_hd_val(v) = h | Color_black;                    /* Blacken the non-scannable block         */
          p --;                                               /* Go back one field in the current block  */
        }
      } else {
        p --;                                                 /* Go back one field in the current block  */
      }

    } else {
      p --;                                                   /* Go back one field in the current block  */
    }

    v = *p;
  }
}

/***/

/* Mark as alive all blocks reachable (directly or indirectly) from the given root. */
static void mark_root(value v) {
  if (Is_block_in_dynamic_heap(v)) {
    header_t h = Ram_hd_val(v);
    if (Color_hd(h) == Color_white) {                   /* Is this block not already scanned?                        */
      if (Tag_hd(h) < No_scan_tag) {                    /* Is this block scannable?                                  */
        Ram_hd_val(v) = UNIQUE_MARK;                    /* Set root header to a unique unaligned value               */
        mark_block(&Ram_field(v, Wosize_hd(h) - 1));
      }
      Ram_hd_val(v) = h | Color_black;                  /* Restore the (blacken) root header                         */
    }
  }
}

/***/

/* Mark all living blocks reachable from roots. */
static void mark_roots(void) {
  value *p, *end;

  mark_root(acc);
  mark_root(env);

  end = ocaml_stack + OCAML_STACK_WOSIZE;
  for (p = sp; p < end; p ++) {
    mark_root(*p);
  }

  end = ocaml_ram_global_data + OCAML_RAM_GLOBDATA_NUMBER;
  for (p = ocaml_ram_global_data; p < end; p ++) {
    mark_root(*p);
  }

  p = ocaml_ram_heap;
  end = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE;
  while (p < end) {
    header_t h = *p;
    mlsize_t sz = Wosize_hd(h);
    if (Tag_hd(h) < No_scan_tag) {
      p ++;
      while (sz > 0) {
        mark_root(*p);
        p ++;
        sz --;
      }
    } else {
      p += sz + 1;
    }
  }
}

/******************************************************************************/
/* GC: compaction routines */

/* Set tag=String and color=White to all dead block headers. */
/* Merge consecutive dead blocks in a unique White string.   */
/* Switch color of living blocks to White.                   */
static void wipe_dead_blocks() {
  value *p = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE;
  header_t h = *p;
  while (p < heap_ptr) {                           /* Loop over the whole heap in block order */
    if (Color_hd(h) == Color_white) {              /* Is this block dead?                     */
      mlsize_t size = Wosize_hd(h);                /* Stringify, whiten and merge dead blocks */
      value *start = p;
      p += size + 1;
      while (p < heap_ptr && Color_hd((h = *p)) == Color_white) {
        p += Wosize_hd(h) + 1;                     /* Skip the dead block                     */
        if ((mlsize_t) (p - start - 1) >=          /* Check size overflow                     */
            (mlsize_t) 1 << Hd_size_bitcnt) {
          p -= Wosize_hd(h) + 1;                   /* Backtrack one block                     */
          break;
        }
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
static void reverse_pointer(value *p) {
  value v = *p;
  if (Is_block_in_dynamic_heap(v)) {         /* Is v point to heap?    */
    /* printf("Reverse %p (value = 0x%08x ) ", v , Val_dynamic_block(p)); */
    *p = Ram_hd_val(v) | Color_red;          /* Yes -> reverse pointer */
    /* printf("with %p \n", Ram_hd_val(v) ); */
    Ram_hd_val(v) = Val_dynamic_block(p) | Color_black;
  }
}

/***/

/* Reverse all roots that are pointers to blocks. */
static void reverse_root_pointers(void) {
  value *p, *end;

  reverse_pointer(&acc);
  reverse_pointer(&env);

  end = ocaml_stack + OCAML_STACK_WOSIZE;
  for (p = sp; p < end; p ++) {
    reverse_pointer(p);
  }

  end = ocaml_ram_global_data + OCAML_RAM_GLOBDATA_NUMBER;
  for (p = ocaml_ram_global_data; p < end; p ++) {
    reverse_pointer(p);
  }

  p = ocaml_ram_heap;
  end = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE;
  while (p < end) {
    header_t h = *p;
    mlsize_t sz = Wosize_hd(h);
    if (Tag_hd(h) < No_scan_tag) {
      p ++;
      while (sz > 0) {
        reverse_pointer(p);
        p ++;
        sz --;
      }
    } else {
      p += sz + 1;
    }
  }
}

/***/

/* Reverse all fields of living blocks that are pointers to other blocks. */
static void reverse_heap_pointers(void) {
  value *p = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE;
  while (p < heap_ptr) {                                 /* Loop over the whole heap in block order                   */
    header_t h = *p;
    while ((Color_hd(h) & Color_black) == Color_black) { /* Skip the reverse pointer list to find the original header */
      h = *Ram_block_val(h & ~Color_brown);
    }
    if (Tag_hd(h) < No_scan_tag) {                       /* Should this block be scanned?                             */
      value *end = p + Wosize_hd(h) + 1;
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
  value *p = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE;
  value *alloc_pos = p;                                       /* Initialize a "virtual allocation pointer"                                       */
  while (p < heap_ptr) {                                      /* Loop over the whole heap in block order                                         */
    value v = *p;
    /* printf("Checking %p\n",p); */
    if (Color_hd(v) == Color_black) {                         /* Does the header contain a reversed pointer (equivalent to "is the block alive")? */
      do {                                                    /* Loop over the reversed pointer list                                             */
        v ^= Color_black;
        value next = *Ram_block_val(v) & ~Color_red;
        *Ram_block_val(v) = Val_dynamic_block(alloc_pos + 1); /* Write the pointer to the destination of the block                               */
        v = next;
      } while (Color_hd(v) == Color_black);
      *p = v;                                                 /* Restore the White original header                                               */
      mlsize_t size = Wosize_hd(v) + 1;
      if (Tag_hd(v) == Closure_tag) {                         /* Is this block a closure?                                                        */
        /* printf("is closure !\n"); */
        value *end = p + size;
        mlsize_t i = 2;
        for (p ++; p < end; p ++, i ++) {                     /* Loop over fields and restore pointers to destination infix sub-block            */
          value v = *p;
          if (Color_hd(v) == Color_black) {                   /* Is it an infix location?                                                           */
            do {                                              /* Loop over the reversed pointer list                                             */
              v ^= Color_black;                               /* Restore pointers to this infix block                                            */
              value next = *Ram_block_val(v) & ~Color_red;
              *Ram_block_val(v) = Val_dynamic_block(alloc_pos + i);
              v = next;
            } while (Color_hd(v) == Color_black);
            *p = v | Color_red;                               /* Restore the Red original infix header                                           */
          }
        }
      } else {
        p += size;                                            /* Jump to the next block                                                          */
      }
      alloc_pos += size;                                      /* Update the virtual allocation pointer                                           */
    } else {
      *p = v | Color_black;
      p += Wosize_hd(v) + 1;                                  /* Jump to the next block                                                          */
    }
  }
}

/***/

/* Compact living blocks to the begining of the heap. */
static void compact_blocks(void) {
  value *p = ocaml_ram_heap + OCAML_STATIC_HEAP_WOSIZE;
  value *alloc_pos = p;                             /* Initialize an "allocation pointer"      */
  while (p < heap_ptr) {                            /* Loop over the whole heap in block order */
    header_t h = *p;
    mlsize_t size = Wosize_hd(h) + 1;
    if (Color_hd(h) == Color_white) {               /* Is this block alive?                    */
      memmove(alloc_pos, p, size * sizeof(value));  /* Move block                              */
      alloc_pos += size;                            /* Update the allocation pointer           */
    }
    p += size;                                      /* Jump to the next block                  */
  }
  heap_ptr = alloc_pos;                             /* Update heap_ptr                         */
}

/******************************************************************************/
/* GC: main function */

void gc(void) {
  gc_count ++;
#if DEBUG >= 3
  printf("#################### MARK & COMPACT ####################\n");
  print_dynamic_heap();
#endif

#if DEBUG >= 3 // DUMP STACK AND HEAP
  printf("&acc = %p\n", &acc);
  printf("&env = %p\n", &env);
  printf("acc = "); print_value(acc);
  printf("env = "); print_value(env);
  printf("\n");
  print_ram_global_data();
  print_dynamic_heap();
  print_static_heap();
  print_flash_heap();
  print_stack();
#endif
  mark_roots();
  wipe_dead_blocks();

#if DEBUG >= 3
  printf("#################### MARK AFTER WIPE ####################\n");
  print_dynamic_heap();
#endif


#if DEBUG >= 3 // DUMP STACK AND HEAP
  printf("MARK AFTER WIPE \n");
  print_dynamic_heap();
#endif


  reverse_root_pointers();


#if DEBUG >= 3
  printf("#################### MARK BEFORE REVERSE HEAP ####################\n");
  print_dynamic_heap();
#endif

  reverse_heap_pointers();

#if DEBUG >= 3
  printf("#################### MARK BEFORE UPDATE ####################\n");
  print_dynamic_heap();
#endif

  update_pointers();


#if DEBUG >= 3
  printf("#################### MARK BEFORE COMPACT ####################\n");
  print_dynamic_heap();
#endif

  compact_blocks();

#if DEBUG >= 3 // DUMP STACK AND HEAP
  printf("################### END OF MARK & COMPACT ####################\n");
  printf("&acc = %p\n", &acc);
  printf("&env = %p\n", &env);
  printf("acc = "); print_value(acc);
  printf("env = "); print_value(env);
  printf("\n");
  print_ram_global_data();
  print_dynamic_heap();
  print_static_heap();
  print_flash_heap();
  print_stack();
#endif
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
