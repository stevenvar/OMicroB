/*
  32 bits version of values:

Floatting point values: ieee754 with only one NaN
                          NaN : 0111 1111 1010 0000 0000 0000 0000 0000 (unique)
                         +inf : 0111 1111 1000 0000 0000 0000 0000 0000 (unique)
                         -inf : 1000 0000 0111 1111 1111 1111 1111 1111 (unique)
                          +0. : 0000 0000 0000 0000 0000 0000 0000 0000 (unique)
                          -0. : 1111 1111 1111 1111 1111 1111 1111 1111 (collides int (-1))
        other positive floats : 0eee eeee emmm mmmm mmmm mmmm mmmm mmmm (as is, collides int)
        other negative floats : 1eee eeee emmm mmmm mmmm mmmm mmmm mmmm (with exponant and mantiss inverted, collides int and code pointer)

Integers, constant variants, etc:
                        int   : xxxx xxxx xxxx xxxx xxxx xxxx xxxx xxx1 (collides float and code pointer)

dynamic heap pointers   (ram) : 0111 1111 1100 xxxx xxxx xxxx xxxx xx00 (unique)
 static heap pointers   (ram) : 0111 1111 1101 xxxx xxxx xxxx xxxx xx00 (unique)
        heap pointers (flash) : 0111 1111 1110 xxxx xxxx xxxx xxxx xx00 (unique)

                            ? : 0111 1111 1111 xxxx xxxx xxxx xxxx xx00 (unique)

        code pointers (flash) : 10xx xxxx xxxx xxxx xxxx xxxx xxxx xxx1 (collides float and int)

                 white header : tttt tttt ssss ssss ssss ssss ssss ss00
                   red header : tttt tttt ssss ssss ssss ssss ssss ss01
                 black header : tttt tttt ssss ssss ssss ssss ssss ss10
                 brown header : tttt tttt ssss ssss ssss ssss ssss ss11

              unaligned_block : 0111 1111 11yy xxxx xxxx xxxx xxxx xx10

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
#define Is_in_ram(x)                (OCAML_NO_FLASH_HEAP || (((uint8_t) ((uint32_t) (x) >> 16)) & 0x20) == 0x00)

// Is a value can be a code pointer? (pretty-printing purpose)
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
#define Int64_val(v) (Is_int(v) ? (int64_t) Int_val(v) : ((int64_t) (uint32_t) Field(v, 1)) | ((int64_t) Field(v, 2) << 32))

#define Val_bool(x) ((uint8_t) (x) != 0 ? 0x3 : 0x1)
#define Bool_val(x) (((uint8_t) (x) & 2) != 0)

extern value value_of_float(float x);
extern float float_of_value(value v);

#define Val_float(x) (value_of_float(x))
#define Float_val(x) (float_of_value(x))

#define Val_codeptr(x) ((value) (((uint32_t) (x) << 1) | 0x80000001))
#define Codeptr_val(x) (((uint32_t) (x) >> 1) & 0x3FFFFFFF)

#define Offsetclosure_delta 8
#define Hd_size_bitcnt 22

/******************************************************************************/
/* Constants */

#define Val_false ((value) 0x1)
#define Val_true  ((value) 0x3)
#define Val_unit  ((value) 0x1)
#define Val_nan   ((value) 0x7FA00000)
#define Val_inf   ((value) 0x7F800000)
#define Val_ninf  ((value) 0x807FFFFF)
#define Val_zero  ((value) 0x00000000)
#define Val_nzero ((value) 0xFFFFFFFF)

/******************************************************************************/
/* Blocks */

#define Ram_field(val, i) (Ram_block_val(val)[i])
#define Ram_string_field(val, i) (((uint8_t *) Ram_block_val(val))[i])

#define Field(val, i) (Is_in_ram(val) ? Ram_field(val, i) : Flash_field(val, i))
#define String_field(val, i) (Is_in_ram(val) ? Ram_string_field(val, i) : Flash_string_field(val, i))

#define Ram_hd_val(val) Ram_field(val, -1)
#define Ram_string_val(val) ((uint8_t *) Ram_block_val(val))

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
