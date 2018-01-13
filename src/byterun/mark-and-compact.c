#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <assert.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Some size definitions (testing purpose) */

#define HEAP_WOSIZE  1024
#define STACK_WOSIZE 1024

/******************************************************************************/
/* Basic types */

typedef int32_t val_t;
typedef uint8_t tag_t;
typedef uint32_t sz_t;
typedef uint8_t color_t;
typedef uint32_t header_t;

/******************************************************************************/
/* Block managment macros */

#define Block(p) ((val_t) (p))
#define Ptr(v) ((val_t *) (v))

#define Field(v, i) (Ptr(v)[i])
#define Header(v) (Field(v, -1))

#define Make_header(tag, size, color) ((((int32_t) (tag)) << 24) | (((int32_t) (size)) << 2) | ((int32_t) (color)))

#define Tag_header(h) ((tag_t) ((header_t) (h) >> 24))
#define Size_header(h) ((sz_t) (((header_t) (h) >> 2) & 0x3FFFFF))
#define Color_header(h) ((color_t) ((header_t) (h) & 0x3))

#define Tag_val(v) Tag_header(Header(v))
#define Size_val(v) Size_header(Header(v))
#define Color_val(v) Color_header(Header(v))

#define Val_int(n) ((val_t) ((n << 1) | 1))
#define Int_val(v) ((int) (v >> 1))

#define Is_int(v) ((v) & 1)
#define Is_ptr(v) (!((v) & 3))
#define Is_in_heap(v) (Is_ptr(v) && Ptr(v) >= heap && Ptr(v) < heap + HEAP_WOSIZE)

#define White 0  /* At runtime: color of all blocks, after marking: color of dead blocks, after updating pointers: color of alive blocks */
#define Red   1  /* Color of infix headers at any time, even when moved at marking stage                                                 */
#define Black 2  /* After marking: color of alive blocks, after updating pointers: color of dead blocks                                  */
#define Brown 3  /* During marking stage: color of block headers moved at an infix location                                              */
                 /* (-: Red paint + Black paint -> Brown paint :-)                                                                       */

#define Closure_tag 247
#define Infix_tag   249
#define No_scan_tag 251
#define String_tag  252

/******************************************************************************/
/* Heap and stack declaration */

val_t heap[HEAP_WOSIZE];
val_t *heap_pos = heap;

val_t stack[STACK_WOSIZE];
val_t *stack_pos = stack;

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Printing tools (testing purpose) */

static void pprint_value(val_t v) {
  if (Is_int(v)) {
    printf("%d", Int_val(v));
  } else if (Is_in_heap(v)) {
    printf("@%d", Ptr(v) - heap);
  } else {
    printf("!0x%X", v);
  }
}

/***/

static void pprint_stack(void) {
  val_t *p;
  printf("==== STACK ====\n");
  for (p = stack; p < stack_pos; p ++) {
    printf("stack[%d] = ", p - stack);
    pprint_value(*p);
    printf("\n");
  }
  printf("\n");
}

/***/

static void pprint_heap(void) {
  val_t *p = heap;
  printf("==== HEAP ====\n");
  while (p < heap_pos) {
    header_t h = *p;
    int i;
    const char *color =
      Color_header(h) == White ? "White" :
      Color_header(h) == Red   ? "Red  " :
      Color_header(h) == Black ? "Black" :
      Color_header(h) == Brown ? "Brown" : "?????";
    printf("@%-4d tag:%-4d size:%-2d color:%s  |  ", p - heap + 1, Tag_header(h), Size_header(h), color);
    if (Tag_header(h) == String_tag) {
      for (i = 0; i < Size_header(h) * sizeof(val_t); i ++) {
        if (i > 0) printf(" ");
        printf("%02X", ((unsigned char *) p)[i + sizeof(val_t)]);
      }
    } else {
      for (i = 0; i < Size_header(h); i ++) {
        if (i > 0) printf(", ");
        pprint_value(Field(p + 1, i));
      }
    }
    printf("\n");
    p = p + Size_header(h) + 1;
  }
  printf("\n");
}

/***/

void pprint(void) {
  pprint_stack();
  pprint_heap();
  printf("\n");
}

/******************************************************************************/
/* Dumping tools (debugging purpose) */

static void dump_stack(void) {
  val_t *p;
  printf("==== STACK ====\n");
  for (p = stack; p < stack_pos; p ++) {
    printf("stack[0] = %08X\n", *p);
  }
  printf("\n");
}

/***/

