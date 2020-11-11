#include <sys/time.h>
#include <unistd.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <time.h>
#include "shared.h"
#include "simul.h"

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#define NB_REG 255
#define NB_PORT 11
#define LOWER_PORT 0x0
#define HIGHER_PORT (LOWER_PORT + NB_PORT - 1)
#define LOWER_DDR (HIGHER_PORT + 1)
#define HIGHER_DDR (LOWER_DDR + NB_PORT - 1)
#define LOWER_PIN (HIGHER_DDR + 1)
#define HIGHER_PIN (LOWER_PIN + NB_PORT - 1)


#define PORTA 0
#define PORTB 1
#define PORTC 2
#define PORTD 3
#define PORTE 4
#define PORTF 5
#define PORTG 6
#define PORTH 7
#define PORTI 8
#define PORTJ 9
#define PORTK 10
#define PORTL 11

#define DDRA 12
#define DDRB 13
#define DDRC 14
#define DDRD 15
#define DDRE 16
#define DDRF 17
#define DDRG 18
#define DDRH 19
#define DDRI 20
#define DDRJ 21
#define DDRK 22
#define DDRL 23

#define PINA 24
#define PINB 25
#define PINC 26
#define PIND 27
#define PINE 28
#define PINF 29
#define PING 30
#define PINH 31
#define PINI 32
#define PINJ 33
#define PINK 34
#define PINL 35


#define SPSR 36
#define SPDR 37

static unsigned char *regs;
static unsigned int *analogs;
static int *sync_counter;
static int sem_regs;
static int sem_sync;
static int sem_done;
static int proc_nb;
static int is_slow;

#define INPUT 0x0
#define OUTPUT 0x1

/* On AVR : PORT = output / PIN = intput / DDR = data direction */
/* and output = 1 / input = 0 */

void init_regs(int n, int slow){
  int i;
  regs = (unsigned char *) alloc_shm(NB_REG * sizeof(unsigned char));
  analogs = (unsigned int *) alloc_shm(16 * sizeof(unsigned int));
  sync_counter = (int *) alloc_shm(sizeof(int));
  *sync_counter = 0;
  is_slow = slow;
  sem_regs = create_sem(1);
  sem_sync = create_sem(1);
  sem_done = create_sem(0);
  proc_nb = n;
  for(i = 0 ; i < NB_REG ; i ++) regs[i] = 0x00;
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
  /* printf("sending write %d = %d \n", port, val); */
  send_write('W', port, val);
}

static void send_write_ddr(int ddr, unsigned char val){
  send_write('T', ddr - LOWER_DDR, val);
}


/* static void send_config_analogs(void){ */
  /* static unsigned int old_analog_nb = 0xFFFF; */
  /* unsigned int analog_nb = 0; */
  /* if((regs[ADCON0] & 1) != 0){ */
  /*   analog_nb = 0xF - (regs[ADCON1] & 0xF); */
  /*   if (analog_nb > 13) analog_nb = 13; */
  /* } */
  /* if (old_analog_nb != analog_nb) { */
  /*   char buf[3]; */
  /*   old_analog_nb = analog_nb; */
  /*   buf[0] = 'C'; */
  /*   buf[1] = hexchar_of_int(analog_nb); */
  /*   buf[2] = '\n'; */
  /*   send_all_proc(buf, 3); */
  /* } */
/* } */

static void send_set_analog(unsigned int chan, unsigned int val){
  fprintf(stderr,"SET ANALOG %d to %d",chan,val);
  char buf[6];
  buf[0] = 'Z';
  buf[1] = hexchar_of_int(chan);
  buf[2] = hexchar_of_int((val >> 8) & 0x0F);
  buf[3] = hexchar_of_int((val >> 4) & 0x0F);
  buf[4] = hexchar_of_int(val & 0x0F);
  buf[5] = '\n';
  send_all_proc(buf, 6);
}

/**************/

static void synchronize(){
  P(sem_sync);
  *sync_counter = proc_nb;
  V(sem_sync);
  send_all_proc("SYNC\n", 5);
  if(proc_nb != 0) P(sem_done);
  may_sleep();
}

