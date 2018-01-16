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

#include <caml/mlvalues.h>
#include <sys/time.h>
#include <stdio.h>
#include <time.h>
#include "shared.h"
#include "simu.h"

#define NB_REG 255
#define NB_PORT 5
#define LOWER_PORT 0x0
#define HIGHER_PORT (LOWER_PORT + NB_PORT - 1)
#define LOWER_DDR (HIGHER_PORT + 1)
#define HIGHER_DDR (LOWER_DDR + NB_PORT -1)
#define LOWER_PIN (HIGHER_DDR + 1)
#define HIGHER_PIN (LOWER_PIN + NB_PORT - 1)
#define LOWER_LAT 0x9
#define HIGHER_LAT (LOWER_LAT + NB_PORT - 1)
#define LOWER_TRIS 0x12
#define HIGHER_TRIS (LOWER_TRIS + NB_PORT - 1)
#define ADCON0 0x42
#define ADCON1 0x41
#define ADCON2 0x40
#define ADRESL 0x43
#define ADRESH 0x44

static unsigned char *regs;
static unsigned int *analogs;
static int *sync_counter;
static int sem_regs;
static int sem_sync;
static int sem_done;
static int nb_proc;
static int is_slow;


void init_regs(int n, int slow){
  int i;
  regs = (unsigned char *) alloc_shm(NB_REG * sizeof(unsigned char));
  /* analogs = (unsigned int *) alloc_shm(16 * sizeof(unsigned int)); */
  sync_counter = (int *) alloc_shm(sizeof(int));
  *sync_counter = 0;
  is_slow = slow;
  sem_regs = create_sem(1);
  sem_sync = create_sem(1);
  sem_done = create_sem(0);
  nb_proc = n;
  for(i = 0 ; i < NB_REG ; i ++) regs[i] = 0x00;
  /* regs[0x71] = 0xFF; // INTCON2 */
  /* regs[0x70] = 0xC0; // INTCON3 */
  /* regs[0x55] = 0xFF; // T0CON */
  /* regs[0x53] = 0x40; // OSCCON */
  /* regs[0x52] = 0x05; // HLVDCON */
  /* regs[0x50] = 0x1C; // RCON */
  /* regs[0x4B] = 0xFF; // PR2 */
  /* regs[0x38] = 0x40; // BAUDCON */
  /* regs[0x34] = 0x07; // CMCON */
  /* regs[0x2C] = 0x02; // TXSTA */
  /* regs[0x22] = 0xFF; // IPR2 */
  /* regs[0x1F] = 0xFF; // IPR1 */
  /* regs[0x16] = 0x0F; // TRISE */
  /* regs[0x15] = 0xFF; // TRISD */
  /* regs[0x14] = 0xFF; // TRISC */
  /* regs[0x13] = 0xFF; // TRISB */
  /* regs[0x12] = 0xFF; // TRISA */
}

void destroy_regs(void){
  destroy_sem(sem_regs);
  destroy_sem(sem_sync);
  destroy_sem(sem_done);
}

void dump_regs(void){
  int i, j;
  P(sem_regs);
  for(i = LOWER_PORT ; i <= HIGHER_PORT ; i ++){
    printf("%c: 0b", 'A' + i);
    for(j = 7 ; j >= 0 ; j --) printf("%d", (regs[i] & (1 << j)) != 0);
    printf("  = %3d  = 0x%02x\n", regs[i], regs[i]);
  }
  V(sem_regs);
}

static int int_of_hexchar(char c){
  if(c >= '0' && c <= '9') return c - '0';
  if(c >= 'A' && c <= 'F') return c - 'A' + 10;
  if(c >= 'a' && c <= 'f') return c - 'a' + 10;
  return -1;
}

static char hexchar_of_int(int n){
  n &= 0x0F;
  if(n < 10) return '0' + n;
  return 'A' + n - 10;
}

/******************************/

