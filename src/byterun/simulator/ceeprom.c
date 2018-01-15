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
#include <stdlib.h>
#include <caml/mlvalues.h>

#define EEPROM_SIZE 1024

#define EEPROM_FILENAME "eeprom.data"

static FILE *eeprom_file = NULL;

static void caml_eeprom_fputc(unsigned char c){
  if(fputc(c, eeprom_file) == EOF){
    fprintf(stderr, "failure: fputc()\n");
    exit(1);
  }
}

static unsigned char caml_eeprom_fgetc(void){
  int c;
  if((c = fgetc(eeprom_file)) == EOF){
    fprintf(stderr, "failure: fgetc()\n");
    exit(1);
  }
  return c;
}

static void caml_eeprom_fseek(long addr){
  if(fseek(eeprom_file, addr, SEEK_SET) != 0){
    fprintf(stderr, "failure: fseek()\n");
    exit(1);
  }
}

static unsigned char caml_int_of_hex(unsigned char c){
  if(c >= '0' && c <= '9'){
    return c - '0';
  }else if(c >= 'a' && c <= 'f'){
    return c - 'a' + 10;
  }else if(c >= 'A' && c <= 'F'){
    return c - 'A' + 10;
  }else{
    fprintf(stderr, "failure: invalid eeprom file\n");
    exit(1);
  }
}

static char caml_hex_of_int(unsigned char c){
  if(c < 10){
    return '0' + c;
  }else{
    return 'A' + c - 10;
  }
}

static void caml_check_eeprom_file(void){
  int i;
  rewind(eeprom_file);
  for(i = 0 ; i < EEPROM_SIZE / 8 ; i ++){
    int j;
    for(j = 0 ; j < 8 ; j ++){
      int l, h;
      if((h = fgetc(eeprom_file)) == EOF || (l = fgetc(eeprom_file)) == EOF){
        fprintf(stderr, "failure: invalid eeprom file\n");
        exit(1);
      }
      caml_int_of_hex(l);
      caml_int_of_hex(h);
      if(j != 7){
        if(fgetc(eeprom_file) != ' '){
          fprintf(stderr, "failure: invalid eeprom file\n");
          exit(1);
        }
      }
    }
    if(fgetc(eeprom_file) != '\n'){
      fprintf(stderr, "failure: invalid eeprom file\n");
      exit(1);
    }
  }
  if(fgetc(eeprom_file) != EOF){
    fprintf(stderr, "failure: invalid eeprom file\n");
    exit(1);
  }
}

static void caml_fill_eeprom_file(void){
  int i;
  rewind(eeprom_file);
  for(i = 0 ; i < EEPROM_SIZE / 8 ; i ++){
    int j;
    for(j = 0 ; j < 7 ; j ++){
      fprintf(eeprom_file, "00 ");
    }
    fprintf(eeprom_file, "00\n");
  }
}

static void caml_init_eeprom_file(void){
  if(eeprom_file == NULL){
    if((eeprom_file = fopen(EEPROM_FILENAME, "r+b")) == NULL){
      if((eeprom_file = fopen(EEPROM_FILENAME, "w+b")) == NULL){
        fprintf(stderr, "failure: fopen()\n");
        exit(1);
      }else{
        caml_fill_eeprom_file();
      }
    }else{
      caml_check_eeprom_file();
    }
  }
}

value caml_eeprom_read(value addr){
  unsigned char l, h;
  caml_init_eeprom_file();
  caml_eeprom_fseek(3 * Long_val(addr));
  h = caml_eeprom_fgetc();
  l = caml_eeprom_fgetc();
  return Val_long(caml_int_of_hex(l) + 16 * caml_int_of_hex(h));
}

value caml_eeprom_write(value addr, value val){
  caml_init_eeprom_file();
  caml_eeprom_fseek(3 * Long_val(addr));
  caml_eeprom_fputc(caml_hex_of_int(Long_val(val) / 16));
  caml_eeprom_fputc(caml_hex_of_int(Long_val(val) % 16));
  return Val_unit;
}

value caml_eeprom_get_size(value unit){
  return Val_long(EEPROM_SIZE);
}

value caml_eeprom_refresh(value unit){
  caml_init_eeprom_file();
  return Val_unit;
}
