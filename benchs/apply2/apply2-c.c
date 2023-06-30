

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
          
 
int repeat (int a, int n) {
  if (n<=0) {return(a);}
  else {return repeat(a+dcs(&succ,n),n-1);
  }
}

                
          

int main() {
int r  =  repeat(0,1000000) ;
 printf("%s %d\n","RES=", r);
}