static void micro_sleep(unsigned long usec){
  struct timespec t;
  t.tv_sec  = usec / 1000000;
  t.tv_nsec = (1000 * usec) % 1000000000;
  nanosleep(&t, NULL);
}

static unsigned long elapsed_time(void){
  return (unsigned long) clock() * 1000000 / CLOCKS_PER_SEC;
}

static void may_sleep(){
  static unsigned long mem_elpt = 0;
  if(is_slow){
    unsigned long elpt = elapsed_time();
    if(elpt - mem_elpt > 100){
      unsigned long usec = (elpt - mem_elpt) * 4;
      micro_sleep(usec);
      mem_elpt = elapsed_time();
    }
  }
}

/******************************/

static void send_write(char cmnd, int port, unsigned char val){
  char buf[5];
  buf[0] = cmnd;
  buf[1] = port + 'A';
  buf[2] = hexchar_of_int((val >> 4) & 0x0F);
  buf[3] = hexchar_of_int(val & 0x0F);
  buf[4] = '\n';
  send_all_proc(buf, 5);
}

static void send_write_port(int port, unsigned char val){
  send_write('W', port, val);
}

static void send_write_tris(int tris, unsigned char val){
  send_write('T', tris - LOWER_TRIS, val);
}

static void send_config_analogs(void){
  static unsigned int old_analog_nb = 0xFFFF;
  unsigned int analog_nb = 0;
  if((regs[ADCON0] & 1) != 0){
    analog_nb = 0xF - (regs[ADCON1] & 0xF);
    if (analog_nb > 13) analog_nb = 13;
  }
  if (old_analog_nb != analog_nb) {
    char buf[3];
    old_analog_nb = analog_nb;
    buf[0] = 'C';
    buf[1] = hexchar_of_int(analog_nb);
    buf[2] = '\n';
    send_all_proc(buf, 3);
  }
}

static void send_set_analog(unsigned int chan, unsigned int val){
  char buf[6];
  buf[0] = 'A';
  buf[1] = hexchar_of_int(chan);
  buf[2] = hexchar_of_int((val >> 8) & 0x0F);
  buf[3] = hexchar_of_int((val >> 4) & 0x0F);
  buf[4] = hexchar_of_int(val & 0x0F);
  buf[5] = '\n';
  send_all_proc(buf, 6);
}

/**************/

