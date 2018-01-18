/*************************************************************************/
/*                                                                       */
/*                                OCaPIC                                 */
/*                                                                       */
/*                             Benoit Vaugon                             */
/*                                                                       */
/*    This file is distributed under the terms of the CeCILL license.    */
/*    See file ../../LICENSE-en.                                         */
/*                                                                       */
/*************************************************************************/

#include <stdio.h>
#include <math.h>
#include <string.h>
#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <caml/custom.h>
#include <caml/fail.h>

/* Constants */

#define SERIAL_BUFFER_SIZE 2000

#define CAML_SERIAL_SEND_BUFFER_SIZE 2048

#define SERIAL_HASH_INITL   0x6B
#define SERIAL_HASH_INITH   0x39

#define SERIAL_FLAG_BASE    0xA6

#define SERIAL_NEWTIC_FLAG  (SERIAL_FLAG_BASE ^ 0x00)
#define SERIAL_NEWTAC_FLAG  (SERIAL_FLAG_BASE ^ 0xFF)
#define SERIAL_ENDTIC_FLAG  (SERIAL_FLAG_BASE ^ 0x0F)
#define SERIAL_ENDTAC_FLAG  (SERIAL_FLAG_BASE ^ 0xF0)
#define SERIAL_RECEIVE_FLAG (SERIAL_FLAG_BASE ^ 0x3C)
#define SERIAL_ERROR_FLAG   (SERIAL_FLAG_BASE ^ 0xC3)
#define SERIAL_GET_FLAG     (SERIAL_FLAG_BASE ^ 0x33)
#define SERIAL_OOM_FLAG     (SERIAL_FLAG_BASE ^ 0xCC)

#define SERIAL_ESC_FLAG  0xFF
#define SERIAL_RES1_FLAG 0x03
#define SERIAL_RES2_FLAG 0x1A
#define SERIAL_RES3_FLAG 0x1C

#define INT32_CUSTOM_ADR 0x15E0
#define INT64_CUSTOM_ADR 0x15F0

#define ATOM0_ADR 0xF88

#define TIC 0x00
#define TAC 0x01

/* Variables */

static int serial_tictac = TIC;
static unsigned char serial_hash_byteL;
static unsigned char serial_hash_byteH;
static int caml_serial_send_buffer_index = 0;
static value caml_serial_send_buffer[CAML_SERIAL_SEND_BUFFER_SIZE];

/* Tools */

static int caml_serial_send_buffer_store(value v){
  int i;
  for(i = 0 ; i < caml_serial_send_buffer_index ; i ++){
    if(caml_serial_send_buffer[i] == v){
      return i << 1;
    }
  }
  if(caml_serial_send_buffer_index == CAML_SERIAL_SEND_BUFFER_SIZE){
    fprintf(stderr, "caml_serial_send: too big heap for a pic\n");
    exit(1);
  }else{
    int index = caml_serial_send_buffer_index;
    caml_serial_send_buffer[index] = v;
    caml_serial_send_buffer_index ++;
    return index << 1;
  }
}

static value caml_serial_send_buffer_get(int adr){
  int index = adr >> 1;
  if(index < 0 || index >= caml_serial_send_buffer_index){
    fprintf(stderr, "caml_serial_send: buffer index out of bounds: %d\n",
            index);
    exit(1);
  }else{
    return caml_serial_send_buffer[index];
  }
}

static void caml_serial_send_buffer_reset(void){
  caml_serial_send_buffer_index = 0;
}

static double caml_serial_trevnoc_float(unsigned char *buffer){
  if(buffer[0] == 0 && buffer[1] == 0 && buffer[2] == 0 && buffer[3] == 0){
    return 0;
  }else{
    int mantissa = buffer[0] + buffer[1]*256 + (buffer[2] | 0x80)*256*256;
    int sign = -((buffer[2] & 0x80) >> 6) + 1;
    int exp = buffer[3] - 150;
    return sign * pow(2, exp) * mantissa;
  }
}