static int is_reg_need_synchro(uint8_t reg){
  return
    (reg >= LOWER_PORT && reg <= HIGHER_PORT);
}

static void write_register_gen(int reg, uint8_t new_val){
  uint8_t old_val = regs[reg];
  if(reg >= LOWER_PORT && reg <= HIGHER_PORT){
    if(old_val != new_val){
      int ddr = reg - LOWER_PORT + LOWER_DDR;
      uint8_t ddr_val = regs[ddr];
      if(ddr_val == 0x00){
        char port_c = 'A' + reg - LOWER_PORT;
        fprintf(stderr, "Warning: the avr writes PORT%c when DDR%c=0xFF\n",
                port_c, port_c);
      }else{
	regs[reg] = new_val;
	send_write_port(reg, new_val);
      }
    }
  }
  else if(reg >= LOWER_DDR && reg <= HIGHER_DDR){
    if(old_val != new_val){
      send_write_ddr(reg, new_val);
      regs[reg] = new_val;
    }
  }
  else if(reg == SPDR){
    regs[reg] = new_val;
    send_write_port('G'-'A',new_val);
  }
  else{
    regs[reg] = new_val;
  }
  may_sleep();
}

void write_register(uint8_t reg, uint8_t new_val){
  printf("write_register(%d, %d)\n", (int) reg, (int) new_val);
  init_simulator();
  P(sem_regs);
  write_register_gen(reg, new_val);
  V(sem_regs);
}

uint8_t read_register(uint8_t reg){
  printf("read_register(%d)\n", (int) reg); 
  uint8_t val;
  init_simulator();
  if (is_reg_need_synchro(reg)) synchronize();
  P(sem_regs);
  val = regs[reg];
  V(sem_regs);
  may_sleep();
  return val;
}

bool read_bit(uint8_t reg, uint8_t bit){
  printf("read_bit(%d, %d)\n", (int) reg, (int) bit);
  /* Dirty hack  */
  if (reg == SPSR){
      return 1;
  }
  uint8_t mask = 1 << bit;
  uint8_t val;
  init_simulator();
  if (is_reg_need_synchro(reg)) synchronize();
  P(sem_regs);
  /* the simulator doesnt change PINs, only PORTs ...  */
  val = (regs[reg-LOWER_PIN] & mask) != 0;
  V(sem_regs);
  may_sleep();
  return val;
}

void clear_bit(uint8_t reg, uint8_t bit){
  printf("clear_bit(%d, %d)\n", (int) reg, (int) bit);  
  init_simulator();
  P(sem_regs);
  {
    uint8_t old_val = regs[reg];
    uint8_t mask = 1 << bit;
    uint8_t new_val = old_val & ~mask;
    if(reg >= LOWER_PORT && reg <= HIGHER_PORT){
      if(old_val != new_val){
        int ddr = reg - LOWER_PORT + LOWER_DDR;
        uint8_t ddr_val = regs[ddr];
        if(!(ddr_val & mask)){
          char port_c = 'A' + reg - LOWER_PORT;
          fprintf(stderr,
                  "Warning: the avr clears PORT%c.R%c%d when DDR%c=0x%02X\n",
                  port_c, port_c, bit, port_c, ddr_val);
        }else{
          regs[reg] = new_val;
          send_write_port(reg, new_val);
        }
      }
    } else if(reg >= LOWER_DDR && reg <= HIGHER_DDR){
      if(old_val != new_val){
        regs[reg] = new_val;
        send_write_ddr(reg, new_val);
      }
    }else{
      regs[reg] = new_val;
    }
  }
  V(sem_regs);
  may_sleep();
}