static void pic_write_reg_gen(int reg, unsigned char new_val){
  unsigned char old_val = regs[reg];
  if(reg >= LOWER_PORT && reg <= HIGHER_PORT){
    int lat = reg - LOWER_PORT + LOWER_LAT;
    regs[lat] = new_val;
    if(old_val != new_val){
      int tris = reg - LOWER_PORT + LOWER_TRIS;
      unsigned char tris_val = regs[tris];
      if(tris_val == 0xFF){
        char port_c = 'A' + reg - LOWER_PORT;
        fprintf(stderr, "Warning: the pic writes PORT%c when TRIS%c=0xFF\n",
                port_c, port_c);
      }else{
        int bit;
        unsigned char new_port_val = old_val;
        for(bit = 0 ; bit < 8 ; bit ++){
          unsigned char mask = 1 << bit;
          if(!(tris_val & mask)){
            if(new_val & mask)
              new_port_val |= mask;
            else
              new_port_val &= ~mask;
          }
        }
        if(new_port_val != old_val){
          regs[reg] = new_port_val;
          send_write_port(reg, new_port_val);
        }
      }
    }
  }else if(reg >= LOWER_LAT && reg <= HIGHER_LAT){
    if(old_val != new_val){
      int bit;
      int port = reg - LOWER_LAT + LOWER_PORT;
      int tris = reg - LOWER_LAT + LOWER_TRIS;
      unsigned char old_port_val = regs[port];
      unsigned char new_port_val = old_port_val;
      unsigned char tris_val = regs[tris];
      for(bit = 0 ; bit < 8 ; bit ++){
        unsigned char mask = 1 << bit;
        if(!(tris_val & mask)){
          if(new_val & mask)
            new_port_val |= mask;
          else
            new_port_val &= ~mask;
        }
      }
      if(old_port_val != new_port_val){
        regs[port] = new_port_val;
        send_write_port(port, new_port_val);
      }
      regs[reg] = new_val;
    }
  }else if(reg >= LOWER_TRIS && reg <= HIGHER_TRIS){
    if(old_val != new_val){
      int bit;
      int port = reg - LOWER_TRIS + LOWER_PORT;
      int lat = reg - LOWER_TRIS + LOWER_LAT;
      unsigned char old_port_val = regs[port];
      unsigned char new_port_val = old_port_val;
      unsigned char lat_val = regs[lat];
      for(bit = 0 ; bit < 8 ; bit ++){
        unsigned char mask = 1 << bit;
        if((old_val & mask) && !(new_val & mask)){
          if(lat_val & mask)
            new_port_val |= mask;
          else
            new_port_val &= ~mask;
        }
      }
      if(old_port_val != new_port_val){
        regs[port] = new_port_val;
        send_write_port(port, new_port_val);
      }
      send_write_tris(reg, new_val);
      regs[reg] = new_val;
    }
  }else if(reg == ADCON0){
    unsigned int chan = (new_val >> 2) & 0xF;
    regs[reg] = new_val;
    send_config_analogs();
    if((new_val & 0x3) != 0){
      if(chan + (regs[ADCON1] & 0xF) >= 0xF || (regs[ADCON2] & (1 << 7)) == 0 || chan > 12)
        fprintf(stderr, "Warning: invalid analog read (ADCON0=0x%02X, ADCON1=0x%02X, ADCON2=0x%02X)\n",
                regs[ADCON0], regs[ADCON1], regs[ADCON2]);
      regs[ADRESH] = analogs[chan] >> 8;
      regs[ADRESL] = analogs[chan] & 0xFF;
      regs[ADCON0] &= 0xFD;
    }
  }else if(reg == ADCON1 || reg == ADCON2){
    regs[reg] = new_val;
    send_config_analogs();
  }else{
    regs[reg] = new_val;
  }
  may_sleep();
}

/**************/

void pic_write_reg(int reg, unsigned char new_val){
  P(sem_regs);
  pic_write_reg_gen(reg, new_val);
  V(sem_regs);
}

void pic_clear_bit(int reg, int bit){
  P(sem_regs);
  {
    unsigned char old_val = regs[reg];
    unsigned char mask = 1 << bit;
    unsigned char new_val = old_val & ~mask;
    if(reg >= LOWER_PORT && reg <= HIGHER_PORT){
      int lat = reg - LOWER_PORT + LOWER_LAT;
      regs[lat] &= ~mask;
      if(old_val != new_val){
        int tris = reg - LOWER_PORT + LOWER_TRIS;
        unsigned char tris_val = regs[tris];
        if(tris_val & mask){
          char port_c = 'A' + reg - LOWER_PORT;
          fprintf(stderr,
                  "Warning: the pic clears PORT%c.R%c%d when TRIS%c=0x%02X\n",
                  port_c, port_c, bit, port_c, tris_val);
        }else{
          regs[reg] = new_val;
          send_write_port(reg, new_val);
        }
      }
    }else if(reg >= LOWER_LAT && reg <= HIGHER_LAT){
      if(old_val != new_val){
        int port = reg - LOWER_LAT + LOWER_PORT;
        int tris = reg - LOWER_LAT + LOWER_TRIS;
        unsigned char tris_val = regs[tris];
        regs[reg] = new_val;
        if(!(tris_val & mask)){
          int old_port_val = regs[port];
          int new_port_val = old_port_val & ~mask;
          if(old_port_val != new_port_val){
            regs[port] = new_port_val;
            send_write_port(port, new_port_val);
          }
        }
      }
    }else if(reg >= LOWER_TRIS && reg <= HIGHER_TRIS){
      if(old_val != new_val){
        int port = reg - LOWER_TRIS + LOWER_PORT;
        int lat = reg - LOWER_TRIS + LOWER_LAT;
        unsigned char port_val = regs[port];
        unsigned char lat_val = regs[lat];
        if((port_val & mask) != (lat_val & mask)){
          if(lat_val & mask)
            port_val |= mask;
          else
            port_val &= ~mask;
          regs[port] = port_val;
          send_write_port(port, port_val);
        }
        regs[reg] = new_val;
        send_write_tris(reg, new_val);
      }
    }else if(reg == ADCON0 || reg == ADCON1 || reg == ADCON2){
      regs[reg] = new_val;
      send_config_analogs();
    }else{
      regs[reg] = new_val;
    }
  }
  V(sem_regs);
  may_sleep();
}