static int32_t caml_serial_convert_float(double f){
  double x;
  int ex;
  x = frexp(f, &ex);
  if(f == 0.0 || f == -0.0 || ex < -128){
    return 0;
  }else{
    int i, s, m, b0, b1, b2, b3;
    double a = fabs(x);
    int r = 0;
    for(i = 24 ; i >= 0 ; i --){
      if(a < 0.5){
        a *= 2;
      }else{
        a = (a - 0.5) * 2;
        r = r | (1 << i);
      }
    }
    s = (f < 0. ? 1 : 0);
    m = (r & 0xFFFFFF) >> 1;
    b0 = m & 0xFF;
    b1 = (m >> 8) & 0xFF;
    b2 = ((m >> 16) & 0x7F) | (s << 7);
    b3 = (ex + 126) & 0xFF;
    return b0 + (b1 << 8) + (b2 << 16) + (b3 << 24);
  }
}

static void caml_serial_inv_tictac(void){
  if(serial_tictac == TIC){
    serial_tictac = TAC;
  }else{
    serial_tictac = TIC;
  }
}

/* Routines */

static unsigned char caml_serial_receive_byte(void){
  int b = getc(stdin);
  if(b == EOF){
    caml_raise_end_of_file();
  }else if(b == SERIAL_ESC_FLAG){
    return getc(stdin) ^ SERIAL_ESC_FLAG;
  }else{
    return b;
  }
}

static unsigned char caml_serial_receive_flag(void){
  unsigned char b0 = caml_serial_receive_byte();
  unsigned char b1 = caml_serial_receive_byte();
  if(b0 == b1){
    return b0;
  }else{
    caml_serial_receive_byte();
    return SERIAL_ERROR_FLAG;
  }
}

static void caml_serial_send_byte(unsigned char b){
  switch(b){
  case SERIAL_RES1_FLAG:
  case SERIAL_RES2_FLAG:
  case SERIAL_RES3_FLAG:
  case SERIAL_ESC_FLAG:
    putc(SERIAL_ESC_FLAG, stdout);
    putc(b ^ SERIAL_ESC_FLAG, stdout);
    fflush(stdout);
    break;
  default:
    putc(b, stdout);
    fflush(stdout);
  }
}

static void caml_serial_send_flag(unsigned char b){
  caml_serial_send_byte(b);
  caml_serial_send_byte(b);
}

static void caml_compute_hash_init(void){
  serial_hash_byteL = SERIAL_HASH_INITL;
  serial_hash_byteH = SERIAL_HASH_INITH;
}

static void caml_compute_hash_step(unsigned char b){
  serial_hash_byteL = (serial_hash_byteL * serial_hash_byteH) & 0xFF;
  serial_hash_byteH = serial_hash_byteL ^ serial_hash_byteH;
  serial_hash_byteL = serial_hash_byteL ^ b;
  serial_hash_byteH = serial_hash_byteH ^ b;
}

/* caml_serial_open_channel */

value caml_serial_open_channel(value unit){
  return Val_unit;
}

/* caml_serial_receive */

static value caml_serial_receive_(void);
static value caml_serial_receive_start(void);
static value caml_serial_receive_heap(int size);
static value caml_serial_receive_check_oom(int size);
static value caml_serial_receive_data(int size);
static value caml_serial_receive_data_loop(int size);
static value caml_serial_receive_end(value ret);
static value caml_serial_receive_oom(void);
static value caml_serial_receive_data_error(void);

value caml_serial_receive(value unit){
  return caml_serial_receive_();
}

