

#include <stdio.h>
#include <stdlib.h>

#define alpha void*


alpha deux(alpha(*f)(alpha), alpha x){
    return (f(f(x)));
}
            
alpha quad(alpha(*f)(alpha), alpha x){
  return f(f(f(f(x))));
}
    
alpha oct(alpha(*f)(alpha), alpha x){
    return f(f(f(f(f(f(f(f(x))))))));

}

alpha seize(alpha(*f)(alpha), alpha x){
    return f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(f(x))))))))))))))));

}
      

alpha dcs(alpha(*f)(alpha), alpha x){
    alpha r = oct(f,x);
/*    for (int i = 0; i<4095; i++) {
        r = seize(f,r);
    }
*/    return r;
}

int succ(int n) { return n + 1;}
          
 
int repeat (int n) {
    int a;
    while(n > 0) {
        a+=dcs(&succ,n);
        n--;
    }
    return a;
}

                
          

int main() {
    int start = millis();

    int r  =  repeat(1000000) ;
    printf("RES= %d\n", r);
    int end = millis();
    printf("%d\n", end-start);
    return 0;
}