void avr_set_bit(int reg,int bit){
  init_simulator();
  
  P(sem_regs);
  unsigned char old_val = regs[reg];
  unsigned char mask = 1 << bit;
  unsigned char new_val = old_val | mask;
  regs[reg] = new_val;
  send_write_port(reg,new_val);
  printf("set bit %d on reg %d \n", bit, reg);
  V(sem_regs);
}

void pic_set_bit(int reg, int bit){
  P(sem_regs);
  {
    unsigned char old_val = regs[reg];
    unsigned char mask = 1 << bit;
    unsigned char new_val = old_val | mask;
    if(reg >= LOWER_PORT && reg <= HIGHER_PORT){
      int lat = reg - LOWER_PORT + LOWER_LAT;
      regs[lat] |= mask;
      if(old_val != new_val){
        int tris = reg - LOWER_PORT + LOWER_TRIS;
        unsigned char tris_val = regs[tris];
        if(tris_val & mask){
          char port_c = 'A' + reg - LOWER_PORT;
          fprintf(stderr, "Warning: the pic sets PORT%c.R%c%d when TRIS%c=0x%02X\n",
                  port_c, port_c, bit, port_c, tris_val);
        }else{
          regs[reg] = new_val;
          send_write_port(reg, new_val);
        }
      }
    }else if(reg >= LOWER_LAT && reg <= HIGHER_LAT){
      if(old_val != new_val){
        unsigned char mask = 1 << bit;
        int port = reg - LOWER_LAT + LOWER_PORT;
        int tris = reg - LOWER_LAT + LOWER_TRIS;
        unsigned char tris_val = regs[tris];
        regs[reg] = new_val;
        if(!(tris_val & mask)){
          int old_port_val = regs[port];
          int new_port_val = old_port_val | mask;
          if(old_port_val != new_port_val){
            regs[port] = new_port_val;
            send_write_port(port, new_port_val);
          }
        }
      }
    }else if(reg >= LOWER_TRIS && reg <= HIGHER_TRIS){
      if(old_val != new_val){
        regs[reg] = new_val;
        send_write_tris(reg, new_val);
      }
    }else if(reg == ADCON0 && bit == 1){
      unsigned int chan = (new_val >> 2) & 0xF;
      regs[reg] = new_val;
      send_config_analogs();
      if((new_val & 0x1) != 0){
        if(chan + (regs[ADCON1] & 0xF) >= 0xF || (regs[ADCON2] & (1 << 7)) == 0 || chan > 12)
          fprintf(stderr, "Warning: invalid analog read (ADCON0=0x%02X, ADCON1=0x%02X, ADCON2=0x%02X)\n",
                  regs[ADCON0], regs[ADCON1], regs[ADCON2]);
        regs[ADRESH] = analogs[chan] >> 8;
        regs[ADRESL] = analogs[chan] & 0xFF;
        regs[ADCON0] &= 0xFD;
      }
    }else if(reg == ADCON0 || reg == ADCON1 || reg == ADCON2){
      regs[reg] = new_val;
      send_config_analogs();
    }else{
      regs[reg] = new_val;
    }
  }
  V(sem_regs);
  may_sleep();
}

/******************************/