static void dump_heap(void) {
  val_t *p;
  printf("==== HEAP ====\n");
  for (p = heap; p < heap_pos; p ++) {
    if (((p - heap) & 7) == 0) {
      if (p > heap) printf("\n");
      printf("[%08X]   ", (unsigned int) p);
    } else {
      printf(" ");
    }
    printf("%08X", *p);
  }
  printf("\n");
}

/***/

void dump(void) {
  dump_stack();
  dump_heap();
  printf("\n");
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
  while (v != Black) {                               /* Did go back to the root block header?   */
    if (Color_header(v) == Black) {                  /* Did go back to another block header?    */
      val_t *old_p = Ptr(v ^ Black);
      header_t old_h = *old_p;
      if (Color_header(old_h) == Red) {
        val_t *inf_p = p + Size_header(old_h);       /* Pointer to infix header location        */
        *p = *inf_p ^ Red;                           /* Restore the (blacken) header of block   */
        *inf_p = old_h;                              /* Restore the infix header                */
        *old_p = Block(inf_p + 1);                   /* Restore the forward pointer             */
        p = old_p - 1;                               /* Return to the backward block            */
      } else {
        *p = old_h;                                  /* Restore the header                      */
        *old_p = Block(p + 1);                       /* Restore the forward pointer             */
        p = old_p - 1;                               /* Return to the backward block            */
      }
      
    } else if (Is_in_heap(v)) {
      header_t h = Header(v);
      tag_t tag = Tag_header(h);
      if (tag == Infix_tag) {                        /* Is infix?                               */
        val_t *pstart = Ptr(v) - Size_header(h) - 1; /* Pointer to the beginning of the block   */
        header_t hstart = *pstart;                   /* Main header of the block                */
        if (Color_header(hstart) == White) {         /* Not already marked as alive?            */
          *p = h;                                    /* Store the (red) infix header            */
          Header(v) = hstart | Brown;                /* Store the (brown) header of block       */
          *pstart = Block(p) | Black;                /* Store the (blacken) back pointer        */
          p = pstart + Size_header(hstart);          /* Jump to the end of the block            */
        } else {
          p --;                                      /* Already marked -> go back one field     */
        }
      } else if (tag < No_scan_tag &&                /* Is this block scannable?                */
                 Color_header(h) == White) {         /* Is this block non-already scanned?      */
        *p = h | Black;                              /* Store the (blacken) header              */
        Header(v) = Block(p) | Black;                /* Store the (blacken) backward pointer    */
        p = &Field(v, Size_header(h) - 1);           /* Go to the forward block                 */
      } else {
        p --;                                        /* Go back one field in the current block  */
      }

    } else {
      p --;                                          /* Go back one field in the current block  */
    }

    v = *p;
  }
}

/***/

/* Mark as alive all blocks reachable (directly or indirectly) from the given root. */
static void mark_root(val_t v) {
  if (Is_in_heap(v)) {
    header_t h = Header(v);
    if (Color_header(h) == White) {        /* Is this block not already scanned?                        */
      if (Tag_header(h) < No_scan_tag) {   /* Is this block scannable?                                  */
        Header(v) = Black;                 /* Set root header to a unique unaligned value               */
        mark_block(&Field(v, Size_header(h) - 1));
      }
      Header(v) = h | Black;               /* Restore the (blacken) root header                         */
    }
  }
}

/***/

/* Mark all living blocks reachable from roots. */
static void mark_roots(void) {
  val_t *p;
  for (p = stack; p < stack_pos; p ++) {
    mark_root(*p);
  }
}

/******************************************************************************/
/* GC: compaction routines */

/* Set tag=String and color=White to all dead block headers. */
/* Merge consecutive dead blocks in a unique White string.   */
/* Switch color of living blocks to White.                   */
static void wipe_dead_blocks() {
  val_t *p = heap;
  header_t h = *p;
  while (p < heap_pos) {                 /* Loop over the whole heap in block order */
    if (Color_header(h) == White) {      /* Is this block dead?                     */
      sz_t size = Size_header(h);        /* Stringify, whiten and merge dead blocks */
      val_t *start = p;
      p += size + 1;
      while (p < heap_pos && Color_header((h = *p)) == White) {
        p += Size_header(h) + 1;         /* Skip the dead block                     */
        if (p - start - 1 >= 1 << 22) {  /* Check size overflow                     */
          p -= Size_header(h) + 1;       /* Backtrack one block                     */
          break;
        }
      }
      *start = Make_header(String_tag, p - start - 1, White);
    } else {
      *p = h ^ Black;                    /* Switch color to White                   */
      p += Size_header(h) + 1;           /* Jump to the next block                  */
      h = *p;
    }
  }
}