static value caml_serial_receive_(void){
  switch(caml_serial_receive_flag()){
  case SERIAL_NEWTIC_FLAG:
    if(serial_tictac == TIC){
      caml_serial_send_flag(SERIAL_RECEIVE_FLAG);
      return caml_serial_receive_start();
    }else{
      caml_serial_send_flag(SERIAL_ENDTIC_FLAG);
      return caml_serial_receive_();
    }
  case SERIAL_NEWTAC_FLAG:
    if(serial_tictac == TAC){
      caml_serial_send_flag(SERIAL_RECEIVE_FLAG);
      return caml_serial_receive_start();
    }else{
      caml_serial_send_flag(SERIAL_ENDTAC_FLAG);
      return caml_serial_receive_();
    }
  case SERIAL_ENDTIC_FLAG:
    caml_serial_send_flag(SERIAL_ENDTIC_FLAG);
    return caml_serial_receive_();
  case SERIAL_ENDTAC_FLAG:
    caml_serial_send_flag(SERIAL_ENDTAC_FLAG);
    return caml_serial_receive_();
  case SERIAL_RECEIVE_FLAG:
    caml_serial_send_flag(SERIAL_RECEIVE_FLAG);
    return caml_serial_receive_();
  default:
    return caml_serial_receive_();
  }
}

static value caml_serial_receive_start(void){
  unsigned char byteL, byteH, hashL, hashH;
  caml_compute_hash_init();
  byteL = caml_serial_receive_byte();
  caml_compute_hash_step(byteL);
  byteH = caml_serial_receive_byte();
  caml_compute_hash_step(byteH);
  hashL = caml_serial_receive_byte();
  hashH = caml_serial_receive_byte();
  if(hashL != serial_hash_byteL || hashH != serial_hash_byteH){
    return caml_serial_receive_();
  }else{
    int accu_or_size = (((int) byteH) << 8) | (int) byteL;
    if(byteL & 1){
      return caml_serial_receive_end(Val_long(accu_or_size >> 1));
    }else if(accu_or_size == ATOM0_ADR){
      return caml_serial_receive_end(Atom(0));
    }else{
      return caml_serial_receive_check_oom(accu_or_size);
    }
  }
}

static value caml_serial_receive_check_oom(int size){
  if(0) caml_serial_receive_oom();
  return caml_serial_receive_heap(size);
}

static value caml_serial_receive_heap(int size){
  unsigned char fsr1L = 0, fsr1H = 0;
  caml_serial_send_flag(SERIAL_GET_FLAG);
  caml_compute_hash_init();
  caml_serial_send_byte(fsr1L);
  caml_compute_hash_step(fsr1L);
  caml_serial_send_byte(fsr1H);
  caml_compute_hash_step(fsr1H);
  caml_serial_send_byte(serial_hash_byteL);
  caml_serial_send_byte(serial_hash_byteH);
  return caml_serial_receive_data(size);
}

static value caml_serial_receive_data(int size){
  caml_compute_hash_init();
  return caml_serial_receive_data_loop(size);
}

