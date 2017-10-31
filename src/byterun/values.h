#include <stdint.h>

#ifdef __AVR__
#include <avr/pgmspace.h>
#else
#define PROGMEM
#endif

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#if OCAML_VIRTUAL_ARCH == 16

/*
  Version 16 bits
*/


/******************************************************************************/


/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#elif OCAML_VIRTUAL_ARCH == 32  || !defined(OCAML_VIRTUAL_ARCH)

/*
  Version 32 bits

  Codage des valeurs par du Nan boxing 32 bits avec :

          float : tels quels avec 1 seul Nan 0111 1111 1100 0000 0000 0000 0000 0000
           int  : 1 bit de marque à la fin
       pointeur : 1111 1111 11xx xxxx xxxx xxxx xxxx xx00  (alignement)
pointeurs flash : tels quels mais limités à 2^31-2^22 en évitant ainsi d'avoir que des 1 dans la zone Nan

        int32_t : entiers sur 32 bits (stdint.h)
          val_t : la représentation uniforme d'une valeur ocaml
           bloc : une valeur allouée : 1 entête suivi de champs ou d'octets (alignée sur la taille des champs)
          champ : une valeur (val_t)

          en-tête : longueur (22bits) | marque (2 bits) | numéro de constructeur (8bits)

*/

/******************************************************************************/
/* Types */

#ifndef TYPES
#define TYPES
typedef int32_t val_t;
typedef uint32_t uval_t;
typedef uint32_t mlsize_t;
typedef int32_t header_t;
typedef uint8_t tag_t;
typedef uint8_t opcode_t;
/* for floats  */
typedef union alpha{
  val_t v;
  float f;
} alpha;


#if OCAML_BYTECODE_BSIZE < 256
typedef uint8_t code_t;
#elif OCAML_BYTECODE_BSIZE < 65536
typedef uint16_t code_t;
#else
typedef uint32_t code_t;
#endif
#endif


/******************************************************************************/
/* Value classification */

#define Is_int(x) (((x) & 1) != 0)
#define Is_block(x) (((val_t) (x) & 0x3) == 0 && (((uval_t) (x)) >> 22) == 0x3FF)

/******************************************************************************/
/* Conversions */

#define Val_int(x) (((val_t) (x) << 1) + 1)
#define Int_val(x) ((val_t) (x) >> 1)

#define Init_val_block(x) ((val_t) ( (x) << 2) | ((val_t) 0x3FF << 22))
/* #Define Val_block(x) ((val_t) ( ((x) - (int) ocaml_heap)) << 2 | ((val_t) 0x3FF << 22)) */
/* #define Block_val(x) (ocaml_heap + (((x) ^ ((val_t) 0x3FF << 22)) >> 2)) */
#define Val_block(x) (val_t)( (((val_t)x - (val_t)ocaml_heap) << 2) | (val_t)(0x3FF << 22) )
#define Block_val(x)  (val_t*)((intptr_t)ocaml_heap + ((intptr_t)(x ^ (0x3FF << 22) ) >> 2))


#define Val_bool(x) Val_int((x) != 0)
#define Bool_val(x) Int_val(x)

#define Val_float(x) ((float) x != (float) x ? Val_nan : ((union { float x; val_t n; }) (float) (x)).n)
#define Float_val(v) (((union { float x; val_t n; }) (val_t) (v)).x)

#define Val_codeptr(x) Val_int(x)
#define Codeptr_val(x) Int_val(x)

/******************************************************************************/
/* Constants */

#define Val_false Val_int(0)
#define Val_true  Val_int(1)
#define Val_unit  Val_int(0)
#define Val_nan   0x7FC00000

/******************************************************************************/
/* Blocks */

#define Field(val, i) (    ((val_t*)(Block_val(val)))   [i]  )
#define StringVal(val) ((char *) Block_val(val))
#define StringField(val, i) ( StringVal(val)[i])

#define Header(val) Field(val, -1)
#define Hd_val(val) Field(val, -1)
#define Code_val(val) Field(val, 0)

#define Make_string_data(c3, c2, c1, c0) \
  (((val_t) (c0) << 24) | ((val_t) (c1) << 16) | ((val_t) (c2) << 8) | ((val_t) (c3)))

#define Make_custom_data(b3, b2, b1, b0) Make_string_data(b3, b2, b1, b0)

