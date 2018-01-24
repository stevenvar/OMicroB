/*
  32 bits version of values:

Floatting point values: ieee754 with only one NaN
                          NaN : 0111 1111 1100 0000 0000 0000 0000 0000
                         +inf : 0111 1111 1000 0000 0000 0000 0000 0000
                         -inf : 1111 1111 1000 0000 0000 0000 0000 0000
                 other floats : xyyy yyyy yxxx xxxx xxxx xxxx xxxx xxxx (with at least one y != 1)

Integers, constant variants, etc:
                        int   : xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxx1

dynamic heap pointers   (ram) : 1111 1111 100x xxxx xxxx xxxx xxxx xx00 (never NULL => distinct to -inf)
 static heap pointers   (ram) : 1111 1111 101x xxxx xxxx xxxx xxxx xx00
        heap pointers (flash) : 1111 1111 110x xxxx xxxx xxxx xxxx xx00

        code pointers (flash) : 10xx xxxx xxxx xxxx xxxx xxxx xxxx xxx1

       exception mark for FFI : 1111 1111 1yyx xxxx xxxx xxxx xxxx xx10

OCaml values:
                        value : uniform representation of an OCaml value
                        block : OCaml value with multiple fields: 1 header followed by fields
                 block header : tag (8 bits) | size (22bits) | color (2 bits)
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

#if OCAML_BYTECODE_BSIZE < 0x100
typedef uint8_t code_t;
#elif OCAML_BYTECODE_BSIZE < 0x10000
typedef uint16_t code_t;
#else
typedef uint32_t code_t;
#endif
#endif

/******************************************************************************/
/* Value classification */

#define Is_block(x)                 (((uint8_t) (x) & 0x3) == 0x0 && (uint16_t) ((uint32_t) (x) >> 23) == 0x01FF)
#define Is_int(x)                   (((uint8_t) (x) & 0x1) == 0x1)

#define Is_block_in_dynamic_heap(x) (((uint8_t) (x) & 0x3) == 0x0 && (uint16_t) ((uint32_t) (x) >> 21) == 0x07FC)
#define Is_block_in_static_heap(x)  (((uint8_t) (x) & 0x3) == 0x0 && (uint16_t) ((uint32_t) (x) >> 21) == 0x07FD)
#define Is_block_in_flash_heap(x)   (((uint8_t) (x) & 0x3) == 0x0 && (uint16_t) ((uint32_t) (x) >> 21) == 0x07FE)

#define Is_in_ram(x)                ((((uint8_t) ((uint32_t) (x) >> 16)) & 0x40) == 0x00)

#define Maybe_code_pointer(x)       (((uint32_t) (x) >> 30) == 0x2) // Useful for debugging

/******************************************************************************/
/* Conversions */

#define Val_dynamic_block(x) ((value) ((char *) (x) - (char *) ocaml_ram_heap) | (value) 0xFF800000)
#define Val_static_block(x)  ((value) ((char *) (x) - (char *) ocaml_ram_heap) | (value) 0xFFA00000)
#define Val_flash_block(x)   ((value) ((char *) (x) - (char *) ocaml_flash_heap)   | (value) 0xFFC00000)

#define Ram_block_val(x)     ((value *) ((char *) ocaml_ram_heap + (((int32_t) (x) << 11) >> 11)))
#define Flash_block_val(x)   ((value *) ((char *) ocaml_flash_heap + ((int32_t) (x) & 0x001FFFFF)))

#define Val_int(x) ((value) (((uint32_t) (x) << 1) | 1))
#define Int_val(x) ((int32_t) ((value) (x) >> 1))

#define Val_bool(x) ((uint8_t) (x) != 0 ? 0x3 : 0x1)
#define Bool_val(x) (((uint8_t) (x) & 2) != 0)

#define Val_float(x) ((float) (x) != (float) (x) ? Val_nan : ((union { float f; value v; }) { .f = (x) }).v)
#define Float_val(v) (((union { float f; value v; }) { .v = (v) }).f)

#define Val_codeptr(x) ((value) (((uint32_t) (x) << 1) | 0x80000001))
#define Codeptr_val(x) (((value) (x) & 0x7FFFFFFF) >> 1)

/******************************************************************************/
/* Constants */

#define Val_false ((value) 0x1)
#define Val_true  ((value) 0x3)
#define Val_unit  ((value) 0x1)
#define Val_nan   ((value) 0x7FC00000)

/******************************************************************************/
/* Blocks */

#define Ram_field(val, i) (Ram_block_val(val)[i])
#define Ram_string_field(val, i) (((char *) Ram_block_val(val))[i])

#ifdef __AVR__
#define Flash_field(val, i) (pgm_read_dword_near(Flash_block_val(val) + i))
#define Flash_string_field(val, i) ((char) pgm_read_byte_near((char *) Flash_block_val(val) + i))
#else
#define Flash_field(val, i) (Flash_block_val(val)[i])
#define Flash_string_field(val, i) (((char *) Flash_block_val(val))[i])
#endif

#define Field(val, i) (Is_in_ram(val) ? Ram_field(val, i) : Flash_field(val, i))
#define String_field(val, i) (Is_in_ram(val) ? Ram_string_field(val, i) : Flash_string_field(val, i))

#define Ram_hd_val(val) Ram_field(val, -1)
#define Ram_string_val(val) ((char *) Ram_block_val(val))

#define Hd_val(val) Field(val, -1)

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

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#endif
