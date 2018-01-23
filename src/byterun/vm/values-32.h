/*
  Version 32 bits

  Codage des valeurs par du Nan boxing 32 bits avec :

          float : tels quels avec 1 seul Nan 0111 1111 1000 0000 0000 0000 0000 0000
           int  : 1 bit de marque à la fin
       pointeur : 1111 1111 1xxx xxxx xxxx xxxx xxxx xx00  (alignement)
pointeurs flash : tels quels mais limités à 2^31-2^23 en évitant ainsi d'avoir que des 1 dans la zone Nan

        int32_t : entiers sur 32 bits (stdint.h)
          value : la représentation uniforme d'une valeur ocaml
           bloc : une valeur allouée : 1 entête suivi de champs ou d'octets (alignée sur la taille des champs)
          champ : une valeur (value)

          en-tête : longueur (22bits) | marque (2 bits) | numéro de constructeur (8bits)

*/

#ifndef VALUES_32_H
#define VALUES_32_H

#include <stdint.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Types */

#ifndef TYPES
#define TYPES
typedef int32_t value;
typedef uint32_t uvalue;
typedef uint32_t mlsize_t;
typedef int32_t header_t;
typedef uint8_t tag_t;
typedef uint8_t color_t;
typedef uint8_t opcode_t;

#if OCAML_BYTECODE_BSIZE < 256
typedef uint8_t code_t;
#elif OCAML_BYTECODE_BSIZE < 65536
typedef uint16_t code_t;
#else
typedef uint32_t code_t;
#endif
#endif

extern value ocaml_heap[OCAML_HEAP_WOSIZE];

/******************************************************************************/
/* Value classification */

#define Is_int(x) (((x) & 1) != 0)
#define Is_block(x) (((value) (x) & 0x3) == 0 && (((uvalue) (x)) >> 23) == 0x1FF)
#define Is_in_heap(x) (Is_block(x) && (uintptr_t) (Block_val(x) - ocaml_heap) < OCAML_HEAP_WOSIZE)

/******************************************************************************/
/* Conversions */

#define Val_int(x) ((value) (((uvalue) (x) << 1) | 1))
#define Int_val(x) ((value) (x) >> 1)

#define Val_long(x) ((value) (((uvalue) (long) (x) << 1) | 1))
#define Long_val(x) ((long) ((value) (x) >> 1))

#ifdef __AVR__
#define Val_block(x) ((value) (intptr_t) (value *) (x) | (value) 0xFF800000)
#define Block_val(x) ((value *) (intptr_t) (value) (x))
#else
#define Val_block(x) ((value) ((char *) (x) - ((char *) ocaml_heap)) | (value) 0xFF800000)
#define Block_val(x) ((value *) ((char *) ocaml_heap + (((int32_t) (x) << 9) >> 9)))
#endif

#define Val_bool(x) Val_int((x) != 0)
#define Bool_val(x) Int_val(x)

/* #define Val_float(x) ((float) x != (float) x ? Val_nan : ((union { float f; value v; }) (float) (x)).v) */
/* #define Float_val(v) (((union { float f; value v; }) (value) (v)).f) */

#define Val_codeptr(x) Val_int(x)
#define Codeptr_val(x) Int_val(x)

/******************************************************************************/
/* Constants */

#define Val_false Val_int(0)
#define Val_true  Val_int(1)
#define Val_unit  Val_int(0)
#define Val_nan   0x7F800000

/******************************************************************************/
/* Blocks */

#define Field(val, i) (((value *) Block_val(val))[i])
#define String_val(val) ((char *) Block_val(val))
#define StringField(val, i) String_val(val)[i]

#define Hd_val(val) Field(val, -1)
#define Code_val(val) Field(val, 0)

#define Make_string_data(c3, c2, c1, c0) (((value) (c0) << 24) | ((value) (c1) << 16) | ((value) (c2) << 8) | ((value) (c3)))

#define Make_custom_data(b3, b2, b1, b0) Make_string_data(b3, b2, b1, b0)

#define Make_float(b3, b2, b1, b0) Make_string_data(b0, b1, b2, b3)

#define Bsize_wsize(sz) ((sz) << 2)
#define Wsize_bsize(sz) ((sz) >> 2)

#define Make_header(size, tag, color) ((value) ((((uvalue) (tag)) << 24) | (((uvalue) (size)) << 2) | ((uvalue) (color))))

#define Tag_hd(h) ((tag_t) ((header_t) (h) >> 24))
#define Wosize_hd(h) ((mlsize_t) (((header_t) (h) >> 2) & 0x3FFFFF))
#define Color_hd(h) ((color_t) ((header_t) (h) & 0x3))

#define Wosize_val(val) Wosize_hd(Hd_val(val))
#define Color_val(val) Color_hd(Hd_val(val))
#define Tag_val(val) Tag_hd(Hd_val(val))

#define Bosize_hd(h) Bsize_wsize(Wosize_hd(h))
#define Bosize_val(val) Bsize_wsize(Wosize_val(val))

                       /* Mark&Compact color descriptions: */
#define Color_white 0  /* At runtime: color of all blocks, after marking: color of dead blocks, after updating pointers: color of alive blocks */
#define Color_red   1  /* Color of infix headers at any time, even when moved at marking stage                                                 */
#define Color_black 2  /* After marking: color of alive blocks, after updating pointers: color of dead blocks                                  */
#define Color_brown 3  /* During marking stage: color of block headers moved at an infix location                                              */
                       /* (-: Red paint + Black paint -> Brown paint :-)                                                                       */

#define Val_double(x) (x)
#define Double_val(x) (x)

/******************************************************************************/
/* Tags */

#define Lazy_tag     246
#define Closure_tag  247
#define Object_tag   248
#define Infix_tag    249
#define Forward_tag  250
#define Abstract_tag 251
#define No_scan_tag  251
#define String_tag   252
#define Custom_tag   255

/* Object_tag 248 */
#define Class_val(val) Field(val, 0)
#define Oid_val(val) Int_val(Field(val, 1))

/* Infix_tag 249 */
#define Infix_offset_hd(hd) Bosize_hd(hd)
#define Infix_offset_val(v) Infix_offset_hd(Hd_val(v))

/* Forward_tag 250 */
#define Forward_val(v) Field(v, 0)

/* Custom_tag 255 */
#define Data_custom_val(v) ((void *) &Field(v, 1))

/******************************************************************************/
/* Custom operations */

extern void *int32_custom_operations;
extern void *int64_custom_operations;
extern void *nativeint_custom_operations;

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#endif