void set_bit(uint8_t reg, uint8_t bit){
  printf("set_bit(%d, %d)\n", (int) reg, (int) bit); 
  init_simulator();
  P(sem_regs);
  uint8_t old_val = regs[reg];
  uint8_t mask = 1 << bit;
  uint8_t new_val = old_val | mask;
  if(reg >= LOWER_PORT && reg <= HIGHER_PORT){
    if (old_val != new_val){
      /* int ddr = reg - LOWER_PORT + LOWER_DDR; */
      /* uint8_t ddr_val = regs[ddr]; */
      /* Forced to remove this as with INPUT_PULLUP, the PORT is also set at the beginning : */
      /* if(!(ddr_val & mask)){ */
	/* char port_c = 'B' + reg - LOWER_PORT; */
	/* fprintf(stderr, "Warning: the avr sets PORT%c.R%c%d when DDR%c=0x%02X\n", */
		/* port_c, port_c, bit, port_c, ddr_val); */
      /* } */
      /* else { */
	regs[reg] = new_val;
	send_write_port(reg,new_val);
      /* } */
    }
  }
  else if (reg >= LOWER_DDR && reg <= HIGHER_DDR){
    if(old_val != new_val){
      regs[reg] = new_val;
      send_write_ddr(reg,new_val);
    }
  }
  else if (reg >= LOWER_PIN && reg <= HIGHER_PIN){
    char port_c = 'A' + reg - LOWER_PIN;
    fprintf(stderr, "Warning : PIN%c is only a read register, it shouldn't be written\n",
		port_c);
  }
  else{
  regs[reg] = new_val;
  /* send_write_port(reg,new_val); */ // don't send internal modifications
  }
  /* printf("set bit %d on reg %d \n", bit, reg); */
  V(sem_regs);
  may_sleep();
}

/***************************************************/

void delay(int ms) {
  printf("delay(%d)\n", ms);
  usleep((useconds_t) ms * 1000);
}

int millis() {
  printf("millis\n");
  return 0;
}

/******************************/

int pic_tris_of_port(int port_or_bit){
  /* unsigned int reg = Long_val(port_or_bit) & 0x7F; */
  /* unsigned int mask = Long_val(port_or_bit) >> 7; */
  /* may_sleep(); */
  /* if(reg >= LOWER_PORT && reg <= HIGHER_PORT){ */
  /*   return Val_long((mask << 7) | (reg + LOWER_TRIS)); */
  /* }else if(reg >= LOWER_LAT && reg <= HIGHER_LAT){ */
  /*   return Val_long((mask << 7) | (reg - LOWER_LAT + LOWER_TRIS)); */
  /* }else{ */
  /*   fprintf(stderr, "Error: tris_of_port(0x%0x): not a port\n", reg); */
  /*   return Val_long(LOWER_TRIS); */
  /* } */
  return 1;
}

/******************************/

static void out_write_port(int port, unsigned char new_val){
  P(sem_regs);
  {
    int ddr = port - LOWER_PORT + LOWER_DDR;
    int ddr_val = regs[ddr];
    int old_val = regs[port];
    if((new_val & ~ddr_val) != 0xFF){
      char port_c = 'A' + port - LOWER_PORT;
      fprintf(stderr,
              "Warning: an outside component writes PORT%c=0x%02X when TRIS%c=0x%02X\n",
              port_c, new_val, port_c, ddr_val);
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
    int ddr = port - LOWER_PORT + LOWER_DDR;
    int ddr_val = regs[ddr];
    int old_val = regs[port];
    int new_val = old_val & ~mask;
    if(ddr_val & mask){
      char port_c = 'A' + port - LOWER_PORT;
      fprintf(stderr,
        "Warning: an outside component clears PORT%c.R%c%d when TRIS%c=0x%02X\n",
              port_c, port_c, bit, port_c, ddr_val);
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
    int ddr = port - LOWER_PORT + LOWER_DDR;
    int ddr_val = regs[ddr];
    int old_val = regs[port];
    int new_val = old_val | mask;
    if(ddr_val & mask){
      char port_c = 'A' + port - LOWER_PORT;
      fprintf(stderr,
        "Warning: an outside component sets PORT%c.R%c%d when DDR%c=0x%02X\n",
              port_c, port_c, bit, port_c, ddr_val);
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
      fprintf(stderr,"I put %d in analog %d", val, chan);
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
  }else if(size == 5 && instr[0] == 'Z'){
    int chan, h2, h1, h0, val;
    chan = int_of_hexchar(instr[1]);
    if(chan == -1 || chan > 14){
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