static value caml_serial_receive_data_loop(int size){
  CAMLparam0();
  CAMLlocal3(block, str, res);
  CAMLlocalN(blocks, SERIAL_BUFFER_SIZE);
  unsigned char buffer[SERIAL_BUFFER_SIZE], hashL, hashH;
  int i, j;
  for(i = 0 ; i < SERIAL_BUFFER_SIZE ; i ++){
    blocks[i] = Val_unit;
  }
  for(i = 0 ; i < size ; i ++){
    unsigned char b = caml_serial_receive_byte();
    buffer[i] = b;
    caml_compute_hash_step(b);
  }
  hashL = caml_serial_receive_byte();
  hashH = caml_serial_receive_byte();
  if(hashL != serial_hash_byteL || hashH != serial_hash_byteH){
    res = caml_serial_receive_data_error();
  }else{
    i = 0;
    while(i < size){
      tag_t tag = buffer[i ++];
      mlsize_t block_sz = buffer[i ++];
      switch(tag){
      case Lazy_tag:
        fprintf(stderr,
                "caml_serial_receive: deserialisation of a lazy block\n");
        exit(1);
      case Closure_tag:
        fprintf(stderr,
                "caml_serial_receive: deserialisation of a closure\n");
        exit(1);
      case Object_tag:
        fprintf(stderr,
                "caml_serial_receive: deserialisation of an object\n");
        exit(1);
      case Infix_tag:
        fprintf(stderr,
                "caml_serial_receive: deserialisation of an infix block\n");
        exit(1);
      case Forward_tag:
        fprintf(stderr,
                "caml_serial_receive: deserialisation of a forward block\n");
        exit(1);
      case Abstract_tag:
        fprintf(stderr,
                "caml_serial_receive: deserialisation of an abstract block\n");
        exit(1);
      case String_tag: {
        int str_sz = 2*block_sz - 1 - buffer[i - 1 + 2*block_sz];
        str = caml_alloc_string(str_sz);
        for(j = 0 ; j < str_sz ; j ++){
          String_val(str)[j] = buffer[i + j];
        }
        blocks[i] = str;
        break;
      }
      case Double_tag: {
        double d = caml_serial_trevnoc_float(buffer+i);
        blocks[i] = caml_copy_double(d);
        break;
      }
      case Double_array_tag: {
        int j;
        value res = caml_alloc(block_sz / 2 * Double_wosize, Double_array_tag);
        for (j = 0 ; j < block_sz / 2 ; j ++){
          double d = caml_serial_trevnoc_float(buffer+i+4*j);
          Store_double_field(res, j, d);
        }
        blocks[i] = res;
        break;
      }
      case Custom_tag: {
        int key = buffer[i] + buffer[i + 1] * 256;
        if(key == INT32_CUSTOM_ADR){
          int32_t n = 0; int j;
          for(j = 5 ; j >= 2 ; j --) n = n * 256 + buffer[i + j];
          blocks[i] = caml_copy_int32(n);
          break;
        }else if(key == INT64_CUSTOM_ADR){
          int64_t n = 0; int j;
          for(j = 9 ; j >= 2 ; j --) n = n * 256 + buffer[i + j];
          blocks[i] = caml_copy_int64(n);
          break;
        }else{
          fprintf(stderr,
           "caml_serial_receive: deserialisation of an unknown custom block\n");
          exit(1);
        }
      }
      default: {
        block = caml_alloc(block_sz, tag);
        blocks[i] = block;
        break;
      }
      }
      i += 2 * block_sz;
    }
    for(i = 0 ; i < size ; i ++){
      block = blocks[i];
      if(block != Val_unit){
        mlsize_t block_sz = buffer[i - 1];
        tag_t tag = buffer[i - 2];
        if(tag < Abstract_tag){
          for(j = 0 ; j < block_sz ; j ++){
            int v = (((int) buffer[i + 2*j + 1]) << 8) | buffer[i + 2*j];
            if(v & 1){
              Field(block, j) = Val_long(v >> 1);
            }else if(v == ATOM0_ADR){
              Field(block, j) = Atom(0);
            }else{
              Field(block, j) = blocks[v];
            }
          }
        }
      }
    }
    res = caml_serial_receive_end(blocks[2]);
  }
  CAMLreturn (res);
}

static value caml_serial_receive_end(value res){
  if(serial_tictac == TIC){
    caml_serial_send_flag(SERIAL_ENDTIC_FLAG);
  }else{
    caml_serial_send_flag(SERIAL_ENDTAC_FLAG);
  }
  caml_serial_inv_tictac();
  return res;
}

static value caml_serial_receive_oom(void){
  caml_serial_send_flag(SERIAL_OOM_FLAG);
  return caml_serial_receive_();
}

static value caml_serial_receive_data_error(void){
  return caml_serial_receive_();
}

/* caml_serial_send */

static value caml_serial_send_(value v);
static value caml_serial_send_block(value v);
static value caml_serial_send_block_tagsize(value v, int adr);
static value caml_serial_send_block_data_start(value v, int adr, tag_t tag,
                                               mlsize_t size);
static value caml_serial_send_block_data_loop(value v, int adr, tag_t tag,
                                              mlsize_t size);
static value caml_serial_send_continue(value v);
static value caml_serial_send_end(void);

value caml_serial_send(value unit, value v){
  caml_serial_send_buffer_reset();
  return caml_serial_send_(v);
}

