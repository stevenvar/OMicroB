

#include <stdio.h>
 #include <stdlib.h>

typedef struct {
    int x ; int y ; int z;
} triplet ;

triplet* create(int a, int b, int c) {
    triplet* t = (triplet *) malloc(sizeof(triplet));
    t->x = a; t->y = b; t->z = c;
    return t;
}

void destroy(triplet* t) {
    free(t);
}

int takc(triplet* t){
 int a = t->x;
 int b = t->y;
 int c = t->z;
 if (a <= b) return c;
 else {
  triplet* t2=create(a-1,b,c);
  triplet* t3=create(b-1,c,a);
  triplet* t4 = create(c-1,a,b);
  int r2=takc(t2);
  int r3=takc(t3);
  int r4 =takc(t4);
  triplet* t5 = create(r2,r3,r4);
  free(t2); free(t3);free(t4);
  int r = takc(t5);
  free(t5);
  return r;
 }
}

int repeat (int n){
  int r = 0 ;
  int i = 0;
  while (i<n) {
    triplet * t1 = create(3,2,1);
    r = r + takc(t1);
    free(t1);
    i= i + 1;
  }
  return r;
}


int main(){
    int start = millis();
    printf("%d\n", repeat(2000000));
    int end = millis();
    printf("%d\n", end-start);
    return 0;
}
