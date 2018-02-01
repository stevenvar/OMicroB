/*
  16 bits version of values:

Floatting point values: only one NaN
                          NaN : 0111 1110 0000 0001 (unique)
                         +inf : 0111 1100 0000 0001 (unique)
                         -inf : 1000 0011 1111 1111 (unique)
                 other floats : seee eemm mmmm mmm1 (as is, collide int and code pointer)

Integers, constant variants, etc:
                        int   : xxxx xxxx xxxx xxx1 (collide float and code pointer)

dynamic heap pointers   (ram) : xxxx xxxx xxxx xx00 (range [ #static .. #static + #dynamic [)
 static heap pointers   (ram) : xxxx xxxx xxxx xx00 (range [ 0 .. #static [)
        heap pointers (flash) : xxxx xxxx xxxx xx00 (range [ #static + #dynamic .. #static + #dynamic + #flash [)

        code pointers (flash) : xxxx xxxx xxxx xxxx (range [ #static + #dynamic + #flash .. #static + #dynamic + #flash + #bytecode [)

                 white header : tttt tttt ssss ss00
                   red header : tttt tttt ssss ss01
                 black header : tttt tttt ssss ss10
                 brown header : tttt tttt ssss ss11

OCaml values:
                        value : uniform representation of an OCaml value
                        block : OCaml value with multiple fields: 1 header followed by fields
                 block header : tag (8 bits) | size (6bits) | color (2 bits)
*/

#ifndef VALUES_16_H
#define VALUES_16_H

#include <stdint.h>

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Types */

#ifndef TYPES
#define TYPES
typedef int32_t  value;
typedef uint32_t uvalue;
typedef uint32_t mlsize_t;
typedef int32_t  header_t;
typedef uint8_t  tag_t;
typedef uint8_t  color_t;
typedef uint8_t  opcode_t;

#if OCAML_BYTECODE_BSIZE < 0x100
typedef uint8_t code_t;
#elif OCAML_BYTECODE_BSIZE < 0x10000
typedef uint16_t code_t;
#else
typedef uint32_t code_t;
#endif
#endif

#define PRIflag ""

/******************************************************************************/
/* Value classification */

// Is a block in one of the three heaps?
#define Is_block(x)                 (((uint8_t) (x) & 0x3) == 0x00 && (uint16_t) ((uint32_t) (x) >> 22) == 0x01FF)
// Is an int, a float or a code pointer?
#define Is_int(x)                   (((uint8_t) (x) & 0x1) == 0x01)

// Is an exceptions that crossed FFI or a blacken header at the marking stage of a Mark&Compact
#define Is_unaligned_block(x)       (((uint8_t) (x) & 0x3) == 0x02 && (uint16_t) ((uint32_t) (x) >> 22) == 0x01FF)

// Is a block in the dynamic heap
#define Is_block_in_dynamic_heap(x) (((uint8_t) (x) & 0x3) == 0x00 && (uint16_t) ((uint32_t) (x) >> 20) == 0x07FC)
// Is a block in the static heap
#define Is_block_in_static_heap(x)  (((uint8_t) (x) & 0x3) == 0x00 && (uint16_t) ((uint32_t) (x) >> 20) == 0x07FD)
// Is a block in the flash heap
#define Is_block_in_flash_heap(x)   (((uint8_t) (x) & 0x3) == 0x00 && (uint16_t) ((uint32_t) (x) >> 20) == 0x07FE)

// (x) is assumed to be a block, is it in one of the ram heaps?
#define Is_in_ram(x)                ((((uint8_t) ((uint32_t) (x) >> 16)) & 0x20) == 0x00)

// (x) is assumed to be an integer, can it be a code pointer? (pretty-printing purpose)
#define Maybe_code_pointer(x)       (Is_int(x) && ((uint32_t) (x) >> 30) == 0x2)

/******************************************************************************/
/* Conversions */

#define Val_dynamic_block(x) ((value) ((char *) (x) - (char *)   ocaml_ram_heap) | (value) 0x7FC00000)
#define Val_static_block(x)  ((value) ((char *) (x) - (char *)   ocaml_ram_heap) | (value) 0x7FD00000)
#define Val_flash_block(x)   ((value) ((char *) (x) - (char *) ocaml_flash_heap) | (value) 0x7FE00000)

#define Ram_block_val(x)     ((value *) ((char *) ocaml_ram_heap + (((int32_t) (x) << 12) >> 12)))
#define Flash_block_val(x)   ((value *) ((char *) ocaml_flash_heap + ((int32_t) (x) & 0x000FFFFF)))

#define Val_int(x) ((value) (((uint32_t) (int32_t) (x) << 1) | 1))
#define Int_val(x) ((int32_t) ((value) (x) >> 1))

#define Val_bool(x) ((uint8_t) (x) != 0 ? 0x3 : 0x1)
#define Bool_val(x) (((uint8_t) (x) & 2) != 0)

union float_or_value { float f; value v; };

#define bitwise_value_of_float(x) (((union float_or_value) { .f = (x) }).v)
#define bitwise_float_of_value(x) (((union float_or_value) { .v = (x) }).f)

#define Val_float(x) ((float) (x) != (float) (x) ? Val_nan : (bitwise_value_of_float((float) (x)) < 0 ? bitwise_value_of_float((float) (x)) ^ 0x7FFFFFFF : bitwise_value_of_float((float) (x))))
#define Float_val(x) ((value) (x) < 0 ? bitwise_float_of_value((value) (x) ^ 0x7FFFFFFF) : bitwise_float_of_value((value) (x)))

#define Val_codeptr(x) ((value) (((uint32_t) (x) << 1) | 0x80000001))
#define Codeptr_val(x) (((uint32_t) (x) >> 1) & 0x7FFFFFFF)

#define Hd_size_bitcnt 22

/******************************************************************************/
/* Constants */

#define Val_false ((value) 0x1)
#define Val_true  ((value) 0x3)
#define Val_unit  ((value) 0x1)
#define Val_nan   ((value) 0x7FA00000)

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

#define Make_custom_data(b0, b1, b2, b3) Make_string_data(b0, b1, b2, b3)

#define Make_float(b0, b1, b2, b3) Make_string_data(b0, b1, b2, b3)

#define Bsize_wsize(sz) ((sz) << 2)
#define Wsize_bsize(sz) ((sz) >> 2)

#define Make_header(size, tag, color) ((value) ((((uvalue) (tag)) << 24) | (((uvalue) (size)) << 2) | ((uvalue) (color))))

#define Tag_hd(h) ((tag_t) ((header_t) (h) >> 24))
#define Wosize_hd(h) ((mlsize_t) (((header_t) (h) >> 2) & 0x003FFFFF))
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