value caml_pic_write_reg(value vreg, value vval){
  unsigned int reg = Long_val(vreg);
  unsigned int val = Long_val(vval);
  init_simulator();
  pic_write_reg(reg, val);
  return Val_unit;
}

value caml_pic_clear_bit(value vbit){
  init_simulator();
  P(sem_regs);
  {
    unsigned int reg = Long_val(vbit) & 0x7F;
    unsigned int mask = Long_val(vbit) >> 7;
    pic_write_reg_gen(reg, regs[reg] & ~mask);
  }
  V(sem_regs);
  return Val_unit;
}

value caml_pic_set_bit(value vbit){
  init_simulator();
  P(sem_regs);
  {
    unsigned int reg = Long_val(vbit) & 0x7F;
    unsigned int mask = Long_val(vbit) >> 7;
    pic_write_reg_gen(reg, regs[reg] | mask);
  }
  V(sem_regs);
  return Val_unit;
}

/******************************/

static int is_reg_need_synchro(unsigned int reg){
  return
    (reg >= LOWER_PORT && reg <= HIGHER_PORT) ||
    (reg >= LOWER_LAT  && reg <= HIGHER_LAT)  ||
    (reg == ADCON0);
}

static void synchronize(){
  P(sem_sync);
  *sync_counter = nb_proc;
  V(sem_sync);
  send_all_proc("SYNC\n", 5);
  if(nb_proc != 0) P(sem_done);
  may_sleep();
}

value caml_pic_read_reg(value reg){
  unsigned int val;
  init_simulator();
  if (is_reg_need_synchro(Long_val(reg))) synchronize();
  P(sem_regs);
  val = regs[Long_val(reg)];
  V(sem_regs);
  may_sleep();
  return Val_long(val);
}

value caml_pic_test_bit(value bit){
  unsigned int reg = Long_val(bit) & 0x7F;
  unsigned int mask = Long_val(bit) >> 7;
  unsigned int val;
  init_simulator();
  if (is_reg_need_synchro(reg)) synchronize();
  P(sem_regs);
  val = (regs[reg] & mask) != 0;
  V(sem_regs);
  may_sleep();
  return Val_long(val);
}

/******************************/

value caml_pic_tris_of_port(value port_or_bit){
  unsigned int reg = Long_val(port_or_bit) & 0x7F;
  unsigned int mask = Long_val(port_or_bit) >> 7;
  may_sleep();
  if(reg >= LOWER_PORT && reg <= HIGHER_PORT){
    return Val_long((mask << 7) | (reg + LOWER_TRIS));
  }else if(reg >= LOWER_LAT && reg <= HIGHER_LAT){
    return Val_long((mask << 7) | (reg - LOWER_LAT + LOWER_TRIS));
  }else{
    fprintf(stderr, "Error: tris_of_port(0x%0x): not a port\n", reg);
    return Val_long(LOWER_TRIS);
  }
}

/******************************/

static void out_write_port(int port, unsigned char new_val){
  P(sem_regs);
  {
    int tris = port - LOWER_PORT + LOWER_TRIS;
    int tris_val = regs[tris];
    int old_val = regs[port];
    if((new_val & ~tris_val) != 0x00){
      char port_c = 'A' + port - LOWER_PORT;
      fprintf(stderr,
              "Warning: an outside component writes PORT%c=0x%02X when TRIS%c=0x%02X\n",
              port_c, new_val, port_c, tris_val);
    }
    if(new_val != old_val){
      regs[port] = new_val;
      send_write_port(port, new_val);
    }
  }
  V(sem_regs);
  may_sleep();
}

static void out_clear_port_bit(int port, int bit){
  P(sem_regs);
  {
    int mask = 1 << bit;
    int tris = port - LOWER_PORT + LOWER_TRIS;
    int tris_val = regs[tris];
    int old_val = regs[port];
    int new_val = old_val & ~mask;
    if(!(tris_val & mask)){
      char port_c = 'A' + port - LOWER_PORT;
      fprintf(stderr,
        "Warning: an outside component clears PORT%c.R%c%d when TRIS%c=0x%02X\n",
              port_c, port_c, bit, port_c, tris_val);
    }
    if(old_val != new_val){
      regs[port] = new_val;
      send_write_port(port, new_val);
    }
  }
  V(sem_regs);
  may_sleep();
}

