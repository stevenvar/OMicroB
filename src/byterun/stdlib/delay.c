void delay(int count){
  #ifdef __AVR__
  while(count--) {
    _delay_ms(1);

  }
  #endif
  #ifdef __PC__
  usleep(count*1000);
  #endif
}