/***/

/* If (*p) is a pointer to a block, permute (*p) and (Header_val(*p)) */
/* Redden the moved header and blacken the written header.            */
static void reverse_pointer(val_t *p) {
  val_t v = *p;
  if (Is_in_heap(v)) {            /* Is v point to heap?    */
    *p = Header(v) | Red;         /* Yes -> reverse pointer */
    Header(v) = Block(p) | Black;
  }
}

/***/

/* Reverse all roots that are pointers to blocks. */
static void reverse_root_pointers(void) {
  val_t *p;
  for (p = stack; p < stack_pos; p ++) {  /* Loop over roots and reverse pointers */
    reverse_pointer(p);
  }
}

/***/

/* Reverse all fields of living blocks that are pointers to other blocks. */
static void reverse_heap_pointers(void) {
  val_t *p = heap;
  while (p < heap_pos) {                         /* Loop over the whole heap in block order                   */
    header_t h = *p;
    while ((Color_header(h) & Black) == Black) { /* Skip the reverse pointer list to find the original header */
      h = *Ptr(h & ~Brown);
    }
    if (Tag_header(h) < No_scan_tag) {           /* Should this block be scanned?                             */
      val_t *end = p + Size_header(h) + 1;
      for (p ++; p < end; p ++) {                /* Yes -> loop over the block in field order                 */
        reverse_pointer(p);                      /* Reverse field (if pointer to heap)                        */
      }
    } else {
      p += Size_header(h) + 1;                   /* No -> jump to the next block                              */
    }
  }
}

/***/

/* Virtually allocate blocks.                         */
/* Update fields of living blocks with new addresses. */
/* Update by the way roots with new addresses.        */
/* Restore headers of living blocks.                  */
static void update_pointers(void) {
  val_t *p = heap;
  val_t *alloc_pos = heap;                      /* Initialize a "virtual allocation pointer"                                       */
  while (p < heap_pos) {                        /* Loop over the whole heap in block order                                         */
    val_t v = *p;
    if (Color_header(v) == Black) {             /* Is the header contains a reversed pointer (equivalent to "is the block alive")? */
      do {                                      /* Loop over the reversed pointer list                                             */
        v ^= Black;
        val_t next = *Ptr(v) & ~Red;
        *Ptr(v) = Block(alloc_pos + 1);         /* Write the pointer to the destination of the block                               */
        v = next;
      } while (Color_header(v) == Black);
      *p = v;                                   /* Restore the White original header                                               */
      sz_t size = Size_header(v) + 1;
      if (Tag_header(v) == Closure_tag) {       /* Is this block a closure?                                                        */
        val_t *end = p + size;
        sz_t i = 2;
        for (p ++; p < end; p ++, i ++) {       /* Loop over fields and restore pointers to destination infix sub-block            */
          val_t v = *p;
          if (Color_header(v) == Black) {       /* Is an infix location?                                                           */
            do {                                /* Loop over the reversed pointer list                                             */
              v ^= Black;                       /* Restore pointers to this infix block                                            */
              val_t next = *Ptr(v) & ~Red;
              *Ptr(v) = Block(alloc_pos + i);
              v = next;
            } while (Color_header(v) == Black);
            *p = v | Red;                       /* Restore the Red original infix header                                           */
          }
        }
      } else {
        p += size;                              /* Jump to the next block                                                          */
      }
      alloc_pos += size;                        /* Update the virtual allocation pointer                                           */
    } else {
      *p = v | Black;
      p += Size_header(v) + 1;                  /* Jump to the next block                                                          */
    }
  }
}

/***/

/* Compact living blocks to the begining of the heap. */
static void compact_blocks(void) {
  val_t *p = heap;
  val_t *alloc_pos = heap;                          /* Initialize an "allocation pointer"      */
  while (p < heap_pos) {                            /* Loop over the whole heap in block order */
    header_t h = *p;
    sz_t size = Size_header(h) + 1;
    if (Color_header(h) == White) {                 /* Is this block alive?                    */
      memmove(alloc_pos, p, size * sizeof(val_t));  /* Move block                              */
      alloc_pos += size;                            /* Update the allocation pointer           */
    }
    p += size;                                      /* Jump to the next block                  */
  }
  heap_pos = alloc_pos;                             /* Update heap_pos                         */
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

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
