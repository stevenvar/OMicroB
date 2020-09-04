int r = 0;
int avr_random(int max){
  r = (r*109+89)%max;
  return r;
}

void avr_adc_init(){
  printf("adc init\n");
  init_simulator();
}

#include <unistd.h>

uint16_t avr_analog_read(uint8_t ch){
  /* printf("analog read (%d)\n", ch); */
  /* out_set_analog(ch,0b11111111); */
  /* usleep(50000); */
  /* out_set_analog(ch,analogs[ch]); */
  return analogs[ch];
}

/******************************************************************************/

void avr_serial_init(){
  init_simulator();
  printf("serial init\n");
  set_bit(DDRD,3);
}

char avr_serial_read(){
  printf("serial read\n");
  set_bit(PORTD,2);
  usleep(10000);
  clear_bit(PORTD,2);
  return '0';
}

void avr_serial_write(char c){
  printf("serial write(%c)\n",c);
  set_bit(PORTD,3);
  usleep(10000);
  clear_bit(PORTD,3);
}

/******************************************************************************/

void avr_timer_set_period(int num, unsigned int cmp) {
  printf("Setting period of %dms for timer %d\n", cmp, num);
}

void avr_timer_set_callback(int num, int closure) {
  printf("Setting callback for timer %d\n", num);
}