/* #define Make_float(b3, b2, b1, b0) Make_string_data(b3, b2, b1, b0) */
#define Make_float(b3, b2, b1, b0) Make_string_data(b0, b1, b2, b3)

#define Make_header(wosize, tag) (((val_t) (wosize) << 10) | tag)
#define Bsize_wsize(sz) ((sz) * sizeof (val_t))
#define Wsize_bsize(sz) ((sz) / sizeof (val_t))
#define Wosize_val(val) (Header(val) >> 10)
#define Bosize_val(val) (Bsize_wsize (Wosize_val (val)))

#define Color_val(val) ((Header(val) >> 8) & 1)
#define Tag_val(val) (Header(val) & 0xFF)

#define Tag_hd(hd) (hd & 0xFF)
#define Wosize_hd(hd) (hd >> 10)
#define Bosize_hd(hd) (Bsize_wsize (Wosize_hd (hd)))


#define Color_white 0
#define Color_black 1

#define Is_black_val(val) ((Header(val) >> 8) & Color_black)
#define Is_black_hd(hd) (((hd) >> 8) & Color_black)

#define Set_black_hd(hd) ((hd | (Color_black << 8)))

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
#define String_tag   252
#define Custom_tag   255

#define No_scan_tag  251 // ??

/* Closure_tag 247 */
//#define Code_val(val) (((code_t *) (val)) [0])

/* Object_tag 248 */
#define Class_val(val) Field((val), 0)
#define Oid_val(val) Int_val(Field((val), 1))

/* Infix_tag 249 */
#define Infix_offset_hd(hd) (Bosize_hd(hd))
#define Infix_offset_val(v) Infix_offset_hd(Hd_val(v))


/* Forward_tag 250 */
#define Forward_val(v) Field(v, 0)

/* Custom_tag 255 */
#define Data_custom_val(v) ((void *) &Field((v), 1))

/******************************************************************************/
/* Custom operations */

extern void *int32_custom_operations;
extern void *int64_custom_operations;
extern void *nativeint_custom_operations;

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#elif OCAML_VIRTUAL_ARCH == 64 || !defined(OCAML_VIRTUAL_ARCH)

/* /\* */
/*   Version 64 bits */

/*   Codage des valeurs par du Nan boxing 64 bits avec : */

/*           float : tels quels avec 1 seul Nan 0111 1111 1111 1000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 */
/*            int  : 1 bit de marque à la fin */
/*        pointeur : 1111 1111 1111 1xxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxxx x000  (alignement) */
/* pointeurs flash : tels quels mais limités à 2^63-2^51 en évitant ainsi d'avoir que des 1 dans la zone Nan */

/*         int64_t : entiers sur 64 bits (stdint.h) */
/*           val_t : la représentation uniforme d'une valeur ocaml */
/*            bloc : une valeur allouée : 1 entête suivi de champs ou d'octets (alignée sur la taille des champs) */
/*           champ : une valeur (val_t) */
/* *\/ */

/* /\******************************************************************************\/ */
/* /\* Types *\/ */

/* typedef int64_t val_t; */
/* typedef uint64_t uval_t; */
/* typedef uint64_t mlsize_t; */
/* typedef uint64_t header_t; */
/* typedef uint8_t tag_t; */
/* typedef uint8_t opcode_t; */
/* typedef uint64_t code_t; */

/* /\******************************************************************************\/ */
/* /\* Value classification *\/ */

/* #define Is_int(x) (((x) & 1) != 0) */
/* #define Is_block(x) (((val_t) (x) & 1) == 0 && ((val_t) (x) >> 51) == 0x1FFF) */

/* /\******************************************************************************\/ */
/* /\* Conversions *\/ */

/* #define Val_int(x) (((val_t) (x) << 1) | 1) */
/* #define Int_val(x) ((val_t) (x) >> 1) */

/* #define Val_block(x) ((val_t) ((x - ocaml_heap) << 3) | ((val_t) 0x1FFF << 51)) */
/* #define Block_val(x) (ocaml_heap + (((x) ^ ((val_t) 0x1FFF << 51)) >> 3)) */

/* #define Val_bool(x) Val_int((x) != 0) */
/* #define Bool_val(x) Int_val(x) */

/* #define Val_float(x) ((double) x != (double) x ? Val_nan : ((union { double d; val_t n; }) (double) (x)).n) */
/* #define Float_val(v) (((union { double d; val_t n; }) (val_t) (v)).d) */