value caml_serial_send_(value v){
  if(serial_tictac == TIC){
    caml_serial_send_flag(SERIAL_NEWTIC_FLAG);
  }else{
    caml_serial_send_flag(SERIAL_NEWTAC_FLAG);
  }
  switch(caml_serial_receive_flag()){
  case SERIAL_RECEIVE_FLAG: {
    int data;
    if(Is_block(v)){
      if(Wosize_val(v) == 0){
        data = ATOM0_ADR;
      }else{
        data = caml_serial_send_buffer_store(v);
      }
    }else{
      data = Long_val(v);
      if(data < -16384 || 16383 < data){
        fprintf(stderr, "caml_serial_send: too big integer in heap\n");
        exit(1);
      }
      data = (data << 1) | 1;
    }
    caml_compute_hash_init();
    caml_serial_send_byte(data & 0xFF);
    caml_compute_hash_step(data & 0xFF);
    caml_serial_send_byte((data >> 8) & 0xFF);
    caml_compute_hash_step((data >> 8) & 0xFF);
    caml_serial_send_byte(serial_hash_byteL);
    caml_serial_send_byte(serial_hash_byteH);
    return caml_serial_send_continue(v);
  }
  case SERIAL_ENDTIC_FLAG:
    if(serial_tictac == TIC){
      caml_serial_send_flag(SERIAL_ENDTIC_FLAG);
      return caml_serial_send_end();
    }else{
      return caml_serial_send_(v);
    }
  case SERIAL_ENDTAC_FLAG:
    if(serial_tictac == TAC){
      caml_serial_send_flag(SERIAL_ENDTAC_FLAG);
      return caml_serial_send_end();
    }else{
      return caml_serial_send_(v);
    }
  default:
    return caml_serial_send_(v);
  }
}

static value caml_serial_send_block(value v){
  unsigned char adrL, adrH, hashL, hashH;
  caml_compute_hash_init();
  adrL = caml_serial_receive_byte();
  caml_compute_hash_step(adrL);
  adrH = caml_serial_receive_byte();
  caml_compute_hash_step(adrH);
  hashL = caml_serial_receive_byte();
  hashH = caml_serial_receive_byte();
  if(hashL != serial_hash_byteL || hashH != serial_hash_byteH){
    return caml_serial_send_(v);
  }else{
    return caml_serial_send_block_tagsize(v, (adrH << 8) | adrL);
  }
}

static value caml_serial_send_block_tagsize(value v, int adr){
  value val = caml_serial_send_buffer_get(adr);
  tag_t tag = Tag_val(val);
  mlsize_t size;
  if(tag == String_tag){
    size = caml_string_length(val) / 2 + 1;
  }else if(tag == Double_array_tag){
    size = 2 * Wosize_val(val) / Double_wosize;
  }else{
    size = Wosize_val(val);
  }
  if(size > 255){
    fprintf(stderr, "caml_serial_send: too big object in heap\n");
    exit(1);
  }
  caml_compute_hash_init();
  caml_serial_send_byte(tag);
  caml_compute_hash_step(tag);
  caml_serial_send_byte(size);
  caml_compute_hash_step(size);
  caml_serial_send_byte(serial_hash_byteL);
  caml_serial_send_byte(serial_hash_byteH);
  return caml_serial_send_block_data_start(v, adr, tag, size);
}

static value caml_serial_send_block_data_start(value v, int adr, tag_t tag,
                                               mlsize_t size){
  caml_compute_hash_init();
  return caml_serial_send_block_data_loop(v, adr, tag, size);
}

