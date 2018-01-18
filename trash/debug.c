#ifdef __AVR__
#include <Arduino.h>
#endif

void debug_init(void) {
  Serial.begin(57600);
}

void debug(int n) {
  Serial.print("debug(");
  Serial.print(n);
  Serial.println(")");
}

/******************************************************************************/
/******************************************************************************/
/******************************************************************************/
/* Debug */

#ifdef __PC__

void debug_init(void) {
  printf("debug_init()\n");
}

void debug(int n) {
  printf("debug(%d)\n", n);
}

void debug_blink(int led, int n) {
  printf("debug_blink(%d, %d)\n", led, n);
}

#endif

/******************************************************************************/

#ifdef __AVR__

void debug_init(void) {
}

void debug_blink(int led, int n) {
  int i;
  pinMode(led, OUTPUT);
  digitalWrite(led, HIGH);
  delay(1000);
  for (i = 0; i < n; i ++) {
    digitalWrite(led, LOW);
    delay(300);
    digitalWrite(led, HIGH);
    delay(300);
  }
  delay(1000);
}

void debug(int n) {
  debug_blink(13, n);
}

void assert_failure(void) {
  int i, led = 17;
  while (1) {
    pinMode(led, OUTPUT);
    digitalWrite(led, LOW);
    delay(1000);
    for (i = 0; i < 3; i ++) {
      digitalWrite(led, HIGH);
      delay(200);
      digitalWrite(led, LOW);
      delay(200);
    }
    delay(1000);
  }
}

#endif

void print_heap(void) {
  val_t* from = tab_heap_start[current_heap];
  val_t* to = tab_heap_end[current_heap];
  Serial.println("HEAP=");
  for(val_t* ptr = from ; ptr < to; ptr++){
    /* if (*ptr != 0){ */
    Serial.print("@0x");
    Serial.print((val_t) ptr, HEX);
    Serial.print(":");
    if (Is_int(*ptr)){
      Serial.println(Int_val(*ptr), DEC);
    }
    else if (Is_block(*ptr)){
      Serial.println((val_t) Block_val(*ptr), HEX);
    }
    else if (*ptr == 0){
      Serial.println("_");
    }
    else{
      Serial.println(*(float *) ptr, 5);
    }
  }
  Serial.println("_____\n");
}

#endif