/* /\******************************************************************************\/ */
/* /\* Constants *\/ */

/* #define Val_false Val_int(0) */
/* #define Val_true  Val_int(1) */
/* #define Val_unit  Val_int(0) */
/* #define Val_nan   0x7FF8000000000000 */

/* /\******************************************************************************\/ */
/* /\* Blocks *\/ */

/* #define Field(val, i) (Block_val(val)[i]) */
/* #define StringVal(val) ((char *) Block_val(val)) */
/* #define StringField(val, i) (StringVal(val)[i]) */

/* #define Header(val) Field(val, -1) */
/* #define Hd_val(val) Field(val, -1) */
/* #define Code_val(val) Field(val, 0) */

/* #define Make_string_data(c7, c6, c5, c4, c3, c2, c1, c0)                                       \ */
/*   (((val_t) (c0) << 56) | ((val_t) (c1) << 48) | ((val_t) (c2) << 40) | ((val_t) (c3) << 32) | \ */
/*    ((val_t) (c4) << 24) | ((val_t) (c5) << 16) | ((val_t) (c6) <<  8) | ((val_t) (c7))) */

/* #define Make_custom_data(b7, b6, b5, b4, b3, b2, b1, b0) Make_string_data(b7, b6, b5, b4, b3, b2, b1, b0) */

/* #define Make_float(b7, b6, b5, b4, b3, b2, b1, b0) Make_string_data(b7, b6, b5, b4, b3, b2, b1, b0) */

/* #define Make_header(wosize, tag) (((val_t) (wosize) << 10) | tag) */

/* #define Bsize_wsize(sz) ((sz) * sizeof (val_t)) */
/* #define Wsize_bsize(sz) ((sz) / sizeof (val_t)) */

/* #define Wosize_val(val) ((mlsize_t) (Header(val) >> 10)) */
/* #define Bosize_val(val) (Bsize_wsize (Wosize_val (val))) */

/* #define Color_val(val) ((Header(val) >> 8) & 1) */
/* #define Tag_val(val) (Header(val) & 0xFF) */

/* #define Tag_hd(hd) (hd & 0xFF) */
/* #define Wosize_hd(hd) (hd >> 10) */
/* #define Bosize_hd(hd) (Bsize_wsize (Wosize_hd(hd))) */

/* #define Color_white 0 */
/* #define Color_black 1 */

/* #define Is_black_val(val) ((Header(val) >> 8) & Color_black) */
/* #define Is_black_hd(hd) (((hd) >> 8) & Color_black) */

/* #define Set_black_hd(hd) ((hd | (Color_black << 8))) */
/* /\******************************************************************************\/ */
/* /\* Tags *\/ */

/* #define Lazy_tag     246 */
/* #define Closure_tag  247 */
/* #define Object_tag   248 */


/* #define Infix_tag    249 */
/* #define Forward_tag  250 */
/* #define Abstract_tag 251 */
/* #define String_tag   252 */
/* #define Custom_tag   255 */

/* #define No_scan_tag  251 // ?? */

/* /\* Closure_tag 247 *\/ */
/* //#define Code_val(val) (((code_t *) (val)) [0]) */

/* /\* Object_tag 248 *\/ */
/* #define Class_val(val) Field((val), 0) */
/* #define Oid_val(val) Int_val(Field((val), 1)) */

/* /\* Infix_tag 249 *\/ */
/* #define Infix_offset_hd(hd) (Bosize_hd(hd)) */
/* #define Infix_offset_val(v) Infix_offset_hd(Hd_val(v)) */


/* /\* Forward_tag 250 *\/ */
/* #define Forward_val(v) Field(v, 0) */

/* /\* Custom_tag 255 *\/ */
/* #define Data_custom_val(v) ((void *) &Field((v), 1)) */

/* /\******************************************************************************\/ */
/* /\* Custom operations *\/ */

/* extern void *int32_custom_operations; */
/* extern void *int64_custom_operations; */
/* extern void *nativeint_custom_operations; */

/* /\******************************************************************************\/ */
/* /\******************************************************************************\/ */
/* /\******************************************************************************\/ */

#else
#error "Invalid virtual architecture, please define OCAML_VIRTUAL_ARCH"
#endif

/* /\******************************************************************************\/ */
/* /\******************************************************************************\/ */
/* /\******************************************************************************\/ */