static value caml_serial_send_block_data_loop(value v, int adr, tag_t tag,
                                              mlsize_t size){
  value curv = caml_serial_send_buffer_get(adr);
  switch(tag){
  case Lazy_tag:
    fprintf(stderr, "caml_serial_send: serialization of a lazy block\n");
    exit(1);
  case Closure_tag:
    fprintf(stderr, "caml_serial_send: serialization of a closure\n");
    exit(1);
  case Object_tag:
    fprintf(stderr, "caml_serial_send: serialization of an object\n");
    exit(1);
  case Infix_tag:
    fprintf(stderr, "caml_serial_send: serialization of an infix block\n");
    exit(1);
  case Forward_tag:
    fprintf(stderr, "caml_serial_send: serialization of a forward block\n");
    exit(1);
  case Abstract_tag:
    fprintf(stderr, "caml_serial_send: serialization of an abstract block\n");
    exit(1);
  case String_tag: {
    int i;
    int len = caml_string_length(curv);
    for(i = 0 ; i < len ; i ++){
      char c = *((char *) curv + i);
      caml_serial_send_byte(c);
      caml_compute_hash_step(c);
    }
    caml_serial_send_byte(0);
    caml_compute_hash_step(0);
    if(len % 2 == 0){
      caml_serial_send_byte(1);
      caml_compute_hash_step(1);
    }
    break;
  }
  case Double_tag: {
    int i;
    int32_t data = caml_serial_convert_float(Double_val(curv));
    for(i = 0 ; i < 4 ; i ++){
      caml_serial_send_byte(data & 0xFF);
      caml_compute_hash_step(data & 0xFF);
      data >>= 8;
    }
    break;
  }
  case Double_array_tag: {
    int j;
    for(j = 0 ; j < size / 2 ; j ++){
      int i;
      int32_t data = caml_serial_convert_float(Double_field(curv, j));
      for(i = 0 ; i < 4 ; i ++){
        caml_serial_send_byte(data & 0xFF);
        caml_compute_hash_step(data & 0xFF);
        data >>= 8;
      }
    }
    break;
  }
  case Custom_tag: {
    char *id = Custom_ops_val(curv)->identifier;
    if(!strcmp(id, "_i")){
      int i;
      int32_t n = Int32_val(curv);
      for(i = 0 ; i < 4 ; i ++){
        caml_serial_send_byte(n & 0xFF);
        caml_compute_hash_step(n & 0xFF);
        n >>= 8;
      }
    }else if(!strcmp(id, "_j")){
      int i;
      int64_t n = Int64_val(curv);
      for(i = 0 ; i < 8 ; i ++){
        caml_serial_send_byte(n & 0xFF);
        caml_compute_hash_step(n & 0xFF);
        n >>= 8;
      }
    }else{
      fprintf(stderr, "caml_serial_send: serialization of a custom block\n");
      exit(1);
    }
    break;
  }
  default: {
    int i;
    for(i = 0 ; i < size ; i ++){
      value f = Field(curv, i);
      int data;
      if(Is_block(f)){
        if(Wosize_val(f) == 0){
          data = ATOM0_ADR;
        }else{
          data = caml_serial_send_buffer_store(f);
        }
      }else{
        data = Long_val(f);
        if(data < -16384 || 16383 < data){
          fprintf(stderr, "caml_serial_send: too big integer in heap\n");
          exit(1);
        }
        data = (data << 1) | 1;
      }
      caml_serial_send_byte(data & 0xFF);
      caml_compute_hash_step(data & 0xFF);
      caml_serial_send_byte((data >> 8) & 0xFF);
      caml_compute_hash_step((data >> 8) & 0xFF);
    }
  }
  }
  caml_serial_send_byte(serial_hash_byteL);
  caml_serial_send_byte(serial_hash_byteH);
  return caml_serial_send_continue(v);
}

static value caml_serial_send_continue(value v){
  switch(caml_serial_receive_flag()){
  case SERIAL_GET_FLAG:
    return caml_serial_send_block(v);
  case SERIAL_ENDTIC_FLAG:
    if(serial_tictac == TIC){
      caml_serial_send_flag(SERIAL_ENDTIC_FLAG);
      return caml_serial_send_end();
    }else{
      return caml_serial_send_(v);
    }
  case SERIAL_ENDTAC_FLAG:
    if(serial_tictac == TAC){
      caml_serial_send_flag(SERIAL_ENDTAC_FLAG);
      return caml_serial_send_end();
    }else{
      return caml_serial_send_(v);
    }
  default:
    return caml_serial_send_(v);
  }
}

static value caml_serial_send_end(void){
  caml_serial_inv_tictac();
  return Val_unit;
}