static void out_set_port_bit(int port, int bit){
  P(sem_regs);
  {
    int mask = 1 << bit;
    int tris = port - LOWER_PORT + LOWER_TRIS;
    int tris_val = regs[tris];
    int old_val = regs[port];
    int new_val = old_val | mask;
    if(!(tris_val & mask)){
      char port_c = 'A' + port - LOWER_PORT;
      fprintf(stderr,
        "Warning: an outside component sets PORT%c.R%c%d when TRIS%c=0x%02X\n",
              port_c, port_c, bit, port_c, tris_val);
    }
    if(old_val != new_val){
      regs[port] = new_val;
      send_write_port(port, new_val);
    }
  }
  V(sem_regs);
  may_sleep();
}

static void out_set_analog(unsigned int chan, unsigned int val){
  P(sem_regs);
  {
    if(val != analogs[chan]){
      analogs[chan] = val;
      send_set_analog(chan, val);
    }
  }
  V(sem_regs);
  may_sleep();
}

/**************/

static void invalid_instr(char *instr){
  fprintf(stderr, "Invalid instruction: '%s'\n", instr);
}

void exec_instr(char *instr, int size){
  if(size < 3){
    invalid_instr(instr);
  }else if((size == 4) &&
           (instr[0] == 'D' || instr[0] == 'd') &&
           (instr[1] == 'O' || instr[1] == 'o') &&
           (instr[2] == 'N' || instr[2] == 'n') &&
           (instr[3] == 'E' || instr[3] == 'e')){
    P(sem_sync);
    *sync_counter = *sync_counter - 1;
    if(*sync_counter == 0) V(sem_done);
    V(sem_sync);
  }else if(size == 5 && instr[0] == 'A'){
    int chan, h2, h1, h0, val;
    chan = int_of_hexchar(instr[1]);
    if(chan == -1 || chan > 12){
      invalid_instr(instr);
      return;
    }
    h2 = int_of_hexchar(instr[2]);
    h1 = int_of_hexchar(instr[3]);
    h0 = int_of_hexchar(instr[4]);
    val = 16 * 16 * h2 + 16 * h1 + h0;
    if(h2 == -1 || h1 == -1 || h0 == -1 || val >= (1 << 10)){
      invalid_instr(instr);
      return;
    }
    out_set_analog(chan, val);
  }else{
    int port;
    if(instr[1] >= 'A' && instr[1] <= ('A' + HIGHER_PORT - LOWER_PORT)){
      port = instr[1] - 'A' + LOWER_PORT;
    }else if(instr[1] >= 'a' && instr[1] <= ('a' + HIGHER_PORT - LOWER_PORT)){
      port = instr[1] - 'a' + LOWER_PORT;
    }else{
      invalid_instr(instr);
      return;
    }
    switch(instr[0]){
    case 'W':
    case 'w':
      if(size != 4) invalid_instr(instr);
      else{
        int h1 = int_of_hexchar(instr[2]);
        int h0 = int_of_hexchar(instr[3]);
        if (h1 == -1 || h0 == -1) {
          invalid_instr(instr);
          return;
        }
        out_write_port(port, 16 * h1 + h0);
      }
    break;
    case 'C':
    case 'c':
      if(size != 3 || instr[2] < '0' || instr[2] > '7') invalid_instr(instr);
      else {
        out_clear_port_bit(port, instr[2] - '0');
      }
    break;
    case 'S':
    case 's':
      if(size != 3 || instr[2] < '0' || instr[2] > '7') invalid_instr(instr);
      else {
        out_set_port_bit(port, instr[2] - '0');
      }
    break;
    default:
      invalid_instr(instr);
    }
  }
}
